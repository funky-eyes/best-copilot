# best-copilot

[English](README.md) | [简体中文](README.zh-CN.md) | 한국어 | [日本語](README.ja.md)

`best-copilot`은 설치 가능하고 재사용 가능하며 지속적으로 개선할 수 있는 AI agent 팀 템플릿입니다. GitHub Copilot CLI 플러그인을 우선 대상으로 설계되었고, `.github/**`를 Copilot 커스터마이징의 단일 진실 공급원으로 유지하며, `AGENTS.md`와 `.codex/**`를 통해 Codex도 같은 팀 규칙을 재사용할 수 있습니다.

핵심 아이디어는 간단합니다. 큰 엔지니어링 작업은 먼저 **Senior Project Expert**가 의도, 범위, 단계, 종료 조건을 정리하고, 필요에 따라 아키텍처, 명세, 구현, 프론트엔드, QA, 보안, 수정, 진화 단계로 넘깁니다.

## 설치

이 저장소를 Copilot CLI 플러그인 marketplace로 등록합니다.

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

등록된 marketplace에서 플러그인을 설치합니다.

```bash
copilot plugin install best-copilot@best-copilot
```

Copilot CLI에서는 저장소, URL, 로컬 경로에서 직접 플러그인을 설치하는 방식이 deprecated 상태입니다. 일반 설치에는 위 marketplace 흐름을 사용하세요. 로컬 개발 시에도 로컬 checkout을 marketplace로 등록합니다.

```bash
copilot plugin marketplace add /absolute/path/to/best-copilot
copilot plugin install best-copilot@best-copilot
```

설치 확인:

```text
/agent
/skills list
```

## 첫 사용

새 저장소에서 의미 있는 작업을 시작하기 전에 Copilot이 저장소를 학습하도록 합니다.

```text
/init
```

또는:

```bash
copilot init
```

`/init`은 Copilot CLI의 공식 초기화 흐름입니다. 저장소를 스캔하고 `.github/copilot-instructions.md`를 작성하거나 갱신합니다. `repo-init-scan` skill은 이를 첫 사용 게이트로 취급합니다. 저장소 정보가 아직 placeholder라면 먼저 초기화한 뒤 실제 작업을 시작합니다.

## 언어 정책

모든 agent는 먼저 사용자의 주요 언어를 식별해야 합니다. 사용자는 한 언어로 문제를 설명하고, 다른 언어의 로그, 스택 트레이스, 코드, API 응답을 붙여 넣을 수 있습니다. 주요 언어는 붙여 넣은 증거가 아니라 실제 요청이나 설명에 사용된 언어입니다.

명시적인 요청이 없으면 감지된 주요 언어로 답변합니다.

## 팀 진입점

큰 작업은 **Senior Project Expert**로 시작합니다. 이 역할은 직접 프로덕션 코드를 작성하지 않고 조율을 담당합니다.

- 사용자의 의도와 성공 기준을 이해합니다.
- `/init`, spec, 계획, design review, 병렬 작업이 필요한지 판단합니다.
- 범위, non-goals, acceptance checks, verification budget을 고정합니다.
- 적절한 specialist에게 라우팅하고 fan-out / fan-in 결과를 종합합니다.
- 종료 시 spec, memory, 검증 증거, 다음 재개 지점을 업데이트합니다.

## Agent 역할

| Agent | 담당 | 담당하지 않음 |
| --- | --- | --- |
| Senior Project Expert | 의도, 범위, 오케스트레이션, 병렬 dispatch, fan-in, closeout, evolution signals | 직접 프로덕션 구현 |
| Specification Writer | 증거, requirements/design/tasks, ADR, 진행 기록, memory/spec recovery | 프로덕션 구현 |
| Technical Architect | 백엔드/풀스택 설계와 메인 구현, API/데이터/서비스 경계 | 프론트엔드 세부 polish, 작은 병렬 slice |
| Developer | 고정된 구현 slice, 집중 테스트, 최소 검증 | 아키텍처 변경 또는 범위 확장 |
| Frontend Designer | 페이지, 컴포넌트, 상호작용, 반응형, 브라우저 동작, 시각 검증 | 백엔드 메인라인 |
| Quality Assurance Expert | 기능 검증, 회귀 위험, 코드 리뷰, merge readiness | 보안 리뷰와 수정 |
| Security Reviewer | 권한, 민감 데이터 흐름, 의존성 위험, release-surface 보안 | 일반 기능 QA |
| Root Cause Fixer | 실패 분석, 최소 패치, 회귀 검증 | 근거 없는 리팩터링 |

## 모델 전략

이 역할들은 같은 범용 agent에 이름만 바꾼 것이 아닙니다. 각 agent는 `.github/agents/*.agent.md` frontmatter에서 명시적인 모델을 선언하며, 모델 선택은 역할에 필요한 추론 특성에 맞춰져 있습니다.

| Agent | 모델 | 추론 특성 |
| --- | --- | --- |
| Senior Project Expert | GPT-5.4 | 장기 오케스트레이션, 범위 제어, fan-out/fan-in 판단, closeout 판단 |
| Technical Architect | GPT-5.4 | 깊은 백엔드/풀스택 추론, 공개 계약 설계, 데이터/API 경계 분석, 메인 구현 전략 |
| Specification Writer | Gemini 3.1 Pro (Preview) | 넓은 컨텍스트 종합, 구조화된 requirements/design/tasks, ADR, recovery records |
| Developer | Gemini 3.1 Pro (Preview) | 고정된 slice의 집중 구현, 빠른 코드 컨텍스트 정렬, 테스트, 제한된 검증 |
| Frontend Designer | Gemini 3.1 Pro (Preview) | UI/상태/컨텍스트 종합, Ant Design식 엔터프라이즈 패턴, 능동적인 디자인 시스템 추론, 반응형 동작, 상호작용 품질, 브라우저 증거 계획 |
| Quality Assurance Expert | Claude Sonnet 4.6 | 저소음 리뷰, 회귀 추론, 테스트 충분성 판단, merge-readiness 판단 |
| Security Reviewer | Gemini 3.1 Pro (Preview) | release surface 분석, 권한 경계, 민감 데이터 흐름, 의존성과 설정 리뷰 |
| Root Cause Fixer | Claude Sonnet 4.6 | 실패 분류, 가설 제거, 최소 패치 선택, 회귀 증명 |

라우팅 정책 자체가 제품의 일부입니다. 오케스트레이션과 아키텍처에는 깊은 계획에 맞는 모델을 사용하고, 구현과 명세에는 넓은 컨텍스트 실행 모델을 사용하며, QA/수정 역할에는 간결한 리뷰/디버깅 모델을 사용해 결론을 구체적이고 실행 가능하게 유지합니다.

## 큰 작업 흐름

1. **Init**: 저장소 정보가 없으면 `/init` 또는 `copilot init`을 실행합니다.
2. **Discover**: 목표, 범위, 위험, acceptance checks를 고정합니다.
3. **Plan**: spec을 갱신하고 `writing-plans`로 실행 가능한 slice를 만듭니다.
4. **Design Review**: 영향 면에 따라 아키텍처, QA, 보안, 프론트엔드 리뷰를 수행합니다.
5. **Implement**: Technical Architect가 메인라인을 맡고, Developer가 독립 slice를 맡고, Frontend Designer가 UI를 맡습니다.
6. **Verify**: QA가 최소 충분 검증을 수행하고, 프론트엔드는 브라우저 증거를 제공합니다.
7. **Secure**: release surface, dependency, permission, sensitive data flow가 있으면 보안 리뷰를 수행합니다.
8. **Fix Loop**: 확인된 실패는 Root Cause Fixer가 최소 수정하고 재검증합니다.
9. **Close**: 변경, 증거, 위험, 재개 지점을 요약합니다.
10. **Evolve**: 반복 실패, 오래된 trigger, review loop, 재사용 가능한 학습을 EvolutionEvent로 기록합니다.

## 자기 진화

`best-copilot`은 agent가 임의로 자신을 다시 쓰도록 허용하지 않습니다. 진화는 증거 기반이며 되돌릴 수 있어야 합니다.

1. **Read**: 작업 결과, 실패 명령, review finding, 사용자 수정, memory, spec drift를 읽습니다.
2. **Select**: 가장 작은 개선 대상(agent, skill, instruction, prompt, memory, README, spec template)을 선택합니다.
3. **Propose**: 증거, 범위, 검증, rollback을 포함한 Evolution Proposal을 만듭니다.
4. **Validate**: frontmatter/schema, trigger eval, static check, review, command evidence로 검증합니다.
5. **Write**: 승인된 학습만 `.github/**`, `memories/repo/**`, `spec/**`에 기록합니다.

승인된 개선은 `EvolutionEvent`: `signal -> target -> mutation -> validation -> rollback -> status` 형식으로 기록합니다.

## 강점

- Copilot-first이며 `copilot plugin marketplace add`로 marketplace를 추가한 뒤 `copilot plugin install best-copilot@best-copilot`로 설치할 수 있습니다.
- Codex-compatible: `.codex` adapter가 같은 `.github` 진실 공급원을 재사용합니다.
- `/init` 후 실행하여 새 저장소에서 추측을 줄입니다.
- 큰 작업은 Senior PM이 단계적으로 조율합니다.
- RAG-lite memory로 전체 히스토리를 불러오지 않고도 맥락을 복구합니다.
- spec은 요구사항과 acceptance를, memory는 recovery와 검증된 사실을 담당합니다.
- 기본 skills는 고빈도 엔지니어링 능력 위주로 유지합니다.
- 완료 주장은 명령, 정적 검사, 브라우저 증거 또는 명확한 blocker가 필요합니다.
- 검증된 workflow 학습은 되돌릴 수 있는 EvolutionEvent가 됩니다.

## 감사와 참고

이 프로젝트는 다음 공개 프로젝트의 아이디어와 설계에서 많은 영감을 받았습니다.

- [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)
- [Superpowers](https://github.com/obra/superpowers)
- [gstack](https://github.com/garrytan/gstack)
- [UI UX Pro Max Skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [Open Design](https://github.com/nexu-io/open-design)
- [claude-mem](https://github.com/thedotmack/claude-mem)
- [fetch-skill](https://github.com/aresbit/fetch-skill/)
- [Anthropic skill-creator](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator)
- [Anthropic code-simplifier](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-simplifier)
- [Anthropic code-review](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review)
- [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills)
- [Evolver](https://github.com/EvoMap/evolver)
