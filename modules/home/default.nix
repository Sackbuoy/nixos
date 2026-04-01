# Home-manager modules bundle
# Import this to get access to all myHome.* options
{
  imports = [
    ./shell
    ./git.nix
    ./terminal
    ./tmux
    ./zoxide.nix
    ./scripts
  ];
}
