# remaster.sh
Remaster an Ubuntu ISO from Ubuntu 14.04+

Requires bash, sudo access, an internet connection (for apt-get), and an iso to remaster.

```bash
Originally by Pat Natali https://github.com/beta0x64/remaster.sh

With contributions by Tai Kedzierski https://github.com/taikedz/remaster.sh

Usage:

  ./remaster.sh --iniso old.iso --outiso new.iso [--entry ENTRYPOINT]
  
  ./remaster.sh --iniso=old.iso --outiso=new.iso [--entry=ENTRYPOINT]
  
ENTRYPOINT is a flag at which you can resume a function of the script. 

The supported entry points are:

mountiso

  Starts the process by mounting the original ISO,
  
  and proceeds through the rest of the script
  
customizeiso

  Re-starts the ISO cusotmization step,
  
  and proceeds through the rest of the script
  
customizekernel

  Re-starts the post-ISO customization step,
  
  and proceeds through the rest of the script
  
buildiso

  Re-builds the ISO from the currrent state.

  Requires that the previous steps to have been run before
  
  and for ./livecdtmp to not have been removed or broken
```
