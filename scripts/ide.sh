#!/bin/bash
tmux split-window -v -l 20% -d # Create a 20% height pane at bottom, keep focus on current pane
nvim                           # Launch nvim editor
