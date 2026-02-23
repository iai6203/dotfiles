#!/bin/bash

tmux rename-window 'ide'
tmux send-keys 'nvim' Enter
tmux split-window -h -p 30
tmux send-keys 'claude' Enter
