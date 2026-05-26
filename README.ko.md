# best-copilot

[English](README.md) | [简体中文](README.zh-CN.md) | 한국어 | [日本語](README.ja.md)

[![version](https://img.shields.io/badge/version-0.5.0-1d9bf0)](plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-f97316)](claude-plugin/.claude-plugin/plugin.json)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-38-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot`은(는) Copilot CLI와 Claude Code에서 사용할 수 있는 설치형 에이전트 팀 템플릿입니다. 이 프로젝트는 저장소에 다음과 같은 시니어급 전달 흐름을 제공합니다: 사실 초기화, 범위 고정, 설계 후 구현, 전문 역할을 통한 구현, 독립적 검토, 증거 기반 검증, 그리고 다음 세션을 위한 복구 지점 보존.

Copilot CLI는 `plugin.json`을 통해 루트 `agents/`와 `skills/`를 사용합니다. Claude Code는 `claude-plugin/` 패키지를 사용합니다: `claude-plugin/.claude-plugin/plugin.json`, `claude-plugin/skills -> ../skills`, `claude-plugin/agents -> ../claude-agents`. 저장소 수준 규칙은 `.github/instructions/**`에 보관됩니다.

## 존재 이유

모호한 요청에서 곧바로 패치로 넘어가면 대형 AI 코딩 작업은 실패하기 쉽습니다. `best-copilot`은 이러한 결여된 전달 규율을 보완합니다:

- **하나의 시니어 진입점**: Senior Project Expert는 의도, 범위, 디스패치, fan-in, 수렴, 재사용 가능한 워크플로 신호를 담당합니다.
- **여덟 개의 전문 에이전트**: 기획, 아키텍처, 구현, 프론트엔드, QA, 보안, 근본 원인 수정, 명세 작업 등이 각각 책임을 가집니다.
- **서른다섯 개의 스킬**: 역할 workflow, 부트스트랩, 검색, 기획, workspace isolation, TDD, 설계 검토, 실행, Java/Python 코딩 가이드라인, 검증, branch closeout, 프런트엔드 감사 및 워크플로 진화를 포함합니다.
- **대상 저장소 로컬의 메모리/스펙**: 설치된 프로젝트는 사실, 워크스트림, 메모리 및 스펙을 플러그인 패키지가 아닌 대상 저장소에 보관합니다.
- **증거 우선의 종료**: ‘완료’ 선언은 명령 출력, 정적 검사, 브라우저 증거 또는 명확한 차단자 중 하나가 있어야 합니다.

## 설치

### Copilot CLI

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

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

로컬 수정 후에는 새 CLI 세션에서 테스트하기 전에 플러그인을 재설치 또는 업데이트하세요.

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

Claude Code agent team을 사용하려면 시작 전에 agent teams를 활성화하세요. Agent teams는 Claude Code의 실험 기능이며 Claude Code v2.1.32 이상이 필요합니다:

```bash
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin
```

Claude Code는 다음을 발견합니다:

- marketplace 메타데이터: [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)
- 플러그인 메타데이터: [claude-plugin/.claude-plugin/plugin.json](claude-plugin/.claude-plugin/plugin.json)
- 공유 스킬: [skills/](skills/), 호출 형식은 `/best-copilot:<skill-name>`
- Claude 호환 subagent: [claude-agents/](claude-agents/)
- 기본 메인 agent: [settings.json](settings.json)의 `best-copilot:senior-project-expert`

로컬 수정 또는 플러그인 업데이트 후에는 Claude Code 안에서 `/reload-plugins`를 실행하거나 세션을 재시작하세요.

## 사용 방법

요구사항 오케스트레이션은 [agents/pm-coordinator.agent.md](agents/pm-coordinator.agent.md)의 코디네이터 에이전트에서 시작해야 합니다. 이 에이전트는 UI에서 **Senior Project Expert**로 표시되며 의도, 범위, 계획, 디스패치, 리뷰 fan-in, 종료를 담당합니다.

- **Copilot CLI**: `/agent`를 실행하고 **Senior Project Expert**를 선택한 뒤 작업을 설명합니다.
- **VS Code 확장**: 채팅 에이전트를 **Senior Project Expert**로 수동 전환한 뒤 작업을 시작합니다.
- **Claude Code**: `claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin`으로 시작합니다. 플러그인의 기본 agent는 `best-copilot:senior-project-expert`입니다. `/agents`로 플러그인 agent를 확인하고 `/best-copilot:<skill-name>`로 스킬을 직접 호출할 수 있습니다.

Claude Code multi-agent 프롬프트 예시:

```text
Create an agent team for this task. Use best-copilot:senior-project-expert as the lead.
Spawn teammates using best-copilot:technical-architect, best-copilot:developer,
best-copilot:quality-assurance-expert, and best-copilot:security-reviewer
where their scopes apply. Keep write sets non-overlapping,
prevent self-review, and report command evidence before closeout.
For each teammate, invoke /best-copilot:core-workflow-contract plus its
matching role workflow skill, or include the minimal role checklist fallback.
```

Claude Code는 plugin agents, skills, agent teams를 통해 Copilot 스타일의 multi-agent 워크플로를 구현할 수 있습니다. 다만 Copilot의 여러 모델 제공자 간 라우팅은 복제하지 않습니다. Claude 어댑터는 `model: inherit`을 사용하므로 실제 모델은 Claude Code 세션의 `/model`, `--model`, 또는 사용자 설정이 결정합니다.

## 런타임 어댑터 아키텍처

공통 cross-role 규칙은 [skills/core-workflow-contract/SKILL.md](skills/core-workflow-contract/SKILL.md)에 둡니다. 각 역할의 workflow는 `skills/*-workflow/`에 따로 둡니다: `senior-project-expert-workflow`, `specification-writer-workflow`, `technical-architect-workflow`, `developer-workflow`, `frontend-designer-workflow`, `quality-assurance-workflow`, `security-reviewer-workflow`, `root-cause-fixer-workflow`. Copilot 전용 내용은 [agents/](agents/)에 둡니다: 모델명, Copilot 도구, `user-invocable`, `agents`, `handoffs`. Claude 전용 내용은 [claude-agents/](claude-agents/)의 대응 파일에 둡니다: scoped plugin agent 이름, `model: inherit`, 읽기 전용 제한, agent-team 모드에서 `skills` frontmatter가 teammate에 자동 적용되지 않는 제한.

이 구조는 공통 동작, 역할별 동작, 호환되지 않는 runtime metadata를 분리하며, 모든 agent가 공통 contract와 자신의 역할 workflow를 함께 로드하도록 합니다.

Claude agent frontmatter는 `core-workflow-contract`와 해당 역할 workflow만 미리 로드합니다. `structured-review`, `test-driven-development`, `web-experience-audit` 같은 focused skills는 agent 본문에서 필요할 때만 호출하도록 두어 시작 컨텍스트를 줄입니다.

Copilot handoff는 fail-closed입니다. 각 PM handoff prompt는 `core-workflow-contract`와 대상 역할 workflow skill을 요구합니다. 런타임이 해당 skill을 로드할 수 없으면 최소 역할 checklist fallback을 포함하며, 둘 다 없으면 specialist는 `NEEDS_CONTEXT missing_required_skill`을 반환합니다.

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

## 워크플로

```text
User request
  -> init or repo fact check
  -> Senior Project Expert freezes scope
  -> Technical Architect SDD brainstorming for large ambiguous work
  -> Developer + QA design review, plus Frontend Designer when UI is involved
  -> parallel-ready requirements / design / tasks when risk is non-trivial
  -> SDD-reviewed, TDD-oriented specialist implementation
  -> cross-author review
  -> QA / security / frontend verification
  -> closeout with evidence and resume point
```

작은 범위 변경은 경량화된 흐름을 유지하지만, 교차 모듈 작업이나 공개 계약, 의존성, 권한 또는 애매한 제품 방향이 포함될 경우 더 엄격한 게이트가 필요합니다.

## 에이전트 팀

| Agent | 담당 | 담당하지 않음 |
| --- | --- | --- |
| Senior Project Expert | 의도, 범위, 오케스트레이션, dispatch, fan-in, 수렴, 진화 신호 | 직접 프로덕션 코드 작성 |
| Specification Writer | 증거 수집, requirements/design/tasks, ADR, 진행 기록, memory/spec 복구 | 프로덕션 구현 |
| Technical Architect | 풀스택 설계, SDD brainstorming, API/데이터/서비스 경계, 주 구현, 병렬 분해, Developer/Frontend Designer 작업 리뷰 | 최종 프론트엔드 polish, 작업 오케스트레이션 |
| Developer | 고정된 구현 슬라이스, 구현 가능성 리뷰, 아키텍처 책임 코드 리뷰 | 아키텍처 변경/범위 확장 |
| Frontend Designer | 페이지, 컴포넌트, 상호작용, 반응형, 브라우저 증거, 프론트엔드 리뷰 | 백엔드 메인라인 |
| Quality Assurance Expert | 기능 검증, 회귀 위험, 코드 리뷰, peer lane 이후 병합 준비 | 보안 전용 검토 |
| Security Reviewer | 권한, 민감 데이터 흐름, 의존성 및 릴리스 표면 보안 | 일반 기능 QA |
| Root Cause Fixer | 실패 분류, 최소 패치, 회귀 검증 | 근거 없는 리팩터링 |

## 스킬 맵

| Area | Skills |
| --- | --- |
| Role Workflows | `senior-project-expert-workflow`, `specification-writer-workflow`, `technical-architect-workflow`, `developer-workflow`, `frontend-designer-workflow`, `quality-assurance-workflow`, `security-reviewer-workflow`, `root-cause-fixer-workflow` |
| Bootstrap | `repo-init-gate`, `repo-init-scan`, `repo-init-official`, `repo-init-manual-fallback`, `target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap` |
| Planning | `brainstorming`, `writing-plans`, `context-packet-fastpath`, `search-fastpath`, `spec-execution-fastpath` |
| Execution | `workspace-isolation`, `test-driven-development`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents` |
| Coding Standards | `td-java-coding-guidelines`, `td-python-coding-guidelines` |
| Review | `structured-review`, `spec-review-gauntlet`, `root-cause-investigation`, `systematic-debugging` |
| Verification | `change-verification`, `verification-before-completion`, `development-branch-closeout`, `web-experience-audit`, `frontend-design-guardrails` |
| Evolution | `evolution-loop` |

## 초기 사용

새 저장소에서 의미 있는 작업을 시작하기 전에 현재 런타임이 프로젝트를 먼저 검사하게 하세요.

```text
/init
```

Copilot CLI에서는 shell 명령도 사용할 수 있습니다:

```bash
copilot init
```

그 다음 **Senior Project Expert** / `best-copilot:senior-project-expert`로부터 실질 작업을 시작하세요. 이 역할은 저장소 사실을 표준화하고 누락된 로컬 스캐폴드를 생성하며, 계속 진행하기 전에 해당 파일들이 존재하는지 검증합니다.

Claude Code 호환이 필요한 대상 저장소에는 공유 `.github/instructions/**` 규칙을 가져오는 `CLAUDE.md` 어댑터도 생성합니다.

## 모델 전략

각 에이전트는 `agents/*.agent.md`에서 모델을 선언합니다. 라우팅 정책은 역할의 추론 특성에 맞추어 결정됩니다.

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

Claude Code는 Claude 모델만 실행합니다. `claude-agents/*.md`의 Claude 어댑터는 역할 분리를 유지하고 `model: inherit`을 사용하므로 실제 모델은 현재 Claude Code 세션이 제어합니다.

## 검증 명령 예시

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read("claude-plugin/.claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find claude-agents -maxdepth 1 -name '*.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
git diff --check
```

## 진화 규칙

`best-copilot`은 agent가 스스로를 임의로 다시 쓰지 않도록 합니다. 진화는 증거 기반이어야 하며 되돌릴 수 있어야 합니다.

## 감사

아이디어와 설계 영감을 얻은 공개 프로젝트들:

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
