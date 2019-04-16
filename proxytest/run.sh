#!/bin/bash -e

yellow="\033[0;33m"
red="\033[0;31m"
nocolor="\033[0m"

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

get_script_path() {
    local _src="${BASH_SOURCE[0]}"
    while [[ -h "${_src}" ]]; do
        local _dir="$(cd -P "$( dirname "${_src}" )" && pwd)"
        local _src="$(readlink "${_src}")"
        if [[ "${_src}" != /* ]]; then _src="$_dir/$_src"; fi
    done
    echo $(cd -P "$(dirname "$_src")" && pwd)
}


### Main
echo -e "${yellow}[INFO] [${BASH_SOURCE[0]}] executed.${nocolor}"

if ! command_exists docker; then
    echo -e "${red}[ERROR] Install docker first.\\n\\
[MacOS] $ brew cask install docker\\n\\
[Linux] $ curl -fsSL https://get.docker.com | sh${nocolor}"
    exit 1;
fi

script_dir=$(get_script_path)
docker_context_dir="${script_dir%/*}/."

(
cd ${docker_context_dir}
docker build -t proxytest -f proxytest/Dockerfile .
docker run -v ${script_dir}/assets:/data -p 80:80 -p 8001:8001 proxytest
)

echo -e "${yellow}[INFO] [${BASH_SOURCE[0]}] Done.${nocolor}"
