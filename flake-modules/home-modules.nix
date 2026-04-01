# Export Home-Manager modules via flake.homeManagerModules
{...}: {
  flake.homeManagerModules = {
    # Individual modules
    shell = import ../modules/home/shell;
    git = import ../modules/home/git.nix;
    terminal = import ../modules/home/terminal;
    tmux = import ../modules/home/tmux;
    zoxide = import ../modules/home/zoxide.nix;
    scripts = import ../modules/home/scripts;

    # Bundle: all home modules
    default = import ../modules/home;
  };
}
