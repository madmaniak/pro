#!/bin/bash

index='/pro/app/index.html'
framework_index='/pro/framework/app/index.html'

printf 'server.document-root = "'
if [ -f $index ]; then
  printf $index
else
  printf $framework_index
fi

printf '"\n'
