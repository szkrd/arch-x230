#!/usr/bin/env bash
# minimal display for conky
# use with ${pre_exec current_volume.sh}
ponymix | grep --color=never Avg. | head -n1 | sed 's/\s*Avg. Volume: //' | sed 's/ \[Muted\]/:M/'
