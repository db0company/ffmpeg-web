#!/bin/bash

folder='npm'
tarname='node.tar.gz'

if [ $# -ge 1 ] && [ $1 = '-clean' ]
then
    rm -rf $folder
    rm -f ~/.npmrc
    rm -f $tarname
    exit 0
fi

mkdir -p $folder && \
cd $folder && \

localpath=`pwd`

echo "root = "$localpath"/lib/node_modules
binroot = "$localpath"/bin
manroot = "$localpath"/share/man" > ~/.npmrc && \

wget "http://nodejs.org/dist/v0.10.29/node-v0.10.29.tar.gz" -O $tarname && \
tar xf $tarname && \
cd node-* && \
./configure --prefix=$localpath && \
make && \
make install && \
cd .. && \

export PATH=$localpath/bin:$PATH && \

npm install -g less && \
npm install -g bower && \

cd .. && \

make
