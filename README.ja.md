# best-copilot

[English](README.md) | [简体中文](README.zh-CN.md) | [한국어](README.ko.md) | 日本語

[![version](https://img.shields.io/badge/version-0.7.0-1d9bf0)](plugin.json)
[![Codex](https://img.shields.io/badge/Codex-plugin-111827)](.codex-plugin/plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-f97316)](claude-plugin/.claude-plugin/plugin.json)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-39-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot` は、Codex、Copilot CLI、Claude Code で利用できるインストール可能なエージェントチーム workflow で、真剣なエンジニアリング作業を対象としています。リポジトリに対してシニア品質のデリバリーフローを提供します：事実の初期化、範囲の固定、設計→構築、専門役割による実装、独立したレビュー、証拠に基づく検証、および次回セッションのための復帰ポイントの保持。

Codex は `.codex-plugin/plugin.json`、`.agents/plugins/marketplace.json`、`.agents/skills -> ../skills` を使います。Copilot CLI は `plugin.json` 経由でルートの `agents/` と `skills/` を使います。Claude Code は `claude-plugin/` パッケージを使います：`claude-plugin/.claude-plugin/plugin.json`、`claude-plugin/skills -> ../skills`、`claude-plugin/agents -> ../claude-agents`。リポジトリレベルのルールは `.github/instructions/**` にあります。

## なぜ存在するのか

漠然とした要求から直接パッチに飛ぶと、大きな AI コーディング作業は失敗しがちです。`best-copilot` は欠けているデリバリーディシプリンを補います：

- **ひとつのシニア入口**：Senior Project Expert が意図、範囲、ディスパッチ、fan-in、集約、再利用可能なワークフロシグナルを担います。
- **八つの専門エージェント**：計画、アーキテクチャ、実装、フロントエンド、QA、セキュリティ、根本原因修正、仕様作成を分担します。
- **三十九のスキル**：ロール workflow、ブートストラップ、検索、計画、workspace isolation、TDD、設計レビュー、実行、Java/Python コーディングガイドライン、検証、branch closeout、フロントエンド監査、ワークフローの進化、Senior Project Expert 互換エントリポイントなどを提供します。
- **ターゲットリポジトリのローカルメモリとスペック**：インストールされたプロジェクトは事実、ワークストリーム、メモリ、スペックをプラグインパッケージではなくターゲットリポジトリに保持します。
- **証拠優先のクローズ**：`done` の宣言はコマンド出力、静的チェック、ブラウザの証拠、または明確なブロッカーが必要です。

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

ローカルの変更後は、新しい CLI セッションでテストする前にプラグインを再インストールまたは更新してください。Copilot CLI はインストール済みプラグインキャッシュからエージェントとスキルを読み取ります。

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

Claude Code で Senior Project Expert を確実な入口にするには、その agent にセッション全体を担当させます：

```bash
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert
```

プラグインをインストール済みなら、通常は次のように短くできます：

```bash
claude --agent senior-project-expert
```

Claude Code は次を検出します：

- marketplace メタデータ：[.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)
- プラグインメタデータ：[claude-plugin/.claude-plugin/plugin.json](claude-plugin/.claude-plugin/plugin.json)
- 共有スキル：[skills/](skills/)。Claude Code では `/best-copilot:repo-init-gate` のような名前空間付き slash command で呼び出します。コマンドピッカーが別のプラグイン表示形式を挿入する場合は、その値を使います。
- Claude 互換 subagent：[claude-agents/](claude-agents/)
- PM メインセッションは `--agent senior-project-expert` または Claude Code のプロジェクト/ユーザー `agent` 設定で選択します。`/agents` と `@` typeahead では `best-copilot:senior-project-expert` のような scoped 名で plugin subagent が表示されるため、手動 `@` mention や Agent-tool dispatch では表示名を使います。

ローカル変更またはプラグイン更新後は、Claude Code 内で `/reload-plugins` を実行するか、セッションを再起動してください。

## 使い方

要求のオーケストレーションは **Senior Project Expert** PM コーディネーターから始めます。意図、範囲、計画、ディスパッチ、レビュー fan-in、クローズを担当します。

- **Copilot CLI**：`/agent` を実行し、**Senior Project Expert** を選択してから作業内容を伝えます。Copilot は `handoffs:` 宣言を使って専門家をルーティングします。
- **VS Code 拡張機能**：チャットのエージェントを手動で **Senior Project Expert** に切り替えてからタスクを開始します。
- **Claude Code**：PM がメインセッションとして **Agent tool** を使って専門家サブエージェントを呼び出します。

### Claude Code の起動方法

```bash
# 方法 1: PM agent の明示的指定（推奨）
claude --agent senior-project-expert
# Claude が agent 名の衝突を報告する場合:
# claude --agent best-copilot:senior-project-expert

# 方法 2: .claude/settings.json でデフォルト agent を設定（毎回指定不要）
# ターゲットリポジトリの .claude/settings.json に追加:
# { "agent": "senior-project-expert", "worktree": { "baseRef": "head" } }

# 方法 3: ローカルプラグイン開発
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin --agent senior-project-expert
```

### Claude Code マルチエージェントの仕組み

PM（`senior-project-expert`）がメインセッションとしてユーザー要求を受信した後：

1. `/best-copilot:repo-init-gate` で初期化プリチェック実行
2. 意図分析、作業分類（micro/standard/full）、ディスパッチパッケージの固定
3. `/agents` に表示される scoped 名を使って **Agent tool** で専門家サブエージェントを生成（例：`best-copilot:technical-architect`、`best-copilot:developer`）
4. 権限が事前に許可され、独立した調査/読み取り専用 review のときだけ background 実行を選択
5. 実装、修正、spec/memory 書き込み、権限確認が必要になり得る検証はデフォルトで foreground 実行
6. 競合の可能性がある実装は `isolation: "worktree"` で隔離し、worktree パス、ブランチ、変更ファイル、検証証拠を回収
7. isolated worktree の変更について `/best-copilot:development-branch-closeout` または同等の keep / merge / PR / discard 判断を行ってから、変更が取り込まれたと主張
8. PM がすべてのサブエージェントの結果を収集して fan-in 仲裁
9. `/best-copilot:verification-before-completion` を呼び出してからユーザーに提供

Claude Code では plugin subagent は scoped 形式で表示されます：`best-copilot:technical-architect`、`best-copilot:developer`、`best-copilot:frontend-designer`、`best-copilot:quality-assurance-expert`、`best-copilot:security-reviewer`、`best-copilot:specification-writer`、`best-copilot:root-cause-fixer`。

Claude アダプターは `claude-agents/*.md` で Claude モデル alias を使います：GPT-5.4 対応ロールは `opus`、Gemini 対応ロールは `haiku`、Claude Sonnet ロールは `sonnet` です。ネイティブ Claude Code では、これらの alias によって Copilot 側のロール階層を Claude のモデル群内に保ちます。`cc-switch`、`new-api`、または他の Anthropic-compatible proxy がこれらの alias を DeepSeek、Qwen、その他の非 Claude backend にルーティングする場合、まずそのルーティングされたセッションで plugin が有効になっていることを確認してください。`/plugin list` には `best-copilot@best-copilot`、`/agents` には `best-copilot:senior-project-expert` などの scoped agent が表示される必要があります。proxy allowlist が必要な場合は `"enabledPlugins": {"best-copilot@best-copilot": true}` を含めます。その後も、PM が source reading や implementation の前に `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION` を出力し、必要な specialist lanes と `repo-init-gate` / `repo-init-scan` の流れに入るまでは degraded とみなしてください。

## ランタイムアダプター構成

### 三層分離原則

```
                    ┌─────────────────────────────────┐
                    │   共有契約層 (Shared Contract)    │
                    │   core-workflow-contract         │
                    │   + 各ロール role-*-workflow      │
                    └──────────────┬──────────────────┘
                                   │
                  ┌────────────────┴────────────────┐
                  │                                  │
        ┌─────────▼──────────┐          ┌────────────▼─────────┐
        │  Copilot CLI アダプタ│          │  Claude Code アダプタ  │
        │                    │          │                       │
        │  agents/*.agent.md │          │  claude-agents/*.md   │
        │  model: GPT-5.4 等 │          │  model: opus/haiku/...│
        │  handoffs: 宣言    │          │  Agent tool ディスパッチ│
        │  vscode_askQ...    │          │  AskUserQuestion      │
        │                    │          │                       │
        │  skills/ 直接読取   │          │  claude-plugin/       │
        │                    │          │    agents -> symlink  │
        │                    │          │    skills -> symlink  │
        └────────────────────┘          └───────────────────────┘
```

共通の cross-role ルールは [skills/core-workflow-contract/SKILL.md](skills/core-workflow-contract/SKILL.md) に置きます。各ロール固有の workflow は `skills/*-workflow/` に分けます：`senior-project-expert-workflow`、`specification-writer-workflow`、`technical-architect-workflow`、`developer-workflow`、`frontend-designer-workflow`、`quality-assurance-workflow`、`security-reviewer-workflow`、`root-cause-fixer-workflow`。Copilot 専用の内容は [agents/](agents/) に置きます：モデル名、Copilot ツール、`user-invocable`、`agents`、`handoffs`。Claude 専用の内容は [claude-agents/](claude-agents/) の対応ファイルに置きます：Claude Code に表示される agent 名、Claude モデル alias（`opus`、`sonnet`、`haiku`）、読み取り専用制限、`isolation: worktree`、PM が所有する foreground/background dispatch 方針。

この構造は、共通動作、ロール固有動作、互換性のない runtime metadata を分離し、各 agent が共通 contract と自分のロール workflow の両方を読み込むようにします。

### スキル読み込みルール

| シナリオ | 動作 |
|---------|------|
| Claude PM メインセッション | PM の `skills:` frontmatter 宣言的プリロード |
| Claude サブエージェント（PM spawn） | サブエージェントは自身の `skills:` frontmatter から読み込む。PM の spawn prompt にタスクコンテキストと必要スキルを含める必要 |
| Claude ベースセッション | agent の `skills:` 未活性化、手動呼び出し必要 |
| Copilot CLI | 本文参照は機械的プリロードではない、パケットに最小チェックリスト含む必要 |

Claude agent の frontmatter は通常 `core-workflow-contract` と対応ロール workflow のみプリロードします。Senior Project Expert は init preflight が必須の起動ゲートであるため、`repo-init-gate` と `repo-init-scan` もプリロードします。`structured-review`、`test-driven-development`、`web-experience-audit` などの他の focused skills は agent 本文で必要時に呼び出す形にして、起動時コンテキストを削減します。

### デュアルランタイム比較

| 次元 | Copilot CLI | Claude Code |
|------|-------------|-------------|
| エントリ agent | `agents/pm-coordinator.agent.md` | `claude-agents/senior-project-expert.md`（`--agent` または `.claude/settings.json` 経由） |
| モデル指定 | `GPT-5.4 (copilot)` 等の具体的名前 | `model: opus` / `haiku` / `sonnet` のロール階層 alias |
| 専門家ディスパッチ | `handoffs:` 宣言 + `agent` tool | PM メインセッションが **Agent tool** で spawn |
| 並列実行 | handoff 宣言が自動処理 | PM が安全な独立調査/読み取り専用 review だけ background を選択 |
| ファイル隔離 | Copilot 組み込み | `isolation: "worktree"` + PM closeout |
| ユーザーインタラクション | `vscode_askQuestions` / `Asking user` | 組み込み `AskUserQuestion` |
| スキル発見 | ルート `skills/` から直接読取 | `claude-plugin/skills -> ../skills` シンボリックリンク |
| Agent 発見 | ルート `agents/` から直接読取 | `claude-plugin/agents -> ../claude-agents` シンボリックリンク |
| クロスモデルルーティング | サポート（GPT / Gemini / Claude 混在） | Claude モデル階層 alias のみ |

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

## コアワークフロー

すべてのタスクは、transcript で各ステップを確認できる観察可能なステージチェーンを通過します：

```
INIT_GATE → [必要に応じて INIT_SCAN] → CLASSIFY → FREEZE_PACKET → LANE_SELECTION
  → [full/曖昧/high-risk の場合 ARCHITECT_SDD] → REVIEW_OR_DISPATCH
  → FAN_IN_ARBITRATION → NEXT_GATE
```

### 行動信頼性ゲート

`FREEZE_PACKET` と実行段階では、次の制約を保持します：

- 前提、トレードオフ、最も単純な実行可能案を明示します。不確実性が実装、ルート、受け入れ基準を変える場合は、推測せず質問します。
- 成功基準を満たす最小変更を選びます。投機的機能や一回限りコードの抽象化は追加しません。
- 手術的変更：すべての変更行はユーザー目標、受け入れチェック、または検証修正に追跡可能であるべきです。隣接コード、コメント、フォーマットをついでに整えません。
- 書く前に読む：コード変更前に対象ファイルの public surface/exports、直接 caller/callee、明らかな共有ユーティリティやローカルパターンを読みます。
- 成功基準、制約、検証、停止条件で実行を駆動します。依存関係、安全性、検証上必要な場合だけ手順を指定します。複数ステップ作業では重要ステップごとに checkpoint を残します。

### ステージ 1: Init ゲート（必須プリフライト）

ターゲットリポジトリで実質的な作業を行う前に、システムはまず `repo-init-gate` を実行します——ターゲットリポジトリルートの `best-copilot.md` のみを読み、frontmatter の `version` が現在の契約バージョン `"0.7.0"` と一致するか確認します。

```
repo-init-gate
  │
  ├── バージョン一致 → ready → スキップ、次のステージへ
  │
  └── 欠失/不一致/無効 → needs_init
                           │
                           ▼
                    repo-init-scan
                      │
                      ├── Stage 1: repo-init-official
                      │     /init または copilot init を試行
                      │     出力 → project.instructions.md
                      │
                      └── Stage 2: repo-init-manual-fallback
                            手動スキャン → スキャフォールド作成
                            target-instructions-bootstrap
                            target-memory-bootstrap
                            target-spec-bootstrap
                            │
                            └── best-copilot.md sentinel 記録
```

これは **Fail-Closed** 設計です：init が完了するまで、計画、実装、レビューは許可されません。推測に基づく継続ではなく `BLOCKED` を返します。`repo-init-scan` が `next_task_ready: yes` を報告した場合のみ、後続ステージへの進入が許可されます。

### ステージ 2: タスク分類

システムは各タスクを 3 レベルに分類します：

| レベル | 該当シナリオ | プロセスの重さ |
|--------|------------|--------------|
| `micro` | 微細編集/確認、パブリック契約・セキュリティ・クロスモジュールリスクなし | 直接実行 |
| `standard` | 境界のあるファイルセット、単一オーナーサーフェス | 簡潔パケット、集中レビュー |
| `full` | 曖昧、クロスモジュール、パブリック API/schema/auth/依存関係/CI/フロントエンド体験 | 完全計画、SDD 設計レビュー、fan-in ゲート |

`task_type` はサイズとは独立に動作を追跡します：`implementation`（書き/更新）、`design_review`（実装せずに評価）、`verification`（リスクレビュー/マージ準備）、`fix`（境界のある修正）、`spec`（要件/設計/タスク、プロダクションコード非作成）。

### ステージ 3: コンテキスト固定（6ブロックディスパッチパケット）

PM は意図を標準の **6ブロックディスパッチパケット**（PM Dispatch Packet）に固定します。これはクロスロール通信の統一プロトコルです：

```markdown
1. task_intent     — 目標、ユーザーパス、意図要約、期待結果、task_type、work_mode
2. frozen_scope    — 範囲、非目標、関連ファイル、変更ファイル、優先/既読ファイル、依存関係
3. fact_packet     — 権威あるリポジトリ事実、出典参照、参照ファイル
4. execution_contract — 前提、トレードオフ、最も単純な案、制約、受容チェック、検証/コンテキスト予算、停止条件、禁止メソッド、書く前に読む対象
5. review_state    — 後続範囲、検証済項目、レビューレーン、準備済成果物
6. output_contract — 必要スキル、ロールチェックリスト代替、必要成果物、次のステージ
```

**なぜパケットを使うのか？** 各専門家は完全な会話履歴ではなく、固定された境界のあるコンテキストを受け取るためです。これにより「あるエージェントの推測が別のエージェントの事実になる」ことを防ぎ、すべてのディスパッチが追跡可能で監査可能であることを保証します。

### ステージ 4: SDD 設計ゲート

`full`、曖昧、高リスク、パブリック契約、auth/セキュリティ、依存関係、schema、またはフロントエンド体験のタスクでは、実装の前に **Technical Architect 主導の SDD（Spec-Driven Design）設計ブレインストーミング** が必要です：

1. PM が設計タスクを Technical Architect にディスパッチ
2. Technical Architect が SDD 設計ブレインストーミングとセルフレビュー/修正を実施
3. PM が Developer + QA に 2 回目の設計レビューをディスパッチ
4. フロントエンド UI が関連する場合、Frontend Designer が参加
5. ブロッキング発見は Technical Architect に修正依頼、PM は影響を受けたレビューレーンのみ再実行
6. レビューを通過した設計のみ実装に進むことが許可

`standard` タスクの場合、ARCHITECT_SDD をスキップし効率性のために理由を記録します——境界があり曖昧でない標準作業にはアーキテクチャ SDD を強制しません。

### ステージ 5: 並列ディスパッチと実行

設計レビュー通過後、PM は `writing-plans` を通じて作業を並列化可能なタスクに分割します：

- 独立したファイル所有権と書き込みセット（重複なし）
- 明確な依存関係と受容チェック
- 指定されたオーナーレーンとレビューレーン

ディスパッチ実行は `subagent-driven-development` または `executing-plans` を通じて進行します：

```
各準備完了タスクについて：
  1. フレッシュなコンテキストパケットを構築（context-packet-fastpath）
  2. 対応する専門家に実装ディスパッチ
     - Technical Architect: フルスタックアーキテクチャ/メインラインスライス
     - Developer: 境界のあるスライス
     - Frontend Designer: UI 所有のスライス
     - Root Cause Fixer: 確認済みの失敗
  3. 実装証拠を要求：変更ファイル、書く前に読んだ証拠、実行テスト/チェック、キー出力、リスク
  4. Stage 1 レビュー：スペック/タスク準拠（要件、非目標、ファイル境界、受容チェック）
  5. Stage 2 レビュー：コード品質とリリースリスク（保守性、結合度、セキュリティ/パフォーマンスリスク、デッドコード、テスト十分性）
  6. 発見が修正サイクルに入ることを確認
  7. すべての必須レビューと検証を通過した後のみ、PM がタスク完了をマーク可能
```

**重要ルール：Stage 1 と Stage 2 のレビュアーは実装者本人であってはなりません。** レビューレーンはクロスレビュールールに従います（下記参照）。

### ステージ 6: Fan-In 仲裁

PM は優先度に従ってすべての専門家の結果を裁定します：

1. **ブロッカー**：`BLOCKED`、`NEEDS_USER_INPUT`、無効な handback、繰り返しの `NEEDS_CONTEXT`
2. **セキュリティ**：セキュリティ、プライバシー、データ損失、auth、依存関係、リリース、破壊的操作リスク
3. **検証**：失敗/欠落した検証、証明されていない完了宣言
4. **スコープ**：スペック不一致、スコープクリープ、書き込みセット重複
5. **品質**：コード品質、保守性、パフォーマンス、UX、アクセシビリティ、テスト十分性
6. **非ブロッキング**：後続注意事項

レビュアーの意見が一致しない場合、PM は `decision_provenance` を記録します（証拠、ブロッキングステータス、次のステージ、残存リスク）。未解決の競合は fan-out または closeout を許可しません。

### クロスレビュールール

| レビュー対象コード | レビュアー |
|------------------|----------|
| Developer コード | Technical Architect |
| Technical Architect コード | Developer |
| Developer/Technical Architect フロントエンドコード | Frontend Designer |
| Frontend Designer コード | Technical Architect |
| すべてのコード（最終） | QA（マージ準備） |
| セキュリティ敏感サーフェス | Security Reviewer（必須） |

### ステージ 7: 検証とクローズアウト

クローズ前に、システムは `verification-before-completion` 最終チェックを実行します：

- 要件/ユーザーリクエストが満たされた
- 変更ファイルがタスクスコープ内に境界
- プレースホルダー、デッド参照、古い名前、壊れたリンクがない
- テスト/ビルド/ブラウザチェック/静的検証が実行済み（または明示的なスキップ報告）
- 残存リスクと次のステージが明確
- Native Ask UI で最終確認/継続（プレーンテキスト要約ではなく）

### 小規模タスクの簡潔パス

`micro` レベルのタスクでは、上記のフローは簡潔に保たれます——直接実行、SDD 設計・並列ディスパッチ・多段レビューをスキップ。しかし最小の変更でも完了マーク前に `verification-before-completion` チェックが必要です。

## エージェントチーム

| Agent | 担当 | 非担当 |
| --- | --- | --- |
| Senior Project Expert | 意図、範囲、オーケストレーション、ディスパッチ、fan-in、クローズ、進化シグナル | プロダクション実装の直接担当 |
| Specification Writer | 証拠収集、requirements、design、tasks、ADR、memory/spec の復元 | プロダクション実装 |
| Technical Architect | フルスタック設計、SDD brainstorming、API/データ/サービス境界、主線実装、並列分解、Developer/Frontend Designer 作業のレビュー | 最終的なフロントエンド polish、タスク統括 |
| Developer | 固定された実装スライス、実装可否レビュー、アーキテクト担当コードのピアレビュー | アーキテクチャ変更や範囲拡大 |
| Frontend Designer | ページ、コンポーネント、インタラクション、レスポンシブ、ブラウザ証拠、フロントエンドレビュー | バックエンドの主線 |
| Quality Assurance Expert | 機能検証、回帰リスク、コードレビュー、peer lane 後のマージ準備 | セキュリティ専用レビュー |
| Security Reviewer | 権限、機密データフロー、依存関係、リリース面のセキュリティ | 一般的な機能 QA |
| Root Cause Fixer | 失敗診断、最小パッチ、回帰検証 | 根拠のないリファクタリング |

## 専門家通信プロトコル

### 専門家質問境界（Specialist Ask Boundary）

すべての specialist（PM 以外の役割）は**ユーザーに直接質問できません**。これはハード制約です：

```
専門家が情報必要
  │
  ├── コンテキスト不足 → PM に NEEDS_CONTEXT を返す
  │                       clarification_request + pm_action: "pm_clarify" を含む
  │
  └── ユーザー入力必要 → PM に NEEDS_USER_INPUT を返す
                          question, why_blocking, options,
                          safe_default, resume_prompt_for_pm を含む
```

PM/コーディネーターのみが Native Ask メカニズム（Copilot: `vscode_askQuestions` / `Asking user`；Claude: `AskUserQuestion`）を使ってユーザーに質問できます。

### Native Ask 契約

- トップレベルセッションまたは PM/コーディネーターのみがネイティブ質問を使用可能
- 各質問は自由形式回答を許可する必要がある（固定選択 UI は「Custom answer」を含む必要がある）
- Native Ask UI が利用可能な場合、プレーンテキスト要約でターンを終了してはならない
- UI が利用できずユーザー選択が必要な場合 → `BLOCKED missing_native_ask_ui` を報告

### 専門家返却構造（Structured Handback）

各 specialist は標準化された構造化結果を返します：

```markdown
- task_id:                タスク識別子
- current_stage:          現在のステージ
- status:                 DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT |
                          NEEDS_USER_INPUT | BLOCKED
- summary:                完了要約
- artifacts:              成果物（ファイル、テスト、証拠）
- risks:                  リスク
- uncovered_items:        未処理項目
- recommended_next_stage: 推奨次のステージ
```

## Memory と Spec システム

### デュアルトラック永続化

`best-copilot` はターゲットリポジトリに 2 つの永続化システムを維持します：

```
ターゲットリポジトリ
├── spec/                          ← スペック：要件/設計/タスクの権威あるソース
│   ├── INDEX.md                   ← スペックルーティングテーブル
│   └── templates/                 ← 再利用可能なテンプレート
│
├── memories/repo/                 ← メモリ：復帰インデックス
│   ├── INDEX.md                   ← メモリルーティングテーブル
│   ├── current-workstreams.md     ← 現在のアクティブな作業
│   ├── project-state.md           ← プロジェクト状態スナップショット
│   ├── decisions.md               ← 意思決定記録
│   └── workflow-rules.md          ← メモリ/スペック調整ルール
│
├── .github/instructions/          ← リポジトリレベルルール
│   ├── project.instructions.md    ← プロジェクト事実（build/test/フレームワーク/エントリポイント）
│   ├── must.instructions.md       ← コアルール
│   └── skills-index.instructions.md ← スキルルーティング
│
└── best-copilot.md               ← Init sentinel（version: "0.7.0"）
```

### Spec vs Memory の分担

| 次元 | Spec | Memory |
|------|------|--------|
| 権威性 | 要件/設計/タスクの**権威あるソース** | **復帰インデックス**——現在の焦点、意思決定、最後の検証、次のアクション |
| 内容 | 要件ドキュメント、設計ドキュメント、タスクリスト、受容チェック | ワークフローステータス、検証済み意思決定、復帰プロンプト、圧縮事実 |
| 含まない | ログを保存しない、ステータスを保存しない | 要件スペックを保存しない、設計ドキュメントを保存しない |
| 調整ルール | — | メモリは現在のリポジトリファイル、コマンド出力、システム指示、または明示的ユーザー指示を決して上書きしない |

### 段階的情報開示

メモリは **INDEX.md ルーティング + オンデマンドローディング** を使用してトークン予算を管理します：

```
1. INDEX.md を読む（ルーティングテーブル）
2. アクティブな作業を復帰する場合、current-workstreams.md を読む
3. linked_spec と linked_memory を辿る
4. 選択されたメモリファイルの関連セクションのみロード
5. ソース追跡が必要な場合のみ archive/logs にフォールバック
```

各メモリファイルには `load_tier` タグがあります：`task-active`（アクティブタスク時にロード）、`task-reference`（参照時にオンデマンドロード）、`archive-reference`（追跡時にのみロード）。

### MEDIUM/LARGE 作業の双方向リンク

中〜大規模作業はスペックとメモリの間に双方向リンクを確立します：

- `current-workstreams.md` の各ワークフローは対応するスペックを指す `linked_spec` を持ちます
- `spec/INDEX.md` の各スペックは関連メモリを逆参照できます
- EvolutionEvent 記録には signal、target、mutation、validation、rollback、status のすべてのフィールドが必要です

## スキルマップ

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

## 初回のターゲットリポジトリでの使用

初期化は**自動的**に行われます——手動で `/init` や `copilot init` を実行する必要はありません。PM agent が起動すると、[コアワークフロー Stage 1](#ステージ-1-init-ゲート必須プリフライト) が自動的に `repo-init-gate` → `repo-init-scan` を実行し、リポジトリ事実の収集とスキャフォールドの作成を完了します。

Claude Code で PM を直接起動するだけです：

```bash
claude --agent senior-project-expert
```

初期化フローはターゲットリポジトリに以下のローカルファイルを作成します：

```text
.github/instructions/project.instructions.md    ← プロジェクト事実（build/test/フレームワーク/エントリポイント）
.github/instructions/must.instructions.md       ← コアルール
.github/instructions/skills-index.instructions.md ← スキルルーティング
CLAUDE.md                                        ← Claude Code 互換（任意）
memories/repo/INDEX.md                           ← 復帰インデックスルーティングテーブル
memories/repo/current-workstreams.md             ← 現在のアクティブな作業
spec/INDEX.md                                    ← スペックルーティングテーブル
spec/templates/                                  ← 再利用可能なテンプレート
best-copilot.md                                  ← Init sentinel（version: "0.7.0"）
```

必要な事実やスキャフォールドを作成できない場合、推測に基づく継続ではなく `BLOCKED first_use_gate_incomplete` として停止します——完全な説明は[コアワークフロー Stage 1](#ステージ-1-init-ゲート必須プリフライト)を参照してください。

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

ネイティブ Claude Code は Claude モデル alias を使います。`claude-agents/*.md` の Claude アダプターは役割分離を保ち、Copilot 階層を Claude alias に対応させます：GPT-5.4 -> `opus`、Gemini 3.1 Pro (Preview) -> `haiku`、Claude Sonnet 4.6 -> `sonnet`。`cc-switch` や `new-api` などの proxy route は、これらの alias を非 Claude モデルにマップすることがあります。これは API 互換であり、workflow 互換を意味しません。DeepSeek、Qwen、unknown backend では、まず plugin が有効か確認してください。`/plugin list` には `best-copilot@best-copilot`、`/agents` には scoped plugin agents が表示され、`cc-switch` / `new-api` allowlist を使う場合は `"enabledPlugins": {"best-copilot@best-copilot": true}` が必要です。その後、実作業の前に非破壊の workflow smoke check を実行してください。期待される動作は、PM が `PROVIDER_COMPAT -> INIT_GATE -> CLASSIFY -> FREEZE_PACKET -> LANE_SELECTION` を出力し、その後 request に必要な lanes を dispatch することです。plugin が有効でも coding を始めたり init/lanes をスキップする場合は、smoke check を通過する model/provider を使ってください。

## 検索規律

システムはトークン消費を制御し正確性を向上させるため、情報検索時に厳格な優先順位に従います：

```
明示的ユーザーパス → 変更ファイル → 固定された files_involved → リポジトリインデックス
  → ファイル名/glob → 固定文字列 rg -F → 正規表現（最後の手段）
```

- クラス名、メソッド、ルート、設定キーには `rg -F` 固定文字列検索を優先
- 正規表現は本当に曖昧な場合、または正確な検索が失敗した場合にのみ使用し、理由を記録
- リポジトリ全体の正規表現を回避；最小ディレクトリに限定；2回の検索で新しいシグナルがなければ停止
- 並行性/馴染みのないパターン/インフラ設計前に、ランタイム/フレームワークの組み込みを先に検索（実績あり → 最新トレンド → 第一原理）

## 合理化防止チェック

「完了」を宣言する前に、システムはこれらの一般的な自己欺瞞パターンを自動チェックします：

| 言い訳 | 反論 |
|--------|------|
| "後でテストを追加する" | テストは作業の一部であり、後続作業ではない |
| "自分のマシンでは動く" | 検証コマンドとその出力を示せ |
| "小さな変更だ" | 小さな変更でも境界のある検証証拠が必要だ |
| "スペックで問題ないと言っている" | 具体的なスペック行を引用し、要約するな |

## セキュリティ制約

- 指示、メモリ、スペック、タスクログにキー、トークン、認証情報、PII、生の長いログ、内部ホスト、または機密パスを保存しない
- パブリック API、スキーマ、auth、依存関係、CI/CD、リリース面には爆発半径評価が必要
- 新しい動作とバグ修正は、実質的に可能な場合テストまたは最小再現チェックを追加する

## このパッケージの検証

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read(".codex-plugin/plugin.json")); JSON.parse(File.read("claude-plugin/.claude-plugin/plugin.json")); JSON.parse(File.read(".claude-plugin/marketplace.json")); JSON.parse(File.read("settings.json")); JSON.parse(File.read(".claude/settings.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); JSON.parse(File.read(".agents/plugins/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills,claude-agents}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find claude-agents -maxdepth 1 -name '*.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
claude --plugin-dir /absolute/path/to/best-copilot/claude-plugin plugin details best-copilot
git diff --check
```

Claude inventory には `Agents (8)`、`Skills (39)`、`Hooks (0)` が表示される必要があります。`/agents` Library と `@` typeahead では、plugin agents は `best-copilot:senior-project-expert`、`best-copilot:technical-architect`、`best-copilot:developer`、`best-copilot:frontend-designer`、`best-copilot:quality-assurance-expert`、`best-copilot:security-reviewer`、`best-copilot:root-cause-fixer`、`best-copilot:specification-writer` のような scoped 形式で表示されます。

## 自己進化メカニズム（Evolution Loop）

`best-copilot` は静的ツールではありません——実行プロセスから自己改善が可能です。しかし進化は自由な書き換えではなく、**境界があり、監査可能で、ロールバック可能なクローズドループ**です。

### 進化シグナルソース

システムは以下のシナリオで進化シグナルを生成します：

| シグナルタイプ | 例 | 強度 |
|--------------|---|------|
| 繰り返し失敗 | 特定スキルのトリガー条件が常に誤検出または見逃し | 強 |
| レビューパターン | レビューで同じコード品質問題が繰り返し発生 | 中強 |
| ユーザー訂正 | ユーザーがエージェントの誤った動作を修正 | 中 |
| 陳腐化トリガー | 特定スキルの description が実際の使用と一致しない | 中 |
| ワークフロー摩擦 | プロセスで繰り返し発生するブロッキングポイントや冗長ステップ | 弱-中 |

### 進化クローズドループ

```
タスク実行 → シグナル生成（失敗/訂正/摩擦）
    │
    ▼
evolution-loop スキル介入
    │
    ▼
最小改善目標選択
（agent / skill / instruction / memory / spec template）
    │
    ▼
境界のある変異提案（Evolution Proposal）
    │
    ▼
検証（静的チェック / 評価プロンプト / レビュー / コマンド証拠）
    │
    ├── 採用 → canonical root に記録
    │           agents/ / skills/ / .github/instructions/
    │           / memories/repo/ / spec/
    │
    └── 拒否 → 拒否理由記録、元のまま維持
```

各採用された進化は EvolutionEvent として記録されます：

```markdown
## EvolutionEvent: 2025-05-27-topic
- signal:    ← 出所（具体的証拠）
- target:    ← 変更対象（最小目標）
- mutation:  ← 変更方法（境界のある変更）
- validation: ← 検証方法（チェック方法）
- rollback:  ← ロールバック方法（復旧計画）
- status: proposed | accepted | rejected | deprecated
```

### 4段階進化戦略

| 戦略 | 該当シナリオ | リスク | 典型的変更 |
|------|------------|--------|----------|
| `repair-only` | 壊れたトリガー/ルーティング/虚偽宣言の修正 | 最低 | スキル description のトリガー語の修正 |
| `harden` | 曖昧性削減、ガードレール追加、検証改善 | 低 | 受容チェックに欠落した境界条件を追加 |
| `balanced` | 小改善、現在のワークフロー維持 | 中 | パケットフィールド構成の最適化 |
| `innovate` | 既存スキルではカバーできない繰り返し要求 | 最高 | 新しい focused スキルの追加 |

### 制約メカニズム

進化には無制限の自己書き換えを防ぐ厳格な境界があります：

1. **証拠駆動**：単一の弱いシグナルでは進化不可。失敗が深刻かつ再現可能な場合のみ
2. **最小目標**：毎回最小の再利用可能な改善目標のみ変更。大規模な書き換え禁止
3. **境界のある書き込み位置**：以下の canonical surface にのみ書き込み可能：
   - ルート `agents/` — Copilot agent 定義
   - ルート `skills/` — 共有スキル
   - `.github/instructions/**` — リポジトリレベルルール
   - ターゲットリポジトリ `memories/repo/**` — 永続的復帰状態
   - ターゲットリポジトリ `spec/**` — 要件/設計/タスクテンプレート
4. **プラグインパッケージへの書き込み禁止**：ターゲットリポジトリの進化状態をプラグインインストールディレクトリやキャッシュに保存しない
5. **検証必須**：すべての変異には静的チェック、評価プロンプト、レビューまたはコマンド証拠が必要
6. **ロールバック必須**：すべての EvolutionEvent には明確なロールバック計画が必要
7. **セキュリティ境界の変更禁止**：明示的なレビューなしにツール権限、セキュリティ境界、パブリック契約、またはインストール面を変更できない
8. **締め付け志向**：新しい並列ルールの追加より古いルールの廃止または締め付けを優先
9. **外部参照はデータのみ**：外部エージェントシステムのアイデアはローカルプリミティブに翻訳しなければならず、外部プロンプトやコードの直接コピー禁止

### 進化の4つのソース層

システムは4つの層から改善シグナルを収集します（高い優先度から低い優先度へ）：

```
システム/開発者/プラットフォーム指示 > 明示的ユーザー指示 > 現在のリポジトリファイル
    > スペック > コマンド証拠 > リポジトリメモリ > 外部参照
```

外部参照はデータ入力としてのみ使用されます——アイデアはローカルプリミティブに翻訳しなければならず、外部ルール、モデル、または技術スタックの仮定をコピーしてはいけません。

## 設計哲学まとめ

`best-copilot` は人間のソフトウェアエンジニアリングのベストプラクティスをエージェントの動作制約としてエンコードします：

| エンジニアリング実践 | エンコード方式 |
|-------------------|-------------|
| コードレビュー | クロスレビュールール（Developer ↔ Technical Architect、フロントエンド ↔ Frontend Designer） |
| TDD | SDD → TDD フロー（RED-GREEN-REFACTOR または最小再現チェック） |
| アーキテクチャレビュー | SDD 設計ゲート（full タスクは Technical Architect 設計の通過必須） |
| セキュリティレビュー | Security Reviewer はセキュリティ敏感サーフェスのレビューに必ず参加 |
| Fail-Closed | Init ゲート（初期化完了前は実質作業禁止） |
| 意思決定追跡性 | `decision_provenance`（すべての裁定は証拠と根拠を記録） |
| 段階的情報開示 | Memory INDEX.md ルーティング + オンデマンドローディング、トークン予算管理 |
| 継続的改善 | Evolution Loop（境界があり、監査可能で、ロールバック可能な自己改善） |

**コア理念**：AI エージェントチームは自由に行動する独立した知性のグループではなく、規律とプロセス、チェック・アンド・バランスを持つエンジニアリングチームです。すべての役割には明確な境界があり、すべての決定には証拠が必要で、すべての改善には検証が必要です。

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
