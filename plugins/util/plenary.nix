{ config, pkgs, ... }:

{
  config.nvim = { startPlugins = with pkgs.neovimPlugins; [ plenary ]; };
}
