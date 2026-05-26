# best-copilot

[English](README.md) | [简体中文](README.zh-CN.md) | [한국어](README.ko.md) | 日本語

[![version](https://img.shields.io/badge/version-0.5.0-1d9bf0)](plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-f97316)](claude-plugin/.claude-plugin/plugin.json)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-38-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot` は、Copilot CLI と Claude Code で利用できるインストール可能なエージェントチームテンプレートで、真剣なエンジニアリング作業を対象としています。リポジトリに対してシニア品質のデリバリーフローを提供します：事実の初期化、範囲の固定、設計→構築、専門役割による実装、独立したレビュー、証拠に基づく検証、および次回セッションのための復帰ポイントの保持。

Copilot CLI は `plugin.json` 経由でルートの `agents/` と `skills/` を使います。Claude Code は `claude-plugin/` パッケージを使います：`claude-plugin/.claude-plugin/plugin.json`、`claude-plugin/skills -> ../skills`、`claude-plugin/agents -> ../claude-agents`。リポジトリレベルのルールは `.github/instructions/**` にあります。

## なぜ存在するのか

漠然とした要求から直接パッチに飛ぶと、大きな AI コーディング作業は失敗しがちです。`best-copilot` は欠けているデリバリーディシプリンを補います：

- **ひとつのシニア入口**：Senior Project Expert が意図、範囲、ディスパッチ、fan-in、集約、再利用可能なワークフロシグナルを担います。
- **8 つの専門エージェント**：計画、アーキテクチャ、実装、フロントエンド、QA、セキュリティ、根本原因修正、仕様作成を分担します。
- **38 のスキル**：ロール workflow、ブートストラップ、検索、計画、workspace isolation、TDD、設計レビュー、実行、Java/Python コーディングガイドライン、検証、branch closeout、フロントエンド監査、ワークフローの進化などを提供します。
- **ターゲットリポジトリのローカルメモリとスペック**：インストールされたプロジェクトは事実、ワークストリーム、メモリ、スペックをプラグインパッケージではなくターゲットリポジトリに保持します。
- **証拠優先のクローズ**：`done` の宣言はコマンド出力、静的チェック、ブラウザの証拠、または明示的なブロッカーが必要です。

## インストール

### Copilot CLI

リポジトリを Copilot CLI プラグインの marketplace として登録します：

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

登録済み marketplace からインストール：

```bash
copilot plugin install best-copilot@best-copilot
```

ローカル開発時は次のようにも実行できます：

```bash
copilot plugin marketplace add /absolute/path/to/best-copilot
copilot plugin install best-copilot@best-copilot
```

現在の Copilot CLI はリポジトリからの直接インストールにも対応しますが、CLI は直接インストールが非推奨であり将来は `plugin@marketplace` のみをサポートすると警告します：

```bash
copilot plugin install funky-eyes/best-copilot
```

ローカルの変更後は、新しい CLI セッションでテストする前にプラグインを再インストールまたは更新してください。

### Claude Code

Claude Code は独自の marketplace システムを使います。このリポジトリを Claude Code marketplace として追加し、プラグインをインストールします：

```text
/plugin marketplace add funky-eyes/best-copilot
/plugin install best-copilot@best-copilot
/reload-plugins
```

ローカル開発または現在の checkout から直接使う場合は、プラグインディレクトリを読み込めます：

```bash
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin
```

Claude Code agent team を使う場合は、起動前に agent teams を有効にします。Agent teams は Claude Code の実験的機能で、Claude Code v2.1.32 以降が必要です：

```bash
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin
```

Claude Code は次を検出します：

- marketplace メタデータ：[.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)
- プラグインメタデータ：[claude-plugin/.claude-plugin/plugin.json](claude-plugin/.claude-plugin/plugin.json)
- 共有スキル：[skills/](skills/)、呼び出し名は `/best-copilot:<skill-name>`
- Claude 互換 subagent：[claude-agents/](claude-agents/)
- 既定のメイン agent：[settings.json](settings.json) の `best-copilot:senior-project-expert`

ローカル変更またはプラグイン更新後は、Claude Code 内で `/reload-plugins` を実行するか、セッションを再起動してください。

## 使い方

要求のオーケストレーションは [agents/pm-coordinator.agent.md](agents/pm-coordinator.agent.md) のコーディネーターエージェントから始めます。このエージェントは UI では **Senior Project Expert** と表示され、意図、範囲、計画、ディスパッチ、レビュー fan-in、クローズを担当します。

- **Copilot CLI**：`/agent` を実行し、**Senior Project Expert** を選択してから作業内容を伝えます。
- **VS Code 拡張機能**：チャットのエージェントを手動で **Senior Project Expert** に切り替えてからタスクを開始します。
- **Claude Code**：`claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin` で開始します。プラグインの既定 agent は `best-copilot:senior-project-expert` です。`/agents` でプラグイン agent を確認し、`/best-copilot:<skill-name>` でスキルを直接呼び出せます。

Claude Code multi-agent プロンプト例：

```text
Create an agent team for this task. Use best-copilot:senior-project-expert as the lead.
Spawn teammates using best-copilot:technical-architect, best-copilot:developer,
best-copilot:quality-assurance-expert, and best-copilot:security-reviewer
where their scopes apply. Keep write sets non-overlapping,
prevent self-review, and report command evidence before closeout.
For each teammate, invoke /best-copilot:core-workflow-contract plus its
matching role workflow skill, or include the minimal role checklist fallback.
```

Claude Code は plugin agents、skills、agent teams によって Copilot 風の multi-agent ワークフローを実現できます。ただし Copilot のような複数モデルプロバイダー間のルーティングは再現しません。Claude アダプターは `model: inherit` を使うため、実際のモデルは Claude Code セッションの `/model`、`--model`、またはユーザー設定で決まります。

## ランタイムアダプター構成

共通の cross-role ルールは [skills/core-workflow-contract/SKILL.md](skills/core-workflow-contract/SKILL.md) に置きます。各ロール固有の workflow は `skills/*-workflow/` に分けます：`senior-project-expert-workflow`、`specification-writer-workflow`、`technical-architect-workflow`、`developer-workflow`、`frontend-designer-workflow`、`quality-assurance-workflow`、`security-reviewer-workflow`、`root-cause-fixer-workflow`。Copilot 専用の内容は [agents/](agents/) に置きます：モデル名、Copilot ツール、`user-invocable`、`agents`、`handoffs`。Claude 専用の内容は [claude-agents/](claude-agents/) の対応ファイルに置きます：scoped plugin agent 名、`model: inherit`、読み取り専用制限、agent-team モードで `skills` frontmatter が teammate に自動適用されない制限。

この構造は、共通動作、ロール固有動作、互換性のない runtime metadata を分離し、各 agent が共通 contract と自分のロール workflow の両方を読み込むようにします。

Claude agent の frontmatter は `core-workflow-contract` と対応するロール workflow だけをプリロードします。`structured-review`、`test-driven-development`、`web-experience-audit` などの focused skills は agent 本文で必要時に呼び出す形にして、起動時コンテキストを削減します。

Copilot handoff は fail-closed です。各 PM handoff prompt は `core-workflow-contract` と対象ロール workflow skill を要求します。ランタイムが skill を読み込めない場合は最小ロール checklist fallback を含め、どちらもない場合 specialist は `NEEDS_CONTEXT missing_required_skill` を返します。

## クイックチェック

```text
/agent
/skills list
```

期待されるパッケージ構成：

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

## ワークフロー

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

小規模なスコープの変更ではフローは軽く保たれますが、クロスモジュール作業、公開契約、依存、認可、または曖昧な製品方針がある場合はより重いゲートが意図的に存在します。

## エージェントチーム

| Agent | 担当 | 非担当 |
| --- | --- | --- |
| Senior Project Expert | 意図、範囲、オーケストレーション、ディスパッチ、fan-in、クローズ、進化シグナル | プロダクション実装の直接担当 |
| Specification Writer | 証拠収集、requirements/design/tasks、ADR、memory/spec の復元 | プロダクション実装 |
| Technical Architect | フルスタック設計、SDD brainstorming、API/データ/サービス境界、主線実装、並列分解、Developer/Frontend Designer 作業のレビュー | 最終的なフロントエンド polish、タスク統括 |
| Developer | 固定された実装スライス、実装可否レビュー、Technical Architect 管轄コードのレビュー | アーキテクチャ変更や範囲拡大 |
| Frontend Designer | ページ、コンポーネント、インタラクション、レスポンシブ、ブラウザ検証、フロントエンドレビュー | バックエンドの主線 |
| Quality Assurance Expert | 機能検証、回帰リスク、コードレビュー、peer lane 後のマージ準備 | セキュリティ専用レビュー |
| Security Reviewer | 認可、機密データフロー、依存リスク、リリース面のセキュリティ | 一般的な機能 QA |
| Root Cause Fixer | フェイル切り分け、最小パッチ、回帰検証 | 根拠のないリファクタリング |

## スキルマップ

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

## 初回のターゲットリポジトリでの使用

新しいリポジトリで有意義な作業を始める前に、現在のランタイムにプロジェクトを確認させてください：

```text
/init
```

Copilot CLI では shell コマンドも使えます：

```bash
copilot init
```

その後、**Senior Project Expert** / `best-copilot:senior-project-expert` から実作業を始めます。対象のリポジトリ内で有用な事実を正規化し、欠けているローカルのスキャフォールドを作成し、実装に入る前にこれらのファイルが存在することを検証します。

ターゲットローカル状態はターゲットリポジトリに属します：

```text
.github/instructions/project.instructions.md
.github/instructions/must.instructions.md
.github/instructions/skills-index.instructions.md
CLAUDE.md  # Claude Code 互換が必要な場合
memories/repo/INDEX.md
memories/repo/current-workstreams.md
spec/INDEX.md
spec/templates/
```

必要な事実やスキャフォールドを作成できない場合、作業は `BLOCKED first_use_gate_incomplete` として停止すべきです。

## モデル戦略

各エージェントは `agents/*.agent.md` にモデルを宣言します：

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

Claude Code は Claude モデルのみを実行します。`claude-agents/*.md` の Claude アダプターは役割分離を保ち、`model: inherit` を使うため、実際のモデルは現在の Claude Code セッションが制御します。

## このパッケージの検証

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read("claude-plugin/.claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find claude-agents -maxdepth 1 -name '*.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin plugin details best-copilot
git diff --check
```

Claude inventory には `Agents (8)` が表示され、`senior-project-expert`、`technical-architect`、`developer`、`frontend-designer`、`quality-assurance-expert`、`security-reviewer`、`root-cause-fixer`、`specification-writer` が含まれている必要があります。

## 進化ルール

`best-copilot` はエージェントが勝手に自分自身を書き換えることを許しません。進化は検証されたシグナルに基づくべきです。

## 謝辞

この実装は以下の公開プロジェクトからアイデアを得ています：

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
