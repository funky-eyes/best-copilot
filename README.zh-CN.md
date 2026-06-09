# best-copilot

[English](README.md) | 简体中文 | [Korean](README.ko.md) | [Japanese](README.ja.md)

[![version](https://img.shields.io/badge/version-0.7.0-1d9bf0)](plugin.json)
[![Codex](https://img.shields.io/badge/Codex-plugin-111827)](.codex-plugin/plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-f97316)](claude-plugin/.claude-plugin/plugin.json)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-39-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero-cn.png)

`best-copilot` 是一套面向 Codex、Copilot CLI 和 Claude Code 的可安装 agent-team workflow，服务严肃的工程工作。它为仓库提供一条资深交付流程：初始化事实、冻结范围、先设计再构建、通过专责角色实现、独立审查、以证据验证，并保留下次会话的恢复点。

Codex 使用 `.codex-plugin/plugin.json`、`.agents/plugins/marketplace.json` 和 `.agents/skills -> ../skills`。Copilot CLI 通过 `plugin.json` 使用根目录 `agents/` 与 `skills/`。Claude Code 通过 `claude-plugin/` 包加载：`claude-plugin/.claude-plugin/plugin.json`、`claude-plugin/skills -> ../skills` 和 `claude-plugin/agents -> ../claude-agents`。仓库级规则保存在 `.github/instructions/**`。

## 为什么存在

大型的 AI 编码任务在从模糊的需求直接跳到补丁时常常失败。`best-copilot` 补上缺失的交付纪律：

- **一个资深入口**：由 Senior Project Expert 负责意图、范围、派发、fan-in、收口和可复用的工作流信号。
- **八位专责 agent**：规划、架构、实现、前端、QA、安全、故障修复与规格工作各自分工。
- **三十九项技能**：包含角色 workflow、引导、搜索、规划、工作区隔离、TDD、设计评审、执行、Java/Python 编码规约、验证、分支收口、前端审计、工作流演进与 Senior Project Expert 兼容入口点等可安装技能。
- **目标仓库本地的 memory 与 spec**：已安装的项目在目标仓库内保留事实、工作流、memory 与 spec，而非插件包内部。
- **证据优先的收尾**：宣称“完成”必须有命令输出、静态检查、浏览器证据，或一个明确的阻塞说明。

## 安装

### Codex

Codex 官方支持将插件作为可安装分发单元，用来打包可复用 skills、apps 和 MCP 配置。把本仓库添加为 Codex marketplace，然后在 Codex 插件目录中安装：

```bash
codex plugin marketplace add funky-eyes/best-copilot
codex plugin add best-copilot@best-copilot
```

本地开发时从当前 checkout 使用：

```bash
codex plugin marketplace add /absolute/path/to/best-copilot
codex plugin add best-copilot@best-copilot
```

Codex 会发现：

- 插件元数据：[.codex-plugin/plugin.json](.codex-plugin/plugin.json)
- 本地/仓库 marketplace 元数据：[.agents/plugins/marketplace.json](.agents/plugins/marketplace.json)
- marketplace 插件 source：[plugins/best-copilot](plugins/best-copilot)，这是一个真实的 Codex 插件子包，其中 `skills` 目录链接到根目录共享 [skills/](skills/)
- 通过插件 manifest 暴露的共享技能：[skills/](skills/)
- 通过 [.agents/skills](.agents/skills) 直接暴露的 repo-scoped 共享技能

安装或修改插件后，启动新的 Codex thread/session。需要使用本工作流时，显式调用 `@best-copilot` 或某个 bundled `$skill`。

### Copilot CLI

把本仓库注册为 Copilot CLI 插件 marketplace：

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

从已注册的 marketplace 安装插件：

```bash
copilot plugin install best-copilot@best-copilot
```

本地开发时同样可用：

```bash
copilot plugin marketplace add /absolute/path/to/best-copilot
copilot plugin install best-copilot@best-copilot
```

当前 Copilot CLI 仍能直接从仓库安装，但 CLI 会提示直接安装已弃用，未来将仅支持 `plugin@marketplace`：

```bash
copilot plugin install funky-eyes/best-copilot
```

本地修改后请重新安装或更新插件以测试新会话，因为 Copilot CLI 会从已安装插件缓存中读取 agents 与 skills。

### Claude Code

Claude Code 使用自己的 marketplace 系统。先把本仓库添加为 Claude Code marketplace，再安装插件：

```text
/plugin marketplace add funky-eyes/best-copilot
/plugin install best-copilot@best-copilot
/reload-plugins
```

本地开发或直接从当前 checkout 使用时，也可以直接加载插件目录：

```bash
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin
```

在 Claude Code 中可靠进入 Senior Project Expert 的方式，是让该 agent 接管整场会话：

```bash
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert
```

插件安装完成后，通常可以简化为：

```bash
claude --agent senior-project-expert
```

Claude Code 会发现：

- marketplace 元数据：[.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)
- 插件元数据：[claude-plugin/.claude-plugin/plugin.json](claude-plugin/.claude-plugin/plugin.json)
- 共享技能：[skills/](skills/)，在 Claude Code 中用带命名空间的 slash 命令调用，例如 `/best-copilot:repo-init-gate`；如果命令选择器插入了其他插件显示形式，以选择器插入值为准
- Claude 兼容 subagents：[claude-agents/](claude-agents/)
- PM 主会话通过 `--agent senior-project-expert` 或 Claude Code 的项目/用户 `agent` 设置选择；`/agents` 和 `@` 选择器会用 `best-copilot:senior-project-expert` 这样的 scoped 名字显示插件 subagent，手动 `@` 或 Agent-tool 显式派发时应使用这个显示名

本地修改或插件更新后，在 Claude Code 内运行 `/reload-plugins`，或重启会话。

## 使用说明

需求编排统一从 **Senior Project Expert** 这个 PM 协调者 agent 开始。它负责意图、范围、规划、派发、review fan-in 和收口。

- **Copilot CLI**：运行 `/agent`，选择 **Senior Project Expert**，然后描述要做的工作。Copilot 使用 `handoffs:` 声明进行专员路由。
- **VS Code 插件**：在聊天中手动切换到 **Senior Project Expert** 这个 agent，然后开始任务。
- **Claude Code**：PM 作为主会话，通过 **Agent tool** 显式 spawn 专业子 agent。
- **Codex**：调用 `@best-copilot` 或兼容入口 `$senior-project-expert` skill，然后要求执行该 workflow。需要并行工作时，必须显式要求 Codex spawn subagents；仅安装插件不会自动 spawn subagents。

### Claude Code 启动方式

```bash
# 方式 1：显式指定 PM agent（推荐）
claude --agent senior-project-expert
# 如果 Claude 报 agent 名冲突，使用：
# claude --agent best-copilot:senior-project-expert

# 方式 2：通过 .claude/settings.json 设置默认 agent（无需每次指定）
# 在目标仓库的 .claude/settings.json 中加入:
# { "agent": "senior-project-expert", "worktree": { "baseRef": "head" } }

# 方式 3：本地插件开发
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert
```

### Claude Code 多代理工作原理

PM（`senior-project-expert`）作为主会话接收用户需求后：

1. 运行 `/best-copilot:repo-init-gate` 做初始化预检
2. 分析意图、分类任务（micro/standard/full）、冻结分发包
3. 通过 **Agent tool** 按 `/agents` 显示的 scoped 名字 spawn 专业子 agent（如 `best-copilot:technical-architect`、`best-copilot:developer` 等）
4. 只有在权限已预授权、且任务是独立调研/只读 review 时，才选择后台执行
5. 实现、修复、spec/memory 写入、可能触发权限确认的验证默认前台执行
6. 可能冲突的实现使用 `isolation: "worktree"` 隔离，并回收 worktree 路径、分支、改动文件和验证证据
7. 对 isolated worktree 改动执行 `/best-copilot:development-branch-closeout` 或等价的 keep / merge / PR / discard 决策，再声称改动已落地
8. PM 收集所有子 agent 的返回结果，做 fan-in 仲裁
9. 调用 `/best-copilot:verification-before-completion` 后向用户交付

Claude Code 中可用的插件子 agent 会以 scoped 形式显示：`best-copilot:technical-architect`、`best-copilot:developer`、`best-copilot:frontend-designer`、`best-copilot:quality-assurance-expert`、`best-copilot:security-reviewer`、`best-copilot:specification-writer`、`best-copilot:root-cause-fixer`。

Claude 适配器在 `claude-agents/*.md` 中使用 Claude 模型别名：GPT-5.4 对应 `opus`，Gemini 对应 `haiku`，Claude Sonnet 对应 `sonnet`。在原生 Claude Code 中，这些别名会在 Claude 模型族内保留 Copilot 侧的角色档位。如果 `cc-switch`、`new-api` 或其他 Anthropic-compatible proxy 把这些别名路由到 DeepSeek、Qwen 或其他非 Claude 后端，先确认该路由会话里插件真的已启用。`/plugin list` 应显示 `best-copilot@best-copilot`，`/agents` 应显示 `best-copilot:senior-project-expert` 等 scoped agent；如果 proxy allowlist 需要显式配置，应包含 `"enabledPlugins": {"best-copilot@best-copilot": true}`。之后仍按降级模型处理，直到 PM 在读取源码或实现前输出 `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION`，列出所需 specialist lanes，并进入 `repo-init-gate` / `repo-init-scan` 流程。

## 运行时适配架构

### 三运行时隔离原则

```text
共享契约层
core-workflow-contract + 各角色 role-*-workflow
        |
        +-- Codex 适配
        |   .codex-plugin/
        |   .agents/plugins/
        |   .agents/skills -> ../skills
        |   @plugin / $skill，显式 subagents
        |
        +-- Copilot CLI 适配
        |   agents/*.agent.md
        |   model: GPT-5.4 等
        |   handoffs 声明
        |   直接读取 skills/
        |
        +-- Claude Code 适配
            claude-agents/*.md
            model: opus/haiku/sonnet
            Agent tool dispatch
            claude-plugin/{agents,skills} symlinks
```

跨角色公共规则放在 [skills/core-workflow-contract/SKILL.md](skills/core-workflow-contract/SKILL.md)。每个角色自己的 workflow 放在 `skills/*-workflow/`：`senior-project-expert-workflow`、`specification-writer-workflow`、`technical-architect-workflow`、`developer-workflow`、`frontend-designer-workflow`、`quality-assurance-workflow`、`security-reviewer-workflow`、`root-cause-fixer-workflow`。Codex-only 的内容留在 [.codex-plugin/](.codex-plugin/) 和 [.agents/](.agents/)：插件元数据、marketplace 元数据和直接 repo-scoped skill discovery。Copilot-only 的内容留在 [agents/](agents/)：模型名、Copilot 工具、`user-invocable`、`agents` 和 `handoffs`。Claude-only 的内容留在 [claude-agents/](claude-agents/) 里的同名文件：Claude Code 实际显示的 agent 名称、Claude 模型别名（`opus`、`sonnet`、`haiku`）、只读限制、`isolation: worktree`，以及 PM 拥有的 foreground/background 派发策略。

这样公共行为、角色专属行为、无法共存的 runtime metadata 三层隔离；每个 agent 都必须同时加载公共 contract 和自己的角色 workflow。

### 技能加载规则

| 场景 | 行为 |
|------|------|
| Codex 插件会话 | `.codex-plugin/plugin.json` 打包 skills；调用 `@best-copilot` 或 `$skill`，并行工作需显式要求 subagents |
| Codex repo checkout | `.agents/skills -> ../skills` 暴露同一份共享 skills，不复制内容 |
| Claude PM 主会话 | PM 的 `skills:` frontmatter 声明式预加载 |
| Claude 子 agent（PM spawn） | 子 agent 从自身 `skills:` frontmatter 加载，PM 的 spawn prompt 必须包含任务上下文和所需技能 |
| Claude base session | agent 的 `skills:` 未激活，需手动调用 |
| Copilot CLI | body 引用非机械预加载，packet 中需含最小 checklist |

Claude agent 的 frontmatter 通常只预加载 `core-workflow-contract` 和对应角色 workflow。Senior Project Expert 额外预加载 `repo-init-gate` 和 `repo-init-scan`，因为 init preflight 是强制启动门禁。`structured-review`、`test-driven-development`、`web-experience-audit` 这类其他 focused skills 保留在 agent 正文里按需触发，避免启动时默认吃掉过多上下文。

### 运行时差异一览

| 维度 | Codex | Copilot CLI | Claude Code |
|------|-------|-------------|-------------|
| 入口 | `@best-copilot` 或 bundled `$senior-project-expert` skill | `agents/pm-coordinator.agent.md` | `claude-agents/senior-project-expert.md`（通过 `--agent` 或 `.claude/settings.json`） |
| 模型指定 | Codex runtime/config 选择，除非 prompt 指定 | 具体名如 `GPT-5.4 (copilot)` | `model: opus` / `haiku` / `sonnet` 角色档位别名 |
| 专员分发 | 通过 workflow skills 显式要求 Codex subagents/delegation | `handoffs:` 声明 + `agent` tool | PM 主会话通过 **Agent tool** spawn 子 agent |
| 并行执行 | 需要用户/PM 显式请求 | handoff 声明自动处理 | PM 只对安全的独立调研/只读 review 选择后台 |
| 文件隔离 | Codex sandbox/worktree 行为 | Copilot 内置 | `isolation: "worktree"` + PM closeout |
| 用户交互 | 当前 Codex ask/approval surface | `vscode_askQuestions` / `Asking user` | 内置 `AskUserQuestion` |
| 技能发现 | `.codex-plugin` skills + `.agents/skills` symlink | 从根目录 `skills/` 直接读取 | `claude-plugin/skills -> ../skills` 符号链接 |
| Agent 发现 | 无安装式角色 adapter 等价物；使用 skills 和显式 subagents | 从根目录 `agents/` 直接读取 | `claude-plugin/agents -> ../claude-agents` 符号链接 |
| 跨模型路由 | Codex runtime/config 控制 | 支持（GPT / Gemini / Claude 混合） | 仅 Claude 模型档位别名 |

Copilot handoff 是 fail-closed：每个 PM handoff prompt 都要求 `core-workflow-contract` 加目标角色 workflow skill。如果运行时不能加载这些 skill，handoff 会带上最小角色 checklist fallback；两者都没有时，specialist 必须返回 `NEEDS_CONTEXT missing_required_skill`。

## 快速检查

```text
/agent
/skills list
```

预期的包结构：

```text
best-copilot
├── plugin.json
├── .codex-plugin/
│   └── plugin.json
├── .agents/
│   ├── plugins/
│   │   └── marketplace.json
│   └── skills -> ../skills
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

## 核心工作流

每个任务都经过一条可观察的阶段链路，用户可以在 transcript 中看到每一步：

```
INIT_GATE → [INIT_SCAN if needed] → CLASSIFY → FREEZE_PACKET → LANE_SELECTION
  → [ARCHITECT_SDD if full/ambiguous/high-risk] → REVIEW_OR_DISPATCH
  → FAN_IN_ARBITRATION → NEXT_GATE
```

### 行为可靠性门禁

`FREEZE_PACKET` 和执行阶段会强制保留以下约束：

- 明确假设、权衡和最简单可行方案；如果不确定性会改变实现、路由或验收标准，先问，不猜。
- 选择满足成功标准的最小变更；不写投机功能，不为一次性代码加抽象。
- 手术式变更：每行改动都应追溯到用户目标、验收检查或验证修复；不顺手整理相邻代码、注释或格式。
- 写前先读：代码变更前读目标文件的 public surface/exports、直接 caller/callee，以及明显共享工具或本地模式。
- 以成功标准、约束、验证和停止条件驱动执行；只在依赖、安全或验证需要时规定步骤。多步任务在每个重要步骤后 checkpoint：已做什么、已验证什么、还剩什么。

### 阶段一：Init 门禁（强制预检）

在目标仓库上做任何实质性工作之前，系统先执行 `repo-init-gate`——只读取目标仓库根目录的 `best-copilot.md`，检查 frontmatter 中的 `version` 是否为当前契约版本 `"0.7.0"`。

```
repo-init-gate
  │
  ├── version 匹配 → ready → 跳过，继续后续阶段
  │
  └── 缺失/不匹配/无效 → needs_init
                           │
                           ▼
                    repo-init-scan
                      │
                      ├── Stage 1: repo-init-official
                      │     尝试 /init 或 copilot init
                      │     输出 → project.instructions.md
                      │
                      └── Stage 2: repo-init-manual-fallback
                            手动扫描 → 创建 scaffold
                            target-instructions-bootstrap
                            target-memory-bootstrap
                            target-spec-bootstrap
                            │
                            └── 写入 best-copilot.md sentinel
```

这是 **Fail-Closed** 设计：init 未完成之前，不允许规划、实现或审查。系统返回 `BLOCKED` 而非基于猜测继续。只有当 `repo-init-scan` 报告 `next_task_ready: yes` 时，才允许进入后续阶段。

### 阶段二：任务分类

系统将每个任务分为三级：

| 级别 | 适用场景 | 流程重量 |
|------|---------|---------|
| `micro` | 微小编辑/检查，无公共契约、安全、跨模块风险 | 直接执行 |
| `standard` | 有界文件集，单一所有者表面 | 精简 packet，聚焦 review |
| `full` | 模糊、跨模块、公共 API/schema/auth/依赖/CI/前端体验 | 完整规划、SDD 设计评审、fan-in 门禁 |

`task_type` 独立于大小追踪行为：`implementation`（写/更新）、`design_review`（评估不实现）、`verification`（审查风险/合并准备）、`fix`（有界修复）、`spec`（需求/设计/任务，不写生产代码）。

### 阶段三：冻结上下文（六区块分发包）

PM 将意图冻结为标准的**六区块分发包**（PM Dispatch Packet），这是跨角色通信的统一协议：

```markdown
1. task_intent     — 目标、用户路径、意图摘要、预期结果、task_type、work_mode
2. frozen_scope    — 范围、非目标、涉及文件、已改文件、优先/已读文件、依赖
3. fact_packet     — 权威仓库事实、来源引用、参考文件
4. execution_contract — 假设、权衡、最简单方案、约束、验收检查、验证/上下文预算、停止条件、禁止方法、写前先读目标
5. review_state    — 后续范围、已验证项、评审通道、就绪产物
6. output_contract — 所需技能、角色 checklist fallback、所需产物、下一阶段
```

**为什么用包？** 因为每个专员拿到的是冻结的有限上下文，而非完整对话历史。这避免了"一个代理的猜测成为另一个代理的事实"，同时保证每次派发都可追溯、可审计。

### 阶段四：SDD 设计门禁

对于 `full`、模糊、高风险、公共契约、auth/安全、依赖、schema 或前端体验类任务，在实现之前必须先经过 **Technical Architect 主导的 SDD（Spec-Driven Design）设计脑暴**：

1. PM 将设计任务派发给 Technical Architect
2. Technical Architect 做 SDD 设计脑暴并自审/修复
3. PM 再派发 Developer + QA 做第二轮设计评审
4. 有前端用户界面时，加入 Frontend Designer
5. 阻塞性发现打回 Technical Architect 修复，PM 只重跑受影响的评审通道
6. 只有通过评审的设计才允许进入实现

对于 `standard` 任务，跳过 ARCHITECT_SDD 并记录原因以保持效率——不对有界、非模糊的标准工作强制架构 SDD。

### 阶段五：并行派发与执行

通过设计评审后，PM 通过 `writing-plans` 将工作拆解为可并行的任务，每个任务都有：

- 独立的文件所有者和写入集（write set 不重叠）
- 明确的依赖关系和验收检查
- 指定的所有者通道和评审通道

派发执行通过 `subagent-driven-development` 或 `executing-plans` 进行：

```
每个就绪任务:
  1. 构建 fresh context packet（context-packet-fastpath）
  2. 派发实现给对应专员
     - Technical Architect: 全栈架构/主线切片
     - Developer: 有界切片
     - Frontend Designer: UI 拥有的切片
     - Root Cause Fixer: 已确认的失败
  3. 要求实现证据：改了哪些文件、写前先读证据、跑了什么测试/检查、关键输出、风险
  4. Stage 1 审查：规格/任务合规性（需求、非目标、文件边界、验收检查）
  5. Stage 2 审查：代码质量与发布风险（可维护性、耦合、安全/性能风险、死代码、测试充分性）
  6. 确认发现进入修复循环
  7. 通过所有必需评审和验证后，PM 才能标记任务完成
```

**关键规则：Stage 1 和 Stage 2 的评审者不能是实现作者本人。** 评审通道遵循交叉评审规则（见下文）。

### 阶段六：Fan-In 仲裁

PM 按优先级裁决所有专员返回的结果。仲裁优先级：

1. **阻塞**：`BLOCKED`、`NEEDS_USER_INPUT`、无效 handback、重复 `NEEDS_CONTEXT`
2. **安全**：安全、隐私、数据丢失、auth、依赖、发布、破坏性操作风险
3. **验证**：失败/缺失的验证、未证明的完成声明
4. **范围**：规格不匹配、范围膨胀、写入集重叠
5. **质量**：代码质量、可维护性、性能、UX、可访问性、测试充分性
6. **非阻塞**：后续注意事项

当评审者意见不一致时，PM 记录 `decision_provenance`（证据、阻塞状态、下一阶段、残余风险）。未裁决的冲突不允许 fan-out 或 closeout。

### 交叉评审规则

| 被评审代码 | 评审者 |
|-----------|--------|
| Developer 代码 | Technical Architect |
| Technical Architect 代码 | Developer |
| Developer/Technical Architect 前端代码 | Frontend Designer |
| Frontend Designer 代码 | Technical Architect |
| 所有代码（最终） | QA（合并准备） |
| 安全敏感面 | Security Reviewer（必须） |

### 阶段七：验证与收口

关闭前，系统执行 `verification-before-completion` 最终检查：

- 需求/用户请求已满足
- 改动文件有界于任务范围
- 无占位符、死引用、过时名称或断裂链接
- 已运行测试/构建/浏览器检查/静态验证（或显式报告跳过）
- 残余风险和下一步已明确
- 使用 Native Ask UI 做最终确认/继续（非纯文本摘要）

### 小任务的精简路径

对于 `micro` 级别任务，以上流程保持精简——直接执行，跳过 SDD 设计、并行派发和多轮评审。但即使是最小的改动，完成前仍需 `verification-before-completion` 检查。

## Agent 团队

| Agent | 负责 | 不负责 |
| --- | --- | --- |
| Senior Project Expert | 意图、范围、编排、派发、fan-in、收口、演进信号 | 直接编写生产代码 |
| Specification Writer | 发现证据、requirements、design、tasks、ADR、memory/spec 恢复 | 生产实现 |
| Technical Architect | 全栈设计、SDD brainstorming、API/数据/服务边界、主线实现、并行拆解、Developer/Frontend Designer 代码评审 | 最终前端打磨、任务编排 |
| Developer | 冻结的实现切片、实现可行性评审、对架构师负责代码的实现评审 | 架构变更或范围扩展 |
| Frontend Designer | 页面、组件、交互、响应式、浏览器证据、前端专项 review | 后端主线 |
| Quality Assurance Expert | 功能验证、回归风险、代码审查、peer lanes 后的合并准备 | 安全专项 |
| Security Reviewer | 权限、敏感数据流、依赖、发布面安全 | 普通功能 QA |
| Root Cause Fixer | 失败诊断、最小补丁、回归验证 | 无证据的重构 |

## 专员通信协议

### 专员提问边界（Specialist Ask Boundary）

所有 specialist（非 PM 角色）**不能直接向用户提问**。这是硬性约束：

```
专员需要信息
  │
  ├── 缺少上下文 → 返回 NEEDS_CONTEXT 给 PM
  │                   包含 clarification_request + pm_action: "pm_clarify"
  │
  └── 需要用户输入 → 返回 NEEDS_USER_INPUT 给 PM
                       包含 question, why_blocking, options,
                       safe_default, resume_prompt_for_pm
```

只有 PM/Coordinator 才能使用 Native Ask 机制（Copilot: `vscode_askQuestions` / `Asking user`；Claude: `AskUserQuestion`）向用户提问。

### Native Ask 合约

- 只有顶层会话或 PM/Coordinator 可以使用原生提问
- 每次提问必须允许自由格式回答（固定选项 UI 必须包含 "Custom answer"）
- 不得以纯文本摘要结束一个 turn（当 Native Ask UI 可用时）
- 若 UI 不可用且需要用户选择 → 报告 `BLOCKED missing_native_ask_ui`

### 专员返回结构（Structured Handback）

每个专员返回标准化的结构化结果：

```markdown
- task_id:                任务标识
- current_stage:          当前阶段
- status:                 DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT |
                          NEEDS_USER_INPUT | BLOCKED
- summary:                完成摘要
- artifacts:              产出物（文件、测试、证据）
- risks:                  风险
- uncovered_items:        未覆盖项
- recommended_next_stage: 建议的下一阶段
```

## Memory 与 Spec 系统

### 双轨持久化

`best-copilot` 在目标仓库中维护两套持久化系统：

```
目标仓库
├── spec/                          ← Spec：需求/设计/任务的权威来源
│   ├── INDEX.md                   ← spec 路由表
│   └── templates/                 ← 可复用模板
│
├── memories/repo/                 ← Memory：恢复索引
│   ├── INDEX.md                   ← memory 路由表
│   ├── current-workstreams.md     ← 当前活跃工作
│   ├── project-state.md           ← 项目状态快照
│   ├── decisions.md               ← 决策记录
│   └── workflow-rules.md          ← memory/spec 协调规则
│
├── .github/instructions/          ← 仓库级规则
│   ├── project.instructions.md    ← 项目事实（build/test/框架/入口）
│   ├── must.instructions.md       ← 核心规则
│   └── skills-index.instructions.md ← 技能路由
│
└── best-copilot.md               ← Init sentinel（version: "0.7.0"）
```

### Spec vs Memory 的分工

| 维度 | Spec | Memory |
|------|------|--------|
| 权威性 | 需求/设计/任务的**权威来源** | **恢复索引**——当前焦点、决策、上次验证、下一步操作 |
| 内容 | 需求文档、设计文档、任务列表、验收检查 | 工作流状态、已验证的决策、恢复提示、压缩事实 |
| 不包含 | 不存日志、不存状态 | 不存需求规格、不存设计文档 |
| 协调规则 | — | memory 永不覆盖当前仓库文件、命令输出、系统指令或显式用户指令 |

### 渐进式信息披露

Memory 使用 **INDEX.md 路由 + 按需加载**，控制 token 预算：

```
1. 读 INDEX.md（路由表）
2. 如果恢复活跃工作，读 current-workstreams.md
3. 跟随 linked_spec 和 linked_memory
4. 只加载选中 memory 文件的相关 section
5. 只有在需要源追溯时才回退到 archive/logs
```

每个 memory 文件有 `load_tier` 标签：`task-active`（活跃任务时加载）、`task-reference`（参考时按需加载）、`archive-reference`（仅在追溯时加载）。

### MEDIUM/LARGE 工作的双向链接

中大型工作在 spec 和 memory 之间建立双向链接：

- `current-workstreams.md` 中的每个工作流都 `linked_spec` 指向对应的 spec
- `spec/INDEX.md` 中的每个 spec 都可以回指相关的 memory
- EvolutionEvent 记录需要 signal、target、mutation、validation、rollback、status 全部字段

## 技能地图

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

## 首次在目标仓库中使用

初始化是**自动的**——不需要手动运行 `/init` 或 `copilot init`。当 PM agent 启动时，[核心工作流 Stage 1](#阶段一init-门禁强制预检) 会自动执行 `repo-init-gate` → `repo-init-scan`，完成仓库事实采集和脚手架创建。

在 Claude Code 中直接启动 PM 即可：

```bash
claude --agent senior-project-expert
```

初始化流程会在目标仓库中创建以下本地文件：

```text
.github/instructions/project.instructions.md    ← 项目事实（build/test/框架/入口）
.github/instructions/must.instructions.md       ← 核心规则
.github/instructions/skills-index.instructions.md ← 技能路由
CLAUDE.md                                        ← Claude Code 兼容（可选）
memories/repo/INDEX.md                           ← 恢复索引路由表
memories/repo/current-workstreams.md             ← 当前活跃工作
spec/INDEX.md                                    ← Spec 路由表
spec/templates/                                  ← 可复用模板
best-copilot.md                                  ← Init sentinel（version: "0.7.0"）
```

如果必需的事实或脚手架无法创建，工作会以 `BLOCKED first_use_gate_incomplete` 停止——参见 [核心工作流 Stage 1](#阶段一init-门禁强制预检) 的完整说明。

## 模型策略

每个 agent 在 `agents/*.agent.md` 中声明模型与路由策略：

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

原生 Claude Code 使用 Claude 模型别名。`claude-agents/*.md` 中的 Claude 适配器保留角色分工，并把 Copilot 档位映射为 Claude 别名：GPT-5.4 -> `opus`，Gemini 3.1 Pro (Preview) -> `haiku`，Claude Sonnet 4.6 -> `sonnet`。`cc-switch` 或 `new-api` 等 proxy route 可能把这些别名映射到非 Claude 模型；这只是 API 兼容，不代表 workflow 兼容。对 DeepSeek、Qwen 或未知后端，先确认插件已启用：`/plugin list` 应包含 `best-copilot@best-copilot`，`/agents` 应显示 scoped plugin agents；如果 `cc-switch` / `new-api` 使用 allowlist，应包含 `"enabledPlugins": {"best-copilot@best-copilot": true}`。之后在真实工作前运行非破坏性的 workflow smoke check。期望行为是：PM 输出 `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION`，然后为请求 dispatch 所需 lanes。如果插件已启用但它仍开始编码、跳过 init 或跳过 lanes，请改用能通过 smoke check 的模型/provider。

## 搜索纪律

系统在检索信息时遵循严格的优先级，以控制 token 消耗和提高准确性：

```
显式用户路径 → 已改文件 → 冻结的 files_involved → 仓库索引
  → 文件名/glob → 固定字符串 rg -F → 正则表达式（最后手段）
```

- 优先用 `rg -F` 固定字符串搜索类名、方法、路由、配置键
- 正则仅在真正模糊或精确搜索失败后使用，且记录原因
- 避免仓库级正则；限定到最小目录；两次搜索无新信号则停止
- 设计并发/不熟悉模式/基础设施前，先搜索运行时/框架内置（久经考验 → 新流行 → 第一性原则）

## 反理性化检查

在声称"完成"之前，系统自动检查这些常见的自我欺骗模式：

| 借口 | 反驳 |
|------|------|
| "稍后再加测试" | 测试是任务的一部分，不是后续工作 |
| "我机器上能跑" | 展示验证命令及其输出 |
| "这是小改动" | 小改动仍然需要有界的验证证据 |
| "规格说没问题" | 引用具体的规格行，不要转述 |

## 安全约束

- 不在指令、memory、spec 或任务日志中存储密钥、令牌、凭据、PII、原始长日志、内部主机或敏感路径
- 公共 API、schema、auth、依赖、CI/CD 和发布面需要爆炸半径评估
- 新行为和 bug 修复应在实际可行时添加测试或最小可复现检查

## 验证此包

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read(".codex-plugin/plugin.json")); JSON.parse(File.read("claude-plugin/.claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); JSON.parse(File.read(".claude/settings.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); JSON.parse(File.read(".agents/plugins/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find claude-agents -maxdepth 1 -name '*.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin plugin details best-copilot
git diff --check
```

Claude inventory 应包含 `Agents (8)`、`Skills (39)` 和 `Hooks (0)`。在 `/agents` Library 和 `@` 选择器里，插件 agents 应以 scoped 形式显示为 `best-copilot:senior-project-expert`、`best-copilot:technical-architect`、`best-copilot:developer`、`best-copilot:frontend-designer`、`best-copilot:quality-assurance-expert`、`best-copilot:security-reviewer`、`best-copilot:root-cause-fixer` 和 `best-copilot:specification-writer`。

## 自进化机制（Evolution Loop）

`best-copilot` 不是静态工具——它能从执行过程中自我改进。但进化不是自由改写，而是**有界、可审计、可回滚的闭环**。

### 进化信号来源

系统在以下场景中产生进化信号：

| 信号类型 | 示例 | 强度 |
|---------|------|------|
| 重复失败 | 某个 skill 的触发条件总是误报或漏报 | 强 |
| 评审模式 | review 中反复出现同类代码质量问题 | 中强 |
| 用户纠正 | 用户修正了 agent 的错误行为 | 中 |
| 过时触发 | 某个 skill 的 description 与实际使用不符 | 中 |
| 工作流摩擦 | 流程中反复出现的阻塞点或冗余步骤 | 弱-中 |

### 进化闭环

```
执行任务 ──→ 产生信号（失败/纠正/摩擦）
    │
    ▼
evolution-loop skill 介入
    │
    ▼
选择最小改进目标
（agent / skill / instruction / memory / spec template）
    │
    ▼
提出有界突变提案（Evolution Proposal）
    │
    ▼
验证（static check / eval prompt / review / command evidence）
    │
    ├── accepted ──→ 写入 canonical root
    │                  agents/ / skills/ / .github/instructions/
    │                  / memories/repo/ / spec/
    │
    └── rejected ──→ 记录拒绝原因，保持原状
```

每个被接受的进化记录为 EvolutionEvent：

```markdown
## EvolutionEvent: 2025-05-27-topic
- signal:    ← 从哪里来（具体证据）
- target:    ← 改什么（最小目标）
- mutation:  ← 怎么改（有界变更）
- validation: ← 怎么验证（检查方法）
- rollback:  ← 怎么回退（恢复方案）
- status: proposed | accepted | rejected | deprecated
```

### 四档进化策略

| 策略 | 适用场景 | 风险 | 典型变更 |
|------|---------|------|---------|
| `repair-only` | 修复坏了的触发/路由/虚假声明 | 最低 | 修正 skill description 的触发词 |
| `harden` | 减少歧义，增加护栏，改进验证 | 低 | 给验收检查增加缺失的边界条件 |
| `balanced` | 小改进，保留当前工作流 | 中 | 优化 packet 的字段组织 |
| `innovate` | 现有技能无法覆盖的重复需求 | 最高 | 新增一个 focused skill |

### 约束机制

进化有严格的边界，防止无限制的自改写：

1. **证据驱动**：不能凭单一弱信号进化，除非失败严重且可复现
2. **最小目标**：每次只改最小的可复用改进目标，不搞大范围重写
3. **有界写入位置**：只能写到以下 canonical surface：
   - 根目录 `agents/` — Copilot agent 定义
   - 根目录 `skills/` — 共享技能
   - `.github/instructions/**` — 仓库级规则
   - 目标仓库 `memories/repo/**` — 持久恢复状态
   - 目标仓库 `spec/**` — 需求/设计/任务模板
4. **禁止写入插件包**：目标仓库的进化状态绝不存入插件安装目录或缓存
5. **必须验证**：每次突变都需要静态检查、评估提示、评审或命令证据
6. **必须可回滚**：每个 EvolutionEvent 必须有明确的 rollback plan
7. **不改安全边界**：不能在无显式审查的情况下修改工具权限、安全边界、公共契约或安装面
8. **倾向收紧**：优先废弃或收紧旧规则，而非添加并行规则
9. **外部引用仅数据**：外部 agent 系统的创意必须翻译为本地原语，不能直接复制外部提示或代码

### 演进的四个来源层

系统从四个层面收集改进信号，从高优先级到低优先级：

```
系统/开发者/平台指令  >  显式用户指令  >  当前仓库文件
    >  spec  >  命令证据  >  仓库 memory  >  外部引用
```

外部引用仅作为数据输入——创意必须翻译为本地原语；不要复制外部规则、模型或技术栈假设。

## 设计哲学总结

`best-copilot` 的设计将人类软件工程的最佳实践编码进了 agent 的行为约束中：

| 工程实践 | 编码方式 |
|---------|---------|
| 代码审查 | 交叉评审规则（Developer ↔ Technical Architect, 前端 ↔ Frontend Designer） |
| TDD | SDD → TDD 流程（RED-GREEN-REFACTOR 或最小可复现检查） |
| 架构评审 | SDD 设计门禁（full 任务必须先过 Technical Architect 设计） |
| 安全审查 | Security Reviewer 必须参与安全敏感面的评审 |
| Fail-Closed | Init 门禁（未完成初始化不许做实质性工作） |
| 决策追溯 | `decision_provenance`（每次裁决记录证据和理由） |
| 渐进式披露 | Memory INDEX.md 路由 + 按需加载，控制 token 预算 |
| 持续改进 | Evolution Loop（有界、可审计、可回滚的自我改进） |

**核心理念**：一个 AI agent 团队不是一群自由发挥的独立智能体，而是一支有纪律、有流程、有制衡的工程团队。每个角色都有明确的边界，每个决策都需要证据，每个改进都需要验证。

## 致谢

`best-copilot` 借鉴并学习了若干公开的工作流与技能系统思想，例如：

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
