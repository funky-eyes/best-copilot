# best-copilot

[English](README.md) | [简体中文](README.zh-CN.md) | 한국어 | [日本語](README.ja.md)

[![version](https://img.shields.io/badge/version-0.3.0-1d9bf0)](plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-25-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot`은(는) 심도 있는 엔지니어링 작업을 위한 설치 가능한 Copilot CLI 에이전트 팀 템플릿입니다. 이 프로젝트는 저장소에 다음과 같은 시니어급 전달 흐름을 제공합니다: 사실 초기화, 범위 고정, 설계 후 구현, 전문 역할을 통한 구현, 독립적 검토, 증거 기반 검증, 그리고 다음 세션을 위한 복구 지점 보존.

Copilot CLI 우선 설계입니다. 루트의 `agents/`와 `skills/`는 `plugin.json`을 통해 노출되며, 저장소 수준 규칙은 `.github/instructions/**`에 보관됩니다.

## 존재 이유

모호한 요청에서 곧바로 패치로 넘어가면 대형 AI 코딩 작업은 실패하기 쉽습니다. `best-copilot`은 이러한 결여된 전달 규율을 보완합니다:

- **하나의 시니어 진입점**: Senior Project Expert는 의도, 범위, 디스패치, fan-in, 수렴, 재사용 가능한 워크플로 신호를 담당합니다.
- **여덟 개의 전문 에이전트**: 기획, 아키텍처, 구현, 프론트엔드, QA, 보안, 근본 원인 수정, 명세 작업 등이 각각 책임을 가집니다.
- **스물다섯 개의 스킬**: 부트스트랩, 검색, 기획, TDD, 설계 검토, 실행, Java/Python 코딩 가이드라인, 검증, 프런트엔드 감사 및 워크플로 진화를 포함합니다.
- **대상 저장소 로컬의 메모리/스펙**: 설치된 프로젝트는 사실, 워크스트림, 메모리 및 스펙을 플러그인 패키지가 아닌 대상 저장소에 보관합니다.
- **증거 우선의 종료**: ‘완료’ 선언은 명령 출력, 정적 검사, 브라우저 증거 또는 명확한 차단자 중 하나가 있어야 합니다.

## 설치

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

## 사용 방법

요구사항 오케스트레이션은 [agents/pm-coordinator.agent.md](agents/pm-coordinator.agent.md)의 코디네이터 에이전트에서 시작해야 합니다. 이 에이전트는 UI에서 **Senior Project Expert**로 표시되며 의도, 범위, 계획, 디스패치, 리뷰 fan-in, 종료를 담당합니다.

- **Copilot CLI**: `/agents`를 실행하고 **Senior Project Expert**를 선택한 뒤 작업을 설명합니다.
- **VS Code 확장**: 채팅 에이전트를 **Senior Project Expert**로 수동 전환한 뒤 작업을 시작합니다.

## 빠른 확인

```text
/agents
/skills list
```

예상 패키지 구조:

```text
best-copilot
├── plugin.json
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
  -> brainstorming or direct planning
  -> requirements / design / tasks when risk is non-trivial
  -> design review before implementation
  -> specialist implementation
  -> cross review
  -> QA / security / frontend verification
  -> closeout with evidence and resume point
```

작은 범위 변경은 경량화된 흐름을 유지하지만, 교차 모듈 작업이나 공개 계약, 의존성, 권한 또는 애매한 제품 방향이 포함될 경우 더 엄격한 게이트가 필요합니다.

## 에이전트 팀

| Agent | 담당 | 담당하지 않음 |
| --- | --- | --- |
| Senior Project Expert | 의도, 범위, 오케스트레이션, dispatch, fan-in, 수렴, 진화 신호 | 직접 프로덕션 코드 작성 |
| Specification Writer | 증거 수집, requirements/design/tasks, ADR, 진행 기록, memory/spec 복구 | 프로덕션 구현 |
| Technical Architect | 백엔드/풀스택 설계, API/데이터/서비스 경계, 주 구현 및 아키텍처 리뷰 | 프론트엔드 세부사항 |
| Developer | 고정된 구현 슬라이스, 구현 가능성 리뷰, 아키텍처 책임 코드 리뷰 | 아키텍처 변경/범위 확장 |
| Frontend Designer | 페이지, 컴포넌트, 상호작용, 반응형, 브라우저 증거 | 백엔드 메인라인 |
| Quality Assurance Expert | 기능 검증, 회귀 위험, 코드 리뷰, 병합 준비 | 보안 전용 검토 |
| Security Reviewer | 권한, 민감 데이터 흐름, 의존성 및 릴리스 표면 보안 | 일반 기능 QA |
| Root Cause Fixer | 실패 분류, 최소 패치, 회귀 검증 | 근거 없는 리팩터링 |

## 스킬 맵

| Area | Skills |
| --- | --- |
| Bootstrap | `repo-init-scan`, `target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap` |
| Planning | `brainstorming`, `writing-plans`, `context-packet-fastpath`, `search-fastpath`, `spec-execution-fastpath` |
| Execution | `test-driven-development`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents` |
| Coding Standards | `td-java-coding-guidelines`, `td-python-coding-guidelines` |
| Review | `structured-review`, `spec-review-gauntlet`, `root-cause-investigation`, `systematic-debugging` |
| Verification | `change-verification`, `verification-before-completion`, `web-experience-audit`, `frontend-design-guardrails` |
| Evolution | `evolution-loop` |

## 초기 사용

새 저장소에서 의미 있는 작업을 시작하기 전에 `/init` 또는 `copilot init`으로 리포지토리 사실을 수집하세요.

```text
/init
```

또는:

```bash
copilot init
```

그 다음 **Senior Project Expert**로부터 실질 작업을 시작하세요. 이 역할은 저장소 사실을 표준화하고 누락된 로컬 스캐폴드를 생성하며, 계속 진행하기 전에 해당 파일들이 존재하는지 검증합니다.

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

## 검증 명령 예시

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
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
