# Nitrox Multiplayer for Subnautica on Linux

This guide helps you install the Nitrox multiplayer mod for Subnautica on Linux using Steam.

## What is this?

- Nitrox lets you play Subnautica with friends
- You can explore the ocean together, build bases and survive as a team
- This guide makes installing Nitrox easy on Linux

## What you need

- Linux (Ubuntu, Fedora, etc.)
- Steam
- Subnautica installed on Steam
- Internet connection

## Usage

1. Open `config.sh` and set your Steam folder path
2. In a terminal, run `./install.sh setup` to:
   - Download and install Nitrox
   - Configure Steam launch options
   - Add NitroxLauncher to Steam
   - Store the Nitrox patch
3. Run `./install.sh patch` to activate the mod
4. Launch Subnautica and play with friends!

## For advanced users

You can do everything manually, the script is just a helper to guide you through the process and automate some steps.

### Setup

#### 1) Install Subnautica

Install Subnautica from Steam.

> [!WARNING]
Make sure to launch it at least once for the wine prefix to be created.

#### 2) Install Nitrox

Download Nitrox from github : https://github.com/SubnauticaNitrox/Nitrox/releases/tag/1.7.1.0
> The zip file is what we need.

Unzip the folder into your Subnautica prefix, at the root of the C: drive : `$STEAM_DIR/steamapps/compatdata/264710/pfx/drive_c/Nitrox`
> 264710 is the Subnautica Game ID on Steam.

#### 3) Configure Subnautica on Steam

- open your Steam library
- right click on **Subnautica** in your library
- click on **Properties**
- in **Set Launch Options**, type `-nitrox C:\Nitrox`
- open the **Betas** tab
- on the dropdown, select **legacy - Public legacy builds**

#### 4) Add NitroxLauncher to Steam

Add to Steam:
- open your Steam library
- click on **Add a game** on the bottom left corner
- select **Add a non-steam game**
- click on **Browse...** on the bottom left corner
- select **NitroxLauncher.exe** ; should be in `$STEAM_DIR/steamapps/compatdata/264710/pfx/drive_c/Nitrox`

NitroxLauncher should be added to your library.

Configure NitroxLauncher:
- right click on **NitroxLauncher** in your library
- click on **Properties**
- open the **Compatibility** tab
- enable **Force the use of specific Steam Play compatibility tool**
- on the dropdown menu, select **Proton 8.0** or the latest version
- close the settings window

You should be able to launch NitroxLauncher from Steam.
It can take a while to start, please be patient.

#### 5) Copy the patch

When NitroxLauncher launches the game, it will patch the file `Assembly-CSharp.dll` in the game folder. The location of the file is `$STEAM_DIR/steamapps/common/Subnautica/Subnautica_Data/Managed/Assembly-CSharp.dll`

> [!NOTE]
> When Nitrox exits, it will restore the patched file. We need to copy it from the game folder while Nitrox is running.
> Right now when we launch the NitroxLauncher from steam, Subnautica does not launch, but the patch is still applied.

We need to :
- launch NitroxLauncher from Steam
- click on the 'PLAY MULTIPLAYER' button
- a small blue popup should show up at the bottom with 'Launching Subnautica...'
- copy the patched file somewhere else
- close NitroxLauncher

We are good to go!

### Launch Nitrox server

To launch the Nitrox server :
- open NitroxLauncher from Steam
- go to the 'SERVER' tab
- click on the 'START SERVER' button

### Launch Subnautica with Nitrox

To launch Subnautica with Nitrox :
- replace the file `Assembly-CSharp.dll` in the game folder with the patched file you copied earlier
- launch Subnautica from Steam

The patch stays applied, but can be overriden by Steam (updates, etc).
