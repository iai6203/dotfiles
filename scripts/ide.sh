#!/bin/bash

# 현재 윈도우 이름을 'ide'로 변경
tmux rename-window 'ide'

# 좌측 pane에서 nvim 실행
tmux send-keys 'nvim' Enter

# 우측에 30% 크기의 pane 생성
tmux split-window -h -p 30

# 우측 pane에서 claude 실행
tmux send-keys 'claude' Enter

# 좌측 pane(nvim)으로 포커스 이동
tmux select-pane -L
