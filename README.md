## Nix Nvim
Neovim configuration, written in Lua, conveniently set up using Nix!

⚠️ In development! ⚠️
<br>
_Some features may be missing or unstable_ 

## Executing with Nix
```bash
nix run github:douglastofoli/nvim#apps.<system>.default
```

## Add to your Nix Flake
```nix
{
  inputs = {
    # ...
    nvim.url = "github:douglastofoli/nvim";
  };

  outputs = { nvim, ... }:
    let overlays = [ nvim.overlays."${system}".default ];
    in {
      # ...
    };
}
```
