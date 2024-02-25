class style:
    font = 'Monospace'
    clock_format = 'week:%V  %A %e. %B  %H:%M'
    #clock_format = 'week%V %A %e. %B %H:%M'
    fontsize = 15
    icon_size = 15
    border_width = 1

    class color:
        black = '#000000'
        blue = '#215578'
        bright_blue = '#18BAEB'
        light_grey = '#111111'
        grey = '404040'
        bluegrey = '445c7e'
        red = 'ff0000'
        #darkred = '941d24'
        darkred = 'a92129'
        darkorange = '8d2914'
        white = 'fcfdfe'
        #green = '18b218'
        #green = '6e961e'
        green = '00aa89'
        #green = '006032'
        darkgreen = '4caf62'
        darkdarkgreen = '1e2d23'
        yellow = 'dfb827'
        azul = '3498db'

layout_defaults = {
    'margin': 0,
    'border_width': style.border_width,
    'border_normal': style.color.grey,
    #'border_focus': style.color.blue,
    'border_focus': style.color.azul,
}

floating_layout_defaults = {
    'margin': 0,
    'border_width': style.border_width,
    'border_normal': style.color.grey,
    'border_focus': style.color.azul,
}

bar_defaults = {
    'size': 20,
    'background': style.color.black,
    'font': style.font,
    'padding': 0,
}

changerbar_defaults = {
    'size': 27,
    'background': style.color.black,
    'font': style.font,
    'padding': 0,
}

widget_defaults = {
    'font': style.font,
    'fontsize': style.fontsize,
}

widget_graph_defaults = {
    'margin_y': 1,
    'border_width': 1,
    'line_width': 1,
}

widget_sep_defaults = {
    'foreground': style.color.azul,
    'linewidth': 2,
    'height_percent': 55,
    'padding': 14,
}
