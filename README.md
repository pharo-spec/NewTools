# NewTools
All development tools for Pharo, developed with Spec.

[![NewTools-Pharo-Integration](https://github.com/pharo-spec/NewTools/actions/workflows/newtools-all.yml/badge.svg)](https://github.com/pharo-spec/NewTools/actions/workflows/newtools-all.yml)  
![https://github.com/pharo-spec/NewTools/workflows/NewTools/badge.svg](https://github.com/pharo-spec/NewTools/workflows/NewTools/badge.svg)


# Installation

```Smalltalk
Metacello new
    baseline: 'NewTools';
    repository: 'github://pharo-spec/NewTools:Pharo10';
    onConflict: [ :e | e useIncoming ];
    onUpgrade: [ :e | e useIncoming ];
    ignoreImage;
    load
```
