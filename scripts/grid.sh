#!/bin/bash

# Pane 8개 추가 생성 (총 9개)
# 분할 직후 pane이 너무 작아 다음 분할이 실패하는 것을 방지하기 위해
# 매 분할마다 tiled 레이아웃을 적용하여 공간을 재분배한다.
for i in {1..8}; do
    tmux split-window
    tmux select-layout tiled
done
