#!/usr/bin/env zsh
for command completion in ${(kv)_comps:#-*(-|-,*)}
do
    printf "%-32s %s\n" $command $completion
done | sort
