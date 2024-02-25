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
#from Xlib import display

try:
    from typing import List  # noqa: F401
except ImportError:
    pass

#last_window_id = None
#x_display = display.Display()
#x_screen = x_display.screen()

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
    firststart = os.path.join(os.path.dirname(__file__), 'bin/firststart')
    lock = os.path.join(os.path.dirname(__file__), 'bin/lock')
    suspend = os.path.join(os.path.dirname(__file__), 'bin/suspend')

TERMINAL = 'st'
#TERMINAL = 'urxvt'
GUIFILEMANAGER = 'pcmanfm'
BROWSER = 'firefox'

def regex(name):
    return r'.*(^|\s|\t|\/)' + name + r'(\s|\t|$).*'
def find_or_run(app, classes=(), group="", processes=()):
    if not processes:
        processes = [regex(app.split('/')[-1])]

    def __inner(qtile):
        if classes:
            for window in qtile.windowMap.values():
                for c in classes:
                    if window.group and window.match(wmclass=c):
                        qtile.currentScreen.setGroup(window.group)
                        window.group.focus(window, False)
                        return
        if group:
            lines = subprocess.check_output(["/usr/bin/ps", "axw"]).decode("utf-8").splitlines()
            ls = [line.split()[4:] for line in lines][1:]
            ps = [' '.join(l) for l in ls]
            for p in ps:
                for process in processes:
                    if re.match(process, p):
                        qtile.groupMap[group].cmd_toscreen()
                        return
        subprocess.Popen(app.split())

    return __inner

# KEY BINDINGS
keys = [
# CHANGE FOCUS
    Key([SUPER], 'h', lazy.layout.left()),                      # go left in stack
    Key([SUPER], 'k', lazy.layout.up()),                        # go up in stack
    Key([SUPER], 'j', lazy.layout.down()),                      # go down in stack
    Key([SUPER], 'l', lazy.layout.right()),                     # go right in stack
    #Key([SUPER], SPACE, lazy.layout.next()),                    # go to next pane in stack
    Key([ALT], TAB, lazy.screen.toggle_group()),                # summon last visited group
    Key([SUPER], 'w', lazy.prev_screen()),                      # go to previous screen
    Key([SUPER], 'e', lazy.next_screen()),                      # go to next screen
    Key([SUPER, ALT, CTRL], 'l', lazy.to_screen(0)),            # go to screen 1
    Key([SUPER, ALT, CTRL], 'h', lazy.to_screen(1)),            # go to screen 2
    Key([SUPER], 'd', lazy.spawn('rofi -show window')),         # rofi

# MOVE STUFF AROUND 
    Key([SUPER, CTRL], 'k', lazy.layout.shuffle_up()),          # move window up in stack
    Key([SUPER, CTRL], 'j', lazy.layout.shuffle_down()),        # move window down in stack
    Key([SUPER, CTRL], SPACE, lazy.layout.rotate()),            # swap panes of split stack (LAYOUT: STACK)
    Key([SUPER], 'i', lazy.layout.swap_main()),

# LAYOUT CHANGERS
    Key([SUPER], TAB, lazy.next_layout()),                      # switch to next layout
    Key([SUPER, SHIFT], TAB, lazy.prev_layout()),               # switch to previous layout
    Key([SUPER, CTRL], SPACE, lazy.window.toggle_floating()),   # toggle floating
    Key([ALT], 'f', lazy.window.toggle_fullscreen()),           # toggle fullscreen
    Key([SUPER], 'Right', lazy.layout.increase_ratio()),        # increase master (DOESN'T WORK)
    Key([SUPER], 'Left', lazy.layout.decrease_ratio()),         # decrease master (DOESN'T WORK)
    Key([SUPER, SHIFT], SPACE, lazy.layout.flip()),             # 
    Key([SUPER, SHIFT], 'h', lazy.layout.shrink()),             # shrink focused window
    Key([SUPER, SHIFT], 'l', lazy.layout.grow()),               # grow focused window
    Key([SUPER, SHIFT], 'n', lazy.layout.reset()),              # reset to default layout
    Key([SUPER], 'm', lazy.layout.maximize()),                  # maximize the layout

# APPLICATION LAUNCHERS
    Key([ALT], RETURN, lazy.spawn(TERMINAL)),                                                           # terminal
    Key([SUPER], RETURN, lazy.spawn(TERMINAL)),                                                         # terminal
    Key([ALT], 'c', lazy.spawn(TERMINAL)),                                                              # terminal
    Key([SUPER, SHIFT], RETURN, lazy.spawn('urxvt')),                                                   # urxvt (until st is patched)
    Key([ALT], 'b', lazy.spawn(BROWSER)),                                                               # browser
    Key([ALT], 'd', lazy.spawn(command.dmenu)),                                                         # dmenu
    Key([ALT], 'e', lazy.function(find_or_run(TERMINAL + ' -e ranger /home/alexander/Desktop/theo12/'))),# open ranger in current exam dir
    Key([ALT], 'f', lazy.function(find_or_run(TERMINAL + ' -e ranger'))),                               # ranger
    Key([ALT, SHIFT], 'f', lazy.spawn(GUIFILEMANAGER)),                                                 # gui file manager
    Key([ALT], 'h', lazy.function(find_or_run(TERMINAL + ' -e htop'))),                                 # htop
    Key([ALT, SHIFT], 'h', lazy.function(find_or_run(TERMINAL + ' -e top'))),                           # top
    Key([ALT], 'k', lazy.spawn('keepass')),                                                             # keepass
    Key([ALT, SHIFT], 'k', lazy.spawn('passwordsafe')),                                                 # passwordsafe
    Key([ALT], 'm', lazy.function(find_or_run(TERMINAL + ' -e ncmpcpp'))),                              # ncmpcpp
    Key([ALT, SHIFT], 'm', lazy.function(find_or_run(TERMINAL + ' -e alsamixer'))),                     # alsamixer
    Key([ALT], 'n', lazy.spawn('nextcloud')),                                                           # nextcloud
    Key([ALT, SHIFT], 'n', lazy.function(find_or_run(TERMINAL + ' -e killall nextcloud'))),             # kill nextcloud
    Key([ALT], 'r', lazy.spawncmd()),                                                                   # run prompt
    Key([ALT], 's', lazy.function(find_or_run(TERMINAL + ' -e sanepic'))),                              # scan with scanimage (requires correct .zshrc)
    Key([ALT, SHIFT], 's', lazy.function(find_or_run(TERMINAL + ' -e sanedoc'))),                       # compile scans to pdf with pdfjoin (requires correct .zshrc)
    Key([ALT], 't', lazy.spawn('thunderbird')),                                                         # thunderbird
    Key([ALT], 'u', lazy.function(find_or_run(TERMINAL + ' -e ranger /home/alexander/Documents/uni/'))),# open ranger in ~/Documents/uni/
    Key([ALT], 'v', lazy.spawn('redshift')),                                                            # redshift
    Key([ALT, SHIFT], 'v', lazy.function(find_or_run(TERMINAL + ' -e killall redshift'))),              # kill redshift
    Key([ALT], 'x', lazy.spawn('xscreensaver-demo')),                                                   # xscreensaver settings
    Key([ALT], 'z', lazy.spawn('zathura')),                                                             # zathura
    Key([], 'Print', lazy.spawn('scrot "/home/alexander/Downloads/%Y-%m-%d-%T_$wx$h.png"')),            # screenshot

    Key([SUPER], SPACE, lazy.spawn('mpc pause')),                                                       # stop mpd playback
    Key([SUPER, SHIFT], SPACE, lazy.spawn('mpc play')),                                                 # start mpd playback

# SYSTEM SHORTCUTS
    Key([SUPER], 'q', lazy.window.kill()),                      # kill focused window
    Key([SUPER], 'r', lazy.restart()),                          # restart Qtile
    Key([SUPER, CTRL], 'q', lazy.shutdown()),                   # shutdown Qtile
    Key([SUPER, CTRL], 's', lazy.spawn('sudo shutdown -P now')),# shutdown computer
    Key([SUPER, CTRL], 'r', lazy.spawn('sudo reboot')),         # reboot computer
    Key([SUPER, CTRL], 'l', lazy.spawn(command.lock)),          # lock
    Key([SUPER, CTRL], 'p', lazy.spawn(command.suspend)),       # suspend

# Special KEYS
    Key([], 'XF86AudioMute', lazy.spawn('amixer -q set Master toggle')),                # mute/unmute audio
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer -c 0 sset Master 5- unmute')),   # decrease audio volume and unmute
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer -c 0 sset Master 5+ unmute')),   # increase audio volume and unmute
    Key([], 'XF86MonBrightnessUp', lazy.spawn('light -A 5')),                           # increase monitor backlight
    Key([], 'XF86MonBrightnessDown', lazy.spawn('light -U 5')),                         # decrease monitor backlight
    #Key([], 'XF86AudioMicMute', lazy.spawn(),                                           #
    #Key([], 'XF86Display', lazy.spawn(),                                                #
    #Key([], 'XF86WLAN', lazy.spawn(),                                                   #
    #Key([], 'XF86Tools', lazy.spawn(),                                                  #
    #Key([], 'XF86Bluetooth', lazy.spawn(),                                              #
    #Key([], 'XF86Favorites', lazy.spawn(),                                              #
]

# GROUPS
groups = [
    #Group('❶ term'),
    #Group('❷ sys'),
    #Group('❸ www'),
    #Group('❹ mail'),
    #Group('❺ snd'),
    #Group('❻ gfx'),
    #Group('❼ data'),
    #Group('❽'),
    #Group('❾ ☘'),
    Group('❶ '),               # 1 terminal
    Group('❷ '),               # 2 system
    Group('❸ '),               # 3 www
    Group('❹ '),               # 4 email
    Group('❺ '),               # 5 files
    Group('❻ '),               # 6 sound
    Group('❼ '),               # 7 graphics
    Group('❽ '),               # 8 data
    Group('❾ ☘'),               # 9 else
    #Group('❿'),                # 10
    #Group('       ❿      ✪     ')
]

for index, grp in enumerate(groups):
    keys.extend([
        Key([SUPER], str(index+1), lazy.group[grp.name].toscreen()),        # summon group
        Key([SUPER, CTRL], str(index+1), lazy.window.togroup(grp.name)),    # send to group
        Key([SUPER, SHIFT], str(index+1), lazy.group.swap_groups(grp.name)),# swap with group
        # KP_i is name for numbers on numpad
        #Key([SUPER], str(index+1), lazy.group[grp.name].toscreen()),        # summon group with numpad
        #Key([SUPER, CTRL], str(index+1), lazy.window.togroup(grp.name)),    # send to group with numpad
        #Key([SUPER, SHIFT], str(index+1), lazy.group.swap_groups(grp.name)),# swap with group with numpad
    ])

# LAYOUTS
layouts = [
    #MonadTall(name='MonadCustom', **layout_defaults),
    layout.MonadTall(name='Monad', border_focus=style.color.azul),
    layout.Max(name='Full'),
    #layout.VerticalTile(name='Vertical', border_focus=style.color.azul),
    #layout.Stack(name='Stack',num_stacks=2, border_focus=style.color.azul),
    VerticalTile(name='CustomVertical', **layout_defaults),
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
                    active_text='-1-',
                    active_color=style.color.darkred,
                    inactive_text='-0-',
                    inactive_color=style.color.azul,
                    ),

                widget.GroupBox(
                    rounded=True,
                    borderwidth=2,
                    padding=2,
                    use_mouse_wheel=False,
                    fontsize=16,
                    this_current_screen_border=style.color.darkred,
                    this_screen_border=style.color.azul,
                    urgent_alert_method='block',
                    ),
                widget.Prompt(foreground=style.color.darkred, prompt=':'),
                widget.TaskList(icon_size=0, border=style.color.darkred),

                #widget.WindowTabs(padding=6, foreground=style.color.grey, selected=('{', '}')),
                widget.DebugInfo(foreground=style.color.red),

                widget.Systray(icon_size=style.icon_size),
                widget.Sep(**widget_sep_defaults),
                widget.CurrentLayout(padding=2),
            ],
            **changerbar_defaults
        ),
        bottom=bar.Bar(
            widgets=[
                widget.TextBox('Cpu:'),
                widget.CPUGraph(
                    **widget_graph_defaults,
                    graph_color=style.color.darkred,
                    border_color=style.color.darkred,
                    foreground=style.color.darkred,
                    fill_color=style.color.darkred,
                    ),

                widget.TextBox('Mem:'),
                widget.MemoryGraph(
                    **widget_graph_defaults,
                    graph_color=style.color.darkred,
                    border_color=style.color.darkred,
                    foreground=style.color.darkred,
                    fill_color=style.color.darkred,
                    ),

                widget.TextBox('Net:'),
                #widget.NetGraph(
                    #**widget_graph_defaults,
                    #graph_color=style.color.azul,
                    #border_color=style.color.azul,
                    #foreground=style.color.azul,
                    #fill_color=style.color.azul,
                    #),
                widget.Net(interface='enp0s31f6', foreground=style.color.azul),
                widget.Sep(**widget_sep_defaults),
                widget.Net(interface='wlp6s0', foreground=style.color.azul, padding=1),

                widget.Spacer(width=bar.STRETCH),
                widget.TextBox('Disk:'),
                widget.DF(visible_on_warn=False, foreground=style.color.azul, update_interval=60),
                widget.DF(partition='/home/alexander/', visible_on_warn=False, foreground=style.color.azul, update_interval=60),

                widget.TextBox('Temp:'),
                widget.ThermalSensor(update_interval=15, foreground=style.color.azul),

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
                    #charge_char='c',
                    #discharge_char='d',
                    status_file='status',
                    foreground=style.color.azul,
                ),
                widget.TextBox('Vol:'),
                widget.Volume(foreground=style.color.azul),
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
                widget.TaskList(icon_size=0, border=style.color.darkred),
                widget.GroupBox(
                    rounded=True,
                    borderwidth=2,
                    padding=2,
                    use_mouse_wheel=False,
                    fontsize=16,
                    this_current_screen_border=style.color.darkred,
                    this_screen_border=style.color.azul,
                    urgent_alert_method='block',
                    ),
                widget.CurrentScreen(
                    active_text='-1-',
                    active_color=style.color.darkred,
                    inactive_text='-0-',
                    inactive_color=style.color.azul,
                    ),
            ],
            **changerbar_defaults
        ),
        bottom=bar.Bar(
            widgets=[
                widget.Spacer(width=bar.STRETCH),

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
                    #charge_char='c',
                    #discharge_char='d',
                    status_file='status',
                    foreground=style.color.azul,
                ),
                widget.TextBox('Vol:'),
                widget.Volume(foreground=style.color.azul),
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

@hook.subscribe.startup_once
def startfirst():
    execute(command.firststart)

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
