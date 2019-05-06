#!/bin/sh
cd `dirname $0`
rm ./var/* -rf


#must >1024000
#ulimit -n 1024000
# +A 8 \
# -config ./octopus.config \
exec erl \
  +P 1002400 \
  +K true \
  -name octopus_monitor@127.0.0.1 \
  +zdbbl 8192 \
  -pa $PWD/deps/*/ebin \
  -pa $PWD/ebin \
  -config ./octopus_monitor.config \
  -boot start_sasl -s reloader -s octopus_monitor -setcookie XEXIWPUHUJTYKXFMMTXE 
