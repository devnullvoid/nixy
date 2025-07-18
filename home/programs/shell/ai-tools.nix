# AI tools for the shell
{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # Amazon Q CLI - AWS AI assistant
    amazon-q-cli
    
    # Google Gemini CLI
    gemini-cli
    
    # Claude Code - Anthropic's coding assistant
    claude-code
  ];

  # Optional: Add any shell-specific configurations for these tools
  # For example, aliases or environment variables
  programs.fish.shellAliases = {
    # Quick access to AI tools
    q = "amazon-q-cli";
    gemini = "gemini-cli";
    claude = "claude-code";
  };

  # Optional: Add any environment variables needed for these tools
  home.sessionVariables = {
    # Add any required API keys or configuration paths
    # AMAZON_Q_API_KEY = "your-key-here";  # Uncomment and set if needed
    # GEMINI_API_KEY = "your-key-here";    # Uncomment and set if needed
    # CLAUDE_API_KEY = "your-key-here";    # Uncomment and set if needed
  };
} 