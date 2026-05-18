#!/bin/bash

# 1행 45%, 2행 45%, 3행 10% 비율의 3행을 만들고,
# 각 행을 가로로 3등분하여 총 9개의 pane을 생성한다.

# 창 전체 높이를 측정해 행별 라인 수를 계산
H=$(tmux display-message -p '#{window_height}')
row1=$((H * 45 / 100))
row2=$((H * 45 / 100))
# 나머지 라인을 마지막 행에 할당하여 합계 = H 보장 (반올림 오차 흡수)
row3=$((H - row1 - row2))

# 1단계: 수직 분할로 3행 구성
# 상단을 row1 크기로 두고, 하단에 (row2 + row3) 크기의 새 pane 생성
tmux split-window -v -l $((row2 + row3))
# 현재 활성 pane(하단)을 다시 분할: 위 row2 / 아래 row3
tmux split-window -v -l "$row3"

# 가로 분할 시 활성 pane이 바뀌므로, 각 행의 pane ID를
# 위에서 아래 순으로 미리 수집해 둔다.
row_panes=$(tmux list-panes -F '#{pane_top} #{pane_id}' | sort -n | awk '{print $2}')

# 2단계: 각 행을 가로로 3등분
for pane in $row_panes; do
  tmux select-pane -t "$pane"
  tmux split-window -h -p 67 # 좌 1/3 + 우 2/3
  tmux split-window -h -p 50 # 우 2/3을 다시 절반으로
done
