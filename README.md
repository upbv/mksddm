<h1 align="center">mksddm — SDDM themes (Qt5)</h1>

<p align="center">
  Qt5 theme index; themes are distributed as GitHub Releases.<br>
  Qt6-ready versions live on <a href="https://github.com/upbv/mksddm/tree/main"><b>main</b></a>.
</p>

<p align="center">
  <a href="https://github.com/sddm/sddm"><img src="https://img.shields.io/badge/SDDM-themes-blue?style=flat-square" alt="SDDM themes"></a>
  <a href="https://github.com/upbv/mksddm/tree/qt5"><img src="https://img.shields.io/badge/greeter-Qt5-orange?style=flat-square" alt="Qt5 greeter"></a>
  <a href="https://github.com/upbv/mksddm/stargazers"><img src="https://img.shields.io/github/stars/upbv/mksddm?style=flat-square" alt="Stars"></a>
</p>

## Install

Download the theme zip from the [Releases page](https://github.com/upbv/mksddm/releases):

| Greeter | Asset |
| ------- | ----- |
| Qt6 (SDDM 0.21+) | `<theme>-qt6.tar.gz` |
| Qt5 (SDDM 0.20 and older) | `<theme>-qt5.tar.gz` |

```bash
tar -xzf <theme>-qt5.tar.gz -C /usr/share/sddm/themes/
```

The repository also contains the theme sources, but cloning it is optional and much larger.

To browse this index without downloading the full history:

```bash
git clone --depth 1 https://github.com/upbv/mksddm.git
```

Then pick the theme in **System Settings → Login Screen (SDDM)**, or write it manually:

```bash
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=<theme-name>\n' | sudo tee /etc/sddm.conf.d/theme.conf
```

`<theme-name>` must match `Theme-Id` in the theme's `metadata.desktop`.

### Dependencies (Qt5)

| Package | Needed for |
| ------- | ---------- |
| `qt5-declarative` | Qt Quick / QML runtime |
| `qt5-quickcontrols` | Qt Quick Controls 1.x |
| `qt5-quickcontrols2` | Qt Quick Controls 2.x |
| `qt5-graphicaleffects` | `QtGraphicalEffects` |
| `plasma-framework` | `org.kde.plasma.*` imports (Apple, WinXPconcept, ittu) — no longer in the official Arch repos; use the AUR or an archive |
| SDDM with the Qt5 greeter (`sddm-greeter`) | SDDM 0.20 and older |

> [!WARNING]
> On a system that only provides the Qt6 greeter, use [`main`](https://github.com/upbv/mksddm/tree/main) instead. Selecting these themes there results in a black login screen.

## Themes

Each entry links to its release asset. Qt6 versions are provided in the same releases. Click a name to download.

<table>
  <tr>
    <td align="center"><img src="./images/Apple-Sequoia-v1.Plasma6.jpg" width="420" alt="Apple-Sequoia-v1.Plasma6"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-Apple-Sequoia-v1.Plasma6"><b>Apple-Sequoia-v1.Plasma6</b></a></td>
    <td align="center"><img src="./images/Apple-Sonoma-v1.png" width="420" alt="Apple-Sonoma-v1"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-Apple-Sonoma-v1"><b>Apple-Sonoma-v1</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/Apple-Sonoma-v2.png" width="420" alt="Apple-Sonoma-v2"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-Apple-Sonoma-v2"><b>Apple-Sonoma-v2</b></a></td>
    <td align="center"><img src="./images/Federation.png" width="420" alt="Federation"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-Federation"><b>Federation</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/WinXPconcept.png" width="420" alt="WinXPconcept"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-WinXPconcept"><b>WinXPconcept</b></a></td>
    <td align="center"><img src="./images/ittu.png" width="420" alt="ittu"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-ittu"><b>ittu</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/sddm-slice-1.5.1.png" width="420" alt="sddm-slice-1.5.1"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-sddm-slice-1.5.1"><b>sddm-slice-1.5.1</b></a></td>
    <td align="center"><img src="./images/Andromeda.png" width="420" alt="Andromeda"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-Andromeda"><b>Andromeda</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/arona-sddm-login.png" width="420" alt="arona-sddm-login"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-arona-sddm-login"><b>arona-sddm-login</b></a></td>
    <td align="center"><img src="./images/C64-AnimTimeCrystal.png" width="420" alt="C64-AnimTimeCrystal"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-C64-AnimTimeCrystal"><b>C64-AnimTimeCrystal</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/C64-GEOS.png" width="420" alt="C64-GEOS"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-C64-GEOS"><b>C64-GEOS</b></a></td>
    <td align="center"><img src="./images/C64-Holiday.png" width="420" alt="C64-Holiday"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-C64-Holiday"><b>C64-Holiday</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/Chocula.png" width="420" alt="Chocula"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-Chocula"><b>Chocula</b></a></td>
    <td align="center"><img src="./images/darkine.jpg" width="420" alt="darkine"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-darkine"><b>darkine</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/LyraB-dark.png" width="420" alt="LyraB-dark"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-LyraB-dark"><b>LyraB-dark</b></a></td>
    <td align="center"><img src="./images/materia.png" width="420" alt="materia"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-materia"><b>materia</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/NetLogin-userlist.png" width="420" alt="NetLogin-userlist"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-NetLogin-userlist"><b>NetLogin-userlist</b></a></td>
    <td align="center"><img src="./images/QTStep.png" width="420" alt="QTStep"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-QTStep"><b>QTStep</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/Ricciolo2.jpg" width="420" alt="Ricciolo2"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-Ricciolo2"><b>Ricciolo2</b></a></td>
    <td align="center"><img src="./images/sddm-catppuccin.png" width="420" alt="sddm-catppuccin"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-sddm-catppuccin"><b>sddm-catppuccin</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/simple.png" width="420" alt="simple"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-simple"><b>simple</b></a></td>
    <td align="center"><img src="./images/sugar-dark.png" width="420" alt="sugar-dark"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-sugar-dark"><b>sugar-dark</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/Uzuri-sddm.png" width="420" alt="Uzuri-sddm"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-Uzuri-sddm"><b>Uzuri-sddm</b></a></td>
    <td align="center"><img src="./images/WarGames.png" width="420" alt="WarGames"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-WarGames"><b>WarGames</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/neontown.png" width="420" alt="neontown"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-neontown"><b>neontown</b></a></td>
    <td align="center"><img src="./images/sugar-candy.png" width="420" alt="sugar-candy"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-sugar-candy"><b>sugar-candy</b></a></td>
  </tr>
  <tr>
    <td align="center"><img src="./images/sugar-light.png" width="420" alt="sugar-light"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-sugar-light"><b>sugar-light</b></a></td>
    <td align="center"><img src="./images/zust.png" width="420" alt="zust"><br><a href="https://github.com/upbv/mksddm/releases/tag/theme-zust"><b>zust</b></a></td>
  </tr>
</table>

<details>
  <summary>QTStep variants (22)</summary>
  <p>
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStep-qt5.tar.gz">QTStep</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepBeige-qt5.tar.gz">QTStep Beige</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepBreezeDark-qt5.tar.gz">QTStep Breeze Dark</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepDebianRed-qt5.tar.gz">QTStep DebianRed</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepHoneycomb-qt5.tar.gz">QTStep Honeycomb</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepIndustrial-qt5.tar.gz">QTStep Industrial</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepKritadark-qt5.tar.gz">QTStep Krita dark</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepOpenStep-qt5.tar.gz">QTStep OpenStep</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepOpenStepAntiford-qt5.tar.gz">QTStep OpenStepAntiford</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepOpenStepCDPlayer-qt5.tar.gz">QTStep OpenStepCDPlayer</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepOpenStepLogin-qt5.tar.gz">QTStep OpenStepLogin</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepOpenStepSilver-qt5.tar.gz">QTStep OpenStepSilver</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepPine-qt5.tar.gz">QTStep Pine</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepSilkBlueSteel-qt5.tar.gz">QTStep SilkBlueSteel</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepSkarabeus-qt5.tar.gz">QTStep Skarabeus</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepSteelBlueSilk-qt5.tar.gz">QTStep SteelBlueSilk</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepTeal-qt5.tar.gz">QTStep Teal</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepWMakerDefault-qt5.tar.gz">QTStep WMakerDefault</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepWMakerOpenStep-qt5.tar.gz">QTStep WMakerOpenStep</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepWontonSoup-qt5.tar.gz">QTStep Wonton Soup</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepWontonSoupBrown-qt5.tar.gz">QTStep Wonton Soup Brown</a> ·
    <a href="https://github.com/upbv/mksddm/releases/download/theme-QTStep/QTStepprodukt-qt5.tar.gz">QTStep produkt</a>
  </p>
</details>

## Notes

- The Qt6 versions are provided as `-qt6.tar.gz` assets in the same releases; use those on a Qt6 system.
- Sequoia's original metadata already says `QtVersion=6`, but its QML still depends on the Plasma QML modules above — use the `-qt6` asset with the Qt6 greeter.
- `theme.conf.user` overrides `theme.conf`; edit one of them to change the background:

```ini
[General]
background=<image-file>
type=image
```

## Credits & licenses

<table align="center">
  <tr>
    <th align="center" width="600">Theme</th>
    <th align="center" width="600">Author</th>
    <th align="center" width="600">License</th>
  </tr>
  <tr>
    <td align="center">Apple-Sequoia-v1.Plasma6</td>
    <td align="center">zayronxio</td>
    <td align="center">GPL-3.0</td>
  </tr>
  <tr>
    <td align="center">Apple-Sonoma-v1</td>
    <td align="center">zayronxio</td>
    <td align="center">GPL-3.0</td>
  </tr>
  <tr>
    <td align="center">Apple-Sonoma-v2</td>
    <td align="center">zayronxio</td>
    <td align="center">GPL-3.0</td>
  </tr>
  <tr>
    <td align="center">Federation</td>
    <td align="center">Aramis76</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">WinXPconcept</td>
    <td align="center">yeyushengfan258</td>
    <td align="center">GPL-3.0-or-later</td>
  </tr>
  <tr>
    <td align="center">ittu</td>
    <td align="center">Adhe</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">sddm-slice-1.5.1</td>
    <td align="center">RadRussianRus</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">Andromeda</td>
    <td align="center">Eliver Lara</td>
    <td align="center">GPL 3+</td>
  </tr>
  <tr>
    <td align="center">arona-sddm-login</td>
    <td align="center">Machillka</td>
    <td align="center">GPL-3.0-or-later</td>
  </tr>
  <tr>
    <td align="center">C64-AnimTimeCrystal</td>
    <td align="center">Pentad</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">C64-GEOS</td>
    <td align="center">Pentad</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">C64-Holiday</td>
    <td align="center">Pentad</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">Chocula</td>
    <td align="center">Sue Donham</td>
    <td align="center">GPL 3+</td>
  </tr>
  <tr>
    <td align="center">darkine</td>
    <td align="center">Rokin</td>
    <td align="center">GPLv3</td>
  </tr>
  <tr>
    <td align="center">LyraB-dark</td>
    <td align="center">yeyushengfan258</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">materia</td>
    <td align="center">Alexey Varfolomeev</td>
    <td align="center">ISC</td>
  </tr>
  <tr>
    <td align="center">NetLogin-userlist</td>
    <td align="center">Novomente</td>
    <td align="center">GPLv2 or later</td>
  </tr>
  <tr>
    <td align="center">QTStep (22 variants)</td>
    <td align="center">Andi Berger</td>
    <td align="center">GPLv3</td>
  </tr>
  <tr>
    <td align="center">Ricciolo2</td>
    <td align="center">rugyada</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">sddm-catppuccin</td>
    <td align="center">—</td>
    <td align="center">—</td>
  </tr>
  <tr>
    <td align="center">simple</td>
    <td align="center">Anton Fehsenmayr</td>
    <td align="center">—</td>
  </tr>
  <tr>
    <td align="center">sugar-dark</td>
    <td align="center">Marian Arlt</td>
    <td align="center">GPL-3.0-or-later</td>
  </tr>
  <tr>
    <td align="center">Uzuri-sddm</td>
    <td align="center">zayronxio</td>
    <td align="center">gpl3.0</td>
  </tr>
  <tr>
    <td align="center">WarGames</td>
    <td align="center">Pentad</td>
    <td align="center">CC-BY-SA</td>
  </tr>

  <tr>
    <td align="center">neontown</td>
    <td align="center">Adhe</td>
    <td align="center">CC-BY-SA</td>
  </tr>
  <tr>
    <td align="center">sugar-candy</td>
    <td align="center">Marian Arlt</td>
    <td align="center">GPL-3.0-or-later</td>
  </tr>
  <tr>
    <td align="center">sugar-light</td>
    <td align="center">Marian Alexander Arlt</td>
    <td align="center">GPL-3.0-or-later</td>
  </tr>
  <tr>
    <td align="center">zust</td>
    <td align="center">stepan-zubkov</td>
    <td align="center">MIT</td>
  </tr>
</table>
