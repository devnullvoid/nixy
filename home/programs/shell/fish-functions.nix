# Fish shell functions - useful utilities
{
  programs.fish = {
    functions = {
      # Refresh fish configuration
      refresh = "source $HOME/.config/fish/config.fish";
      
      # Create directory and cd into it
      take = ''mkdir -p -- "$1" && cd -- "$1"'';
      
      # Create temporary directory and cd into it
      ttake = "cd $(mktemp -d)";
      
      # Show PATH in readable format
      show_path = "echo $PATH | tr ' ' '\n'";
      
      # Source POSIX environment files
      posix-source = ''
        for i in (cat $argv)
          set arr (echo $i |tr = \n)
          set -gx $arr[1] $arr[2]
        end
      '';
    };
  };
} 