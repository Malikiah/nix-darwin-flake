{pkgs, ...}:
{
  launchd.agents.monitorcontrol = {
    command = ''
#!/bin/bash

MonitorControlProcess=$(ps aux | grep -i monitorcontrol | grep -v "grep")
MonitorControlProcessCount=$(echo "$MonitorControlProcess" | wc -l)
MonitorControlProcessID=($(echo "$MonitorControlProcess" | awk '{print $2}'))

if [ -z "$MonitorControlProcess" ]; then
	echo "Opening MonitorControl..."
  open -na ${pkgs.monitorcontrol}/Applications/MonitorControl.app
elif [ "$MonitorControlProcessCount" -gt 1 ]; then
	for ((i = 0; i < ''${#MonitorControlProcessID[@]}; i++)); do
		if [ $i -eq 0 ]; then
			echo "excluding ''${MonitorControlProcessID[i]}"
			continue
		fi
		echo "Killing Extra Process ID: ''${MonitorControlProcessID[i]}"
		kill ''${MonitorControlProcessID[i]}
	done
else;
  echo "Monitor Control is already running."
fi
    '';
    serviceConfig = {
        Label = "com.user.monitorcontrol";
        KeepAlive = true;
        LowPriorityIO = true;
        ProcessType = "Background";
        StandardOutPath = "/var/log/com.user.monitorcontrol/MonitorControl.log";
        StandardErrorPath = "/var/log/com.user./MonitorControl-Errors.log";
      };
    };
  }
