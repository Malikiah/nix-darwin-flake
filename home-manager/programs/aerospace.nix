{pkgs, lib, ...}:
let
  Terminal = "exec-and-forget open -na /Applications/Alacritty.app";
  Browser = "exec-and-forget open -na /Applications/Arc.app";
  ScreenshotUtility = "exec-and-forget open -na Screenshot";
  MonitorControl = "exec-and-forget open -na ${pkgs.monitorcontrol}/Applications/MonitorControl.app";

  aerospace = ''
    # Place a copy of this config to ~/.aerospace.toml
    # After that, you can edit ~/.aerospace.toml to your liking
    
    # Feel free to omit keys that you don't use in your config.
    # If the key is absent in your config the default value is taken from this config
    
    # You can use it to add commands that run after login to macOS user session.
    # 'start-at-login' needs to be 'true' for 'after-login-command' to work
    # Available commands: https://nikitabobko.github.io/AeroSpace/commands
    after-login-command = [
    ]
    
    # You can use it to add commands that run after AeroSpace startup.
    # 'after-startup-command' is run after 'after-login-command'
    # Available commands : https://nikitabobko.github.io/AeroSpace/commands
    after-startup-command = [
    ]
    
    # Start AeroSpace at login
    start-at-login = true
    
    # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true
    
    # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
    # The 'accordion-padding' specifies the size of accordion padding
    # You can set 0 to disable the padding feature
    accordion-padding = 30
    
    # Possible values: tiles|accordion
    default-root-container-layout = 'tiles'
    
    # Possible values: horizontal|vertical|auto
    # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
    #               tall monitor (anything higher than wide) gets vertical orientation
    default-root-container-orientation = 'auto'
    
    # Possible values: (qwerty|dvorak)
    # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
    key-mapping.preset = 'qwerty'

    [workspace-to-monitor-force-assignment]
    1 = ['main']                # Monitor sequence number from left to right. 1-based indexing
    2 = ['main']                     # Main monitor
    3 = ['main']                 # Non-main monitor in case when there are only two monitors
    4 = ['main']                  # Case insensitive regex substring
    5 = ['main']  # Case insensitive regex match
    6 = ['main']
    7 = [3, 'main'] # You can specify multiple patterns. The first matching pattern will be used
    8 = [3, 'main']
    9 = [1, 'main']
    0 = [1, 'main']

    # Gaps between windows (inner-*) and between monitor edges (outer-*).
    # Possible values:
    # - Constant:     gaps.outer.top = 8
    # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
    #                 In this example, 24 is a default value when there is no match.
    #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
    #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
    [gaps]
    inner.horizontal = 20
    inner.vertical = 20
    outer.left = 10
    outer.bottom = 10
    outer.top = 10
    outer.right = 10
    
    # See https://nikitabobko.github.io/AeroSpace/guide#exec-env-vars
    [exec]
    inherit-env-vars = true
    [exec.env-vars]
    PATH = '/opt/homebrew/bin:/opt/homebrew/sbin:''${PATH}'
    
    # 'main' binding mode declaration
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    # 'main' binding mode must be always presented
    [mode.main.binding]
    
    # All possible keys:
    # - Letters.        a, b, c, ..., z
    # - Numbers.        0, 1, 2, ..., 9
    # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
    # - F-keys.         f1, f2, ..., f20
    # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
    #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
    # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
    #                   keypadMinus, keypadMultiply, keypadPlus
    # - Arrows.         left, down, up, right
    
    # All possible modifiers: cmd, alt, ctrl, shift
    
    # All possible commands: https://nikitabobko.github.io/AeroSpace/commands
    
    # You can uncomment this line to open up terminal with alt + enter shortcut
    # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
    # alt-enter = 'exec-and-forget open -n /System/Applications/Utilities/Terminal.app'
    # Removes hide keybinding
    #cmd-h = []
    #cmd-l = []
    #cmd-j = []
    #cmd-k = []

    cmd-q = 'close'

    cmd-alt-r = 'reload-config'

    cmd-shift-f = 'fullscreen'
    cmd-alt-f = 'macos-native-fullscreen'
    cmd-alt-h = 'macos-native-minimize'

    #Terminal
    alt-enter = '${Terminal}'

    #Browser
    alt-b = '${Browser}'

    #Screenshot Utility
    alt-s = '${ScreenshotUtility}'
    
    # See: https://nikitabobko.github.io/AeroSpace/commands#layout
    alt-slash = 'layout tiles horizontal vertical'
    alt-comma = 'layout accordion horizontal vertical'
    
    # See: https://nikitabobko.github.io/AeroSpace/commands#focus
    cmd-h = 'focus left'
    cmd-j = 'focus down'
    cmd-k = 'focus up'
    cmd-l = 'focus right'

    cmd-y = 'focus-monitor left'
    cmd-o = 'focus-monitor right'

    cmd-u = 'workspace prev'
    cmd-i = 'workspace next'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
    cmd-1 = 'workspace 1'
    cmd-2 = 'workspace 2'
    cmd-3 = 'workspace 3'
    cmd-4 = 'workspace 4'
    cmd-5 = 'workspace 5'
    cmd-6 = 'workspace 6'
    cmd-7 = 'workspace 7'
    cmd-8 = 'workspace 8'
    cmd-9 = 'workspace 9'
    cmd-0 = 'workspace 0'
    
    # See: https://nikitabobko.github.io/AeroSpace/commands#move
    cmd-shift-h = 'move left'
    cmd-shift-j = 'move down'
    cmd-shift-k = 'move up'
    cmd-shift-l = 'move right'

    cmd-shift-y = 'move-node-to-monitor left'
    cmd-shift-o = 'move-node-to-monitor right'

    cmd-shift-u = 'move-node-to-workspace prev'
    cmd-shift-i = 'move-node-to-workspace next'
    
    # See: https://nikitabobko.github.io/AeroSpace/commands#resize
    cmd-shift-minus = 'resize smart -50'
    cmd-shift-equal = 'resize smart +50'
    
    # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
    cmd-shift-1 = 'move-node-to-workspace 1'
    cmd-shift-2 = 'move-node-to-workspace 2'
    cmd-shift-3 = 'move-node-to-workspace 3'
    cmd-shift-4 = 'move-node-to-workspace 4'
    cmd-shift-5 = 'move-node-to-workspace 5'
    cmd-shift-6 = 'move-node-to-workspace 6'
    cmd-shift-7 = 'move-node-to-workspace 7'
    cmd-shift-8 = 'move-node-to-workspace 8'
    cmd-shift-9 = 'move-node-to-workspace 9'
    cmd-shift-0 = 'move-node-to-workspace 0'

    cmd-alt-o = 'move-workspace-to-monitor next --wrap-around'
    cmd-alt-y = 'move-workspace-to-monitor prev --wrap-around'
    
    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
    alt-tab = 'workspace-back-and-forth'
    # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
    alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'
    
    # See: https://nikitabobko.github.io/AeroSpace/commands#mode
    alt-shift-semicolon = 'mode service'
    
    # 'service' binding mode declaration.
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    [mode.service.binding]
    esc = ['reload-config', 'mode main']
    r = ['flatten-workspace-tree', 'mode main'] # reset layout
    #s = ['layout sticky tiling', 'mode main'] # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
    f = [
      'layout floating tiling',
      'mode main',
    ] # Toggle between floating and tiling layout
    backspace = ['close-all-windows-but-current', 'mode main']
    
    alt-shift-h = ['join-with left', 'mode main']
    alt-shift-j = ['join-with down', 'mode main']
    alt-shift-k = ['join-with up', 'mode main']
    alt-shift-l = ['join-with right', 'mode main']
    
  '';
in 
{
  home.file."aerospace" = {
      enable = false;
      executable = true;
      recursive = false;
      text = aerospace;
      target = ".config/aerospace/aerospace.toml";
    };

}
