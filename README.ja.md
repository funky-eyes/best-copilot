# best-copilot

[English](README.md) | [简体中文](README.zh-CN.md) | [한국어](README.ko.md) | 日本語

[![version](https://img.shields.io/badge/version-0.3.0-1d9bf0)](plugin.json)
[![Copilot CLI](https://img.shields.io/badge/Copilot%20CLI-plugin-22c55e)](https://docs.github.com/copilot/how-tos/copilot-cli/customize-copilot)
[![agents](https://img.shields.io/badge/agents-8-2563eb)](agents/)
[![skills](https://img.shields.io/badge/skills-25-10b981)](skills/)
[![license](https://img.shields.io/badge/license-Apache--2.0-64748b)](LICENSE)

![best-copilot hero](assets/best-copilot-hero.png)

`best-copilot` は、インストール可能な Copilot CLI エージェントチームのテンプレートで、真剣なエンジニアリング作業を対象としています。リポジトリに対してシニア品質のデリバリーフローを提供します：事実の初期化、範囲の固定、設計→構築、専門役割による実装、独立したレビュー、証拠に基づく検証、および次回セッションのための復帰ポイントの保持。

Copilot CLI を第一に想定しています。ルートの `agents/` と `skills/` は `plugin.json` 経由で公開され、リポジトリレベルのルールは `.github/instructions/**` にあります。

## なぜ存在するのか

漠然とした要求から直接パッチに飛ぶと、大きな AI コーディング作業は失敗しがちです。`best-copilot` は欠けているデリバリーディシプリンを補います：

- **ひとつのシニア入口**：Senior Project Expert が意図、範囲、ディスパッチ、fan-in、集約、再利用可能なワークフロシグナルを担います。
- **8 つの専門エージェント**：計画、アーキテクチャ、実装、フロントエンド、QA、セキュリティ、根本原因修正、仕様作成を分担します。
- **25 のスキル**：ブートストラップ、検索、計画、TDD、設計レビュー、実行、Java/Python コーディングガイドライン、検証、フロントエンド監査、ワークフローの進化などを提供します。
- **ターゲットリポジトリのローカルメモリとスペック**：インストールされたプロジェクトは事実、ワークストリーム、メモリ、スペックをプラグインパッケージではなくターゲットリポジトリに保持します。
- **証拠優先のクローズ**：`done` の宣言はコマンド出力、静的チェック、ブラウザの証拠、または明示的なブロッカーが必要です。

## インストール

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

## 使い方

要求のオーケストレーションは [agents/pm-coordinator.agent.md](agents/pm-coordinator.agent.md) のコーディネーターエージェントから始めます。このエージェントは UI では **Senior Project Expert** と表示され、意図、範囲、計画、ディスパッチ、レビュー fan-in、クローズを担当します。

- **Copilot CLI**：`/agents` を実行し、**Senior Project Expert** を選択してから作業内容を伝えます。
- **VS Code 拡張機能**：チャットのエージェントを手動で **Senior Project Expert** に切り替えてからタスクを開始します。

## クイックチェック

```text
/agents
/skills list
```

期待されるパッケージ構成：

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

## ワークフロー

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

小規模なスコープの変更ではフローは軽く保たれますが、クロスモジュール作業、公開契約、依存、認可、または曖昧な製品方針がある場合はより重いゲートが意図的に存在します。

## エージェントチーム

| Agent | 担当 | 非担当 |
| --- | --- | --- |
| Senior Project Expert | 意図、範囲、オーケストレーション、ディスパッチ、fan-in、クローズ、進化シグナル | プロダクション実装の直接担当 |
| Specification Writer | 証拠収集、requirements/design/tasks、ADR、memory/spec の復元 | プロダクション実装 |
| Technical Architect | バックエンド/フルスタック設計、API/データ/サービス境界、主線実装、アーキテクチャレビュー | フロントエンドの磨き込み |
| Developer | 固定された実装スライス、実装可否レビュー、Technical Architect 管轄コードのレビュー | アーキテクチャ変更や範囲拡大 |
| Frontend Designer | ページ、コンポーネント、インタラクション、レスポンシブ、ブラウザ検証 | バックエンドの主線 |
| Quality Assurance Expert | 機能検証、回帰リスク、コードレビュー、マージ準備 | セキュリティ専用レビュー |
| Security Reviewer | 認可、機密データフロー、依存リスク、リリース面のセキュリティ | 一般的な機能 QA |
| Root Cause Fixer | フェイル切り分け、最小パッチ、回帰検証 | 根拠のないリファクタリング |

## スキルマップ

| Area | Skills |
| --- | --- |
| Bootstrap | `repo-init-scan`, `target-instructions-bootstrap`, `target-memory-bootstrap`, `target-spec-bootstrap` |
| Planning | `brainstorming`, `writing-plans`, `context-packet-fastpath`, `search-fastpath`, `spec-execution-fastpath` |
| Execution | `test-driven-development`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents` |
| Coding Standards | `td-java-coding-guidelines`, `td-python-coding-guidelines` |
| Review | `structured-review`, `spec-review-gauntlet`, `root-cause-investigation`, `systematic-debugging` |
| Verification | `change-verification`, `verification-before-completion`, `web-experience-audit`, `frontend-design-guardrails` |
| Evolution | `evolution-loop` |

## 初回のターゲットリポジトリでの使用

新しいリポジトリで有意義な作業を始める前に Copilot にリポジトリを学習させてください：

```text
/init
```

または：

```bash
copilot init
```

その後、**Senior Project Expert** から実作業を始めます。対象のリポジトリ内で有用な事実を正規化し、欠けているローカルのスキャフォールドを作成し、実装に入る前にこれらのファイルが存在することを検証します。

ターゲットローカル状態はターゲットリポジトリに属します：

```text
.github/instructions/project.instructions.md
.github/instructions/must.instructions.md
.github/instructions/skills-index.instructions.md
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

## このパッケージの検証

```bash
ruby -rjson -e 'JSON.parse(File.read("plugin.json")); JSON.parse(File.read("marketplace.json")); JSON.parse(File.read(".github/plugin/marketplace.json")); puts "json ok"'
ruby -ryaml -e 'Dir["{agents,skills}/**/*.{md,agent.md}"].sort.uniq.each { |f| s=File.read(f); next unless s.start_with?("---"); YAML.safe_load(s.split("---",3)[1], permitted_classes: [Symbol]); }; puts "frontmatter ok"'
find agents -maxdepth 1 -name '*.agent.md' | sort
find skills -maxdepth 3 -name SKILL.md | sort
git diff --check
```

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
