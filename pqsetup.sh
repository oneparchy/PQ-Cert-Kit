#!/bin/bash

# This script installs the OQS Provider (and dependencies), and is written for Ubuntu/Debian OS only.
# You may have issues trying to use with other distros.
# This script will attempt to install OQS Provider, however it is best to activate manually. 
# See https://github.com/open-quantum-safe/oqs-provider/blob/main/USAGE.md#activation for activation details.
# Verify proper functionality of your system-wide OpenSSL with:
# 	openssl list -providers

############################################### UPDATE ###############################################
# The OQS guys have massively simplified this process from what we used to have to do before
# Script has been adjusted to reflect that, however this script ASSUMES you already have a compatible
# OpenSSL (>=3.0) in a system-standard location. If this is not the case, do not use this script - 
# Manually install LibOQS & OQS-Provider yourself: https://github.com/open-quantum-safe/oqs-provider
######################################################################################################

######################################################################################################
# -------------------------------------------- Global Vars -------------------------------------------
BASE_DIR=$(pwd)					#Starting directory
OQSP_DIR=$BASE_DIR/oqs-provider			#OQS Provider install directory
$OSSLCNF_FILE=/lib/ssl/openssl.cnf		#Path to OpenSSL config file
ALGS_ENABLED="All"				#OQS Algorithms enabled (see https://github.com/open-quantum-safe/liboqs/blob/main/CONFIGURE.md#oqs_algs_enabled:~:text=Default%3A%20Unset.-,OQS_ALGS_ENABLED,-A%20selected%20algorithm)

######################################################################################################
# ----------------------------------------------------------------------------------------------------
# logging helpers
# ----------------------------------------------------------------------------------------------------

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

# ----------------------------------------------------------------------------------------------------
# Check dependencies
# ----------------------------------------------------------------------------------------------------
function check_dependencies {
    DEPS=("astyle" "cmake" "gcc" "ninja-build" "libssl-dev" "python3-pytest" "python3-pytest-xdist" "unzip" "xsltproc" "doxygen" "graphviz" "python3-yaml" "valgrind" "libtool" "make" "git" "software-properties-common" "build-essential" "moreutils")
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

# ----------------------------------------------------------------------------------------------------
# Prompt installer
# ----------------------------------------------------------------------------------------------------
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

# ----------------------------------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------------------------------

################################ MEMORY CHECK ################################
# Building liboqs is VERY memory intensive, may fail on VMs with < 16GB RAM.
# I read somewhere that the below command helps, but had no success with it myself.
# sysctl -w vm.overcommit_memory=2

# The workaround is to (temporarily) provision at least 16GB of RAM to the VM, then run this script.
# You can reduce the RAM afterwards when liboqs is built.

_info "Check dependencies"
check_dependencies

_info "Installing OQS Provider to '$OQSP_DIR'"
git clone --branch main https://github.com/open-quantum-safe/oqs-provider.git "$OQSP_DIR"
cd "$OQSP_DIR" && env CMAKE_PARAMS="-DOQS_ALGS_ENABLED=$ALGS_ENABLED" bash scripts/fullbuild.sh
./scripts/runtests.sh		# For whatever reason this always returns 1 on my system even though it seems to work just fine. Might be WIP
#if [ $? -eq 0 ]; then
#	_success "Provider install succeed"
#else
#	_fail "Provider install failed"
#	exit 1
#fi

#_info "Activating OQS Provider"
#if [ -f "/lib/ssl/openssl.cnf" ]; then
#	sudo sed -i '/^\[provider_sect\]$/ { N; /\ndefault = default_sect$/ a\
#oqsprovider = oqsprovider_sect
#}' "$OSSLCNF_FILE" &&
#	sudo sed -i "/^\[default_sect\]$/ { N; /\n# activate = 1$/ {s/# activate = 1/activate = 1/; a\
#[oqsprovider_sect]\
#module = ${OQSP_DIR}/_build/lib/oqsprovider.so\
#activate = 1
#}}" "$OSSLCNF_FILE" &&
# 	_success "Activated OQS Provider" 	
#else
#	_warn "Unable to activate OQS Provider"
#fi

if [ $? -eq 0 ]; then
	_warn "OQS Provider installed but not activated. Activate manually"
 	_success "Done"
else
	_fail "Failed"
	exit 1
fi

cd $BASE_DIR
exit 0
