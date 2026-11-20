<a id="top"></a>

<div align="center">

### 🇬🇧 [English](#en) &nbsp;·&nbsp; 🇹🇷 [Türkçe](#tr) &nbsp;·&nbsp; 🇩🇪 [Deutsch](#de)

</div>

---

<a id="en"></a>

<div align="center">

🇬🇧 **English** &nbsp;·&nbsp; 🇹🇷 [Türkçe](#tr) &nbsp;·&nbsp; 🇩🇪 [Deutsch](#de)

# MuJoCo Quickstart · one command, first simulation

[![Website: praxtify.com](https://img.shields.io/badge/praxtify.com-Website-111111?style=for-the-badge)](https://praxtify.com)
[![YouTube](https://img.shields.io/badge/YouTube-@praxtify-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@praxtify)

**Install the MuJoCo physics engine and run your first simulation in VS Code with a single command.**
Windows, macOS and Linux.

[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![MuJoCo](https://img.shields.io/badge/MuJoCo-3.x%20%7C%204.x-1E88E5)](https://mujoco.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

## Quick start

**Windows** — open PowerShell (or the VS Code terminal) and paste:

```powershell
irm https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main/setup.ps1 | iex
```

…or, with one click: **Code → Download ZIP**, unzip it and double-click **`setup.bat`**.

**macOS / Linux** — open Terminal and paste:

```bash
curl -fsSL https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main/setup.sh | bash
```

A MuJoCo window opens: an orange cube and a blue ball fall onto the floor. 🎉

## What the script does

| Step | What happens |
|---|---|
| 1 · Python | Uses your Python 3.10+; if there is none, installs Python 3.13 (Windows: `winget` · macOS: Homebrew or python.org) |
| 2 · VS Code | Uses VS Code if installed; otherwise installs it (Windows: `winget` · macOS: Homebrew or code.visualstudio.com) |
| 3 · Extension | Adds the VS Code **Python** extension (`ms-python.python`) |
| 4 · MuJoCo | Creates the project folder `~/mujoco-quickstart` with a virtual environment `.venv` and runs `pip install mujoco` |
| 5 · Files | Writes [`hello_mujoco.py`](hello_mujoco.py) and `.vscode/settings.json` (VS Code uses `.venv` automatically, so there is no *No module named 'mujoco'* error) |
| 6 · Run | Opens the folder in VS Code and starts the simulation |

Running it again is safe: existing files are kept and MuJoCo is only updated.
Next time, just open the folder in VS Code and press **▷ Run** on `hello_mujoco.py`.

## The one line everyone forgets

```python
import mujoco
import mujoco.viewer   # without this: AttributeError: module 'mujoco' has no attribute 'viewer'
```

`viewer` is a submodule. `import mujoco` alone does not load it.

## Doing it by hand

```bash
python -m venv .venv
# Windows:      .venv\Scripts\activate
# macOS/Linux:  source .venv/bin/activate
pip install mujoco
python hello_mujoco.py
```

In VS Code: `Ctrl+Shift+P` → **Python: Select Interpreter** → choose `.venv`.

> [!NOTE]
> - **Windows "protected your PC" warning** on `setup.bat`: click **More info → Run anyway** (the file comes from the internet).
> - **Linux:** if `venv` is missing, run `sudo apt install python3-venv`. Python is not installed automatically on Linux.
> - Options (environment variables): `MUJOCO_DIR` (project folder), `MUJOCO_NO_RUN=1`, `MUJOCO_NO_CODE=1`.
> - Tested with: Windows 10 · Python 3.13 · MuJoCo 4.0.1.

## License

[MIT](LICENSE) — free to use, also commercially. More projects from Praxtify: [github.com/praxtify](https://github.com/praxtify) · [praxtify.com](https://praxtify.com)

<p align="right"><a href="#top">↑ Top</a></p>

---

<a id="tr"></a>

<div align="center">

🇬🇧 [English](#en) &nbsp;·&nbsp; 🇹🇷 **Türkçe** &nbsp;·&nbsp; 🇩🇪 [Deutsch](#de)

# MuJoCo Hızlı Başlangıç · tek komut, ilk simülasyon

**MuJoCo fizik motorunu kur ve VS Code'da ilk simülasyonunu tek komutla çalıştır.**
Windows, macOS ve Linux.

</div>

## Hızlı başlangıç

**Windows** — PowerShell'i (ya da VS Code terminalini) aç ve yapıştır:

```powershell
irm https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main/setup.ps1 | iex
```

…ya da tek tıkla: **Code → Download ZIP**, klasörü çıkar ve **`setup.bat`** dosyasına çift tıkla.

**macOS / Linux** — Terminal'i aç ve yapıştır:

```bash
curl -fsSL https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main/setup.sh | bash
```

MuJoCo penceresi açılır: turuncu küp ve mavi top zemine düşer. 🎉

## Betik ne yapar?

| Adım | Ne olur |
|---|---|
| 1 · Python | Python 3.10+ varsa onu kullanır; yoksa Python 3.13'ü kurar (Windows: `winget` · macOS: Homebrew ya da python.org) |
| 2 · VS Code | VS Code kuruluysa onu kullanır; değilse kurar (Windows: `winget` · macOS: Homebrew ya da code.visualstudio.com) |
| 3 · Eklenti | VS Code **Python** eklentisini ekler (`ms-python.python`) |
| 4 · MuJoCo | `~/mujoco-quickstart` proje klasörünü ve `.venv` sanal ortamını açar, `pip install mujoco` çalıştırır |
| 5 · Dosyalar | [`hello_mujoco.py`](hello_mujoco.py) ve `.vscode/settings.json` yazar (VS Code `.venv`'i kendiliğinden kullanır; *No module named 'mujoco'* hatası olmaz) |
| 6 · Çalıştır | Klasörü VS Code'da açar ve simülasyonu başlatır |

Tekrar çalıştırmak güvenlidir: var olan dosyalar korunur, MuJoCo yalnızca güncellenir.
Sonraki seferlerde klasörü VS Code'da açıp `hello_mujoco.py` üzerinde **▷ Run** düğmesine basman yeterli.

## Herkesin unuttuğu tek satır

```python
import mujoco
import mujoco.viewer   # bu olmadan: AttributeError: module 'mujoco' has no attribute 'viewer'
```

`viewer` bir alt modüldür. Yalnız `import mujoco` onu yüklemez.

## Elle kurulum

```bash
python -m venv .venv
# Windows:      .venv\Scripts\activate
# macOS/Linux:  source .venv/bin/activate
pip install mujoco
python hello_mujoco.py
```

VS Code'da: `Ctrl+Shift+P` → **Python: Select Interpreter** → `.venv`'i seç.

> [!NOTE]
> - `setup.bat` açılırken **"Windows bilgisayarınızı korudu"** uyarısı çıkarsa: **Ek bilgi → Yine de çalıştır** (dosya internetten geldiği için).
> - **Linux:** `venv` eksikse `sudo apt install python3-venv` çalıştır. Linux'ta Python otomatik kurulmaz.
> - Seçenekler (ortam değişkenleri): `MUJOCO_DIR` (proje klasörü), `MUJOCO_NO_RUN=1`, `MUJOCO_NO_CODE=1`.
> - Test edilen: Windows 10 · Python 3.13 · MuJoCo 4.0.1.

## Lisans

[MIT](LICENSE) — ticari kullanım dahil serbest. Praxtify'ın diğer projeleri: [github.com/praxtify](https://github.com/praxtify) · [praxtify.com](https://praxtify.com)

<p align="right"><a href="#top">↑ Başa dön</a></p>

---

<a id="de"></a>

<div align="center">

🇬🇧 [English](#en) &nbsp;·&nbsp; 🇹🇷 [Türkçe](#tr) &nbsp;·&nbsp; 🇩🇪 **Deutsch**

# MuJoCo Schnellstart · ein Befehl, erste Simulation

**Installiere die Physik-Engine MuJoCo und starte deine erste Simulation in VS Code mit einem einzigen Befehl.**
Windows, macOS und Linux.

</div>

## Schnellstart

**Windows** — PowerShell (oder das VS-Code-Terminal) öffnen und einfügen:

```powershell
irm https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main/setup.ps1 | iex
```

…oder mit einem Klick: **Code → Download ZIP**, entpacken und **`setup.bat`** doppelklicken.

**macOS / Linux** — Terminal öffnen und einfügen:

```bash
curl -fsSL https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main/setup.sh | bash
```

Ein MuJoCo-Fenster öffnet sich: Ein oranger Würfel und ein blauer Ball fallen auf den Boden. 🎉

## Was das Skript macht

| Schritt | Was passiert |
|---|---|
| 1 · Python | Nutzt dein Python 3.10+; falls keines da ist, installiert es Python 3.13 (Windows: `winget` · macOS: Homebrew oder python.org) |
| 2 · VS Code | Nutzt ein installiertes VS Code; sonst wird es installiert (Windows: `winget` · macOS: Homebrew oder code.visualstudio.com) |
| 3 · Erweiterung | Fügt die VS-Code-Erweiterung **Python** hinzu (`ms-python.python`) |
| 4 · MuJoCo | Legt den Projektordner `~/mujoco-quickstart` mit der virtuellen Umgebung `.venv` an und führt `pip install mujoco` aus |
| 5 · Dateien | Schreibt [`hello_mujoco.py`](hello_mujoco.py) und `.vscode/settings.json` (VS Code nutzt `.venv` automatisch, also kein *No module named 'mujoco'*) |
| 6 · Start | Öffnet den Ordner in VS Code und startet die Simulation |

Erneutes Ausführen ist sicher: Vorhandene Dateien bleiben erhalten, MuJoCo wird nur aktualisiert.
Beim nächsten Mal einfach den Ordner in VS Code öffnen und bei `hello_mujoco.py` auf **▷ Run** klicken.

## Die eine Zeile, die alle vergessen

```python
import mujoco
import mujoco.viewer   # ohne diese Zeile: AttributeError: module 'mujoco' has no attribute 'viewer'
```

`viewer` ist ein Untermodul. `import mujoco` allein lädt es nicht.

## Von Hand

```bash
python -m venv .venv
# Windows:      .venv\Scripts\activate
# macOS/Linux:  source .venv/bin/activate
pip install mujoco
python hello_mujoco.py
```

In VS Code: `Strg+Umschalt+P` → **Python: Select Interpreter** → `.venv` wählen.

> [!NOTE]
> - Warnung **„Der Computer wurde durch Windows geschützt“** bei `setup.bat`: **Weitere Informationen → Trotzdem ausführen** (die Datei stammt aus dem Internet).
> - **Linux:** Fehlt `venv`, dann `sudo apt install python3-venv` ausführen. Unter Linux wird Python nicht automatisch installiert.
> - Optionen (Umgebungsvariablen): `MUJOCO_DIR` (Projektordner), `MUJOCO_NO_RUN=1`, `MUJOCO_NO_CODE=1`.
> - Getestet mit: Windows 10 · Python 3.13 · MuJoCo 4.0.1.

## Lizenz

[MIT](LICENSE) — frei nutzbar, auch kommerziell. Weitere Projekte von Praxtify: [github.com/praxtify](https://github.com/praxtify) · [praxtify.com](https://praxtify.com)

<p align="right"><a href="#top">↑ Nach oben</a></p>
