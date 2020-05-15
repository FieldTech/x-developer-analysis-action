#!/bin/sh -l

echo "X-Developer client starting..."
python -m xdclient -i $1 -k $2 -t $3
