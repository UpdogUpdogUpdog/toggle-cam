# toggle-cam
A tool for linux laptops. Like a light-switch to turn your webcam device on and off.

Discord for Linux desktop environments will power on your laptop's onboard webcam while it is running, and poll it repeatedly every few seconds. Even if you are not in any video calls, or if it is just running in the background. Even if you've never used it to video chat at all.

This behavior causes significant, non-trivial battery drain even if you only let Discord idle and never even interact with it. Legitimately 2+ Watts. You can watch this yourself if you install `powertop` and open Discord, wait 5 seconds or so and the camera will appear and your power usage might increase by 50-100%. Then close it, or run this tool and check again. Multiple hours of battery drained, thousands of tons of coal and oil and nuclear power wasted. Accelerate the heat death of the universe, or use this tool? Easy choice.  

Or just run discord from your browser and deny it camera privileges instead, but then you gotta keep a browser open.

toggle-cam can be run directly from CLI to disable the camera until next boot, or you can run it again to re-enable the camera.

I'm working on the desktop icon for toggle-cam, but we'll get there. Just CLI for now. 

Tested in NixOS in KDE. Probably works with other stuff. Requires `kdialog` only for a pop-up menu indicating state change. Should work without it I think.

# Install instructions
These steps will improve in time:
* Be a sudo or root user, this is driver manipulation stuff.
  
```git clone https://github.com/UpdogUpdogUpdog/toggle-cam.git```

* Install kdialog, or don't. I'm not your dad. (you got this. IDK what distro you're on, figure it out.)
  
```cp toggle-cam/toggle-cam-1.0/usr/local/bin/toggle-cam.sh /usr/local/bin/toggle-cam```

```chmod +x /usr/local/bin/toggle-cam```


# How to use it
toggle-cam

or

`toggle-cam`

perhaps

```toggle-cam```

or

toggle-cam

Survives sleep mode for me. If you are rebooting, your system will redetect the camera. 

_Buy me a drink? I put out._

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W51DFJQG)