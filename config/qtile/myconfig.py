# -*- coding: utf-8 -*-
import os
import subprocess
from libqtile import layout, bar, widget, hook
from libqtile.command import lazy
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from lib.layout import MonadTall, VerticalTile
from lib.default import style, layout_defaults, floating_layout_defaults,\
    bar_defaults, changerbar_defaults, widget_defaults, widget_graph_defaults, widget_sep_defaults
from lib.utils import get_alternatives, execute
from Xlib import display

try:
    from typing import List  # noqa: F401
except ImportError:
    pass

last_window_id = None
x_display = display.Display()
x_screen = x_display.screen()

auto_fullscreen = True
dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
focus_on_window_activation = 'smart'

# KEY MACROS
SUPER = 'mod4'
ALT = 'mod1'
CTRL = 'control'
SHIFT = 'shift'
# not modifiers, can't be in []
RETURN = 'Return'
SPACE = 'space'
TAB = 'Tab'

class command:
    dmenu = 'dmenu_run -i -b -p ">>>" -fn "Open Sans-10" -nb "#000" -nf "#fff" -sb "#770d14" -sf "#fff"'
    autostart = os.path.join(os.path.dirname(__file__), 'bin/autostart')
    lock = os.path.join(os.path.dirname(__file__), 'bin/lock')
    suspend = os.path.join(os.path.dirname(__file__), 'bin/suspend')

TERMINAL = 'urxvt'
FILEMANAGER = 'thunar'
BROWSER = 'firefox'

# KEY BINDINGS
keys = [
# CHANGE FOCUS
    Key([SUPER], 'h', lazy.layout.left()),                      # go left in stack
    Key([SUPER], 'k', lazy.layout.up()),                        # go up in stack
    Key([SUPER], 'j', lazy.layout.down()),                      # go down in stack
    Key([SUPER], 'l', lazy.layout.right()),                     # go right in stack
    Key([SUPER], SPACE, lazy.layout.next()),                    # go to next pane in stack
    Key([ALT], TAB, lazy.screen.toggle_group()),                # summon last visited group
    Key([SUPER], 'w', lazy.prev_screen()),                      # go to previous screen
    Key([SUPER], 'e', lazy.next_screen()),                      # go to next screen
    Key([SUPER, ALT, CTRL], 'l', lazy.to_screen(0)),            # go to screen 1
    Key([SUPER, ALT, CTRL], 'h', lazy.to_screen(1)),            # go to screen 2

# MOVE STUFF AROUND 
    Key([SUPER, CTRL], 'k', lazy.layout.shuffle_up()),          # move window up in stack
    Key([SUPER, CTRL], 'j', lazy.layout.shuffle_down()),        # move window down in stack
    Key([SUPER, CTRL], SPACE, lazy.layout.rotate()),            # swap panes of split stack (LAYOUT: STACK)
    Key([SUPER], 'i', lazy.layout.swap_main()),

# LAYOUT CHANGERS
    Key([SUPER], TAB, lazy.next_layout()),                      # switch to next layout
    Key([SUPER, SHIFT], TAB, lazy.prev_layout()),               # switch to previous layout
    Key([SUPER, ALT], SPACE, lazy.window.toggle_floating()),    # toggle floating
    Key([ALT], 'f', lazy.window.toggle_fullscreen()),           # toggle fullscreen
    Key([SUPER], 'Right', lazy.layout.increase_ratio()),        # increase master (DOESN'T WORK)
    Key([SUPER], 'Left', lazy.layout.decrease_ratio()),         # decrease master (DOESN'T WORK)
    Key([SUPER, SHIFT], SPACE, lazy.layout.flip()),             # 
    Key([SUPER, SHIFT], 'h', lazy.layout.shrink()),             # shrink focused window
    Key([SUPER, SHIFT], 'l', lazy.layout.grow()),               # grow focused window
    Key([SUPER, SHIFT], 'n', lazy.layout.reset()),              # reset to default layout
    Key([SUPER], 'm', lazy.layout.maximize()),                  # maximize the layout

# APPLICATION LAUNCHERS
    Key([ALT], 'r', lazy.spawncmd()),                           # run prompt
    Key([ALT, SHIFT], 'd', lazy.spawn('rofi -show run')),       # rofi
    Key([ALT], 'b', lazy.spawn(BROWSER)),                       # browser
    Key([ALT], 't', lazy.spawn('thunderbird')),                 # thunderbird
    Key([ALT], 'k', lazy.spawn('keepassxc')),                   # keepassxc
    Key([ALT], 'd', lazy.spawn(command.dmenu)),                 # dmenu
    Key([ALT], RETURN, lazy.spawn(TERMINAL)),                   # terminal
    Key([SUPER], RETURN, lazy.spawn(TERMINAL)),                 # terminal
    Key([ALT], 'f', lazy.spawn(FILEMANAGER)),                   # file manager
    #Key([ALT, SHIFT], 'f', lazy.spawn(TERMINAL -e 'ranger')     # ranger
    Key([ALT], 'm', lazy.spawn('rhythmbox')),                   # rhythmbox
    Key([ALT], 'v', lazy.spawn('virtualbox')),                  # virtualbox
    Key([ALT], 'n', lazy.spawn('nextcloud')),                   # nextcloud
    #Key('Print', lazy.spawn('scrot '%Y-%m-%d_$wx$h.png' -e 'mv $f ~/shots/'')), # screenshot

# SYSTEM SHORTCUTS
    Key([SUPER], 'q', lazy.window.kill()),                      # kill focused window
    Key([SUPER, CTRL], 'r', lazy.restart()),                    # restart Qtile
    Key([SUPER, CTRL], 'q', lazy.shutdown()),                   # shutdown Qtile
    Key([SUPER, CTRL], 's', lazy.spawn('shutdown -P now')),     # shutdown computer
    Key([SUPER, CTRL], 'l', lazy.spawn(command.lock)),          # lock
    Key([SUPER, CTRL], 'p', lazy.spawn(command.suspend)),       # suspend
    #Key([SUPER, SHIFT], 'k', lazy.spawn('/usr/local/bin/kb-light.py +2')    # increase keyboard backlight
    #Key([SUPER, SHIFT], 'j', lazy.spawn('/usr/local/bin/kb-light.py -2')    # decrease keyboard backlight

# Fn-KEYS
    Key([], 'XF86AudioMute', lazy.spawn('amixer -q set Master toggle')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer -c 0 sset Master 1- unmute')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer -c 0 sset Master 1+ unmute')),

#############################
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([SUPER, SHIFT], RETURN, lazy.layout.toggle_split()),
]

# GROUPS
groups = [
    Group('❶ '),
    Group('❷ '),
    Group('❸ '),
    Group('❹ '),
    Group('❺ '),
    Group('❻ '),
    Group('❼ '),
    Group('❽ '),
    Group('❾ ☘'),
    #Group('❿✪')
]

for index, grp in enumerate(groups):
    keys.extend([
        Key([SUPER], str(index+1), lazy.group[grp.name].toscreen()),        # summon group
        Key([SUPER, CTRL], str(index+1), lazy.window.togroup(grp.name)),    # send to group
        Key([SUPER, SHIFT], str(index+1), lazy.group.swap_groups(grp.name)) # swap with group
    ])

# LAYOUTS
layouts = [
    layout.MonadTall(name='Monad', border_focus=style.color.darkred),
    layout.Max(name='Full'),
    #MonadTall(name='MonadCustom', **layout_defaults),
    layout.Stack(name='Stack',num_stacks=2, border_focus=style.color.darkred),
    VerticalTile(name='VerticalTile', **layout_defaults),
]

#extension_defaults = widget_defaults.copy()

floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
],
**floating_layout_defaults)

# SCREENS AND WIDGETS
screens = [
    Screen(
        top=bar.Bar(
            widgets=[
                widget.CurrentScreen(
                    active_text='A',
                    active_color=style.color.darkred,
                    inactive_text='I',
                    inactive_color=style.color.darkgreen,
                    ),

                widget.GroupBox(
                    rounded=True,
                    borderwidth=2,
                    padding=2,
                    use_mouse_wheel=False,
                    fontsize=16,
                    this_current_screen_border=style.color.darkred,
                    this_screen_border=style.color.darkgreen,
                    urgent_alert_method='block',
                    ),
                widget.TaskList(icon_size=0, max_title_width=400, border=style.color.darkred),
                widget.TextBox('Cpu:'),
                widget.CPUGraph(
                    **widget_graph_defaults,
                    graph_color=style.color.darkgreen,
                    border_color=style.color.darkgreen,
                    ),

                widget.TextBox('Mem:'),
                widget.MemoryGraph(
                    **widget_graph_defaults,
                    graph_color=style.color.darkred,
                    border_color=style.color.darkred,
                    ),

                widget.TextBox('Net:'),
                widget.NetGraph(
                    **widget_graph_defaults,
                    graph_color=style.color.bluegrey,
                    border_color=style.color.bluegrey,
                    ),

                widget.Systray(icon_size=style.icon_size),
                widget.Sep(**widget_sep_defaults),
                widget.CurrentLayout(padding=2),
            ],
            **changerbar_defaults
        ),
        bottom=bar.Bar(
            widgets=[
                widget.Prompt(foreground=style.color.darkred, prompt=':'),
                #widget.WindowTabs(padding=6, foreground=style.color.grey, selected=('{', '}')),
                widget.DebugInfo(foreground=style.color.red),
                widget.Spacer(width=bar.STRETCH),
                widget.TextBox('Disk:'),
                widget.DF(visible_on_warn=False, foreground=style.color.grey, update_interval=60),

                widget.TextBox('Temp:'),
                widget.ThermalSensor(update_interval=15, foreground=style.color.darkgreen),

                widget.TextBox('Bat:'),
                widget.Battery(
                    #energy_now_file='charge_now',
                    energy_now_file='energy_now',
                    #energy_full_file='charge_full',
                    energy_full_file='energy_full',
                    #power_now_file='current_now',
                    power_now_file='power_now',
                    charge_char='↑',
                    discharge_char='↓',
                    status_file='status',
                    foreground=style.color.bluegrey,
                ),
                widget.TextBox('Vol:'),
                widget.Volume(foreground=style.color.bluegrey),
                widget.Sep(**widget_sep_defaults),
                widget.Clock(format=style.clock_format, padding=6),
	    ],
	    **bar_defaults
	),
    ),
    Screen(
        top=bar.Bar(
            widgets=[
                widget.CurrentLayout(padding=2),
                widget.Sep(**widget_sep_defaults),
                widget.TaskList(icon_size=0, max_title_width=400, border=style.color.darkred),
                widget.GroupBox(
                    rounded=True,
                    borderwidth=2,
                    padding=2,
                    use_mouse_wheel=False,
                    fontsize=16,
                    this_current_screen_border=style.color.darkred,
                    this_screen_border=style.color.darkgreen,
                    urgent_alert_method='block',
                    ),
                widget.CurrentScreen(
                    active_text='A',
                    active_color=style.color.darkred,
                    inactive_text='I',
                    inactive_color=style.color.darkgreen,
                    ),
            ],
            **changerbar_defaults
        ),
        bottom=bar.Bar(
            widgets=[
                widget.Prompt(foreground=style.color.darkred, prompt=':'),
                #widget.WindowTabs(padding=6, foreground=style.color.grey, selected=('{', '}')),
                widget.DebugInfo(foreground=style.color.red),
                widget.Spacer(width=bar.STRETCH),
                widget.Clock(format=style.clock_format, padding=6),
	    ],
	    **bar_defaults
	),
    ),
]

# DRAG FLOATING WITH MOUSE
mouse = [
    Drag([SUPER], 'Button1', lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([SUPER], 'Button3', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([SUPER], 'Button2', lazy.window.bring_to_front())
]

@hook.subscribe.startup
def startup():
    execute(command.autostart)


@hook.subscribe.client_new
def floating_dialogs(window):
    global floating_windows
    dialog = window.window.get_wm_type() == 'dialog'
    transient = window.window.get_wm_transient_for()
    window_name = window.name.lower()

    if dialog or transient:
        window.floating = True

    for i in floating_windows:
        if i in window_name:
            window.floating = True


#def main(qtile):
    #pass

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = 'LG3D'
#wmname = 'qtile'
