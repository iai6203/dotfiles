#!/bin/bash

tmux rename-window 'ide'
tmux send-keys 'nvim' Enter
tmux split-window -h -p 30
tmux send-keys 'claude' Enter
tmux split-window -v -p 67
tmux send-keys 'claude' Enter
tmux split-window -v -p 50
tmux send-keys 'claude' Enter
