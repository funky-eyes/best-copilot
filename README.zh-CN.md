# best-copilot

[English](README.md) | 简体中文 | [한국어](README.ko.md) | [日本語](README.ja.md)

`best-copilot` 是一套可安装、可复用、可持续进化的 AI agent 团队模板。它优先面向 GitHub Copilot CLI 插件，同时保留 `.github/**` 作为 Copilot 定制的单一真源，并通过 `AGENTS.md` 与 `.codex/**` 让 Codex 复用同一套团队契约。

核心思路：大型工程任务先由 **Senior Project Expert** 统一理解、拆解和收口，再按需要进入架构、规格、实现、前端、QA、安全、修复和演进阶段。

## 安装

先把这个仓库注册为 Copilot CLI 插件 marketplace：

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

再从已注册的 marketplace 安装插件：

```bash
copilot plugin install best-copilot@best-copilot
```

Copilot CLI 已经弃用从仓库、URL 或本地路径直接安装插件的方式。正常安装请使用上面的 marketplace 流程。本地开发时，也应该把本地 checkout 注册成 marketplace：

```bash
copilot plugin marketplace add /absolute/path/to/best-copilot
copilot plugin install best-copilot@best-copilot
```

安装后检查：

```text
/agent
/skills list
```

安装到目标仓库后，plugin 提供自己的 agents 和 skills；目标仓库自己的项目事实仍来自目标仓库本地文件。作为 Codex 模板使用时，Codex 会读取 `AGENTS.md`，并通过 `.codex/instructions`、`.codex/prompts`、`.codex/skills` 这些符号链接回到 `.github`。

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

插件安装本身没有可靠的首次运行 hook，不能保证在任何 agent 被调用前自动执行初始化。因此这里按“第一次实质任务门禁”处理：如果当前 runtime 能执行 shell 命令，Senior Project Expert 应该先直接运行 `copilot init` 再做需求分析；如果只能使用 Copilot 交互式 slash command，则要求用户运行 `/init`。初始化完成后，应在同一轮对话里继续处理用户原始需求。

如果目标仓库已经存在 `.github/copilot-instructions.md`，没有未解决的 init 占位符，并且记录了 build/test/check/dev 命令事实，以及 runtime/framework、entrypoint、module boundary 事实或显式 `unknown`，则视为已经执行过 `/init`，不应该因为换了一轮对话就重复执行。

这些持久状态应存储在目标仓库本地：项目记忆写入 `memories/repo/**`，规格写入 `spec/**`。插件包里自带的 `memories/` 和 `spec/` 只是模板和插件仓库自身状态，不是所有安装项目共享的存储位置。

## 语言策略

每个 agent 必须先识别用户输入的主要语言。混合输入很常见：用户可能用一种语言描述问题，同时贴上另一种语言的日志、堆栈、代码或 API 响应。主要语言取决于用户实际提问或解释所用语言，而不是粘贴证据里的 incidental language。

默认用识别出的主要语言回复，除非用户明确指定其他语言。

## 团队入口

大型任务先找 **Senior Project Expert**。它不直接写生产代码，负责：

面对一个真正的大需求，Senior Project Expert 不是简单“分派一下 agent”，而是像项目总控一样把模糊请求压成一条可审计、可复盘、可验证的交付链。它跑的不是随手分工，而是这套仓库真正依赖的 workflow：先在有歧义时做 brainstorming 锁方向，再把方向落成 Spec Kit，然后拉多方会审，之后按 spec-driven、test-driven 的方式推进实现，代码出来后还要经过架构师/开发工程师互评，再进入 QA、安全和前端验证。

它带来的价值不只是流程更完整，而是同时把质量和效率往上拉：质量更高，是因为高风险假设会在写代码前就被 challenge；效率更高，是因为团队不会在错误方向上连续白干两三轮。

比如用户说“把这个回调链路优化一下”，它不会立刻把任务丢给实现 agent 开改，而是先用 brainstorming 锁清楚这句话到底是在说性能、正确性、重试安全、接口收敛，还是发布风险，然后把锁定后的方向落成 requirements、design、tasks。这个动作看起来多了一步，但实际是在避免后面两三轮都在错误目标上返工。

再比如一个需求同时碰 API 契约、后台任务和前端交互，它也不会让所有内容混在一条长对话里一起失控，而是先冻结范围和非目标，落成 Spec Kit，先让 Technical Architect、Developer、QA 对方案做会审，涉及安全或前端体验时再把 Security Reviewer 或 Frontend Designer 拉进来。设计过关后，主线交给 Technical Architect，独立切片交给 Developer，页面和交互交给 Frontend Designer；新增行为或 bugfix 在可行时先写失败测试，再按 spec 推进实现；代码写完以后，再强制架构师与开发工程师互相审查各自负责的代码，最后才进 QA / 安全 / 前端验证。这样做的好处是：问题会更早暴露，责任边界更清楚，review 不会退化成“作者自己说没问题”。

最终效果不是“agent 更多了”，而是整条链路更难跑偏：开始阶段少盲猜，中间阶段少重复搜仓库，实施阶段少脱离 spec 硬写代码，收尾阶段少在 QA 或发布前才爆出大坑。

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
| Technical Architect | 后端/全栈设计与主线实现、API/数据/服务边界、审查 Developer 负责代码的架构适配性 | 前端细节、小切片 |
| Developer | 已冻结实现切片、实现可行性审查、审查 Technical Architect 负责代码的落地复杂度 | 架构变更或扩范围 |
| Frontend Designer | 页面、组件、交互、响应式、浏览器行为、视觉验证 | 后端主线 |
| Quality Assurance Expert | 功能验证、回归风险、代码审查、可合并性 | 安全专项和修复 |
| Security Reviewer | 权限、敏感数据流、依赖风险、发布面安全 | 普通功能 QA |
| Root Cause Fixer | 失败分析、最小补丁、回归验证 | 无证据重构 |

## 模型策略

这些角色不是给同一个通用 agent 换名字。每个 agent 都在 `.github/agents/*.agent.md` frontmatter 中声明了明确模型，模型选择和角色需要的推理方式对应：

| Agent | 模型 | 推理特性 |
| --- | --- | --- |
| Senior Project Expert | GPT-5.4 | 长程编排、范围控制、fan-out/fan-in 判断和收口决策 |
| Technical Architect | GPT-5.4 | 深度后端/全栈推理、公开契约设计、数据/API 边界分析、主线实现策略，以及对 Developer 负责代码的审查 |
| Specification Writer | Gemini 3.1 Pro (Preview) | 大上下文综合、结构化 requirements/design/tasks、ADR 和恢复记录 |
| Developer | Gemini 3.1 Pro (Preview) | 冻结切片的聚焦实现、对主线代码的实现可行性审查、快速代码上下文对齐、测试和有界验证 |
| Frontend Designer | Gemini 3.1 Pro (Preview) | UI/状态/上下文综合、Ant Design 式企业级模式、主动设计系统推理、响应式行为、交互质量和浏览器证据规划 |
| Quality Assurance Expert | Claude Sonnet 4.6 | 低噪声审查、回归推理、测试充分性判断和可合并性结论 |
| Security Reviewer | Gemini 3.1 Pro (Preview) | 发布面分析、权限边界、敏感数据流、依赖和配置审查 |
| Root Cause Fixer | Claude Sonnet 4.6 | 失败分诊、假设排除、最小补丁选择和回归证明 |

路由策略本身就是产品的一部分：编排和架构使用更适合深度规划的模型，实现和规格使用大上下文执行模型，QA/修复角色使用更偏审查和调试的模型，让结论保持具体、低噪声、可执行。

## 大型任务流程

大需求不会从 prompt 直接跳到代码提交。它会经过一条有检查点的流程，目的是尽早打掉坏假设，把设计评审和独立审查前置，把实现、互评、验证拆开处理。

1. **Init**：缺仓库事实时运行 `/init` 或 `copilot init`。
2. **Discover**：冻结目标、范围、风险和验收标准。
3. **Brainstorm**：如果需求存在歧义或路线会影响实现方向，先用 `brainstorming` 锁定方向，避免在错误语义分支上开工。
4. **Spec Kit**：由 Specification Writer 把已锁定方向落成仓库里的 Spec Kit，也就是 `requirements.md`、`design.md`、`tasks.md`。
5. **Design Review**：先由 Technical Architect、Developer、QA 共同审 Spec Kit；涉及安全或前端体验时，再加入 Security Reviewer 或 Frontend Designer，让高风险假设在实现前就被挑战。
6. **SDD/TDD Implementation**：主线交给 Technical Architect，独立切片交给 Developer，前端交给 Frontend Designer。实现以 Spec Kit 为锚点推进；新增行为或 bugfix 在可行时先写失败测试，而不是先写代码再回头补理由。
7. **Cross Review**：Technical Architect 审 Developer 负责的代码，Developer 审 Technical Architect 负责的代码，任何实现者都不能给自己写的代码放行。
8. **Verify**：QA 做最小充分验证；前端补浏览器证据；没过就进入 fix loop，而不是口头说“应该没问题”。
9. **Secure**：存在发布面、依赖、权限或敏感数据流时做安全审查。
10. **Fix Loop**：确认失败后由 Root Cause Fixer 最小修复并复测。
11. **Close**：总结改动、证据、风险和恢复入口。
12. **Evolve**：重复失败、老化触发词、review 回环或可复用经验变成 EvolutionEvent。

## 自进化能力

`best-copilot` 不允许 agent 随意重写自己。演进必须基于证据且可回滚：

1. **Read**：读取任务结果、失败命令、review finding、用户纠正、memory 和 spec drift。
2. **Select**：选择最小改进目标：agent、skill、instruction、prompt、memory、README 或 spec template。
3. **Propose**：生成带证据、范围、验证和回滚的 Evolution Proposal。
4. **Validate**：通过 frontmatter/schema、触发词 eval、静态检查、review 或命令证据验证。
5. **Write**：只把已接受的经验写回 `.github/**`、`memories/repo/**` 或 `spec/**`。

接受的改进记录为 `EvolutionEvent`: `signal -> target -> mutation -> validation -> rollback -> status`。

## 项目优点

- 先评审再实现：大需求先经过设计审查，而不是代码写完了再补理由。
- Spec Kit + TDD 驱动实现：方向先落成 requirements/design/tasks，新行为或 bugfix 在可行时先写测试，再推进实现。
- 架构师与开发互评：主线 owner 和切片 owner 互相审查，避免实现者自己给自己放行。
- Copilot-first，可通过 `copilot plugin marketplace add` 加入 marketplace 后，再用 `copilot plugin install best-copilot@best-copilot` 安装。
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
- [Open Design](https://github.com/nexu-io/open-design)
- [claude-mem](https://github.com/thedotmack/claude-mem)
- [fetch-skill](https://github.com/aresbit/fetch-skill/)
- [spec-kit](https://github.com/github/spec-kit)
- [Anthropic skill-creator](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator)
- [Anthropic code-simplifier](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-simplifier)
- [Anthropic code-review](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review)
- [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills)
- [Evolver](https://github.com/EvoMap/evolver)
