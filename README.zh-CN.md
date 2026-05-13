# best-copilot

[English](README.md) | 简体中文 | [한국어](README.ko.md) | [日本語](README.ja.md)

`best-copilot` 是一套可安装、可复用、可持续进化的 AI agent 团队模板。它优先面向 GitHub Copilot CLI 插件，同时保留 `.github/**` 作为 Copilot 定制的单一真源，并通过 `AGENTS.md` 与 `.codex/**` 让 Codex 复用同一套团队契约。

核心思路：大型工程任务先由 **Senior Project Expert** 统一理解、拆解和收口，再按需要进入架构、规格、实现、前端、QA、安全、修复和演进阶段。

## 安装

从 GitHub 仓库安装：

```bash
copilot plugin install funky-eyes/best-copilot
```

从仓库子目录安装：

```bash
copilot plugin install funky-eyes/best-copilot:path/to/best-copilot
```

如果当前 Copilot CLI 支持本地插件源，也可以从本地目录安装；否则使用 GitHub 仓库或 Git URL：

```bash
copilot plugin install /absolute/path/to/best-copilot
```

安装后检查：

```text
/agent
/skills list
```

## 第一次使用

新仓库第一次执行有意义任务前，先让 Copilot 学习仓库：

```text
/init
```

或执行：

```bash
copilot init
```

`/init` 是 Copilot CLI 官方初始化流程，会扫描仓库并写入或更新 `.github/copilot-instructions.md`。`repo-init-scan` skill 会把它作为首次使用门禁：仓库事实仍是占位符时，先初始化，再进入真实任务。

## 语言策略

每个 agent 必须先识别用户输入的主要语言。混合输入很常见：用户可能用一种语言描述问题，同时贴上另一种语言的日志、堆栈、代码或 API 响应。主要语言取决于用户实际提问或解释所用语言，而不是粘贴证据里的 incidental language。

默认用识别出的主要语言回复，除非用户明确指定其他语言。

## 团队入口

大型任务先找 **Senior Project Expert**。它不直接写生产代码，负责：

- 理解用户意图和成功标准。
- 判断是否需要 `/init`、spec、计划、设计审查或并行拆分。
- 冻结范围、非目标、验收标准和验证预算。
- 路由到合适 specialist，并综合 fan-out / fan-in 结果。
- 收口时更新 spec、memory、验证证据和下一步恢复入口。

## Agent 分工

| Agent | 负责 | 不负责 |
| --- | --- | --- |
| Senior Project Expert | 意图、范围、编排、并行派发、fan-in、收口、演进信号 | 直接写生产代码 |
| Specification Writer | 证据、requirements/design/tasks、ADR、进度记录、memory/spec 恢复 | 生产实现 |
| Technical Architect | 后端/全栈设计与主线实现、API/数据/服务边界 | 前端细节、小切片 |
| Developer | 已冻结实现切片、聚焦测试、最小验证 | 架构变更或扩范围 |
| Frontend Designer | 页面、组件、交互、响应式、浏览器行为、视觉验证 | 后端主线 |
| Quality Assurance Expert | 功能验证、回归风险、代码审查、可合并性 | 安全专项和修复 |
| Security Reviewer | 权限、敏感数据流、依赖风险、发布面安全 | 普通功能 QA |
| Root Cause Fixer | 失败分析、最小补丁、回归验证 | 无证据重构 |

## 大型任务流程

1. **Init**：缺仓库事实时运行 `/init` 或 `copilot init`。
2. **Discover**：冻结目标、范围、风险和验收标准。
3. **Plan**：更新 spec，并用 `writing-plans` 拆成可执行切片。
4. **Design Review**：按影响面进行架构、QA、安全、前端审查。
5. **Implement**：主线交给 Technical Architect，独立切片交给 Developer，前端交给 Frontend Designer。
6. **Verify**：QA 做最小充分验证；前端补浏览器证据。
7. **Secure**：存在发布面、依赖、权限或敏感数据流时做安全审查。
8. **Fix Loop**：确认失败后由 Root Cause Fixer 最小修复并复测。
9. **Close**：总结改动、证据、风险和恢复入口。
10. **Evolve**：重复失败、老化触发词、review 回环或可复用经验变成 EvolutionEvent。

## 自进化能力

`best-copilot` 不允许 agent 随意重写自己。演进必须基于证据且可回滚：

1. **Read**：读取任务结果、失败命令、review finding、用户纠正、memory 和 spec drift。
2. **Select**：选择最小改进目标：agent、skill、instruction、prompt、memory、README 或 spec template。
3. **Propose**：生成带证据、范围、验证和回滚的 Evolution Proposal。
4. **Validate**：通过 frontmatter/schema、触发词 eval、静态检查、review 或命令证据验证。
5. **Write**：只把已接受的经验写回 `.github/**`、`memories/repo/**` 或 `spec/**`。

接受的改进记录为 `EvolutionEvent`: `signal -> target -> mutation -> validation -> rollback -> status`。

## 项目优点

- Copilot-first，可通过 `copilot plugin install` 安装。
- Codex-compatible，通过 `.codex` adapter 复用 `.github` 真源。
- 先 `/init` 再执行，减少新仓库盲猜。
- 大型任务由 Senior PM 编排，分阶段审查、实现、验证和收口。
- RAG-lite memory：用 Markdown index 和 current workstream 恢复上下文。
- Spec-memory 联动：spec 管需求和验收，memory 管恢复和验证事实。
- 精简默认 skills，只保留高频工程能力。
- Evidence-first：完成结论必须有命令、静态检查、浏览器证据或明确阻塞。
- 可审计进化：已验证经验沉淀为可回滚 EvolutionEvent。

## 致谢与参考

感谢这些项目带来的公开思想和设计启发：

- [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)
- [Superpowers](https://github.com/obra/superpowers)
- [gstack](https://github.com/garrytan/gstack)
- [UI UX Pro Max Skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [claude-mem](https://github.com/thedotmack/claude-mem)
- [fetch-skill](https://github.com/aresbit/fetch-skill/)
- [Anthropic skill-creator](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator)
- [Anthropic code-simplifier](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-simplifier)
- [Anthropic code-review](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review)
- [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills)
- [Evolver](https://github.com/EvoMap/evolver)
