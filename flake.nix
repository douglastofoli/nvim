{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    # Add bleeding-edge plugins here.
    # They can be updated with `nix flake update` (make sure to commit the generated flake.lock)
    # wf-nvim = {
    #   url = "github:Cassin01/wf.nvim";
    #   flake = false;
    # };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    systems = builtins.attrNames nixpkgs.legacyPackages;

    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neovim-overlay
          inputs.gen-luarc.overlays.default
        ];
      };
      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pkgs; [
          lua-language-server
          nil
          stylua
          luajitPackages.luacheck
          nvim-dev
        ];
        shellHook = ''
          ln -fs ${pkgs.nvim-luarc-json} .luarc.json
          ln -Tfns $PWD/nvim ~/.config/nvim-dev
        '';
      };
    in {
      packages = rec {
        default = nvim;
        nvim = pkgs.nvim-pkg;
      };
      devShells = {
        default = shell;
      };
    })
    // {
      overlays.default = neovim-overlay;
    };
}
