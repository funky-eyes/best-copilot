# best-copilot

[English](README.md) | [简体中文](README.zh-CN.md) | 한국어 | [日本語](README.ja.md)

[![version](https://img.shields.io/badge/version-0.7.1-1d9bf0)](plugin.json)
[![Codex](https://img.shields.io/badge/Codex-plugin-111827)](.codex-plugin/plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-f97316)](claude-plugin/.claude-plugin/plugin.json)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-39-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot`은(는) Codex, Copilot CLI, Claude Code에서 사용할 수 있는 설치형 에이전트 팀 workflow입니다. 이 프로젝트는 저장소에 다음과 같은 시니어급 전달 흐름을 제공합니다: 사실 초기화, 범위 고정, 설계 후 구현, 전문 역할을 통한 구현, 독립적 검토, 증거 기반 검증, 그리고 다음 세션을 위한 복구 지점 보존.

Codex는 `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json`, `.agents/skills -> ../skills`, `.codex/agents/*.toml`을 사용합니다. Copilot CLI는 `plugin.json`을 통해 루트 `agents/`와 `skills/`를 사용합니다. Claude Code는 `claude-plugin/` 패키지를 사용합니다: `claude-plugin/.claude-plugin/plugin.json`, `claude-plugin/skills -> ../skills`, `claude-plugin/agents -> ../claude-agents`. 저장소 수준 규칙은 `.github/instructions/**`에 보관됩니다.

## 존재 이유

모호한 요청에서 곧바로 패치로 넘어가면 대형 AI 코딩 작업은 실패하기 쉽습니다. `best-copilot`은 이러한 결여된 전달 규율을 보완합니다:

- **하나의 시니어 진입점**: Senior Project Expert는 의도, 범위, 디스패치, fan-in, 수렴, 재사용 가능한 리플렉션/Memory/정책 신호를 담당합니다.
- **여덟 개의 전문 에이전트**: 기획, 아키텍처, 구현, 프론트엔드, QA, 보안, 근본 원인 수정, 명세 작업 등이 각각 책임을 가집니다.
- **서른아홉 개의 스킬**: 역할 workflow, 부트스트랩, 검색, 기획, workspace isolation, TDD, 설계 검토, 실행, Java/Python 코딩 가이드라인, 검증, branch closeout, 프런트엔드 감사, 워크플로 진화, Senior Project Expert 호환 진입점을 포함합니다.
- **대상 저장소 로컬의 메모리/스펙**: 설치된 프로젝트는 사실, 워크스트림, 메모리 및 스펙을 플러그인 패키지가 아닌 대상 저장소에 보관합니다.
- **증거 우선의 종료**: '완료' 선언은 명령 출력, 정적 검사, 브라우저 증거 또는 명확한 차단자 중 하나가 있어야 합니다.

## 설치

### Codex

Codex는 재사용 가능한 skills, apps, MCP 설정을 플러그인으로 배포할 수 있습니다. 이 저장소를 Codex marketplace로 추가한 뒤 플러그인을 설치하세요:

```bash
codex plugin marketplace add funky-eyes/best-copilot
codex plugin add best-copilot@best-copilot
```

로컬 개발에서 현재 checkout을 사용할 때:

```bash
codex plugin marketplace add /absolute/path/to/best-copilot
codex plugin add best-copilot@best-copilot
```

Codex는 다음을 발견합니다:

- 플러그인 메타데이터: [.codex-plugin/plugin.json](.codex-plugin/plugin.json)
- 로컬 / 저장소 marketplace 메타데이터: [.agents/plugins/marketplace.json](.agents/plugins/marketplace.json)
- marketplace plugin source: [plugins/best-copilot](plugins/best-copilot). 실제 Codex 플러그인 서브패키지이며, `skills` 디렉터리는 루트의 공유 [skills/](skills/)로 연결됩니다
- plugin manifest를 통해 노출되는 공유 skills: [skills/](skills/). 설치된 플러그인 상세 화면에 표시됩니다
- [.agents/skills](.agents/skills)를 통한 repo-scoped 공유 skills. 이 checkout에서 작업할 때 일반 `$` skill selector에 표시되게 하는 경로입니다
- [.codex/agents](.codex/agents)를 통한 Codex custom agents. 이 checkout에서 작업하거나, 해당 adapter 디렉터리를 대상 저장소로 복사하거나, Codex compatibility로 `repo-init-scan`을 실행한 뒤 사용할 수 있습니다

설치하거나 수정한 뒤에는 새로운 Codex thread/session을 시작하세요. 설치된 플러그인에서 이 workflow를 사용할 때는 `@best-copilot`을 명시적으로 호출합니다. 개별 workflow skill을 일반 `$` skill selector에 표시하려면 `.agents/skills` 또는 `~/.agents/skills` 같은 repo/user skill 위치로 노출하세요.

Codex subagent는 플러그인과 별도로 설정됩니다. Copilot의 `agents/*.agent.md` 파일과 Claude의 `claude-agents/*.md` 어댑터는 플러그인 설치 후 Codex custom agent로 자동 등록되지 않으므로, 이 저장소는 [.codex/agents](.codex/agents)에 네이티브 Codex TOML adapter도 제공합니다. 대상 저장소에서는 Codex compatibility를 요청하면 init helper가 `AGENTS.md`와 동일한 8개의 `.codex/agents/*.toml` adapter를 생성합니다.

### Copilot CLI

이 저장소를 Copilot CLI 플러그인 마켓플레이스로 등록합니다:

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

등록된 마켓플레이스에서 설치:

```bash
copilot plugin install best-copilot@best-copilot
```

로컬 개발 시:

```bash
copilot plugin marketplace add /absolute/path/to/best-copilot
copilot plugin install best-copilot@best-copilot
```

직접 GitHub 저장소에서 설치할 수도 있으나, CLI는 직접 설치가 deprecated 이며 향후 `plugin@marketplace`만 지원될 예정이라고 경고합니다:

```bash
copilot plugin install funky-eyes/best-copilot
```

로컬 수정 후에는 새 CLI 세션에서 테스트하기 전에 플러그인을 재설치 또는 업데이트하세요. Copilot CLI는 설치된 플러그인 캐시에서 에이전트와 스킬을 읽습니다.

### Claude Code

Claude Code는 자체 marketplace 시스템을 사용합니다. 이 저장소를 Claude Code marketplace로 추가한 뒤 플러그인을 설치하세요:

```text
/plugin marketplace add funky-eyes/best-copilot
/plugin install best-copilot@best-copilot
/reload-plugins
```

로컬 개발 또는 현재 checkout에서 직접 사용할 때는 플러그인 디렉터리를 로드할 수 있습니다:

```bash
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin
```

Claude Code에서 Senior Project Expert를 안정적인 진입점으로 쓰려면 해당 agent가 전체 세션을 담당하게 시작하세요:

```bash
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert
```

플러그인을 설치한 뒤에는 보통 다음처럼 줄일 수 있습니다:

```bash
claude --agent senior-project-expert
```

Claude Code는 다음을 발견합니다:

- marketplace 메타데이터: [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)
- 플러그인 메타데이터: [claude-plugin/.claude-plugin/plugin.json](claude-plugin/.claude-plugin/plugin.json)
- 공유 스킬: [skills/](skills/). Claude Code에서는 `/best-copilot:repo-init-gate` 같은 namespace가 붙은 slash command로 호출합니다. 명령 선택기가 다른 플러그인 표시 형식을 삽입하면 그 값을 그대로 사용하세요.
- Claude 호환 subagent: [claude-agents/](claude-agents/)
- PM 메인 세션은 `--agent senior-project-expert` 또는 Claude Code의 프로젝트/사용자 `agent` 설정으로 선택합니다. `/agents`와 `@` typeahead에서는 plugin subagent가 `best-copilot:senior-project-expert` 같은 scoped 이름으로 표시되므로, 수동 `@` mention이나 Agent-tool dispatch에는 표시 이름을 사용하세요.

로컬 수정 또는 플러그인 업데이트 후에는 Claude Code 안에서 `/reload-plugins`를 실행하거나 세션을 재시작하세요.

## 사용 방법

요구사항 오케스트레이션은 **Senior Project Expert** PM 코디네이터에서 시작합니다. 이 역할은 의도, 범위, 계획, 디스패치, 리뷰 fan-in, 리플렉션, Memory 동기화, 정책 델타 라우팅, 종료를 담당합니다.

- **Copilot CLI**: `/agent`를 실행하고 **Senior Project Expert**를 선택한 뒤 작업을 설명합니다. Copilot은 `handoffs:` 선언을 사용하여 전문가를 라우팅합니다.
- **VS Code 확장**: 채팅 에이전트를 **Senior Project Expert**로 수동 전환한 뒤 작업을 시작합니다.
- **Claude Code**: PM이 메인 세션으로서 **Agent tool**을 통해 전문가 서브에이전트를 호출합니다.
- **Codex**: `@best-copilot`을 호출한 뒤 workflow 실행을 요청합니다. 이 checkout에서는 `.agents/skills`가 호환 진입점 `$senior-project-expert`도 일반 `$` skill selector에 노출합니다. 병렬 작업이 필요하면 Codex에 subagent spawn을 명시적으로 요청해야 하며, 플러그인 설치만으로 subagent가 자동 spawn되지는 않습니다.

### Claude Code 시작 방법

```bash
# 방법 1: PM agent 명시적 지정 (권장)
claude --agent senior-project-expert
# Claude가 agent 이름 충돌을 보고하면:
# claude --agent best-copilot:senior-project-expert

# 방법 2: .claude/settings.json에 기본 agent 설정 (매번 지정할 필요 없음)
# 대상 저장소의 .claude/settings.json에 추가:
# { "agent": "senior-project-expert", "worktree": { "baseRef": "head" } }

# 방법 3: 로컬 플러그인 개발
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert
```

### Claude Code 다중 에이전트 작동 방식

PM(`senior-project-expert`)이 메인 세션으로서 사용자 요구사항을 수신한 후:

1. `/best-copilot:repo-init-gate`로 초기화 프리체크 실행
2. 의도 분석, 작업 분류(micro/standard/full), 디스패치 패키지 고정
3. `/agents`에 표시되는 scoped 이름으로 **Agent tool** 전문가 서브에이전트 생성 (예: `best-copilot:technical-architect`, `best-copilot:developer`)
4. 권한이 사전 허용되어 있고 독립 조사/읽기 전용 review일 때만 background 실행을 선택
5. 구현, 수정, spec/memory 쓰기, 권한 확인이 필요할 수 있는 검증은 기본적으로 foreground 실행
6. 충돌 가능한 구현은 `isolation: "worktree"`로 격리하고 worktree 경로, 브랜치, 변경 파일, 검증 증거를 회수
7. isolated worktree 변경은 `/best-copilot:development-branch-closeout` 또는 동등한 keep / merge / PR / discard 결정을 거친 뒤에만 반영 완료로 주장
8. PM이 모든 서브에이전트 결과를 `OBSERVER_FAN_IN`으로 수집한 뒤 `EVALUATOR_ARBITRATION` 수행
9. `REFLECTOR_SIGNAL`을 기록하고 `MEMORY_STATE_SYNC`를 실행하며, 수용되고 검증된 학습에만 `POLICY_DELTA_OR_NONE` 적용
10. `/best-copilot:verification-before-completion` 호출 후 사용자에게 전달

Claude Code에서 plugin subagent는 scoped 형식으로 표시됩니다: `best-copilot:technical-architect`, `best-copilot:developer`, `best-copilot:frontend-designer`, `best-copilot:quality-assurance-expert`, `best-copilot:security-reviewer`, `best-copilot:specification-writer`, `best-copilot:root-cause-fixer`.

Claude 어댑터는 `claude-agents/*.md`에서 Claude 모델 alias를 사용합니다. GPT-5.4에 대응하는 역할은 `opus`, Gemini에 대응하는 역할은 `haiku`, Claude Sonnet 역할은 `sonnet`을 사용합니다. 네이티브 Claude Code에서는 이 alias가 Copilot 쪽 역할 등급을 Claude 모델군 안에 보존합니다. `cc-switch`, `new-api` 또는 다른 Anthropic-compatible proxy가 이 alias를 DeepSeek, Qwen 또는 다른 비 Claude backend로 라우팅하는 경우, 먼저 해당 라우팅된 세션에서 plugin이 활성화되었는지 확인하세요. `/plugin list`에는 `best-copilot@best-copilot`이 보여야 하고, `/agents`에는 `best-copilot:senior-project-expert` 같은 scoped agent가 보여야 하며, proxy allowlist가 필요한 경우 `"enabledPlugins": {"best-copilot@best-copilot": true}`가 포함되어야 합니다. 그 다음 PM이 source reading이나 implementation 전에 `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> PLANNER_FREEZE_PACKET -> LANE_SELECTION -> EXECUTOR_LANES`를 출력하고 필요한 specialist lanes 및 `repo-init-gate` / `repo-init-scan` 흐름에 진입할 때까지 degraded로 취급하세요.

## 런타임 어댑터 아키텍처

### 3계층 격리 원칙

```
                    ┌─────────────────────────────────┐
                    │   공유 계약 계층 (Shared Contract) │
                    │   core-workflow-contract         │
                    │   + 역할별 role-*-workflow        │
                    └──────────────┬──────────────────┘
                                   │
                  ┌────────────────┴────────────────┐
                  │                                  │
        ┌─────────▼──────────┐          ┌────────────▼─────────┐
        │ Copilot CLI 어댑터  │          │ Claude Code 어댑터     │
        │                    │          │                       │
        │  agents/*.agent.md │          │  claude-agents/*.md   │
        │  model: GPT-5.4 등 │          │  model: opus/haiku/...│
        │  handoffs: 선언    │          │  Agent tool 디스패치   │
        │  vscode_askQ...    │          │  AskUserQuestion      │
        │                    │          │                       │
        │  skills/ 직접 읽기  │          │  claude-plugin/       │
        │                    │          │    agents -> symlink  │
        │                    │          │    skills -> symlink  │
        └────────────────────┘          └───────────────────────┘
```

공통 cross-role 규칙은 [skills/core-workflow-contract/SKILL.md](skills/core-workflow-contract/SKILL.md)에 둡니다. 각 역할의 workflow는 `skills/*-workflow/`에 따로 둡니다: `senior-project-expert-workflow`, `specification-writer-workflow`, `technical-architect-workflow`, `developer-workflow`, `frontend-designer-workflow`, `quality-assurance-workflow`, `security-reviewer-workflow`, `root-cause-fixer-workflow`. Copilot 전용 내용은 [agents/](agents/)에 둡니다: 모델명, Copilot 도구, `user-invocable`, `agents`, `handoffs`. Claude 전용 내용은 [claude-agents/](claude-agents/)의 대응 파일에 둡니다: Claude Code에 표시되는 agent 이름, Claude 모델 alias(`opus`, `sonnet`, `haiku`), 읽기 전용 제한, `isolation: worktree`, PM이 소유하는 foreground/background dispatch 정책.

이 구조는 공통 동작, 역할별 동작, 호환되지 않는 runtime metadata를 분리하며, 모든 agent가 공통 contract와 자신의 역할 workflow를 함께 로드하도록 합니다.

### 스킬 로딩 규칙

| 시나리오 | 동작 |
|---------|------|
| Claude PM 메인 세션 | PM의 `skills:` frontmatter 선언적 프리로딩 |
| Claude 서브에이전트 (PM spawn) | 서브에이전트는 자신의 `skills:` frontmatter에서 로드; PM은 spawn prompt에 작업 컨텍스트와 필요한 스킬을 포함해야 함 |
| Claude 기본 세션 | agent의 `skills:` 미활성화, 수동 호출 필요 |
| Copilot CLI | 본문 참조는 기계적 프리로딩이 아님, 패킷에 최소 체크리스트 포함 필요 |

Claude agent frontmatter는 일반적으로 `core-workflow-contract`와 해당 역할 workflow만 미리 로드합니다. Senior Project Expert는 추가로 `repo-init-gate`만 미리 로드하며, `repo-init-scan`은 sentinel gate가 실패할 때만 필요에 따라 로드됩니다. `structured-review`, `test-driven-development`, `web-experience-audit` 같은 다른 focused skills는 agent 본문에서 필요할 때만 호출하도록 두어 시작 컨텍스트를 줄입니다.

### 듀얼 런타임 비교

| 차원 | Copilot CLI | Claude Code |
|------|-------------|-------------|
| 진입 agent | `agents/pm-coordinator.agent.md` | `claude-agents/senior-project-expert.md` (`--agent` 또는 `.claude/settings.json` 통해) |
| 모델 지정 | `GPT-5.4 (copilot)` 등 구체적 이름 | `model: opus` / `haiku` / `sonnet` 역할 등급 alias |
| 전문가 분배 | `handoffs:` 선언 + `agent` tool | PM 메인 세션이 **Agent tool**으로 spawn |
| 병렬 실행 | handoff 선언이 자동 처리 | PM이 안전한 독립 조사/읽기 전용 review에만 background 선택 |
| 파일 격리 | Copilot 내장 | `isolation: "worktree"` + PM closeout |
| 사용자 상호작용 | `vscode_askQuestions` / `Asking user` | 내장 `AskUserQuestion` |
| 스킬 발견 | 루트 `skills/`에서 직접 읽기 | `claude-plugin/skills -> ../skills` 심볼릭 링크 |
| Agent 발견 | 루트 `agents/`에서 직접 읽기 | `claude-plugin/agents -> ../claude-agents` 심볼릭 링크 |
| 크로스 모델 라우팅 | 지원 (GPT / Gemini / Claude 혼합) | Claude 모델 등급 alias만 |

Copilot handoff는 fail-closed입니다: 각 PM handoff prompt는 `core-workflow-contract`와 대상 역할 workflow skill을 요구합니다. 런타임이 해당 skill을 로드할 수 없으면 최소 역할 checklist fallback을 포함하며, 둘 다 없으면 specialist는 `NEEDS_CONTEXT missing_required_skill`을 반환합니다.

## 빠른 확인

```text
/agent
/skills list
```

예상 패키지 구조:

```text
best-copilot
├── plugin.json
├── .claude-plugin/
│   └── marketplace.json
├── claude-plugin/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── .mcp.json
│   ├── agents/ -> runtime-named symlinks to ../claude-agents
│   └── skills -> ../skills
├── marketplace.json
├── agents/
│   ├── pm-coordinator.agent.md
│   ├── tech-architect.agent.md
│   ├── developer.agent.md
│   ├── frontend-designer.agent.md
│   ├── risk-qa.agent.md
│   ├── security-agent.agent.md
│   ├── auto-fixer.agent.md
│   └── spec-writer.agent.md
├── claude-agents/
│   ├── senior-project-expert.md
│   ├── technical-architect.md
│   ├── developer.md
│   ├── frontend-designer.md
│   ├── quality-assurance-expert.md
│   ├── security-reviewer.md
│   ├── root-cause-fixer.md
│   └── specification-writer.md
├── skills/
└── .github/
    ├── instructions/
    └── plugin/
```

## 핵심 워크플로

모든 작업은 트랜스크립트에서 각 단계를 확인할 수 있는 관찰 가능한 단계 체인을 거칩니다:

```
INIT_GATE → [필요시 INIT_SCAN] → CLASSIFY → PLANNER_FREEZE_PACKET
  → [전체/모호/고위험시 ARCHITECT_SDD] → LANE_SELECTION
  → EXECUTOR_LANES → OBSERVER_FAN_IN → EVALUATOR_ARBITRATION
  → REFLECTOR_SIGNAL → MEMORY_STATE_SYNC → POLICY_DELTA_OR_NONE → NEXT_GATE
```

### 행동 신뢰성 게이트

`PLANNER_FREEZE_PACKET`과 실행 단계는 다음 제약을 유지합니다:

- 가정, 트레이드오프, 가장 단순한 실행 가능안을 명시합니다. 불확실성이 구현, 라우팅, 수용 기준을 바꾸면 추측하지 말고 질문합니다.
- 성공 기준을 만족하는 최소 변경을 선택합니다. 투기적 기능이나 일회성 코드의 추상화를 추가하지 않습니다.
- 수술적 변경: 모든 변경 줄은 사용자 목표, 수용 검증, 또는 검증 수리에 추적 가능해야 합니다. 인접 코드, 주석, 포맷을 덤으로 정리하지 않습니다.
- 쓰기 전에 읽기: 코드 변경 전 대상 파일의 public surface/exports, 직접 caller/callee, 명확한 공유 유틸리티나 로컬 패턴을 읽습니다.
- 성공 기준, 제약, 검증, 중지 조건으로 실행을 구동합니다. 의존성, 안전, 검증상 필요한 경우에만 절차를 지정합니다. 다단계 작업은 중요한 단계마다 checkpoint를 남깁니다.

### 단계 1: Init 게이트 (필수 프리체크)

대상 저장소에서 실질적인 작업을 하기 전, 시스템은 먼저 `repo-init-gate`를 실행합니다 — 대상 저장소 루트의 `best-copilot.md`만 읽어서 frontmatter의 `version`이 현재 계약 버전 `"0.7.1"`과 일치하는지 확인합니다.

```
repo-init-gate
  │
  ├── 버전 일치 → ready → 건너뛰고 다음 단계로
  │
  └── 누락/불일치/무효 → needs_init
                           │
                           ▼
                    repo-init-scan
                      │
                      ├── Stage 1: repo-init-official
                      │     copilot init 또는 Claude native /init helper 실행
                      │     출력 → project.instructions.md
                      │
                      └── Stage 2: repo-init-manual-fallback
                            수동 스캔 → 스캐폴드 생성
                            target-instructions-bootstrap
                            target-memory-bootstrap
                            target-spec-bootstrap
                            │
                            └── best-copilot.md sentinel 기록
```

이것은 **Fail-Closed** 설계입니다: init이 완료되기 전에는 기획, 구현, 검토가 허용되지 않습니다. 추측에 기반한 계속 대신 `BLOCKED`를 반환합니다. `repo-init-scan`이 `next_task_ready: yes`를 보고해야만 후속 단계로 진입할 수 있습니다.

### 단계 2: 작업 분류

시스템은 각 작업을 세 등급으로 분류합니다:

| 등급 | 적용 시나리오 | 프로세스 무게 |
|------|-------------|-------------|
| `micro` | 미세 편집/확인, 공개 계약·보안·크로스 모듈 위험 없음 | 직접 실행 |
| `standard` | 경계 있는 파일 세트, 단일 소유자 표면 | 간소화된 패킷, 집중 리뷰 |
| `full` | 모호, 크로스 모듈, 공개 API/schema/auth/의존성/CI/프론트엔드 경험 | 전체 기획, SDD 설계 리뷰, fan-in 게이트 |

`task_type`은 크기와 독립적으로 동작을 추적합니다: `implementation`(쓰기/업데이트), `design_review`(구현 없이 평가), `verification`(위험 리뷰/병합 준비), `fix`(경계 있는 수정), `spec`(요구사항/설계/작업, 프로덕션 코드 미작성).

### 단계 3: Planner 컨텍스트 고정 (6블록 디스패치 패키지)

PM은 의도를 표준 **6블록 디스패치 패키지**(PM Dispatch Packet)로 고정합니다. 이는 크로스 역할 통신의 통합 프로토콜입니다:

```markdown
1. task_intent     — 목표, 사용자 경로, 의도 요약, 예상 결과, task_type, work_mode
2. frozen_scope    — 범위, 비목표, 관련 파일, 변경 파일, 우선순위/읽은 파일, 의존성
3. fact_packet     — 권위 있는 저장소 사실, 출처 참조, 참조 파일
4. execution_contract — 가정, 트레이드오프, 가장 단순한 안, 제약, 수용 검증, 검증/컨텍스트 예산, 중지 조건, 금지 방법, 쓰기 전 읽기 대상
5. review_state    — 후속 범위, 검증된 항목, 리뷰 레인, 준비된 산출물
6. output_contract — 필요한 스킬, 역할 체크리스트 대체, 필요한 산출물, 다음 단계
```

**왜 패키지를 사용하나요?** 각 전문가는 전체 대화 기록이 아닌 고정된 경계 있는 컨텍스트를 받기 때문입니다. 이는 "한 에이전트의 추측이 다른 에이전트의 사실이 되는" 것을 방지하면서, 모든 디스패치가 추적 가능하고 감사 가능하도록 보장합니다.

### 단계 4: SDD 설계 게이트

`full`, 모호, 고위험, 공개 계약, auth/보안, 의존성, schema 또는 프론트엔드 경험 작업의 경우, 구현 전에 반드시 **Technical Architect 주도의 SDD(Spec-Driven Design) 설계 브레인스토밍**을 거쳐야 합니다:

1. PM이 설계 작업을 Technical Architect에게 디스패치
2. Technical Architect가 SDD 설계 브레인스토밍 및 자체 리뷰/수정 수행
3. PM이 Developer + QA에게 2차 설계 리뷰 디스패치
4. 프론트엔드 UI가 관련되면 Frontend Designer 참여
5. 블로킹 발견 사항은 Technical Architect에게 수정 요청, PM은 영향받은 리뷰 레인만 재실행
6. 리뷰를 통과한 설계만 구현으로 진행 가능

`standard` 작업의 경우 ARCHITECT_SDD를 건너뛰고 효율성을 위해 이유를 기록합니다 — 경계 있고 모호하지 않은 표준 작업에 아키텍처 SDD를 강제하지 않습니다.

### 단계 5: 병렬 디스패치 및 실행

설계 리뷰 통과 후, PM은 `writing-plans`를 통해 작업을 병렬화 가능한 작업으로 분해합니다:

- 독립적인 파일 소유권과 쓰기 세트 (겹치지 않음)
- 명확한 의존성 관계와 수용 검증
- 지정된 소유자 레인과 리뷰 레인

디�스패치 실행은 `subagent-driven-development` 또는 `executing-plans`를 통해 진행됩니다:

```
각 준비된 작업에 대해:
  1. 새로운 컨텍스트 패킷 구성 (context-packet-fastpath)
  2. 해당 전문가에게 구현 디스패치
     - Technical Architect: 풀스택 아키텍처/메인라인 슬라이스
     - Developer: 경계 있는 슬라이스
     - Frontend Designer: UI 소유 슬라이스
     - Root Cause Fixer: 확인된 실패
  3. 구현 증거 요청: 변경된 파일, 쓰기 전 읽기 증거, 실행한 테스트/검사, 핵심 출력, 위험
  4. Stage 1 리뷰: 스펙/작업 준수 (요구사항, 비목표, 파일 경계, 수용 검증)
  5. Stage 2 리뷰: 코드 품질 및 릴리스 위험 (유지보수성, 결합도, 보안/성능 위험, 데드 코드, 테스트 충분성)
  6. 발견 사항이 수정 사이클에 진입 확인
  7. 모든 필수 리뷰와 검증 통과 후에만 PM이 작업 완료 표시 가능
```

**핵심 규칙: Stage 1과 Stage 2의 리뷰어는 구현자 본인이 될 수 없습니다.** 리뷰 레인은 교차 리뷰 규칙을 따릅니다 (아래 참조).

### 단계 6: Observer Fan-In 및 Evaluator 중재

PM은 먼저 모든 specialist handback을 관찰 가능한 증거로 기록한 뒤 우선순위에 따라 결과를 재판합니다:

1. **블로커**: `BLOCKED`, `NEEDS_USER_INPUT`, 무효한 handback, 반복된 `NEEDS_CONTEXT`
2. **보안**: 보안, 프라이버시, 데이터 손실, auth, 의존성, 릴리스, 파괴적 동작 위험
3. **검증**: 실패/누락된 검증, 증명되지 않은 완료 선언
4. **범위**: 스펙 불일치, 범위 확장, 쓰기 세트 겹침
5. **품질**: 코드 품질, 유지보수성, 성능, UX, 접근성, 테스트 충분성
6. **논블로킹**: 후속 참고사항

리뷰어 의견이 불일치할 때, PM은 `decision_provenance`를 기록합니다 (증거, 블로킹 상태, 다음 단계, 잔여 위험). 미해결 충돌은 fan-out이나 closeout을 허용하지 않습니다.

### 교차 리뷰 규칙

| 리뷰 대상 코드 | 리뷰어 |
|---------------|--------|
| Developer 코드 | Technical Architect |
| Technical Architect 코드 | Developer |
| Developer/Technical Architect 프론트엔드 코드 | Frontend Designer |
| Frontend Designer 코드 | Technical Architect |
| 모든 코드 (최종) | QA (병합 준비) |
| 보안 민감 표면 | Security Reviewer (필수) |

### 단계 7: 리플렉션, Memory 동기화, 정책 델타, 검증 및 수렴

종료 전, PM은 자가 진화의 꼬리 루프를 완료해야 합니다:

- `REFLECTOR_SIGNAL`: 검증된 재사용 가능한 교훈을 추출하거나 `evolution_signal: none` 기록
- `MEMORY_STATE_SYNC`: 진행, 검증, 종료, 진화 상태가 바뀔 때 task/spec/memory 상태 동기화
- `POLICY_DELTA_OR_NONE`: 수용되고 검증되며 롤백 가능한 교훈에 대해서만 라우팅, prompt, 템플릿, 도구 우선순위, workflow 규칙 업데이트

그 다음 시스템은 `verification-before-completion` 최종 검사를 실행합니다:

- 요구사항/사용자 요청 충족
- 변경 파일이 작업 범위 내에 경계
- 플레이스홀더, 데드 참조, 오래된 이름, 깨진 링크 없음
- 테스트/빌드/브라우저 검사/정적 검증 실행 완료 (또는 명시적 스킵 보고)
- 잔여 위험과 다음 단계가 명확
- Native Ask UI를 사용한 최종 확인/계속 (일반 텍스트 요약이 아닌)

### 소규모 작업의 간소화 경로

`micro` 수준의 작업은 위 흐름이 간소화됩니다 — 직접 실행, SDD 설계·병렬 디스패치·다단계 리뷰 건너뛰기. 그러나 가장 작은 변경이라도 완료 표시 전 `verification-before-completion` 검사가 필요합니다.

## 에이전트 팀

| Agent | 담당 | 담당하지 않음 |
| --- | --- | --- |
| Senior Project Expert | 의도, 범위, 오케스트레이션, dispatch, fan-in, 수렴, 진화 신호 | 직접 프로덕션 코드 작성 |
| Specification Writer | 증거 수집, requirements, design, tasks, ADR, memory/spec 복구 | 프로덕션 구현 |
| Technical Architect | 풀스택 설계, SDD brainstorming, API/데이터/서비스 경계, 주 구현, 병렬 분해, Developer/Frontend Designer 코드 리뷰 | 최종 프론트엔드 polish, 작업 오케스트레이션 |
| Developer | 고정된 구현 슬라이스, 구현 가능성 리뷰, 아키텍처 담당 코드에 대한 피어 리뷰 | 아키텍처 변경/범위 확장 |
| Frontend Designer | 페이지, 컴포넌트, 상호작용, 반응형, 브라우저 증거, 프론트엔드 리뷰 | 백엔드 메인라인 |
| Quality Assurance Expert | 기능 검증, 회귀 위험, 코드 리뷰, peer lane 이후 병합 준비 | 보안 리뷰 및 수정 |
| Security Reviewer | 권한, 민감 데이터 흐름, 의존성, 릴리스 표면 보안 | 일반 기능 QA |
| Root Cause Fixer | 실패 분류, 최소 패치, 회귀 검증 | 근거 없는 리팩터링 |

## 전문가 통신 프로토콜

### 전문가 질문 경계 (Specialist Ask Boundary)

모든 specialist(PM이 아닌 역할)는 **사용자에게 직접 질문할 수 없습니다**. 이것은 경성 제약입니다:

```
전문가가 정보 필요
  │
  ├── 컨텍스트 부족 → PM에게 NEEDS_CONTEXT 반환
  │                    clarification_request + pm_action: "pm_clarify" 포함
  │
  └── 사용자 입력 필요 → PM에게 NEEDS_USER_INPUT 반환
                          question, why_blocking, options,
                          safe_default, resume_prompt_for_pm 포함
```

PM/코디네이터만 Native Ask 메커니즘(Copilot: `vscode_askQuestions` / `Asking user`; Claude: `AskUserQuestion`)을 사용하여 사용자에게 질문할 수 있습니다.

### Native Ask 계약

- 최상위 세션 또는 PM/코디네이터만 원본 질문 사용 가능
- 각 질문은 자유 형식 답변 허용 필수 (고정 선택 UI는 "Custom answer" 포함)
- Native Ask UI를 사용할 수 있을 때 일반 텍스트 요약으로 turn 종료 불가
- UI를 사용할 수 없고 사용자 선택이 필요한 경우 → `BLOCKED missing_native_ask_ui` 보고

### 전문가 반환 구조 (Structured Handback)

각 specialist는 표준화된 구조적 결과를 반환합니다:

```markdown
- task_id:                작업 식별자
- current_stage:          현재 단계
- status:                 DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT |
                          NEEDS_USER_INPUT | BLOCKED
- summary:                완료 요약
- artifacts:              산출물 (파일, 테스트, 증거)
- risks:                  위험
- uncovered_items:        미처리 항목
- recommended_next_stage: 권장 다음 단계
```

## Memory와 Spec 시스템

### 듀얼 트랙 영속성

`best-copilot`은 대상 저장소에 두 가지 영속성 시스템을 유지합니다:

```
대상 저장소
├── spec/                          ← 스펙: 요구사항/설계/작업의 권위 출처
│   ├── INDEX.md                   ← 스펙 라우팅 테이블
│   └── templates/                 ← 재사용 가능한 템플릿
│
├── memories/repo/                 ← 메모리: 복구 인덱스
│   ├── INDEX.md                   ← 메모리 라우팅 테이블
│   ├── current-workstreams.md     ← 현재 활성 작업
│   ├── project-state.md           ← 프로젝트 상태 스냅샷
│   ├── decisions.md               ← 의사결정 기록
│   └── workflow-rules.md          ← 메모리/스펙/evolution 조정 규칙
│
├── .github/instructions/          ← 저장소 수준 규칙
│   ├── project.instructions.md    ← 프로젝트 사실 (build/test/프레임워크/진입점)
│   ├── must.instructions.md       ← 핵심 규칙
│   └── skills-index.instructions.md ← 스킬 라우팅
│
└── best-copilot.md               ← Init sentinel (version: "0.7.1")
```

### Spec vs Memory 분업

| 차원 | Spec | Memory |
|------|------|--------|
| 권위성 | 요구사항/설계/작업의 **권위 출처** | **복구 인덱스** — 현재 초점, 의사결정, 마지막 검증, 다음 동작 |
| 내용 | 요구사항 문서, 설계 문서, 작업 목록, 수용 검증 | 워크플로 상태, 검증된 의사결정, 복구 프롬프트, 압축된 사실 |
| 포함하지 않음 | 로그 저장 안 함, 상태 저장 안 함 | 요구사항 스펙 저장 안 함, 설계 문서 저장 안 함 |
| 조정 규칙 | — | 메모리는 현재 저장소 파일, 명령 출력, 시스템 지시 또는 명시적 사용자 지시를 절대 덮어쓰지 않음 |

### 점진적 정보 공개

메모리는 **INDEX.md 라우팅 + 온디맨드 로딩**을 사용하여 토큰 예산을 관리합니다:

```
1. INDEX.md 읽기 (라우팅 테이블)
2. 활성 작업 복구 시 current-workstreams.md 읽기
3. linked_spec 및 linked_memory 따라가기
4. 선택된 메모리 파일의 관련 섹션만 로딩
5. 소스 추적이 필요할 때만 archive/logs로 폴백
```

각 메모리 파일에는 `load_tier` 태그가 있습니다: `task-active`(활성 작업 시 로딩), `task-reference`(참조 시 온디맨드 로딩), `archive-reference`(추적 시에만 로딩).

### MEDIUM/LARGE 작업의 양방향 링크

중대형 작업은 스펙과 메모리 사이에 양방향 링크를 설정합니다:

- `current-workstreams.md`의 각 워크플로는 해당 스펙을 가리키는 `linked_spec`을 가짐
- `spec/INDEX.md`의 각 스펙은 관련 메모리를 역참조 가능
- EvolutionEvent 기록에는 signal, target, mutation, validation, rollback, seven_module_trace, ten_pass_review, status 모든 필드 필요

## 스킬 맵

| Area | Skills |
| --- | --- |
| Compatibility | `senior-project-expert` |
| Role Workflows | `senior-project-expert-workflow`, `specification-writer-workflow`, `technical-architect-workflow`, `developer-workflow`, `frontend-designer-workflow`, `quality-assurance-workflow`, `security-reviewer-workflow`, `root-cause-fixer-workflow` |
| Bootstrap | `repo-init-gate`, `repo-init-scan`, `repo-init-official`, `repo-init-manual-fallback`, `target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap` |
| Planning | `brainstorming`, `writing-plans`, `context-packet-fastpath`, `search-fastpath`, `spec-execution-fastpath` |
| Execution | `workspace-isolation`, `test-driven-development`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents` |
| Coding Standards | `td-java-coding-guidelines`, `td-python-coding-guidelines` |
| Review | `structured-review`, `spec-review-gauntlet`, `root-cause-investigation`, `systematic-debugging` |
| Verification | `change-verification`, `verification-before-completion`, `development-branch-closeout`, `web-experience-audit`, `frontend-design-guardrails` |
| Evolution | `evolution-loop` |

## 초기 사용

초기화는 **자동으로** 수행됩니다 — 수동으로 `/init`이나 `copilot init`을 실행할 필요가 없습니다. PM agent가 시작되면 [핵심 워크플로 Stage 1](#단계-1-init-게이트-필수-프리체크)이 먼저 `repo-init-gate`를 실행하고, `best-copilot.md` sentinel이 최신이면 `repo-init-scan`을 건너뜁니다. sentinel이 없거나, 유효하지 않거나, 읽을 수 없거나, 오래된 경우에만 scan 경로로 들어가 target instructions, memory, spec scaffold와 sentinel을 생성합니다.

Claude Code에서 바로 PM을 시작하세요:

```bash
claude --agent senior-project-expert
```

초기화 흐름은 대상 저장소에 다음 로컬 파일을 생성합니다:

```text
.github/instructions/project.instructions.md    ← 프로젝트 사실 (build/test/프레임워크/진입점)
.github/instructions/must.instructions.md       ← 핵심 규칙
.github/instructions/skills-index.instructions.md ← 스킬 라우팅
CLAUDE.md                                        ← Claude Code 호환 (선택)
memories/repo/INDEX.md                           ← 복구 인덱스 라우팅 테이블
memories/repo/current-workstreams.md             ← 현재 활성 작업
spec/INDEX.md                                    ← 스펙 라우팅 테이블
spec/templates/                                  ← 재사용 가능한 템플릿
best-copilot.md                                  ← Init sentinel (version: "0.7.1")
```

필요한 사실이나 스캐폴드를 생성할 수 없는 경우, 추측에 기반한 계속 대신 `BLOCKED first_use_gate_incomplete`로 중지합니다 — 전체 설명은 [핵심 워크플로 Stage 1](#단계-1-init-게이트-필수-프리체크)을 참조하세요.

## 모델 전략

각 에이전트는 `agents/*.agent.md`에서 모델을 선언합니다. 라우팅 정책은 역할의 추론 특성에 맞추어 결정됩니다:

| Agent | Model |
| --- | --- |
| Senior Project Expert | GPT-5.4 |
| Technical Architect | GPT-5.4 |
| Specification Writer | Gemini 3.1 Pro (Preview) |
| Developer | Gemini 3.1 Pro (Preview) |
| Frontend Designer | Gemini 3.1 Pro (Preview) |
| Quality Assurance Expert | Claude Sonnet 4.6 |
| Security Reviewer | Gemini 3.1 Pro (Preview) |
| Root Cause Fixer | Claude Sonnet 4.6 |

네이티브 Claude Code는 Claude 모델 alias를 사용합니다. `claude-agents/*.md`의 Claude 어댑터는 역할 분리를 유지하고 Copilot 등급을 Claude alias로 대응합니다: GPT-5.4 -> `opus`, Gemini 3.1 Pro (Preview) -> `haiku`, Claude Sonnet 4.6 -> `sonnet`. `cc-switch`나 `new-api` 같은 proxy route는 이 alias를 비 Claude 모델에 매핑할 수 있습니다. 이는 API 호환일 뿐 workflow 호환을 의미하지 않습니다. DeepSeek, Qwen 또는 unknown backend에서는 먼저 plugin 활성화를 확인하세요. `/plugin list`에는 `best-copilot@best-copilot`이 있어야 하고, `/agents`에는 scoped plugin agents가 보여야 하며, `cc-switch` / `new-api` allowlist에는 필요한 경우 `"enabledPlugins": {"best-copilot@best-copilot": true}`가 있어야 합니다. 그 다음 실제 작업 전에 비파괴 workflow smoke check를 실행하세요. 기대 동작은 PM이 `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> PLANNER_FREEZE_PACKET -> LANE_SELECTION -> EXECUTOR_LANES`를 출력한 뒤 요청에 필요한 lanes를 dispatch하는 것입니다. 종료 전에는 `OBSERVER_FAN_IN -> EVALUATOR_ARBITRATION -> REFLECTOR_SIGNAL -> MEMORY_STATE_SYNC -> POLICY_DELTA_OR_NONE -> NEXT_GATE`까지 진행해야 합니다. plugin이 활성화되어 있는데도 coding을 시작하거나 init/lanes를 건너뛰거나 꼬리 게이트 없이 종료하면 smoke check를 통과하는 model/provider를 사용하세요.

## 검색 규율

시스템은 토큰 소비를 제어하고 정확도를 높이기 위해 정보 검색 시 엄격한 우선순위를 따릅니다:

```
명시적 사용자 경로 → 변경된 파일 → 고정된 files_involved → 저장소 인덱스
  → 파일명/glob → 고정 문자열 rg -F → 정규표현식 (최후 수단)
```

- 클래스 이름, 메서드, 라우트, 설정 키에는 `rg -F` 고정 문자열 검색 우선
- 정규식은 정말 모호하거나 정확한 검색이 실패한 경우에만 사용하고, 이유 기록
- 저장소 전체 정규식 회피; 최소 디렉터리로 제한; 두 번의 검색에서 새 신호가 없으면 중지
- 동시성/생소한 패턴/인프라 설계 전, 런타임/프레임워크 내장 기능 먼저 검색 (전투 검증됨 → 최근 유행 → 제1원리)

## 합리화 방지 검사

"완료"를 선언하기 전, 시스템은 다음의 일반적인 자기 기만 패턴을 자동 검사합니다:

| 변명 | 반박 |
|------|------|
| "나중에 테스트 추가할게" | 테스트는 작업의 일부이지 후속 작업이 아님 |
| "내 머신에서는 돌아가" | 검증 명령과 출력을 보여줘 |
| "작은 변경이야" | 작은 변경이라도 경계 있는 검증 증거가 필요해 |
| "스펙에서 괜찮다고 해" | 구체적인 스펙 라인을 인용해, 요약하지 마 |

## 보안 제약

- 지시, 메모리, 스펙, 작업 로그에 키, 토큰, 자격 증명, PII, 원시 긴 로그, 내부 호스트 또는 민감한 경로 저장 금지
- 공개 API, 스키마, auth, 의존성, CI/CD, 릴리스 표면은 폭발 반경 평가 필요
- 새로운 동작과 버그 수정은 실질적으로 가능한 경우 테스트나 최소 재현 검증을 추가

## 검증 명령 예시

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read(".codex-plugin/plugin.json")); JSON.parse(File.read("claude-plugin/.claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); JSON.parse(File.read(".claude/settings.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); JSON.parse(File.read(".agents/plugins/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find claude-agents -maxdepth 1 -name '*.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin plugin details best-copilot
git diff --check
```

Claude inventory에는 `Agents (8)`, `Skills (39)`, `Hooks (0)`이 표시되어야 합니다. `/agents` Library와 `@` typeahead에서 plugin agents는 `best-copilot:senior-project-expert`, `best-copilot:technical-architect`, `best-copilot:developer`, `best-copilot:frontend-designer`, `best-copilot:quality-assurance-expert`, `best-copilot:security-reviewer`, `best-copilot:root-cause-fixer`, `best-copilot:specification-writer` 같은 scoped 형식으로 표시됩니다.

## 자가 진화 메커니즘 (Evolution Loop)

`best-copilot`은 정적 도구가 아닙니다 — 실행 과정에서 자기 개선이 가능합니다. 그러나 진화는 자유로운 재작성이 아니라 **경계 있고, 감사 가능하며, 롤백 가능한 폐쇄 루프**입니다.

### 진화 신호 출처

시스템은 다음 시나리오에서 진화 신호를 생성합니다:

| 신호 유형 | 예시 | 강도 |
|----------|------|------|
| 반복 실패 | 특정 skill의 트리거 조건이 항상 오탐 또는 미탐 | 강 |
| 리뷰 패턴 | 리뷰에서 동일한 코드 품질 문제가 반복 출현 | 중강 |
| 사용자 수정 | 사용자가 agent의 오류 동작을 수정 | 중 |
| 오래된 트리거 | 특정 skill의 description이 실제 사용과 불일치 | 중 |
| 워크플로 마찰 | 프로세스에서 반복적으로 나타나는 블로킹 포인트 또는 중복 단계 | 약-중 |

### 진화 폐쇄 루프

```
Planner → 개선 목표, 대상, 검증, 롤백 고정
Executor → 최소 승인 변경 실행 또는 제안 반환
Observer → 구체적 신호와 재현 가능한 증거 캡처
Evaluator → 심각도, 반복성, 신뢰도, 영향 범위 판단
Reflector → 근본 원인, 교훈, 향후 행동, 반패턴 추출
Memory → canonical owner에 accepted/rejected/deferred event 기록
Policy → 검증 후에만 경계 있는 workflow 규칙 업데이트
```

각 수용된 진화는 EvolutionEvent로 기록됩니다:

```markdown
## EvolutionEvent: 2025-05-27-topic
- signal:    ← 출처 (구체적 증거)
- target:    ← 변경 대상 (최소 목표)
- mutation:  ← 변경 방법 (경계 있는 변경)
- validation: ← 검증 방법 (검사 방법)
- rollback:  ← 롤백 방법 (복구 계획)
- seven_module_trace: ← Planner/Executor/Observer/Evaluator/Reflector/Memory/Policy 증거
- ten_pass_review: ← source priority, 분리, 범위, capability loss 없음, 증거, memory hygiene, 가역성, runtime compatibility, verification fit, future reuse
- status: proposed | accepted | rejected | deprecated
```

### 4단계 진화 전략

| 전략 | 적용 시나리오 | 위험 | 전형적 변경 |
|------|-------------|------|-----------|
| `repair-only` | 깨진 트리거/라우팅/허위 선언 수정 | 최저 | skill description의 트리거 단어 수정 |
| `harden` | 모호성 감소, 안전장치 추가, 검증 개선 | 낮음 | 수용 검증에 누락된 경계 조건 추가 |
| `balanced` | 소규모 개선, 현재 워크플로 유지 | 중간 | 패킷 필드 구성 최적화 |
| `innovate` | 기존 스킬로 커버 불가능한 반복 요구 | 최고 | 새로운 focused 스킬 추가 |

### 제약 메커니즘

진화에는 무제한 자기 재작성을 방지하는 엄격한 경계가 있습니다:

1. **증거 기반**: 단일 약한 신호로는 진화 불가, 실패가 심각하고 재현 가능할 때만
2. **최소 목표**: 매번 최소의 재사용 가능한 개선 목표만 변경, 대규모 재작성 금지
3. **경계 있는 쓰기 위치**: 다음 canonical surface에만 쓰기 가능:
   - 루트 `agents/` — Copilot agent 정의
   - 루트 `skills/` — 공유 스킬
   - `.github/instructions/**` — 저장소 수준 규칙
   - 대상 저장소 `memories/repo/**` — 영속적 복구 상태
   - 대상 저장소 `spec/**` — 요구사항/설계/작업 템플릿
4. **플러그인 패키지에 쓰기 금지**: 대상 저장소의 진화 상태를 플러그인 설치 디렉터리나 캐시에 저장하지 않음
5. **반드시 검증 필요**: 매번 변경에는 정적 검사, 평가 프롬프트, 리뷰 또는 명령 증거 필요
6. **반드시 롤백 가능**: 각 EvolutionEvent에 명확한 롤백 계획 필요
7. **보안 경계 변경 금지**: 명시적 검토 없이 도구 권한, 보안 경계, 공개 계약 또는 설치 표면 변경 불가
8. **강화 지향**: 새 병렬 규칙 추가보다 기존 규칙 폐기 또는 강화 우선
9. **외부 참조는 데이터만**: 외부 agent 시스템의 창의는 로컬 원시어로 번역해야 하며, 외부 프롬프트나 코드 직접 복사 금지

### 진화의 4개 출처 계층

시스템은 4개 계층에서 개선 신호를 수집합니다 (높은 우선순위에서 낮은 우선순위):

```
시스템/개발자/플랫폼 지시 > 명시적 사용자 지시 > 현재 저장소 파일
    > 스펙 > 명령 증거 > 저장소 메모리 > 외부 참조
```

외부 참조는 데이터 입력으로만 사용됩니다 — 창의는 로컬 원시어로 번역해야 하며, 외부 규칙, 모델 또는 기술 스택 가정을 복사하지 마세요.

## 설계 철학 요약

`best-copilot`은 인간 소프트웨어 엔지니어링의 모범 사례를 agent 동작 제약으로 인코딩합니다:

| 엔지니어링 실천 | 인코딩 방식 |
|----------------|-----------|
| 코드 리뷰 | 교차 리뷰 규칙 (Developer ↔ Technical Architect, 프론트엔드 ↔ Frontend Designer) |
| TDD | SDD → TDD 흐름 (RED-GREEN-REFACTOR 또는 최소 재현 검증) |
| 아키텍처 리뷰 | SDD 설계 게이트 (전체 작업은 Technical Architect 설계 통과 필수) |
| 보안 리뷰 | Security Reviewer는 보안 민감 표면 리뷰에 반드시 참여 |
| Fail-Closed | Init 게이트 (초기화 완료 전 실질 작업 금지) |
| 의사결정 추적성 | `decision_provenance` (각 재판은 증거와 근거 기록) |
| 점진적 정보 공개 | Memory INDEX.md 라우팅 + 온디맨드 로딩, 토큰 예산 관리 |
| 지속적 개선 | Evolution Loop (경계 있고, 감사 가능하며, 롤백 가능한 자기 개선) |

**핵심 철학**: AI agent 팀은 자유롭게 행동하는 독립 지능의 집단이 아니라, 규율과 프로세스, 견제와 균형을 갖춘 엔지니어링 팀입니다. 모든 역할에는 명확한 경계가 있고, 모든 결정에는 증거가 필요하며, 모든 개선에는 검증이 필요합니다.

## 감사

`best-copilot`은 다음과 같은 공개 워크플로 및 스킬 시스템 아이디어에서 학습합니다:

- [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)
- [Superpowers](https://github.com/obra/superpowers)
- [gstack](https://github.com/garrytan/gstack)
- [spec-kit](https://github.com/github/spec-kit)
- [Open Design](https://github.com/nexu-io/open-design)
- [UI UX Pro Max Skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [claude-mem](https://github.com/thedotmack/claude-mem)
- [fetch-skill](https://github.com/aresbit/fetch-skill/)
- [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills)
- [Evolver](https://github.com/EvoMap/evolver)
