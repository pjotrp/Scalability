#! /bin/sh

cd test/data
time for x in cluster000[45]* ; do cd $x ; codeml ../paml0-3.ctl ; cd .. ; done
cd ../..
