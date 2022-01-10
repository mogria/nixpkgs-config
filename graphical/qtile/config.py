# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Set a wallpaper
def wallpaper():
    os.system('feh --bg-scale ~/.config/qtile/redhex.jpg')

# Do things on startup
@hook.subscribe.startup
def autostart():
    wallpaper()
    # os.system('kscreen-doctor output.DP-1-1.position.1,1920 output.HDMI-1-1.position,0,600 output.eDP-1-1.position.1,1024')

@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    qtile.cmd_restart()

mod = "mod4"
terminal = guess_terminal()

colors = [["#1b1c1d", "#1b1c1d"], # background color
  ["#1b1c1d50", "#1b1c1d50"], # background for selected workspace
  ["#ffffff", "#ffffff"], # foreground color
  ["#e75e4f", "#e75e4f"], # red
  ["#2c70b7", "#2c70b7"], # blue
  ["#fdc325", "#fdc325"], # yellow
  ["#adadad", "#adadad"], # window name color
  ["#adadad", "#adadad"]] # foreground color for inactive workspace


keys = [

    # Example Key Chrod, launches xterm after pressing mod +z, followed by x
    # KeyChord([mod], "z", [
        # Key([], "x", lazy.spawn("xterm"))
    # ]),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"),

    # Monitor Focus
    Key([mod, "mod1"], "space", lazy.next_screen(), desc="Switch focus to next screen"),
    Key([mod, "mod1", "shift"], "space", lazy.prev_screen(), desc="Switch focus to next screen"),
    Key([mod], "1", lazy.toscreen(0), desc='Focus Monitor 1'),
    Key([mod], "2", lazy.toscreen(1), desc='Focus Monitor 2'),
    Key([mod], "3", lazy.toscreen(2), desc='Focus Monitor 3'),
    Key([mod], "4", lazy.toscreen(3), desc='Focus Monitor 4'),

    # Switch between windows in current screen
    Key([mod], "j", lazy.layout.down(), desc='Select window below'),
    Key([mod], "k", lazy.layout.up(), desc='Select window above'),
    Key([mod], "h", lazy.layout.left(), desc="Select window on the left"),
    Key([mod], "l", lazy.layout.right(), desc="Select window on the right"),

    # Swap windows in current screen
    Key([mod, "shift"], "h", lazy.layout.swap_left(), desc='Swap current window with left window'),
    Key([mod, "shift"], "l", lazy.layout.swap_right(), desc='Swap current window with right window'),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc='Swap current window with window below'),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc='Swap current window with window above'),

    # Make windows bigger and smaller
    Key([mod], "equal", lazy.layout.grow(), desc='Make current window bigger'),
    Key([mod], "minus", lazy.layout.shrink(), desc='Make current window smaller'),
    Key([mod], "0", lazy.layout.normalize(), desc='Reset window layout'),
    Key([mod], "backslash", lazy.layout.maximize(), desc='Maximize window'),

    # Switch between layouts layout
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod, "shift"], "Tab", lazy.prev_layout()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    # Key([mod], ".", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "x", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod, "control"], "h", lazy.spawn('systemctl hibernate'), desc="Hibernate"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Toggle floating
    Key([mod], "g", lazy.window.toggle_floating(), desc='Toggle floating mode of window'),
    # Close window
    Key([mod], "w", lazy.window.kill(), desc='Close current window'),


    # Search windows using rofi
    Key([mod], "slash", lazy.spawn("rofi -show window"), desc='Search windows using rofi'),
    Key([mod], "x", lazy.spawn("rofi -show run"), desc='Run command using rofi'),

    KeyChord([mod], "z", [
      Key([], "d", lazy.spawn("kcmshell5 kscreen"), desc='KScreen Display Settings'),
      Key([], "m", lazy.spawn("clementine"), desc='Start Music Player (Clementine)'),
      Key([], "k", lazy.spawn("keepassxc"), desc='Start Password Manager (KeePassXC)'),
      Key([], "w", lazy.spawn("libreoffice --writer"), desc='Start Libre Office Writer'),
      Key([], "x", lazy.spawn("libreoffice --calc"), desc='Start Libre Office Calc'),
      Key([], "c", lazy.spawn("chromium --calc"), desc='St'),
      Key([], "q", lazy.spawn("qt5ct --calc"), desc='Open Qt configuration tool'),
      Key([], "t", lazy.spawn("xterm"), desc='Open Xterm'),
    ]),


    # Application shortcuts
    Key([mod], "b", lazy.spawn("qutebrowser"), desc='Start Qutebrowser'),
    Key([mod], "c", lazy.spawn("dolphin"), desc='Start File-Manager'),
    Key([mod], "t", lazy.spawn("alacritty"), desc='Start Terminal Emulator (Alacritty)'),



    # Volume control
    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%"),
        desc="Raise volume"
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%"),
        desc="Lower volume"
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Mute"
    ),
    Key(
        [], "XF86AudioMicMute",
        lazy.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),
        desc="Mute mic"
    ),

    # Monitor Brightness controls
    Key(
        [], "XF86MonBrightnessUp",
        lazy.spawn("xbacklight +5"),
        desc="Brightness up"
    ),
    Key(
        [], "XF86MonBrightnessDown",
        lazy.spawn("xbacklight -10"),
        desc="Brightness down"
    ),

    # Media controls
    # Key([], "XF86AudioPlay", lazy.spawn("/usr/bin/playerctl play-pause")),
    # Key([], "XF86AudioPause", lazy.spawn("/usr/bin/playerctl pause")),
    # Key([], "XF86AudioNext", lazy.spawn("/usr/bin/playerctl next")),
    # Key([], "XF86AudioPrev", lazy.spawn("/usr/bin/playerctl previous")),

]

groups = [Group(i) for i in "asdfuiop"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    layout.MonadTall(),
    layout.TreeTab(),
    layout.MonadWide(),
    layout.Columns(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='Monoid HalfTight',
    fontsize=12,
    padding=0,
    foreground=colors[2],
    background=colors[0],
)
extension_defaults = widget_defaults.copy()

# because the screen configuration tool of plasma is used, don't
# reconfigure screens. This option also caes screens to be reconfigured
# when the screen is turned back on from locking.
reconfigure_screens = False
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentScreen(),
                widget.CurrentLayoutIcon(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Clipboard(),
                widget.BatteryIcon(),
                widget.Battery(),
                # widget.Wlan(), # requires iwlib
                widget.Systray(),
                widget.ThermalSensor(), # required psutil
                widget.Clock(format='%Y-%m-%d %a %H:%M'),
                widget.QuickExit(),
            ],
            24,
        ),
        # right=bar.Bar([
        #         widget.CPU(),
        #         widget.CPUGraph(),
        #         # widget.Bluetooth(),
        #         widget.TextBox("MEM"),
        #         widget.Memory(),
        #         widget.MemoryGraph(),
        #     ],
        #     200,
        # ),
    ),
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentScreen(),
                widget.CurrentLayoutIcon(),
                widget.GroupBox(),
                widget.TaskList(),
            ],
            30,
        ),
    ),
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentScreen(),
                widget.CurrentLayoutIcon(),
                widget.GroupBox(),
                widget.TaskList(),
            ],
            30,
        ),
    ),
]

for i, screen in enumerate(screens):
    number_key = str(i + 1)
    keys.extend([
        # Move Between Screens
        Key([mod], number_key, lazy.toscreen(i), desc="Go to monitor " + number_key),
        # Move windows between Screens
        Key([mod, "shift"], number_key, lazy.window.to_screen(i), desc="Move window to monitor " + number_key),
    ])

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = False
bring_front_click = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        {'wmclass': 'confirm'},
        {'wmclass': 'dialog'},
        {'wmclass': 'download'},
        {'wmclass': 'error'},
        {'wmclass': 'file_progress'},
        {'wmclass': 'notification'},
        {'wmclass': 'splash'},
        {'wmclass': 'toolbar'},
        {'wmclass': 'makebranch'},  # gitk
        {'wname': 'pinentry'},  # GPG key password entry
        {'wmclass': 'ssh-askpass'},  # ssh-askpass
        {'wmclass': 'xpad'}, # desktop notes
        {'wmclass': 'confirmreset'}, # desktop notes
        {'wmclass': 'makebranch'}, # gitk
        {'wmclass': 'branchdialog'}, # gitk
        {'wmclass': 'confirmreset'}, # gitk
        {'wmclass': 'maketag'}, # gitk
        {'wmclass': 'ssh-askpass'}, # gitk
    ],
    no_reposition_rules=None,
    border_width=1,
    border_focus=colors[1][0],
    border_normal=colors[2][0],
    max_border_width=0,
    fullscreen_border_width=0,
)
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


def main(qtile):
    qtile.cmd_warning()
