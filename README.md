# Dotfiles

## Oh My Pi

[`config/omp/config.yml`](config/omp/config.yml)은 Codex 5시간·주간 사용량을 표시하는 상태줄을 포함한 OMP 설정입니다. 기존 `~/.omp/agent/config.yml`이 있다면 필요한 설정을 병합하고 원본을 백업한 뒤, 저장소 루트에서 실행합니다.

```sh
mkdir -p ~/.omp/agent
ln -s "$(pwd -P)/config/omp/config.yml" ~/.omp/agent/config.yml
```

OMP에서 설정을 저장하면 링크 대상인 저장소 파일이 바뀝니다. 인증 정보와 세션은 링크하지 않으며, API 키는 이 YAML에 넣지 않습니다.

## Repo Activity

![Alt](https://repobeats.axiom.co/api/embed/c7e9e41c78b570655ae2709534aea1fbff8536d6.svg "Repobeats analytics image")
