# toggle-cam 🔌📷  
A tool for linux laptops. Like a light-switch to turn your webcam device on and off.

---

When your power bill is lower, you can thank me at https://ko-fi.com/updogupdogupdog 💸

---

Discord for Linux desktop environments will power on your laptop's onboard webcam while it is running, and poll it repeatedly every few seconds. Even if you are not in any video calls, or if it is just running in the background. Even if you've never used it to video chat at all.

This behavior causes significant, non-trivial battery drain even if you only let Discord idle and never even interact with it. Legitimately 2+ Watts. You can watch this yourself if you install `powertop` and open Discord, wait 5 seconds or so and the camera will appear and your power usage might increase by 50-100%. Then close it, or run this tool and check again. Multiple hours of battery drained, thousands of tons of coal and oil and nuclear power wasted. Accelerate the heat death of the universe, or use this tool? Easy choice. 🔥🌍

Or just run discord from your browser and deny it camera privileges instead, but then you gotta keep a browser open. 🧠

---

Use the desktop icon, or `toggle-cam` can be run directly from CLI to disable the camera. Either until next boot, or you can run it again to re-enable the camera.

Tested in NixOS in KDE. Probably works with other stuff but if it doesn't work, tell me. Requires `kdialog` only for a pop-up menu indicating state change. Should work without it I think.

---

# Install instructions (normies) 🛠️  
* Be a sudo or root user, this is driver manipulation stuff.
* (Optional) Install kdialog, or don't. I'm not your dad. (you got this. IDK what distro you're on, figure it out.)
```
wget https://github.com/UpdogUpdogUpdog/toggle-cam/archive/main.zip -O ~/toggle-cam.zip
unzip ~/toggle-cam.zip  -d ~/   # creates ~/toggle-cam-main
~/toggle-cam-main/install.sh             # enters sudo password once
```
---
# NixOS home-manager

Add this crap to your Home Manager configuration (`home.nix`):

```nix
home.packages = with pkgs; [
  (stdenv.mkDerivation rec {
    pname = "toggle-cam";
    version = "main";

    src = fetchFromGitHub {
      owner = "UpdogUpdogUpdog";
      repo = "toggle-cam";
      rev = "main";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # replace after initial build attempt
    };

    nativeBuildInputs = [ bash ];

    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      IS_NIXOS=true PREFIX=$out bash ./install.sh
    '';
  })
];
```

**First-time setup**:

1. Run:
   ```shell
   home-manager switch
   ```

   This initial run **will fail**, but that's good for once. We're generating SHA256 hashes.

2. Copy the correct SHA256 hash provided by the error message, replace the placeholder (`sha256-AAA...`) in your configuration.

3. Run again:
   ```shell
   home-manager switch
   ```

Then you're good 


# How to use it 🧰  
toggle-cam

or

![image](https://github.com/user-attachments/assets/745f094d-f640-4e19-8178-42794efb31c9)


or

`toggle-cam`

perhaps

```
toggle-cam
```

or

toggle-cam

Survives sleep mode for me. If you are rebooting, your system will redetect the camera. 🔁

---

# Uninstall
```
~/toggle-cam-main/uninstall.sh
```

---

_Buy me a drink? I put out._ 🍻

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W51DFJQG)
