function fish_greeting
    set_color $fish_color_autosuggestion
    uname -nmsr
    uptime | sed "s/^ //"
    set_color normal
end
