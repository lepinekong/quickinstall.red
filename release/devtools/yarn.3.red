Red [
    File: "yarn"
]

unless value? '.redlang [
    do https://redlang.red
]
.redlang [alias]
.quickinstall/load-only [install]

.install-yarn: does [
    return .install https://yarnpkg.com/latest.msi
]

.alias .install-yarn [install-yarn]
