<div align="center">

# ii-DYNAMiC$

```
=====================================================
                      UPCOMING~                      
=====================================================
```

**A Material 3 Expressive desktop environment for Hyprland, powered by Quickshell.**

</div>

<br>

A customized fork of **[ii-p3drovfx](https://github.com/P3DROVFX/ii-p3drovfx)** (itself derived from **[ii-vynx](https://github.com/vaguesyntax/ii-vynx)** and **[illogical-impulse](https://github.com/end-4/dots-hyprland)**). Every surface follows **Material 3 Expressive**: fluid state-morphing shapes, expressive typography, and dynamic palette generation driven by Matugen.

---

<div align="center">

### UPCOMING~

</div>

## Key Architectural Highlights

- **Dynamic Island**:
  - **Instant Collapse**: Pressing **`Esc`** while expanded collapses the island directly to its compact, resting time-only clock face.
  - **Type-to-Search**: Seamless app search from the island dashboard without extra search bars cluttering resting states.
  - **Uniform Scaling**: Optical alignment and synchronized width transitions between workspaces and the resting clock.
  - **Live Overlays**: Contextual controls for media playback, volume, brightness, battery, and system activities.
- **Rebuilt Top Shell Autohide Engine**:
  - Centralized hover bus in `GlobalStates.qml` eliminates top-edge cursor oscillation and panel jitter.
  - **Window Overlay Mode**: When `pushWindows: false` is set in Settings, the top bar and island smoothly slide above windows without resizing tiles or triggering desktop reflow.
- **Notification Sanitization**:
  - Strict pattern filtering prevents internal file paths (e.g. `.SCOPED_DIR...`) from rendering as broken oversized font glyphs.
- **Hardware Bindings Protection**:
  - Touchpad toggle, audio mute, mic mute, and volume controls run with `ignore_mods = true` so laptop hardware switches always register.

---

<div align="center">

### UPCOMING~

</div>

## Built-in Apps & Tools

- **Clock**: Alarms, world clock, timers, pomodoro counter, and bedtime routines.
- **EasyEffects**: Dedicated audio profiles and presets for headphones and speakers.
- **Modes & Routines**: Profile automation and display modes.
- **Cheatsheet**: Integrated calendar with Google/Outlook/ICS sync, interactive keybind library, typing test, and offline dev tools.
- **Companion Bridge (`ii-tools`)**: Phone pairing over LAN/Tailscale, interactive screen mirroring, touchpad, camera, microphone, and shared clipboard.
- **Live Draw**: Screen annotation, spotlighting, and instant capture.

---

## Requirements

- **Hyprland 0.56.1 or newer**
- **Matugen 4.1.0 or newer**
- **quickshell-git 0.3.0 or newer** (or patched `quickshell-ii-git`)

---

## Installation

### Default Installation (Full Setup)

Installs the base dotfiles and applies the **ii-DYNAMiC$** configuration:

```bash
git clone --recurse-submodules https://github.com/imyash0722/ii-DYNAMiC.git
cd ii-DYNAMiC
./setup-ii-p3drovfx.sh install
```

### Minimal Installation (Quickshell Config Only)

If you already have illogical-impulse dotfiles configured and only want the shell:

```bash
git clone --recurse-submodules https://github.com/imyash0722/ii-DYNAMiC.git
cd ii-DYNAMiC
./setup-ii-p3drovfx.sh
```

---

## Updating

Update effortlessly from within the shell (**Settings → About**) or directly from the terminal:

```bash
./setup-ii-p3drovfx.sh update
```

The shell update checker and installer automatically recognize `ii-DYNAMiC$` and keep all customizations and hardware protections preserved across updates.

---

<details>
<summary><strong>🛠 Troubleshooting & Common Fixes</strong></summary>

<br>

### Dynamic Colors / Matugen Not Working
Verify installed versions:
```bash
matugen --version
quickshell --version
```
On Arch Linux / CachyOS, make sure you are using `aur/quickshell-git`:
```bash
yay -S aur/quickshell-git
```

### Quickshell Stopped Working After a Qt Update
Rebuild `quickshell-git` against the newly updated Qt libraries:
```bash
yay -S --rebuild aur/quickshell-git
```

### Tray Icons Missing After Restart
Ensure the `sni_watcher` helper binary is compiled:
```bash
~/.config/quickshell/ii/scripts/rust-helpers.sh build sni_watcher
```

</details>

---

## Credits & Attribution

<!-- Special credit to P3DROVFX for the o.g. project (https://github.com/P3DROVFX/ii-p3drovfx) and its architecture -->

Special credit and gratitude to **[P3DROVFX](https://github.com/P3DROVFX/ii-p3drovfx)** for the o.g. project and its foundational architecture.

- **[P3DROVFX](https://github.com/P3DROVFX/ii-p3drovfx):** Creator of the original ii-p3drovfx shell.
- **[end-4](https://github.com/end-4):** Creator of illogical-impulse dotfiles.
- **[vaguesyntax](https://github.com/vaguesyntax):** Creator of ii-vynx.
- **[pc-trade](https://github.com/pctrade):** Design and feature inspirations.
- **[so-do-i-look-like-him](https://github.com/so-do-i-look-like-him):** Installation bug fixes.
- **[asteriau](https://github.com/asteriau):** Cheatsheet keybind animations.
- **[hnpf](https://github.com/hnpf):** Nothing widgets design.
- **[gowall](https://github.com/Achno/gowall):** Dynamic icons theme system.
- **[hyprmon](https://github.com/erans/hyprmon):** Monitor management in settings.
- **[Quickshell](https://quickshell.org/):** Reactive desktop shell toolkit.
- **[Hyprland](https://hypr.land/):** Wayland compositor.

<br>

<div align="center">
  <b>⭐ If you find ii-DYNAMiC$ useful, consider starring the repository!</b>
</div>
