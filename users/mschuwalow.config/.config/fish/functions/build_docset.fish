function build_docset
	set orig_dir (pwd)
	set dir /tmp/mk_docset
	set zeal_dir $HOME/.local/share/Zeal/Zeal/docsets 
    
    mkdir -p $dir
    mkdir -p $zeal_dir
    cd $dir
    
    # ==========================================================
    
    # Changeme. Get all .tgz containing docsets
    set targets 'BlueD/Pandas.docset' 'ppwwyyxx/dash-docset-tensorflow' 'BlueD/sklearn.docset'

    # ==========================================================

    for target in $targets
        wget (curl -s https://api.github.com/repos/$target/releases/latest | grep 'browser_download_url' | cut -d\" -f4 )
    end
    
    for file in *.tgz
        tar -xvf $file
    end   
    
    for docset in (ls | grep .docset)
        rm -rf $zeal_dir/$docset
        mv $docset $zeal_dir
    end
    
    rm -rf $dir
    cd $orig_dir
end
