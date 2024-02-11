#!/bin/bash

clean_uninstall=false
install=false

show_help(){
    echo "Deploy basic ssh config to $HOME/.ssh/config."
    echo "usage: $0 [-r] [-u] [-h]"
    echo "  -r  remote host name"
    echo "  -u  remote host user name"
    echo "  -h  show help"
    exit 0
}

copy_scripts(){
    ssh -v -l "$user" "$remote" "mkdir -p ~/scripts"
    scp -v ./install_docker_engine.sh "$user@$remote":~/scripts/install_docker_engine.sh
    scp -v ./uninstall_docker_engine_and_cleanup.sh "$user@$remote":~/scripts/uninstall_docker_engine_and_cleanup.sh

}

while getopts ":c:i:r:u:h" opt; do
  case $opt in
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