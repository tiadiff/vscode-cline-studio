# Cline Agent Studio

A minimalist, distraction-free dark grayscale AI coding workspace built on top of Visual Studio Code and a customized fork of [Cline](https://github.com/cline/cline).

![Cline Agent Studio Icon](assets/cline-studio.png)

## Features

- **Monochrome Office Minimal Dark UI**: Redesigned webview and VS Code workbench palette (`#0e0f10` matte charcoal canvas, `#151618` elevated surfaces, 1px hairline borders, offline-bundled `Inter Variable` + `Geist Mono Variable` typography).
- **Centered Editorial Reading Column**: Messages, task headers, welcome screen, and unified floating composer card are centered (`max-w-[820px]`) for comfortable reading on wide desktop monitors.
- **Inline Model & Context Window Controls**: Switch active models (including live fetch from OpenAI-compatible/LocalAI, Ollama, and LM Studio servers) and adjust context window sizes (`4k` to `1M`) directly from the chat composer toolbar.
- **Per-Message Generation Telemetry**: Displays real-time `tok/s`, input/output tokens, total latency, TTFT (Time To First Token), prompt cache hit ratio, context window usage %, cost, and model name beneath every assistant response.
- **Focused 3-Pane or Solo Cline Layout**:
  - Clean File Explorer (left), single-file Code Editor (`showTabs: single`, 1 file at a time in the center), and locked Cline Studio panel (right).
  - Toggle between **Explorer + Editor + Cline** and **Solo Cline** full-window focus mode via **Settings -> General & Layout** or the top bar button.
- **Startup Project Picker**: Minimal dark WPF dialog on launch with recent project history and native Windows folder browser.
- **100% Isolated Profile**: Uses local `data/` and `extensions/` directories (gitignored) so your regular VS Code setup, extensions, and settings remain completely untouched.

## Quick Start (Windows)

1. Install [Visual Studio Code](https://code.visualstudio.com/).
2. Download the latest `cline-fullscreen.vsix` from the Releases page into this folder (or build it from source).
3. Run setup once to configure the isolated profile and create the Desktop shortcut with the custom monochrome icon:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Setup-Cline-Studio.ps1
   ```
4. Launch **Cline Agent Studio** from your Desktop shortcut (or run `Start-Cline-Kiosk.bat`).

## Keyboard Shortcuts

| Shortcut | Action |
| :--- | :--- |
| `Ctrl + B` | Toggle File Explorer sidebar |
| `Ctrl + Shift + K` | Focus or reopen Cline Studio panel |
| `Ctrl + Shift + O` | Switch project folder |
| `F11` | Toggle Zen Mode |

## Privacy & Security

All local session state — including VS Code `data/`, cookies, API keys, authentication tokens, AI conversation history (`state.vscdb`), installed `extensions/`, and `recent-projects.json` — is strictly excluded by `.gitignore`. Only sanitized configuration templates (`config/settings.json`, `config/keybindings.json`) and launcher scripts are stored in this repository.
