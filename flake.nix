{
  description = "My Neovim using Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Coding
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };

    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };

    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    # Colorscheme
    catppuccin = {
      url = "github:catppuccin/nvim/v1.2.0";
      flake = false;
    };

    # Editor
    nvim-tree = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Extras

    # LSP

    # Treesitter
    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };

    nvim-ts-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    nvim-ts-rainbow = {
      url = "github:HiPhish/nvim-ts-rainbow2";
      flake = false;
    };

    # UI
    bufferline = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };

    dressing = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };

    legendary = {
      url = "github:mrjones2014/legendary.nvim";
      flake = false;
    };

    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # Util
    orgmode = {
      url = "github:nvim-orgmode/orgmode";
      flake = false;
    };

    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        lib = import ./lib.nix { inherit inputs pkgs; };

        inherit (import ./overlays.nix { inherit lib; }) overlays;

        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

        config = {
          nvim = {
            coding = {
              autopairs.enable = true;
              #comments.enable = true;
              completion = {
                enable = true;
                buffer.enable = true;
                cmdline.enable = true;
                lsp = {
                  enable = true;
                  lspkind.enable = true;
                };
                path.enable = true;
                snippets = {
                  enable = true;
                  source = "luasnip";
                };
              };
            };
            colorscheme = {
              catppuccin = {
                enable = true;
                name = "catppuccin";
                flavour = {
                  dark = "mocha";
                  light = "latte";
                };
              };
            };
            editor = {
              nvim-tree = { enable = true; };
              telescope = { enable = true; };
            };
            #extras = { };
            #lsp = { };
            treesitter = {
              enable = true;
              autotag.enable = true;
              context.enable = true;
              rainbow.enable = true;
              ensure-installed = [
                "css"
                "eex"
                "elixir"
                "graphql"
                "heex"
                "html"
                "javascript"
                "json"
                "lua"
                "nix"
                "toml"
                "typescript"
                "regex"
                "scss"
                "sql"
                "org"
                "yaml"
              ];
            };
            ui = {
              enable = true;
              bufferline.enable = true;
              dressing = {
                enable = true;
                input.enable = true;
                select.enable = true;
              };
              legendary.enable = true;
              statusline = {
                enable = true;
                global = true;
              };
              which-key.enable = true;
            };
            util = {
              orgmode = {
                enable = true;
                org-agenda-files = [ "~/org/agenda" "~/.org/agenda" ];
                org-notes-file = "~/org/";
              };
            };
          };
        };
      in rec {
        packages = rec {
          default = nvim;
          nvim = lib.mkNeovim { inherit config; };
        };

        apps = rec {
          nvim = {
            type = "app";
            program = "${packages.default}/bin/nvim";
          };
          default = nvim;
        };

        overlays.default = super: self: {
          inherit (lib) mkNeovim;
          inherit (pkgs) neovimPlugins;
          nvim = packages.nvim;
        };

        devShells.default = pkgs.mkShell { packages = [ packages.nvim ]; };
      });
}
