#! /bin/bash
#
# Copyright (C) 2010 Pjotr Prins <pjotr.prins@thebird.nl>

cd test/data
for x in cluster000[45]* ; do
  cd $x
  export dir=`pwd`
  clustalw -tree -outorder=INPUT -infile=$dir/aa.fa -outfile=$dir/aa.ph 
  clustalw -align -outorder=INPUT -infile=$dir/aa.fa -outfile=$dir/aa.aln
  pal2nal.pl -output paml $dir/aa.aln $dir/nt.fa > $dir/alignment.phy
  cd ..
done
# export PATH=~/opt/ruby/rq/bin/:$PATH
# first time create the queue
if [ ! -d ~/queue ]; then
  rq ~/queue create
else
  rq ~/queue d all
fi
# start the rq daemon, max 8 processes running in parallel
rq ~/queue feed --daemon --log=rq.log --max_feed=8 --min_sleep 2 --max_sleep 15
# start submitting jobs to rq
for x in cluster000[45]* ; do
  cd $x
  export dir=`pwd`
  # submit to rq; pass in the path!
  rq ~/queue submit "cd $dir ; codeml $dir/../paml0-3.ctl"
  cd ..
done
