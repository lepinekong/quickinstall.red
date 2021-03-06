Red [
    Title: "red"
    File: "red"
    UUID: #19765291-2b46-4cf5-954e-906b4817b299
    Builds: [
		[0.0.0.1.1.2 {>install-folder: .ask-folder/title "Choose install directory:"}]
		[0.0.0.1.1.1 {initial}]
    ]
    Template: [
        Url: https://codeops.red/res/templates/install.red
        UUID: #fc3d5a36-47ed-4000-9c98-8503fbfc144c
        Date: 2018-12-02
        Location: 'France
        Builds: [
		    [0.0.0.1.1.3 {abort downloading" "https://static.red-lang.org/dl/win/red-064.exe"}]
            [0.0.0.1.1.2 {>url: Select >platforms-urls environment>OS}]
            [0.0.0.1.1.1 {initial build}]
        ]
    ]    
]

unless value? '.ask-folder [
    do https://redlang.red/ask-folder
]

unless value? '.install [
    do https://quickinstall.red
]

.install-red: function[
    /_debug
][
    >platforms-urls: [
        Windows: https://static.red-lang.org/dl/win/red-064.exe
    ]
    environment>OS: system/platform

    >url: Select >platforms-urls environment>OS

    if none? >url [
        print [{no download url found for} {nodejs} {in} environment>OS {environment.}]
        >url: ask "Give download url:"
        if >url = "" [
            print ["abort downloading" "https://static.red-lang.org/dl/win/red-064.exe"]
            return false
        ]
        
    ]    

    >install-folder: .ask-folder/title "Choose install directory:"

    either _debug [
        do-trace 20 [
            ?? >url
        ] %red
        
        ret>value: .install/_debug/folder (>url) (>install-folder)
    ][
        ret>value: .install/folder (>url) (>install-folder)
    ]
    return ret>value   
]

install-red: :.install-red
