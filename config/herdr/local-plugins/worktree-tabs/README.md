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

## Worktree 위치

Herdr는 `<worktrees.directory>/<repo>/<branch-slug>`에 checkout을 만듭니다. 기본값은 `~/.herdr/worktrees`이고, `~/.worktrees` 아래에 두려면 `~/.config/herdr/config.toml`에 다음을 추가합니다.

```toml
[worktrees]
directory = "~/.worktrees"
```

실행 중인 서버에는 `herdr server reload-config`로 반영합니다.

## 멀티 레포 프로젝트

여러 Git 레포를 담은 상위 디렉터리는 그 자체가 레포가 아니라서 Herdr worktree 메뉴가 나타나지 않습니다. 상위 디렉터리를 설정 파일만 추적하는 meta 레포로 만들면 Herdr가 기능 단위 worktree를 프로젝트 space 아래에 묶어 보여 주고, 이 플러그인이 지정한 서브 레포의 worktree를 checkout 안에 함께 만듭니다.

```text
~/projects/example/                   meta 레포(main)
  api/  web/  worker/  ...
~/.worktrees/example/<branch-slug>/   Herdr가 만든 meta worktree
  api/  web/                           플러그인이 만든 서브 레포 worktree
```

meta 레포 루트에 `.gitignore`와 `.herdr-worktree.json`을 두고 커밋합니다.

```gitignore
/*
!/.gitignore
!/.herdr-worktree.json
# 서브 레포를 untracked로 남겨 두어야 git이 meta worktree 삭제를 거부합니다.
!/api/
!/web/
!/worker/
```

```json
{
  "repos": ["api", "web"],
  "copy": ["api/.env", "web/src/.env"]
}
```

- `repos`: 분기할 서브 레포 디렉터리입니다. 각 항목은 그 자체가 Git 레포 루트여야 하며, 아니면 경고를 남기고 건너뜁니다. 같은 이름의 로컬 브랜치가 있으면 그 브랜치를 checkout하고, 없으면 `origin/HEAD`(없거나 가리키는 브랜치가 사라졌으면 `HEAD`)에서 meta worktree와 같은 이름의 브랜치를 upstream 없이 만듭니다. 미리 `git fetch`하지 않으므로 최신 기준이 필요하면 원본 레포에서 먼저 fetch합니다.
- `copy`: Git이 추적하지 않아 새 checkout에 없는 파일을 meta 레포 루트 기준 경로로 적습니다. 원본 파일이나 대상 디렉터리가 없거나 대상이 checkout 밖으로 이어지면 경고만 남기고, 이미 있는 파일은 덮어쓰지 않습니다.

meta 레포에서는 `nvim` 탭을 서브 레포 worktree 수만큼 같은 폭으로 좌우 분할하고, `repos` 순서대로 각 pane에서 해당 서브 레포 루트로 `nvim`을 실행합니다. 이번에 만들지 못한 서브 레포는 경로가 이미 있더라도 분할에서 빠지고, 하나도 없으면 checkout 루트에서 `nvim` 하나만 엽니다. 레포를 넘나드는 검색이나 작업은 checkout 루트에서 열리는 `agents`, `terminal` 탭에서 합니다.

`.herdr-worktree.json`이 없는 일반 레포에서는 서브 레포 단계를 건너뜁니다. manifest 형식이 잘못됐거나 서브 레포 준비에 실패해도 탭은 열고, 플러그인 로그에 실패 상태와 이유를 남깁니다.

meta worktree를 지울 때는 서브 레포 worktree를 먼저 정리해야 합니다. 남아 있으면 Herdr 삭제가 `dirty_worktree_requires_force`로 거부되므로, 커밋하지 않은 변경이 meta worktree와 함께 지워지지 않습니다. 이 보호는 Git이 서브 레포를 untracked로 보고할 때만 동작하므로, meta 레포에 `status.showUntrackedFiles=no`를 설정하지 않습니다.

```sh
git -C ~/projects/example/api worktree remove ~/.worktrees/example/<branch-slug>/api
```
