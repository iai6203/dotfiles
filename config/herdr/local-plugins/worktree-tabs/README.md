# Worktree Tabs

macOS 또는 Linux(WSL2 포함)에서 Herdr 0.9.5 이상과 `jq`가 필요합니다. Herdr pane의 셸에서 `nvim`, `claude`, `omp`를 실행할 수 있어야 합니다.

이 레포의 메인 체크아웃 루트에서 한 번 등록합니다.

```sh
herdr plugin link "$PWD/config/herdr/local-plugins/worktree-tabs"
```

Herdr에서 새 worktree를 만들면 기본 탭을 `nvim`으로 바꾸고 `agents`, `terminal` 탭을 순서대로 추가합니다. `agents` 탭은 좌우 50:50으로 나뉘어 왼쪽에서 `claude`, 오른쪽에서 `omp`를 실행합니다. 모든 pane은 새 checkout 루트에서 열립니다. `nvim` 탭은 `nvim`을 실행하고, `terminal` 탭은 별도 명령 없이 기본 셸만 엽니다. 추가 탭으로 포커스를 옮기지 않으며, 기존 worktree를 다시 열 때는 실행되지 않습니다.

```sh
herdr plugin log list --plugin local.worktree-tabs --limit 5
herdr plugin unlink local.worktree-tabs
```

첫 번째 명령은 실행 로그를 확인하고, 두 번째 명령은 플러그인 등록만 해제합니다.
