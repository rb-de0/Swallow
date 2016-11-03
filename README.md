[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg)](https://swift.org)
![Platform Linux, OSX](https://img.shields.io/badge/Platforms-Linux%2C%20OSX-lightgray.svg)
[![Build Status](https://travis-ci.org/rb-de0/Swallow.svg?branch=master)](https://travis-ci.org/rb-de0/Swallow)

# Swallow

Swallow is a simple stub manager using Swift

## Prerequisites

#### Swift

- Swift 3.0 Release

#### macOS

- OS X El Captain 10.11.6

#### Linux

- Ubuntu 14.04

## USAGE

### Download

```bash
$ git clone https://github.com/rb-de0/Swallow
```

### Build

#### Standard

```bash
# Linux
$ swift build -Xlinker -L/usr/lib

# OS X/mac OS
$ swift build -Xlinker -L/usr/local/lib -Xcc -I/usr/local/include -Xcc -I/usr/local/include/mysql
```

#### Toolbox

```bash
$ vapor build
```

### Generate xcode project

#### Standard

```bash
# Linux
$ swift package generate-xcodeproj -Xlinker -L/usr/lib

# OS X/mac OS
$ swift package generate-xcodeproj -Xswiftc -I/usr/local/include/mysql -Xswiftc -I/usr/local/include -Xlinker -L/usr/local/lib
```

#### Toolbox

```bash
$ vapor xcode
```

### Run

#### bash

```bash
$ .build/debug/App
```

#### Xcode

Press Command + R to build & run.

## LICENSE

Swallow is released under the MIT License. See the license file for more info.

