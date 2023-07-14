{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  colorscheme = config.nvim.colorscheme;
  completion = config.nvim.coding.completion;
in {
  options.nvim.colorscheme = {
    enable = mkEnableOption "Enable theme customization";
    name = mkOption {
      description = "Name of the colorscheme to use";
      type = types.enum [ "catppuccin" ];
      default = "catppuccin";
    };
    flavour = {
      dark = mkOption {
        description = "Dark variant of colorscheme style";
        type = let catppuccin = types.enum [ "frappe" "macchiato" "mocha" ];
        in catppuccin;
        default = "mocha";
      };
      light = mkOption {
        description = "Light variant of colorscheme style";
        type = let catppuccin = types.enum [ "latte" ];
        in types.nullOr (catppuccin);
        default = null;
      };
    };
  };

  config.nvim = mkIf colorscheme.enable {
    startPlugins = with pkgs.neovimPlugins;
      ((withPlugins (colorscheme.name == "catppuccin")
        [ colorscheme-catppuccin ]));

    rawConfig = ''
      ${writeIf (colorscheme.name == "catppuccin") ''
        -- catppuccin colorscheme
        require('catppuccin').setup({
          flavour = "${colorscheme.flavour.dark}",
          ${
            writeIf (colorscheme.flavour.light != null) ''
              background = {
                dark = "${colorscheme.flavour.dark}",
                light = "${colorscheme.flavour.light}",
              },
            ''
          }
          integration = {
            ${
              writeIf completion.enable ''
                cmp = true,
              ''
            }
          },
        })
      ''}
    '';
  };
}
