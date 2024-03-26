#!/usr/bin/env bash
set -euxo pipefail

VORTEX_LINUX="v1.3.4"
VORTEX_VERSION="1.9.12"
PROTON_BUILD="GE-Proton8-27"

PROTON_URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/$PROTON_BUILD/$PROTON_BUILD.tar.gz"
VORTEX_INSTALLER="vortex-setup-$VORTEX_VERSION.exe"
VORTEX_URL="https://github.com/Nexus-Mods/Vortex/releases/download/v$VORTEX_VERSION/$VORTEX_INSTALLER"
DOTNET_URL="https://download.visualstudio.microsoft.com/download/pr/06239090-ba0c-46e2-ad3e-6491b877f481/c5e4ab5e344eb3bdc3630e7b5bc29cd7/windowsdesktop-runtime-6.0.21-win-x64.exe"

# install steam linux runtime sniper
steam steam://install/1628350

mkdir -p ~/.pikdum/steam-deck-master/vortex/

cd ~/.pikdum/steam-deck-master/vortex/

rm -rf vortex-linux || true
wget https://github.com/pikdum/vortex-linux/releases/download/$VORTEX_LINUX/vortex-linux
chmod +x vortex-linux

# set STEAM_RUNTIME_PATH to internal storage or sd card
if [ -f "$HOME/.steam/steam/steamapps/common/SteamLinuxRuntime_sniper/run" ]; then
    STEAM_RUNTIME_PATH="$HOME/.steam/steam/steamapps/common/SteamLinuxRuntime_sniper"
elif [ -f "/run/medis/games-2tb/SteamLibrary/steamapps/common/SteamLinuxRuntime_sniper/run" ]; then
    STEAM_RUNTIME_PATH="/run/medis/games-2tb/SteamLibrary/steamapps/common/SteamLinuxRuntime_sniper"
else
    echo "SteamLinuxRuntime Sniper not found!"
    sleep 3
    exit 1
fi

./vortex-linux setConfig STEAM_RUNTIME_PATH $STEAM_RUNTIME_PATH
./vortex-linux downloadProton "$PROTON_URL"
./vortex-linux setProton "$PROTON_BUILD"
./vortex-linux downloadVortex "$VORTEX_URL"
./vortex-linux protonRunUrl "$DOTNET_URL" /q
./vortex-linux setupVortexDesktop
./vortex-linux installVortex "$VORTEX_INSTALLER"

cd ~/.vortex-linux/compatdata/pfx/dosdevices

if [ -d "$HOME/.steam/steam/steamapps/common/" ]; then
    ln -s "$HOME/.steam/steam/steamapps/common/" j: || true
fi

if [ -d "/run/medis/games-2tb/steamapps/common/" ]; then
    ln -s "/run/medis/games-2tb/steamapps/common/" k: || true
fi

update-desktop-database || true


mkdir -p /run/medis/games-2tb/vortex-downloads || true

echo "Success! Exiting in 3..."
sleep 3
