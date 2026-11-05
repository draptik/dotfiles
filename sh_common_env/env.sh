# shellcheck shell=sh
# Environment variables shared by zsh (~/.zshenv) and bash (~/.bashrc)
# Include via: [[ -r ~/.dotfiles/sh_common_env/env.sh ]] && source ~/.dotfiles/sh_common_env/env.sh
#   zsh: in ~/.zshenv; bash: in ~/.bashrc, before the interactive-only guard

if command -v dotnet >/dev/null 2>&1; then
  # Opt out of .NET CLI telemetry
  export DOTNET_CLI_TELEMETRY_OPTOUT=1

  # Trust the .NET HTTPS dev cert in OpenSSL-based clients (curl, HttpClient)
  if [ -d "$HOME/.aspnet/dev-certs/trust" ]; then
    export SSL_CERT_DIR="$HOME/.aspnet/dev-certs/trust:/etc/ssl/certs"
  fi
fi
