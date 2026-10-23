# [tmux](https://github.com/tmux/tmux)

## Install

플러그인은 [TPM](https://github.com/tmux-plugins/tpm)으로 관리합니다.

```sh
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

tmux 실행 후 아래 키로 플러그인을 관리합니다.

- `prefix + I`: 플러그인 설치
- `prefix + U`: 플러그인 업데이트
- `prefix + alt + u`: 목록에서 제거된 플러그인 정리

## Plugins

### Theme

- [Catppuccin](https://github.com/catppuccin/tmux)
- [tmux-cpu](https://github.com/tmux-plugins/tmux-cpu)
- [tmux-battery](https://github.com/tmux-plugins/tmux-battery)

### Session

- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)

`prefix + C-s`로 세션을 저장하고 `prefix + C-r`로 복원합니다. 저장 파일은 `~/.local/share/tmux/resurrect`에 생성됩니다.
