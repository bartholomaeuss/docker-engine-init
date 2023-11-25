#!/bin/bash

clean_uninstall=false
install=false

show_help(){
    echo "Deploy basic ssh config to $HOME/.ssh/config."
    echo "usage: $0 [-c] [-i] [-r] [-u] [-h]"
    echo "  -c  bool; uninstall docker from remote host and cleanup; default: false "
    echo "  -i  bool; install docker on remote host; default false"
    echo "  -r  remote host name"
    echo "  -u  remote host user name"
    echo "  -h  show help"
    exit 0
}

copy_scripts(){
    ssh -l "$user" "$remote" "mkdir -p ~/scripts"
    scp ./install_docker_engine.sh "$user@$remote":~/scripts/install_docker_engine.sh
    ssh -l "$user" "$remote" "chmod +x ~/scripts/install_docker_engine.sh"
    scp ./uninstall_docker_engine_and_cleanup.sh "$user@$remote":~/scripts/uninstall_docker_engine_and_cleanup.sh
    ssh -l "$user" "$remote" "chmod +x ~/scripts/uninstall_docker_engine_and_cleanup.sh"

}

clean_uninstall_docker(){
    start ssh -l "$user" "$remote" "sudo ~/scripts/uninstall_docker_engine_and_cleanup.sh; echo \"Press return to close window...\"; read"
    exit 0
}

install_docker(){
    start ssh -l "$user" "$remote" "sudo ~/scripts/install_docker_engine.sh; echo \"Press return to close window...\"; read"
    exit 0
}

while getopts ":c:i:r:u:h" opt; do
  case $opt in
    c)
      clean_uninstall=true
      ;;
    i)
      install=true
      ;;
    r)
      remote="$OPTARG"
      ;;
    u)
      user="$OPTARG"
      ;;
    h)
      show_help
      ;;
    \?)
      echo "unknown option: -$OPTARG" >&2
      show_help
      ;;
    :)
      echo "option requires an argument -$OPTARG." >&2
      show_help
      ;;
  esac
done

if "$install" && "$clean_uninstall"
then
  echo "script can't install and uninstall simultaneously"
  show_help
  exit 1
fi

if [ "$#" -le 0 ]
then
  echo "script requires an option"
  show_help
fi

if [ -z "$remote" ]
then
  echo "'-r' option is mandatory"
  show_help
fi

if [ -z "$user" ]
then
  echo "'-u' option is mandatory"
  show_help
fi

copy_scripts

if $clean_uninstall
then
  clean_uninstall_docker
fi

if $install
then
  install_docker
fi