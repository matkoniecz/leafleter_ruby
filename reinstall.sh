#!/bin/bash
set -Eeuo pipefail
IFS=$'\\n\\t'
err_report() {
    echo "Error on line $1"
}
trap 'err_report $LINENO' ERR

gem build *.gemspec
gem install --user-install *.gem 
#gem push *.gem 
