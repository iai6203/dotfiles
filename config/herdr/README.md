# [Herdr](https://herdr.dev/)

로컬 플러그인 소스는 `local-plugins/`에서 관리하고, 플러그인 디렉터리마다 `herdr plugin link`로 등록합니다. Herdr 설정 디렉터리 전체를 이 디렉터리에 심볼릭 링크하지 않습니다.

## 로컬 플러그인

- [Worktree Tabs](local-plugins/worktree-tabs/README.md): 새 worktree에 `nvim`(아래쪽 셸 포함), `agents`(`claude`와 `omp` 좌우 분할), `terminal` 탭을 준비하고, 멀티 레포 meta 레포에서는 지정한 서브 레포 worktree도 함께 만듭니다.
