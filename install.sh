#!/bin/bash

dir=$(dirname $(realpath $0))

source "$dir/config.sh";

# STEAM_DIR="~/.steam"
# NITROX_VERSION="1.7.1.0"

SUBNAUTICA_ID="264710"
STEAM_PREFIX="$STEAM_DIR/steamapps/compatdata/$SUBNAUTICA_ID/pfx"
NITROX_DIR="$STEAM_PREFIX/drive_c/Nitrox"
WORLD_BACKUP_DIR="$STEAM_DIR/steamapps/common/Subnautica/Worlds"
PATCH_PATH="$STEAM_DIR/steamapps/common/Subnautica/Subnautica_Data/Managed/Assembly-CSharp.dll"
SAVED_PATCH_PATH="$NITROX_DIR/Assembly-CSharp.dll"


# install Subnautica legacy build
check_game() {
    printf "1) checking subnautica..."
    if [ -d "$STEAM_DIR/steamapps/common/Subnautica" ]; then
        printf " \x1b[32minstalled\x1b[0m\n"
    else
        printf " \x1b[31mnot installed\x1b[0m\n"
        printf "\n\x1b[31m/!\\\\\x1b[0m Please install subnautica first.\n"
        exit 1
    fi
}

# return nitrox download url from version number
nitrox_dl_url() {
	version="$1"
	if [ -z "$version" ]; then
		version="$NITROX_VERSION"
	fi

	echo "https://github.com/SubnauticaNitrox/Nitrox/releases/download/$version/Nitrox_$version.zip"
	return 0
}

# download and unzip Nitrox
check_nitrox() {
    printf "2) checking nitrox..."
    if [ -d "$NITROX_DIR" ]; then
        printf " \x1b[32minstalled\x1b[0m\n"
        return 0
    fi
    printf " \x1b[31mnot found\x1b[0m\n"

	version="$1"
	if [ -z "$version" ]; then
		version="$NITROX_VERSION"
	fi
	url=$(nitrox_dl_url "$version")


	# backup worlds if exists
	printf "  a) backing up worlds..."
	if [ -d "$NITROX_DIR/world" ]; then
		mkdir -p "$WORLD_BACKUP_DIR";
		backup_dir="$WORLD_BACKUP_DIR/world-$(date +%s)"
		cp -r "$NITROX_DIR/world" "$backup_dir" > /tmp/nitrox-backup.log 2>&1
		if [ $? -ne 0 ]; then
			printf " \x1b[31mfailed\x1b[0m\n (logs: /tmp/nitrox-backup.log)\n"
			exit 1
		fi
		printf " \x1b[32mbacked up\x1b[0m (%s)\n" "$backup_dir"
	else
		printf " \x1b[32mnone\x1b[0m\n"
	fi

    printf "  b) cleaning up..."
    rm -rf "$NITROX_DIR";
	if [ $? -ne 0 ]; then
		printf " \x1b[31mfailed\x1b[0m\n"
		exit 1
	fi
	printf " \x1b[32mok\x1b[0m\n"

    printf "  c) downloading..."
	wget -O /tmp/nitrox.zip "$url" > /tmp/nitrox-download.log 2>&1
	if [ $? -ne 0 ]; then
		printf " \x1b[31mfailed\x1b[0m\n (logs: /tmp/nitrox-download.log)\n"
		exit 1
	fi
	printf " \x1b[32mok\x1b[0m\n"

    printf "  d) unzipping..."
    mkdir -p "$NITROX_DIR"
    unzip /tmp/nitrox.zip -d "$NITROX_DIR" > /tmp/nitrox-unzip.log 2>&1
	if [ $? -ne 0 ]; then
		printf " \x1b[31mfailed\x1b[0m\n (logs: /tmp/nitrox-unzip.log)\n"
		exit 1
	fi
	printf " \x1b[32mok\x1b[0m\n"
    rm /tmp/nitrox.zip
}

# log config
log_config() {
    printf "* STEAM_DIR:        '%s'\n" "$STEAM_DIR"
    printf "* SUBNAUTICA_ID:    '%s'\n" "$SUBNAUTICA_ID"
    printf "* NITROX_VERSION:   '%s'\n" "$NITROX_VERSION"
    printf "* NITROX_URL:       '%s'\n" "$(nitrox_dl_url "$NITROX_VERSION")"
    printf "* NITROX_DIR:       '%s'\n" "$NITROX_DIR"
	printf "* WORLD_BACKUP_DIR: '%s'\n" "$WORLD_BACKUP_DIR"
	printf "\n"

	if [ ! -d "$STEAM_DIR" ]; then
		printf " \x1b[31m/!\\\\\x1b[0m 'STEAM_DIR' not found, please set the correct path in the script\n"
		exit 1
	fi

	if [ ! -d "$STEAM_PREFIX" ]; then
		printf " \x1b[31m/!\\\\\x1b[0m Steam prefix not found, please ensure to launch Subnautica at least once\n"
		exit 1
	fi
}

setup() {
	printf "[ config ]\n"
	log_config
	printf "[ run ]\n"
	check_game
	check_nitrox "$NITROX_VERSION"

	printf "3) configure Subnautica (s: skip, y: yes) "
	read -s -n 1 answer
	if [ "$answer" = "y" ]; then
		printf "\n"
		printf "  \x1b[34ma)\x1b[0m open your Steam library\n"
		printf "  \x1b[34mb)\x1b[0m right click on 'Subnautica' in your library\n"
		printf "  \x1b[34mc)\x1b[0m click on 'Properties'\n"
		printf "  \x1b[34md)\x1b[0m in 'Set Launch Options', type: -nitrox C:\Nitrox\\\\\n"
		printf "  \x1b[34me)\x1b[0m open the 'Betas' tab\n"
		printf "  \x1b[34mg)\x1b[0m on the dropdown, select 'legacy - Public legacy builds'\n\n"
	else
		printf "\x1b[32mskipped\x1b[0m\n"
	fi

	printf "4) add NitroxLauncher to Steam (s: skip, y: yes) "
	read -s -n 1 answer
	if [ "$answer" = "y" ]; then
		printf "\n"
		printf "  [ADD TO STEAM]\n"
		printf "  \x1b[34ma)\x1b[0m open your Steam library\n"
		printf "  \x1b[34mb)\x1b[0m click on 'Add a game' on the bottom left corner\n"
		printf "  \x1b[34mc)\x1b[0m select 'Add a non-steam game'\n"
		printf "  \x1b[34md)\x1b[0m click on 'Browse...' on the bottom left corner'\n"
		printf "  \x1b[34me)\x1b[0m select 'NitroxLauncher.exe' in the folder '%s'\n\n" "$NITROX_DIR"

		printf "  Yay ! NitroxLauncher should be added to your library now ; if not, redo the steps a) to e)\n\n"

		printf "  [CONFIGURE]\n"
		printf "  \x1b[34mf)\x1b[0m right click on 'NitroxLauncher' in your library\n"
		printf "  \x1b[34mg)\x1b[0m click on 'Properties'\n"
		printf "  \x1b[34mh)\x1b[0m open the 'Compatibility' tab\n"
		printf "  \x1b[34mi)\x1b[0m enable 'Force the use of specific Steam Play compatibility tool'\n"
		printf "  \x1b[34mj)\x1b[0m on the dropdown menu, select 'Proton 8.0' or the latest version\n"
		printf "  \x1b[34mk)\x1b[0m close the settings window\n\n"

		printf "  Yay ! NitroxLauncher should be configured now ; you should be able to launch it from Steam\n"
		printf "  It can take a while to start, please be patient.\n"
		printf "  If it is not working, redo the steps f) to k)\n\n"
	fi
	printf "\x1b[32mskipped\x1b[0m\n"

	printf "5) copy the patch (s: skip, y: yes) "
	read -s -n 1 answer
	if [ "$answer" = "y" ]; then
		printf "\n"
		printf "  \x1b[34ma)\x1b[0m open your Steam library\n"
		printf "  \x1b[34mb)\x1b[0m launch NitroxLauncher\n"
		printf "  \x1b[34mc)\x1b[0m click on the 'PLAY MULTIPLAYER' button\n"
		printf "  \x1b[34md)\x1b[0m press enter when the bottom blue popup shows 'Launching Subnautica...'\n"
		read -s -n 1
		printf "  \x1b[34me)\x1b[0m copying the patch..."
		cp -r "$PATCH_PATH" "$NITROX_DIR/" > /tmp/nitrox-patch.log 2>&1
		if [ $? -ne 0 ]; then
			printf " \x1b[31mfailed\x1b[0m\n (logs: /tmp/nitrox-patch.log)\n"
			exit 1
		fi
		printf " \x1b[32mok\x1b[0m\n"
		printf "  \x1b[34mf)\x1b[0m close NitroxLauncher\n"
	fi

	printf "\n\n"
	printf "> It was a long ride, but you're done ! Congratulations !\n\n"
	printf "To launch the nitrox server, launch NitroxLauncher from Steam, go to Server, and click on 'Start Server'\n";
	printf "To launch Subnautica with the multiplayer mod enabled, run './install.sh patch', then launch Subnautica from Steam\n";
	exit 0
}

patch() {
	printf "[ config ]\n"
	log_config
	printf "[ run ]\n"
	check_game
	check_nitrox "$NITROX_VERSION"

	# ensure saved patch exists
	printf "1) checking patch..."
	if [ ! -f "$SAVED_PATCH_PATH" ]; then
		printf " \x1b[31m/!\\\\\x1b[0m patch not found, please run './install.sh setup' first\n"
		exit 1
	fi
	printf " \x1b[32mfound\x1b[0m\n"

	# copy saved patch to game
	printf "2) copying patch..."
	cp -r "$SAVED_PATCH_PATH" "$PATCH_PATH"
	if [ $? -ne 0 ]; then
		printf " \x1b[31mfailed\x1b[0m\n"
		exit 1
	fi
	printf " \x1b[32mcopied\x1b[0m\n"

	printf "\n\n"
	printf "You can now launch Subnautica from Steam, and enjoy the multiplayer mod !\n"
	exit 0
}

if [ "$1" = "patch" ]; then
	patch
elif [ "$1" = "setup" ]; then
	setup
else
	printf "Usage: ./install.sh [patch|setup]\n"
	exit 1
fi
