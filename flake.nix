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

    # Colorscheme
    colorscheme-catppuccin = {
      url = "github:catppuccin/nvim/v1.2.0";
      flake = false;
    };

    # Core
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # Editor
    nvim-tree = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };

    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Extras

    # LSP

    # Treesitter

    # UI
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # Util
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
              completion.enable = true;
            };
            colorscheme = {
              enable = true;
              name = "catppuccin";
              flavour = {
                dark = "mocha";
                light = "latte";
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
              ensure-installed = [ "css" "elixir" ];
            };
            ui = {
              lualine.enable = true;
              which-key.enable = true;
            };
            #util = { };
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
