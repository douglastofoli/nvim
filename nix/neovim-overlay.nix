{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
      doCheck = false;
    };

  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  all-plugins = with pkgs.vimPlugins; [
    # Core
    (mkNvimPlugin inputs.plenary-nvim "plenary.nvim")

    # LSP / Autocomplete / Snippets
    (mkNvimPlugin inputs.nvim-lspconfig "nvim-lspconfig")
    (mkNvimPlugin inputs.elixir-tools-nvim "elixir-tools.nvim")
    (mkNvimPlugin inputs.nvim-cmp "nvim-cmp")
    (mkNvimPlugin inputs.cmp-nvim-lsp "cmp-nvim-lsp")
    (mkNvimPlugin inputs.cmp-buffer "cmp-buffer")
    (mkNvimPlugin inputs.cmp-path "cmp-path")
    (mkNvimPlugin inputs.cmp-luasnip "cmp-luasnip")
    (mkNvimPlugin inputs.luasnip "luasnip")
    (mkNvimPlugin inputs.friendly-snippets "friendly-snippets")

    # Syntax
    (mkNvimPlugin inputs.nvim-treesitter "nvim-treesitter")

    # Files
    (mkNvimPlugin inputs.telescope-nvim "telescope.nvim")
    (mkNvimPlugin inputs.telescope-fzf-native "telescope-fzf-native.nvim")
    (mkNvimPlugin inputs.neo-tree-nvim "neo-tree.nvim")
    (mkNvimPlugin inputs.nvim-web-devicons "nvim-web-devicons")

    # UI
    (mkNvimPlugin inputs.lualine-nvim "lualine.nvim")
    (mkNvimPlugin inputs.noice-nvim "noice.nvim")
    (mkNvimPlugin inputs.dressing-nvim "dressing.nvim")
    #(mkNvimPlugin inputs.which-key-nvim "which-key.nvim")
    which-key-nvim
    (mkNvimPlugin inputs.wf-nvim "wf.nvim")

    # Git
    (mkNvimPlugin inputs.gitsigns-nvim "gitsigns.nvim")
    (mkNvimPlugin inputs.diffview-nvim "diffview.nvim")

    # AI / Copilot
    (mkNvimPlugin inputs.copilot-lua "copilot.lua")
    (mkNvimPlugin inputs.copilot-cmp "copilot-cmp")
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
