{...}:
{
  launchd.agents.displayplacer = {
    command = ''displayplacer "id:C2530B46-0FFE-4190-81C2-E59E489BF8B0 res:3008x1692 hz:144 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:0DA033DA-E29A-4CFB-9D84-C73A52C95CD8 res:3008x1692 hz:144 color_depth:8 enabled:true scaling:on origin:(3008,0) degree:0" "id:60EA0095-D130-48DD-9803-B92F3E5D2A6C res:3008x1692 hz:144 color_depth:8 enabled:true scaling:on origin:(-3008,0) degree:0"'';
    serviceConfig = {
        Label = "com.user.displayplacer";
        KeepAlive = true;
        LowPriorityIO = true;
        ProcessType = "Background";
        StandardOutPath = "/var/log/com.user.displayplacer/DisplayPlacer.log";
        StandardErrorPath = "/var/log/com.user.displayplacer/DisplayPlacer-Errors.log";
      };
    };
  }
