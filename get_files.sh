#!/bin/bash -eu

function usage() {
  cat <<_EOT_
Usage:
  $(basename $0) [-a|-b|-t|-f] [-q] [-h] \*.vfs

Options:
  -a do not display total file(s)(TYPE A)
  -b do not display total file(s)(TYPE B)
  -f do not display file name(s)
  -q suppress log
  -h display this help and exit
_EOT_
  exit 1
}

for char in a b f q h; do
  eval OPT_FLAG_${char}=0;
done

while getopts "abfqh" OPT; do
  case $OPT in
    h) usage; continue;;
    \?) usage; continue;;
  esac
  eval OPT_FLAG_${OPT}=1;eval OPT_VALUE_${OPT}=${OPTARG:-""}
done

shift $(($OPTIND - 1))

if [ "${#}" = "0" ]; then
  echo "$(basename $0)"': error: argument not specified'
  exit 1
fi

function echo_log() {
  if [ "${OPT_FLAG_q}" = "0" ]; then
    echo ${*}
  fi
}

readonly FILES=($(grep 'data....\.bin' $1 -ao))

if [ "${OPT_FLAG_f}" = "0" ]; then
  echo_log 'File name(s):'
  declare i=0
  for i in ${FILES[*]}; do
    echo ${i}
  done
fi

if [ "${OPT_FLAG_a}" = "0" ]; then
  echo_log -n 'Total file(s)(TYPE A): '
  expr $(wc -c < $1) / 226896
fi

if [ "${OPT_FLAG_b}" = "0" ]; then
  echo_log -n 'Total file(s)(TYPE B): '
  echo ${#FILES[*]}
fi

# echo ${array[3]}
# dd if=savedata.vfs bs=1 count=226896 skip=20 status=none
