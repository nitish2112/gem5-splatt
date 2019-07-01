#!/bin/bash

set -x # echo on

declare -a arr=("nell-2" "netflix" "poisson3D" "ml20m")

source setup-brg.sh

for tensor in "${arr[@]}"
do
  echo ====================================== | tee -a result.log;
  echo $tensor | tee -a result.log;
  echo ====================================== | tee -a result.log;
  for mode in `seq 0 2`
  do
    echo "*************** Mode $mode ******************" | tee -a result.log;
    for bin_ in `seq 0 4`
    do
      echo Bin: $bin_ | tee -a result.log &&
      cd splatt &&
      make -j &&
      sed -i 's/,/\t/g' ../spxcel-mttkrp-data/$tensor-mode-$mode-bin-$bin_.tns &&
      ./run.sh ../spxcel-mttkrp-data/$tensor-mode-$mode-bin-$bin_ 64 &&
      #./run.sh ../gem5-o3-mttkrp-dataset/nell-2 64 &&
      mv args.h mttkrp/. &&
      cd mttkrp &&
      rm -rf mttkrp.x86 &&
      ./compile.sh $mode &&
      cd ../../ &&
      make build-gem5 &&
      make run-splatt-mttkrp 2>&1 | tee -a result.log
    done
  done
done
