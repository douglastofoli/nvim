{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  plugin = config.nvim.colorscheme.catppuccin;
  completion = config.nvim.coding.completion;
in {
  options.nvim.colorscheme.catppuccin = {
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

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins;
      ((withPlugins (plugin.name == "catppuccin") [ catppuccin ]));

    rawConfig = ''
      ${writeIf (plugin.name == "catppuccin") ''
        -- catppuccin colorscheme
        require('catppuccin').setup({
          flavour = "${plugin.flavour.dark}",
          ${
            writeIf (plugin.flavour.light != null) ''
              background = {
                dark = "${plugin.flavour.dark}",
                light = "${plugin.flavour.light}",
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
