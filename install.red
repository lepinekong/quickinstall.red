Red [
    File: "install"
    Title: "install"
    UUID: #cfead2a8-fb26-4893-96d8-37e4d5715d81
    Builds: [
		[0.0.0.2.2.5 {fixed bug for rstudio. to release}]
		[0.0.0.2.1.1 {#include https://redlang.red/redlang}]
    ]    
    Html-Proxy: https://quickinstall.red/install
    Description: {
        install library
    }
    Features: [
        1 {download the file}
        1.1 {if keyword call install-<keyword>}
        1.2 {}
        2 {run downloaded file if confirmation}
        2.1 {unzip the file before if necessary}
    ]
    Bug: {
install.1.red line 148 :
>url: https://quickinstall.red/rstudio
>command: {install-https://download1.rstudio.org/RStudio-1.1.463.exe/_debug}
pause in install.1.red on line 148...
    }
    Builds:[
    ]
]

unless value? '.redlang [
    #include https://redlang.red/redlang
]
.redlang [alias to-file confirm join]
do https://quickinstall.red/get-software-install-config.red

.redlang download

.install: function [
    'param>url [word! string! file! path! url!] 
    /folder 'param>download-folder [word! string! file! url! path!] 
    /_build {Build number for developer}
    /silent {don't print message on console}   
    /_debug {debug mode} 
][

    if _debug [
        do https://redlang.red/do-trace ; 0.0.0.1.01.7: fixed to-trace 
    ]    
    
    const>download-url: form :param>url

    if _debug [
        do-trace 74 [
            ?? const>download-url
        ] %install.1.red
    ]

    >builds: [
    ] 

    if _build [
        unless silent [
            print >builds
        ]
        return >builds
    ]

    ..install-url: func[
        /folder
    ][
        if _debug [
            do-trace 94 [
                ?? const>download-url
            ] %install.1.red
            
        ]
        either folder [
            param>download-folder: to-red-file form param>download-folder
            >local-download-folder: to-local-file param>download-folder
            either _debug [
                downloaded-file>out: .download/folder/_debug (const>download-url) (>local-download-folder)
            ][
                downloaded-file>out: .download/folder/_debug (const>download-url) (>local-download-folder)
            ]
        ][
            either _debug [
                do-trace 109 [
                    ?? const>download-url
                ] %install.1.red
                
                downloaded-file>out: .download/_debug (const>download-url)
            ][
                downloaded-file>out: .download (const>download-url)
            ]            
        ]       
    ]

    ..install-keyword: func[/_debug /local >url][
        
        >url: to-url rejoin ["https://quickinstall.red/" param>url]

        if _debug [

            do-trace 126 [
                ?? >url
            ] %install.1.red
            
        ]

        if error? try [
            do (>url)
        ][
            ;load from install.config
            word>software: to-word form param>url
            extern>config>software: .get-software-install-config (word>software)

            if _debug [
                do-trace 117 [
                    ?? word>software
                    ?? extern>config>software
                ] %install.3.red
                
            ]
            if none? (extern>config>software) [
                print ["cannot install" (word>software) ]
                return false
            ]
            param>url: select (extern>config>software) 'Windows
            if _debug [
                do-trace 129 [
                    ?? param>url
                ] %install.3.red
                
            ]
            if none? (param>url) [
                print ["cannot download" (word>software) ]
                return false            
            ] 
            const>download-url: (param>url)
            downloaded-file>out: ..install-url
            return (downloaded-file>out)           
            
        ]
        
        either _debug [
            >command: rejoin ["install-" (param>url) "/_debug"]
            do-trace 148 [
                ?? >url
                ?? >command
            ] %install.1.red
        ][
            >command: rejoin ["install-" param>url]
        ]
        
        if _debug [
            do-trace 157 [
                ?? >command
            ] %install.1.red  
        ]
        do (>command)
        
    ]

    if _debug [
        do-trace 166 [
            ?? folder
        ] %install.1.red
        
    ]
    either folder [
        if _debug [
            do-trace 173 [
                ?? param>download-folder
            ] %install.1.red
        ]
        param>download-folder: to-red-file form (param>download-folder)

        downloaded-file>out: ..install-url
        
    ][

        if _debug [
            do-trace 185 [
                ?? param>url
            ] %install.1.red
        ]        

        either word? param>url [
            either _debug [
                do-trace 192 [
                    ?? param>url
                ] %install.1.red
                downloaded-file>out: ..install-keyword/_debug param>url
            ][
                downloaded-file>out: ..install-keyword param>url
            ]
            exit ; 0.0.0.1.2.6
        ][
            if _debug [
                do-trace 202 [
                    print "executing ..install-url"
                ] %install.1.red
            ]
            downloaded-file>out: ..install-url
        ]
    ]

    ; --- run install ---
    if _debug [
        do-trace 212 [
            ?? downloaded-file>out
        ] %install.1.red
        
    ]

]

install: function [
    'param>what [word! string! file! path! url!] 
    'param>details [word! string! file! path! url! unset!]
    /_debug
][
    if _debug [
        do https://redlang.red/do-trace 
    ]   

    if _debug [
        type: type?/word get/any 'param>details
        do-trace 233 [
            ?? type
        ] %install.1.red
    ]
    switch/default type?/word get/any 'param>details [
        unset! [
            either _debug [
                .install/_debug (param>what)
            ][
                .install (param>what)
            ]
            
        ]
        word! string![
            either (param>what) = 'extension [
                param>details: form :param>details
                either _debug [
                    .install-extension/_debug (param>details)
                ][
                    .install-extension (param>details)
                ]
                
            ][
                ;TODO:
            ]
        ]

        url! [
            either _debug [
                do-trace 262 [
                    ?? param>what
                ] %install.1.red
                
                .install/_debug (param>what)
            ][
                .install (param>what)
            ]
        ]
    ][
        throw error 'script 'expect-arg param>details
    ]
]
