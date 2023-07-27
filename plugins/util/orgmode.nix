{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  inherit (lib.strings) concatStringsSep;
  plugin = config.nvim.util.orgmode;
in {
  options.nvim.util.orgmode = {
    enable = mkEnableOption "Enable nvim-tree";
    org-agenda-files = mkOption {
      description = "Directory where agenda files will be saved";
      type = with types; listOf (nullOr (str));
      default = [ "~/org/agenda/" ];
    };
    org-notes-file = mkOption {
      description = "Directory where notes files will be saved";
      type = with types; nullOr (str);
      default = "~/org/";
    };
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ orgmode ];

    rawConfig = ''
      require("orgmode").setup_ts_grammar()

      require("orgmode").setup({
        org_agenda_files = {
          ${
            concatStringsSep "\n"
            (map (x: ''"'' + x + ''",'') plugin.org-agenda-files)
          }
        },
        org_default_notes_file = "${plugin.org-notes-file}",
      })
    '';
  };
}
