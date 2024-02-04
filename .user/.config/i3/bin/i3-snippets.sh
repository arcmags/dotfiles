#!/bin/bash

swap_displays() {
# move all workspaces one display to the right:
    local workspaces workspace workspace_current
    workspace_current="$(i3-msg -t get_workspaces | \
        sed -e 's/},{/},\n{/g' | sed -ne '/"focused":true/p' | \
        grep -Po '.*"name":"\K.+?(?=")')"
    mapfile -t workspaces < \
        <(i3-msg -t get_workspaces | sed -e 's/},{/},\n{/g' | \
        sed -ne '/"visible":true/p' | grep -Po '.*"name":"\K.+?(?=")')
    for workspace in "${workspaces[@]}"; do
        i3-msg -- workspace --no-auto-back-and-forth "$workspace"
        i3-msg -- move workspace to output right
    done
    i3-msg -- workspace "$workspace_current"
}

toggle_gaps() {
# toggle gaps using grep:
    if [ `i3-msg -t get_tree | grep -Po \
    '.*"gaps":{"inner":\K(-|)[0-9]+(?=.*"focused":true)'` -eq 0 ]; then
        i3-msg gaps inner current set 0
    else
        i3-msg gaps inner current set 20
    fi
}

toggle_gaps_jq() {
# toggle gaps using jq (way slower):
    if [ $(i3-msg -t get_tree | jq -r \
    'recurse(.nodes[]) | if .type == "workspace" and .name == "'`i3-msg \
    -t get_workspaces | jq -r '.[] | if .["focused"] then .["name"] else \
    empty end'`'" then .gaps.inner else empty end') -eq 0 ]; then
        i3-msg gaps inner current set 0
    else
        i3-msg gaps inner current set 20
    fi
}

print_workspace_name() {
# print current workspace name:
    i3-msg -t get_workspaces | \
        grep -Po '.*(},|\[)\K{.*?"focused":true.*?(?=(,{|\]))' | \
        grep -Po '.*"name":"\K.+?(?=")'
}

# get active container info:
i3-msg -t get_tree | jq '.. | objects |  select(.focused==true)'

# get active window id:
i3-msg -t get_tree | jq '.. | objects |  select(.focused==true) | .id'

# get all window ids on active workspace:
i3-msg -t get_tree | jq '.nodes[].nodes[].nodes[] | select(.. | objects | select(.focused==true)) | .. | objects | select(.window!=null) | .id'
