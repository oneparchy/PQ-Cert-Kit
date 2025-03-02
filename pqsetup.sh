#!/bin/bash

# Script to:
# 1. Install liboqs
# 2. Install OQS openssl

# This script is written for Ubuntu OS only.

BASE_DIR=$(pwd)

###############################################################################
################################## IMPORTANT ##################################
###############################################################################
# The variables in this section MUST be set for proper execution of this script.

#ABSOLUTE path to the directory to which OQS openssl should be installed:
OPENSSL_DIR=$BASE_DIR/openssl

###############################################################################

# -----------------------------------------------------------------------------
# logging helpers
# -----------------------------------------------------------------------------

function _log {
    level=$1
    msg=$2

    case "$level" in
        info)
            tag="\e[1;36minfo\e[0m"
            ;;
        err)
            tag="\e[1;31merr \e[0m"
            ;;
        warn)
            tag="\e[1;33mwarn\e[0m"
            ;;
        ok)
            tag="\e[1;32m ok \e[0m"
            ;;
        fail)
            tag="\e[1;31mfail\e[0m"
            ;;
        *)
            tag="    "
            ;;
    esac
    echo -e "`date +%Y-%m-%dT%H:%M:%S` [$tag] $msg"
}

function _err {
    msg=$1
    _log "err" "$msg"
}

function _warn {
    msg=$1
    _log "warn" "$msg"
}

function _info {
    msg=$1
    _log "info" "$msg"
}

function _success {
    msg=$1
    _log "ok" "$msg"
}

function _fail {
    msg=$1
    _log "fail" "$msg"
}

# -----------------------------------------------------------------------------
# Checking dependencies
# -----------------------------------------------------------------------------
function check_dependencies {
    DEPS=("bc" "astyle" "cmake" "gcc" "ninja-build" "libssl-dev" "python3-pytest" "python3-pytest-xdist" "unzip" "xsltproc" "doxygen" "graphviz" "python3-yaml" "valgrind" "libtool" "make" "git" "software-properties-common" "build-essential" "moreutils")
    for d in ${DEPS[@]}; do
        _info "Looking for '$d'"
        found=0
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $d |grep "install ok installed")
        if [ "" != "$PKG_OK" ]; then
                _success "'$d' installed"
                found=1
        fi
        if [ $found -eq 0 ]; then
            _fail "Missing dependency: $d"
            _info "On Debian/Ubuntu: apt-get install '$d'"
            prompt_installer $d
        fi
    done
}

# -----------------------------------------------------------------------------
# Prompt installer
# -----------------------------------------------------------------------------
function prompt_installer {
    read -p "Do you want to install it? [Y/n]: " -n 10 CHOICE

    case $CHOICE in
        y|Y|yes|YES|"")
            sudo apt-get install -y $1
            ;;
        *)
            _info "Quitting..."
            exit 1
            ;;
    esac
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

OS=$(cat /etc/os-release  | grep VERSION_ID | cut -d '"' -f2)

################################ VERSION CHECK ################################
# Ubuntu Jammy uses OpenSSL >= 3.x.x , and at the time of making this script OpenSSL 1.x.x is not installable.
# This may (or may not) be a problem. I haven't tried to install this in Jammy.
# If you believe it can successfully be installed on your system, feel free to remove the below check & clean up the rest of the if statement.

if (( $(echo "$OS < 18.04" |bc -l) )) || (( $(echo "$OS < 21.04" |bc -l) )); then
    _fail "You are running Ubuntu version $OS, which may not support openssl 1.1.1"
else


    ################################ MEMORY CHECK ################################
    # Building liboqs is VERY memory intensive, will likely fail on VMs with < 16GB RAM.
    # I read somewhere that this command helps, but had no success with it myself.
    
    # sysctl -w vm.overcommit_memory=2
    
    # The workaround is to (temporarily) provision at least 16GB of RAM to the VM, then run this script.
    # You can reduce the RAM afterwards when liboqs is built.
    
    _info "Check dependencies"
    check_dependencies

    _info "OQS OpenSSL target directory set to $BASE_DIR/openssl"
    git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/openssl.git $OPENSSL_DIR
    
    _info "Install liboqs to '$BASE_DIR'/liboqs"
    git clone --branch main https://github.com/open-quantum-safe/liboqs.git
    cd liboqs
    mkdir build && cd build
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=$OPENSSL_DIR/oqs .. 
    ninja
    ninja install
    if [ $? -eq 0 ]; then
        ninja clean
        _success "Success"
    else
        ninja clean
        _fail "Failed"
	exit 1
    fi
    
    _info "Install OQS OpenSSL to $BASE_DIR/openssl"
    cd $OPENSSL_DIR 
    ./Configure no-shared linux-x86_64 -lm
    make -j
    if [ $? -eq 0 ]; then
        _success "Success"
    else
        make clean
        _fail "Failed"
	exit 1
    fi

    cd $BASE_DIR
    exit 0
fi
