{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  completion = config.nvim.coding.completion;
in {
  options.nvim.coding.completion = {
    enable = mkEnableOption "Enables auto completion";
  };
}
