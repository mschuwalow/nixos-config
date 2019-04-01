function omf_install
        set dir /tmp/omf-install
        mkdir $dir
        cd $dir
        curl -L https://get.oh-my.fish > ./install
        fish ./install --path=~/.local/share/omf --config=~/.config/omf
        cd
        rm -rf $dir
end
