# [Claude Code](https://docs.claude.com/en/docs/claude-code)

## Statusline

주간/세션 사용량과 리셋 시각, 컨텍스트 사용률을 표시합니다.

```
week 56% (reset 10/18 14:06) session 12% (reset 02:46) ctx 42%
```

### Requirements

- [`jq`](https://github.com/jqlang/jq)

### Install

```sh
ln -s ~/projects/personal/dotfiles/config/claude/statusline.sh ~/.claude/statusline.sh
```

`~/.claude/settings.json`에 아래 설정을 추가합니다.

```json
"statusLine": {
  "type": "command",
  "command": "bash ~/.claude/statusline.sh"
}
```
