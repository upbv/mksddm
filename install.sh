#!/usr/bin/env bash
# install.sh — interactive SDDM theme installer for upbv/mksddm.
#
# Fetches every theme release from GitHub, lets the user pick one by number,
# downloads the build that matches the local greeter (Qt5 or Qt6), installs it
# to /usr/share/sddm/themes and activates it in /etc/sddm.conf.d/theme.conf.

set -euo pipefail

REPO="upbv/mksddm"
API_URL="https://api.github.com/repos/${REPO}/releases"
THEMES_DIR="/usr/share/sddm/themes"
CONF_DIR="/etc/sddm.conf.d"
CONF_FILE="${CONF_DIR}/theme.conf"

WORK_DIR=""
MATCHES=()

cleanup() {
    if [ -n "${WORK_DIR:-}" ]; then
        rm -rf -- "$WORK_DIR"
    fi
}
trap cleanup EXIT

info() { printf '%s\n' "$*"; }
warn() { printf 'Warning: %s\n' "$*" >&2; }
die() {
    printf '\nError: %s\n' "$*" >&2
    exit 1
}

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Interactively install an SDDM theme from https://github.com/${REPO}/releases.

The script lists every theme release, downloads the Qt5/Qt6 build that matches
the local greeter, installs it to ${THEMES_DIR} and sets it as the
current theme in ${CONF_FILE}.

It refuses to run unless SDDM is installed and is the active display manager.
Root privileges are required; the script re-runs itself with sudo if needed.

Options:
  -h, --help    Show this help.
EOF
}

# Refuse to touch the system unless SDDM is installed and, when known,
# the active display manager is SDDM.
check_sddm() {
    if ! command -v sddm >/dev/null 2>&1 \
        && [ ! -e /usr/lib/systemd/system/sddm.service ] \
        && [ ! -e /lib/systemd/system/sddm.service ]; then
        die "SDDM is not installed on this system. Install SDDM first, then re-run this script."
    fi

    local target=""
    if [ -L /etc/systemd/system/display-manager.service ]; then
        target=$(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null || true)
    elif [ -f /etc/systemd/system/display-manager.service ]; then
        if grep -qi 'sddm' /etc/systemd/system/display-manager.service; then
            target="sddm"
        else
            target="/etc/systemd/system/display-manager.service"
        fi
    fi

    if [ -n "$target" ]; then
        case "$target" in
            *sddm*) ;;
            *) die "The active display manager is not SDDM (${target}). Refusing to install an SDDM theme." ;;
        esac
    fi
}

# Prefer the greeter binary that is actually present; fall back to the version.
detect_qt() {
    if command -v sddm-greeter-qt6 >/dev/null 2>&1; then
        printf '6\n'
        return 0
    fi
    if command -v sddm-greeter >/dev/null 2>&1; then
        printf '5\n'
        return 0
    fi

    local version
    version=$(sddm --version 2>/dev/null | awk 'NR == 1 { print $NF }' || true)
    if [ -n "$version" ] && printf '0.21\n%s\n' "$version" | sort -V -C 2>/dev/null; then
        printf '6\n'
    else
        printf '5\n'
    fi
}

# Emit "tag<TAB>name<TAB>asset<TAB>url" for every downloadable theme asset.
parse_releases() {
    if command -v jq >/dev/null 2>&1; then
        jq -r '
            .[]
            | select(.tag_name | startswith("theme-")) as $rel
            | $rel.assets[]?
            | select(.name | test("\\.(tar\\.gz|tgz)$"))
            | [$rel.tag_name, ($rel.name // $rel.tag_name), .name, .browser_download_url]
            | @tsv
        '
    elif command -v python3 >/dev/null 2>&1; then
        python3 -I -c '
import json, sys

for rel in json.load(sys.stdin):
    tag = rel.get("tag_name") or ""
    if not tag.startswith("theme-"):
        continue
    name = (rel.get("name") or tag).replace("\t", " ").replace("\n", " ").replace("\r", " ")
    for asset in rel.get("assets") or []:
        asset_name = asset.get("name") or ""
        if not (asset_name.endswith(".tar.gz") or asset_name.endswith(".tgz")):
            continue
        url = asset.get("browser_download_url") or ""
        print("\t".join((tag, name, asset_name, url)))
'
    else
        die "jq or python3 is required to read the GitHub release list."
    fi
}

# Download every page of the releases API into a TSV file.
fetch_releases() {
    local out=$1
    local page=1
    local headers body
    local -a curl_args

    : > "$out"
    while :; do
        headers="${WORK_DIR}/headers.${page}"
        body="${WORK_DIR}/page.${page}.json"
        curl_args=(-fsSL --retry 2 --connect-timeout 15 -H 'Accept: application/vnd.github+json')
        if [ -n "${GITHUB_TOKEN:-}" ]; then
            curl_args+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
        fi

        if ! curl "${curl_args[@]}" -D "$headers" -o "$body" \
            "${API_URL}?per_page=100&page=${page}"; then
            die "Could not fetch ${API_URL}. Check your network connection; if the unauthenticated GitHub API rate limit is exhausted, set GITHUB_TOKEN and retry."
        fi

        parse_releases < "$body" >> "$out"

        if grep -Eqi '^link:.*rel="next"' "$headers"; then
            page=$((page + 1))
        else
            break
        fi
    done
}

declare -a TAGS=() NAMES=()
declare -A ASSETS=() SEEN=()

load_releases() {
    local tag name asset url
    while IFS=$'\t' read -r tag name asset url; do
        [ -n "$tag" ] || continue
        if [ -z "${SEEN[$tag]:-}" ]; then
            SEEN[$tag]=1
            TAGS+=("$tag")
            NAMES+=("$name")
            ASSETS[$tag]=""
        fi
        ASSETS[$tag]+="${asset}"$'\t'"${url}"$'\n'
    done < "$1"
}

# Print "<qt5> <qt6> <unversioned>" build counts for a release.
count_builds() {
    local tag=$1
    local asset rest
    local n5=0 n6=0 nany=0

    while IFS=$'\t' read -r asset rest; do
        [ -n "$asset" ] || continue
        if [[ "$asset" =~ -qt([56])\.(tar\.gz|tgz)$ ]]; then
            if [ "${BASH_REMATCH[1]}" = "6" ]; then
                n6=$((n6 + 1))
            else
                n5=$((n5 + 1))
            fi
        else
            nany=$((nany + 1))
        fi
    done <<< "${ASSETS[$tag]:-}"

    printf '%s %s %s\n' "$n5" "$n6" "$nany"
}

has_compatible_asset() {
    local tag=$1 want=$2
    local n5 n6 nany
    read -r n5 n6 nany < <(count_builds "$tag")

    if [ "$want" = "6" ] && [ "$n6" -gt 0 ]; then
        return 0
    fi
    if [ "$want" = "5" ] && [ "$n5" -gt 0 ]; then
        return 0
    fi
    [ "$nany" -gt 0 ]
}

print_menu() {
    local greeter_qt=$1
    local i tag name n5 n6 nany avail marker

    printf '  %3s  %-34s %s\n' "#" "Theme" "Builds"
    printf '  %3s  %-34s %s\n' "---" "----------------------------------" "------"
    for i in "${!TAGS[@]}"; do
        tag=${TAGS[$i]}
        name=${NAMES[$i]}
        read -r n5 n6 nany < <(count_builds "$tag")

        if [ "$n5" -gt 0 ] && [ "$n6" -gt 0 ]; then
            avail="Qt5 + Qt6"
        elif [ "$n6" -gt 0 ]; then
            avail="Qt6 only"
        elif [ "$n5" -gt 0 ]; then
            avail="Qt5 only"
        else
            avail="unversioned"
        fi

        marker=""
        if { [ "$greeter_qt" = "6" ] && { [ "$n6" -gt 0 ] || [ "$nany" -gt 0 ]; }; } \
            || { [ "$greeter_qt" = "5" ] && { [ "$n5" -gt 0 ] || [ "$nany" -gt 0 ]; }; }; then
            marker=" *"
        fi

        printf '  %3d)  %-34s %s%s\n' "$((i + 1))" "$name" "$avail" "$marker"
    done
    printf '\n  * usable with your Qt%s greeter\n\n' "$greeter_qt"
}

# Fill MATCHES with "asset<TAB>url" entries that fit the local greeter.
collect_matches() {
    local tag=$1 want=$2
    local asset url qt

    MATCHES=()
    while IFS=$'\t' read -r asset url; do
        [ -n "$asset" ] || continue
        qt=""
        if [[ "$asset" =~ -qt([56])\.(tar\.gz|tgz)$ ]]; then
            qt=${BASH_REMATCH[1]}
        fi
        if [ -z "$qt" ] || [ "$qt" = "$want" ]; then
            MATCHES+=("${asset}"$'\t'"${url}")
        fi
    done <<< "${ASSETS[$tag]:-}"
}

# Set the [Theme] Current= entry, preserving any other settings in the file.
set_current_theme() {
    local theme_name=$1
    local tmp_conf

    mkdir -p "$CONF_DIR"
    if [ -f "$CONF_FILE" ]; then
        tmp_conf="${WORK_DIR}/theme.conf"
        if ! awk -v name="$theme_name" '
            BEGIN { in_theme = 0; seen = 0 }
            /^[[:space:]]*\[/ {
                in_theme = ($0 ~ /^[[:space:]]*\[Theme\][[:space:]]*$/)
            }
            in_theme && /^[[:space:]]*Current[[:space:]]*=/ {
                if (!seen) {
                    print "Current=" name
                    seen = 1
                }
                next
            }
            { print }
            END {
                if (!seen) {
                    print ""
                    print "[Theme]"
                    print "Current=" name
                }
            }
        ' "$CONF_FILE" > "$tmp_conf"; then
            die "Could not update ${CONF_FILE}."
        fi
        mv -- "$tmp_conf" "$CONF_FILE"
    else
        printf '[Theme]\nCurrent=%s\n' "$theme_name" > "$CONF_FILE"
    fi
    chmod 644 "$CONF_FILE"
}

main() {
    case "${1:-}" in
        "") ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            die "Unknown option: $1 (try --help)"
            ;;
    esac

    check_sddm

    if [ "$EUID" -ne 0 ]; then
        if command -v sudo >/dev/null 2>&1; then
            info "Root privileges are required; re-running with sudo..."
            if [ -n "${GITHUB_TOKEN:-}" ]; then
                exec sudo --preserve-env=GITHUB_TOKEN -- bash "$0" "$@"
            fi
            exec sudo -- bash "$0" "$@"
        fi
        die "Please run as root: sudo bash $0"
    fi

    if ! command -v curl >/dev/null 2>&1; then
        die "curl is required to download releases."
    fi

    local greeter_qt
    greeter_qt=$(detect_qt)
    info "Detected SDDM greeter: Qt${greeter_qt}"

    WORK_DIR=$(mktemp -d "${TMPDIR:-/tmp}/mksddm-install.XXXXXX")
    local raw="${WORK_DIR}/releases.tsv"

    info "Fetching releases from github.com/${REPO} ..."
    fetch_releases "$raw"
    load_releases "$raw"
    if [ "${#TAGS[@]}" -eq 0 ]; then
        die "No theme releases were found."
    fi
    info "Found ${#TAGS[@]} theme releases (newest first; non-theme releases are skipped)."
    printf '\n'

    local choice idx tag name
    while :; do
        print_menu "$greeter_qt"
        read -r -p "Select a theme [1-${#TAGS[@]}] (q to quit): " choice || {
            printf '\n'
            exit 0
        }
        case "$choice" in
            q|Q|quit|exit) exit 0 ;;
        esac

        if ! [[ "$choice" =~ ^[0-9]+$ ]] \
            || ((10#$choice < 1 || 10#$choice > ${#TAGS[@]})); then
            warn "Invalid selection."
            printf '\n'
            continue
        fi

        idx=$((10#$choice - 1))
        tag=${TAGS[$idx]}
        name=${NAMES[$idx]}

        if ! has_compatible_asset "$tag" "$greeter_qt"; then
            warn "'${name}' has no build for your Qt${greeter_qt} greeter. Choose another theme."
            printf '\n'
            continue
        fi
        break
    done

    collect_matches "$tag" "$greeter_qt"
    if [ "${#MATCHES[@]}" -eq 0 ]; then
        die "'${name}' has no build for your Qt${greeter_qt} greeter."
    fi

    local selected asset url
    if [ "${#MATCHES[@]}" -eq 1 ]; then
        selected=${MATCHES[0]}
        asset=${selected%%$'\t'*}
        url=${selected#*$'\t'}
        info "Selected: ${asset}"
    else
        local i base
        local -a labels=()
        for selected in "${MATCHES[@]}"; do
            base=${selected%%$'\t'*}
            base=${base%.tar.gz}
            base=${base%.tgz}
            base=${base%-qt5}
            base=${base%-qt6}
            labels+=("$base")
        done

        printf '\nMultiple Qt%s builds are available for %s:\n\n' "$greeter_qt" "$name"
        for i in "${!MATCHES[@]}"; do
            printf '  %3d)  %s\n' "$((i + 1))" "${labels[$i]}"
        done
        printf '\n'

        local variant_choice
        while :; do
            read -r -p "Select a build [1-${#MATCHES[@]}] (q to quit): " variant_choice || {
                printf '\n'
                exit 0
            }
            case "$variant_choice" in
                q|Q|quit|exit) exit 0 ;;
            esac
            if [[ "$variant_choice" =~ ^[0-9]+$ ]] \
                && ((10#$variant_choice >= 1 && 10#$variant_choice <= ${#MATCHES[@]})); then
                break
            fi
            warn "Invalid selection."
        done

        selected=${MATCHES[$((10#$variant_choice - 1))]}
        asset=${selected%%$'\t'*}
        url=${selected#*$'\t'}
        info "Selected: ${asset}"
    fi

    printf '\nDownloading %s ...\n' "$asset"
    local archive="${WORK_DIR}/theme.tar.gz"
    if ! curl -fL --retry 2 --connect-timeout 15 --progress-bar -o "$archive" -- "$url"; then
        die "Download failed: ${url}"
    fi
    if [ ! -s "$archive" ]; then
        die "Downloaded file is empty: ${url}"
    fi

    if tar -tzf "$archive" | grep -Eq '(^/)|(^|/)\.\.(/|$)'; then
        die "The archive contains unsafe paths; refusing to extract it."
    fi

    mkdir -p "${WORK_DIR}/extract"
    if ! tar -xzf "$archive" -C "${WORK_DIR}/extract" --no-same-owner; then
        die "Could not extract the theme archive."
    fi

    local -a md_files=()
    mapfile -t md_files < <(find "${WORK_DIR}/extract" -maxdepth 2 -type f -name metadata.desktop | sort)
    if [ "${#md_files[@]}" -eq 0 ]; then
        die "The archive does not contain an SDDM theme (metadata.desktop not found)."
    fi
    if [ "${#md_files[@]}" -gt 1 ]; then
        die "The archive contains more than one theme; refusing to guess."
    fi

    local theme_dir theme_name
    theme_dir=$(dirname "${md_files[0]}")
    theme_name=$(basename "$theme_dir")
    case "$theme_name" in
        ''|.|..|*/*)
            die "Unsafe theme directory name: ${theme_name}"
            ;;
    esac
    if ! grep -q '^\[SddmGreeterTheme\]' "$theme_dir/metadata.desktop"; then
        die "'${theme_name}' is not a valid SDDM theme (missing [SddmGreeterTheme])."
    fi

    local target="${THEMES_DIR}/${theme_name}"
    if [ -e "$target" ]; then
        printf '\nTheme %s is already installed.\n' "$theme_name"
        local reply
        read -r -p "Overwrite it? [y/N] " reply || {
            printf '\n'
            exit 0
        }
        case "$reply" in
            y|Y|yes|YES) ;;
            *)
                info "Nothing changed."
                exit 0
                ;;
        esac
    fi

    mkdir -p "$THEMES_DIR"
    rm -rf -- "$target"
    if ! cp -a -- "$theme_dir" "$target"; then
        die "Could not copy the theme to ${target}."
    fi
    chmod -R a+rX "$target"

    set_current_theme "$theme_name"

    printf '\nInstalled and activated %s.\n' "$theme_name"
    printf '  Theme:  %s\n' "$target"
    printf '  Config: %s\n' "$CONF_FILE"
    printf '\nLog out or reboot to see it on the login screen.\n'
    if command -v sddm-greeter-qt6 >/dev/null 2>&1; then
        printf 'Preview from a terminal: sddm-greeter-qt6 --test-mode --theme %s\n' "$target"
    elif command -v sddm-greeter >/dev/null 2>&1; then
        printf 'Preview from a terminal: sddm-greeter --test-mode --theme %s\n' "$target"
    fi
}

main "$@"
