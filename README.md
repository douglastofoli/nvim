# Neovim Derivation (Nix Flake)

Custom Neovim build packaged as a Nix flake. The flake wraps the
configuration under `nvim/`, bundles plugins via an overlay, and exposes both
a runnable Neovim package and a development shell tailored for Lua work.

## Prerequisites
- Nix with flakes enabled.

## Quick Start
- `nix build` — builds the default package (`.#nvim`) and produces a wrapped
  Neovim binary in `./result/bin/nvim`.
- `nix run` — runs the wrapped Neovim directly without keeping the build output.
- `nix develop` — enters the development shell with language servers, linters,
  and a shell hook that links the config to `~/.config/nvim-dev` and generates
  `.luarc.json`.

The derivation sets `NVIM_APPNAME` when needed, so runtime files and caches are
isolated from any globally installed Neovim.

## Repository Layout
- `flake.nix` / `flake.lock` — flake entry point, inputs, package and shell
  definitions.
- `nix/`
  - `neovim-overlay.nix` — overlay providing the packaged Neovim, dev variant,
    and generated `luarc` metadata.
  - `mkNeovim.nix` — wrapper logic used by the overlay (handles runtime path,
    optional dev plugins, and external tool packaging).
- `nvim/` — Neovim runtime files that become the packaged configuration.
  - `init.lua` — main entry point sourced by the wrapped Neovim.
  - `after/` — configuration loaded after the main runtime (see
    `nvim/after/README.md`).
  - `ftplugin/` — filetype-specific Lua settings.
  - `lua/` — Lua modules, including `lua/user/` for language-server setup.
  - `plugin/` — plugin configuration modules automatically sourced on startup.

## Customisation Notes
- To add or pin plugins, edit `nix/neovim-overlay.nix` (use `mkNvimPlugin` for
  non-flake sources) and run `nix flake update` when inputs change.
- Adjust runtime files under `nvim/` as you would in a standard Neovim setup;
  the flake packages the directory onto the runtime path.
- The development shell exposes `lua-language-server`, `nil`, `stylua`, and
  `luacheck` for local iteration.

## Updating
Run `nix flake update` to refresh inputs. Commit the resulting `flake.lock` so
that builds remain reproducible.

