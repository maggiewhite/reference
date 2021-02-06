## Where are the files?
- sound/soc/
- Documentation/sound/alsa/

Qualcomm files
- sound/soc/msm/

## Good references
- (Qualcomm's AFE vs ADP vs ASM)[https://lwn.net/Articles/730574/]
  - AFE (Audio FrontEnd)
  - ADM (Audio Device Manager)
  - ASM (Audio Stream Manager)
  - APR (Asynchronous Packet Router)

## Debug

### Proc files
```bash
# Get 
cat /proc/asound/cardX/pcmX[c|p]/info
cat /proc/asound/card0/pcm4c/info
```

Resource:
 - https://www.kernel.org/doc/html/v4.11/sound/designs/procfile.html
