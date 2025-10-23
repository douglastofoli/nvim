{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  all-plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    luasnip

    nvim-cmp
    cmp_luasnip
    lspkind-nvim
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-buffer
    cmp-path
    cmp-nvim-lua
    cmp-cmdline
    cmp-cmdline-history

    diffview-nvim
    neogit
    gitsigns-nvim
    vim-fugitive

    telescope-nvim
    telescope-fzy-native-nvim
    lualine-nvim
    nvim-navic
    statuscol-nvim
    nvim-treesitter-context
    vim-unimpaired
    eyeliner-nvim
    nvim-surround
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    nvim-unception
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    which-key-nvim

    # (mkNvimPlugin inputs.wf-nvim "wf.nvim")
  ];

  extraPackages = with pkgs; [
    lua-language-server
    nil
  ];
in {
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
