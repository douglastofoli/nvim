{
  lib,
  stdenv,
  sqlite,
  git,
  neovim-unwrapped,
  wrapNeovimUnstable,
  neovimUtils,
}:
with lib;
  {
    appName ? null,
    plugins ? [],
    devPlugins ? [],
    ignoreConfigRegexes ? [],
    extraPackages ? [],
    extraLuaPackages ? p: [],
    extraPython3Packages ? p: [],
    withPython3 ? true,
    withRuby ? false,
    withNodeJs ? false,
    withSqlite ? true,
    viAlias ? appName == null || appName == "nvim",
    vimAlias ? appName == null || appName == "nvim",
    wrapRc ? true,
  }: let
    defaultPlugin = {
      plugin = null;
      config = null;
      optional = false;
      runtime = {};
    };

    externalPackages = extraPackages ++ (optionals withSqlite [sqlite]);

    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    plugins;

    neovimConfig = neovimUtils.makeNeovimConfig {
      inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    nvimRtpSrc = let
      src = ../nvim;
    in
      lib.cleanSourceWith {
        inherit src;
        name = "nvim-rtp-src";
        filter = path: tyoe: let
          srcPrefix = toString src + "/";
          relPath = lib.removePrefix srcPrefix (toString path);
        in
          lib.all (regex: builtins.match regex relPath == null) ignoreConfigRegexes;
      };

    nvimRtp = stdenv.mkDerivation {
      name = "nvim-rtp";
      src = nvimRtpSrc;

      buildPhase = ''
        mkdir -p $out/nvim
        mkdir -p $out/lua
        rm init.lua
      '';

      installPhase = ''
        cp -r lua $out/lua
        rm -r lua
        if [ -d "after" ]; then
            cp -r after $out/after
            rm -r after
        fi
        if [ ! -z "$(ls -A)" ]; then
            cp -r -- * $out/nvim
        fi
      '';
    };

    initLua =
      ''
        -- prepend lua directory
        vim.opt.rtp:prepend('${nvimRtp}/lua')
      ''
      + (builtins.readFile ../nvim/init.lua)
      + optionalString (devPlugins != []) (
        ''
          local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
          local dev_plugins_dir = dev_pack_path .. '/opt'
          local dev_plugin_path
        ''
        + strings.concatMapStringsSep
        "\n"
        (plugin: ''
          dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
          if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
            vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
            vim.cmd('!${git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
          end
          vim.cmd('packadd! ${plugin.name}')
        '')
        devPlugins
      )
      + ''
        vim.opt.rtp:prepend('${nvimRtp}/nvim')
        vim.opt.rtp:prepend('${nvimRtp}/after')
      '';

    extraMakeWrapperArgs = let
      sqliteLibExt = stdenv.hostPlatform.extensions.sharedLibrary;
      sqliteLibPath = "${sqlite.out}/lib/libsqlite3${sqliteLibExt}";
    in
      builtins.concatStringsSep " " (
        (optional (appName != "nvim" && appName != null && appName != "")
          ''--set NVIM_APPNAME "${appName}"'')
        ++ (optional (externalPackages != [])
          ''--prefix PATH : "${makeBinPath externalPackages}"'')
        ++ (optional withSqlite
          ''--set LIBSQLITE_CLIB_PATH "${sqliteLibPath}"'')
        ++ (optional withSqlite
          ''--set LIBSQLITE "${sqliteLibPath}"'')
      );

    luaPackages = neovim-unwrapped.lua.pkgs;
    resolvedExtraLuaPackages = extraLuaPackages luaPackages;

    extraMakeWrapperLuaCArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''--suffix LUA_CPATH ";" "${concatMapStringsSep ";" luaPackages.getLuaCPath resolvedExtraLuaPackages}"'';

    extraMakeWrapperLuaArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''--suffix LUA_PATH ";" "${concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages}"'';

    neovim-wrapped = wrapNeovimUnstable neovim-unwrapped (neovimConfig
      // {
        luaRcContent = initLua;
        wrapperArgs =
          escapeShellArgs neovimConfig.wrapperArgs
          + " "
          + extraMakeWrapperArgs
          + " "
          + extraMakeWrapperLuaCArgs
          + " "
          + extraMakeWrapperLuaArgs;
        wrapRc = wrapRc;
      });

    isCustomAppName = appName != null && appName != "nvim";
  in
    neovim-wrapped.overrideAttrs (oa: {
      buildPhase =
        oa.buildPhase
        + lib.optionalString isCustomAppName ''
          mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
        '';
      meta.mainProgram =
        if isCustomAppName
        then appName
        else oa.meta.mainProgram;
    })
