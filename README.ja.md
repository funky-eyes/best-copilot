# best-copilot

[English](README.md) | [简体中文](README.zh-CN.md) | [한국어](README.ko.md) | 日本語

`best-copilot` は、インストール可能で再利用でき、継続的に進化できる AI agent チームテンプレートです。GitHub Copilot CLI プラグインを第一の利用面として設計し、`.github/**` を Copilot カスタマイズの単一の真実源として保ち、`AGENTS.md` と `.codex/**` によって Codex も同じチーム契約を再利用できるようにします。

基本思想は単純です。大きな開発タスクはまず **Senior Project Expert** が意図、範囲、段階、完了条件を整理し、必要に応じてアーキテクチャ、仕様、実装、フロントエンド、QA、セキュリティ、修正、進化の各段階へ渡します。

## インストール

このリポジトリを Copilot CLI プラグイン marketplace として登録します。

```bash
copilot plugin marketplace add funky-eyes/best-copilot
```

登録済み marketplace からプラグインをインストールします。

```bash
copilot plugin install best-copilot@best-copilot
```

Copilot CLI では、リポジトリ、URL、ローカルパスからの直接インストールは非推奨です。通常のインストールには上記の marketplace フローを使ってください。ローカル開発時も、ローカル checkout を marketplace として登録します。

```bash
copilot plugin marketplace add /absolute/path/to/best-copilot
copilot plugin install best-copilot@best-copilot
```

インストール確認:

```text
/agent
/skills list
```

## 初回利用

新しいリポジトリで意味のある作業を始める前に、Copilot にリポジトリを学習させます。

```text
/init
```

または:

```bash
copilot init
```

`/init` は Copilot CLI の公式初期化フローです。リポジトリをスキャンし、`.github/copilot-instructions.md` を作成または更新します。`repo-init-scan` skill はこれを初回利用ゲートとして扱います。リポジトリ情報がまだ placeholder の場合は、先に初期化してから実タスクに入ります。

## 言語ポリシー

すべての agent は、まずユーザー入力の主要言語を識別します。ユーザーはある言語で問題を説明し、別の言語のログ、スタックトレース、コード、API レスポンスを貼り付けることがあります。主要言語は、貼り付けられた証拠ではなく、実際の依頼や説明に使われた言語です。

ユーザーが別の言語を明示しない限り、検出した主要言語で応答します。

## チームの入口

大きなタスクは **Senior Project Expert** から始めます。この役割は直接プロダクションコードを書かず、調整を担当します。

- ユーザーの意図と成功条件を理解します。
- `/init`、spec、計画、design review、並列作業が必要か判断します。
- 範囲、non-goals、acceptance checks、verification budget を固定します。
- 適切な specialist にルーティングし、fan-out / fan-in の結果を統合します。
- 終了時に spec、memory、検証証拠、次の再開地点を更新します。

## Agent 役割

| Agent | 担当 | 担当しないこと |
| --- | --- | --- |
| Senior Project Expert | 意図、範囲、オーケストレーション、並列 dispatch、fan-in、closeout、evolution signals | 直接のプロダクション実装 |
| Specification Writer | 証拠、requirements/design/tasks、ADR、進捗記録、memory/spec recovery | プロダクション実装 |
| Technical Architect | バックエンド/フルスタック設計と主実装、API/データ/サービス境界 | フロントエンドの細部、小さな並列 slice |
| Developer | 固定された実装 slice、集中テスト、最小検証 | アーキテクチャ変更や範囲拡大 |
| Frontend Designer | ページ、コンポーネント、インタラクション、レスポンシブ、ブラウザ挙動、視覚検証 | バックエンド主線 |
| Quality Assurance Expert | 機能検証、回帰リスク、コードレビュー、merge readiness | セキュリティレビューと修正 |
| Security Reviewer | 権限、機密データフロー、依存関係リスク、release-surface セキュリティ | 通常の機能 QA |
| Root Cause Fixer | 失敗分析、最小パッチ、回帰検証 | 根拠のないリファクタリング |

## モデル戦略

これらの役割は、同じ汎用 agent に別名を付けただけではありません。各 agent は `.github/agents/*.agent.md` の frontmatter で明示的なモデルを宣言し、モデル選択は役割に必要な推論特性に合わせています。

| Agent | モデル | 推論特性 |
| --- | --- | --- |
| Senior Project Expert | GPT-5.4 | 長期的な調整、範囲制御、fan-out/fan-in 判断、closeout 判断 |
| Technical Architect | GPT-5.4 | 深いバックエンド/フルスタック推論、公開契約設計、データ/API 境界分析、主実装戦略 |
| Specification Writer | Gemini 3.1 Pro (Preview) | 広いコンテキスト統合、構造化 requirements/design/tasks、ADR、recovery records |
| Developer | Gemini 3.1 Pro (Preview) | 固定済み slice の集中実装、コード文脈への素早い整合、テスト、有界な検証 |
| Frontend Designer | Gemini 3.1 Pro (Preview) | UI/状態/文脈の統合、Ant Design 型のエンタープライズパターン、能動的なデザインシステム推論、レスポンシブ挙動、インタラクション品質、ブラウザ証拠計画 |
| Quality Assurance Expert | Claude Sonnet 4.6 | 低ノイズなレビュー、回帰推論、テスト十分性判断、merge-readiness 判断 |
| Security Reviewer | Gemini 3.1 Pro (Preview) | release surface 分析、権限境界、機密データフロー、依存関係と設定レビュー |
| Root Cause Fixer | Claude Sonnet 4.6 | 失敗の切り分け、仮説の絞り込み、最小パッチ選択、回帰証明 |

ルーティング方針も製品の一部です。オーケストレーションとアーキテクチャには深い計画向けのモデルを使い、実装と仕様には広いコンテキスト実行向けのモデルを使い、QA/修正には簡潔なレビュー/デバッグ向けモデルを使うことで、結論を具体的で実行可能に保ちます。

## 大きなタスクの流れ

1. **Init**: リポジトリ情報が不足している場合は `/init` または `copilot init` を実行します。
2. **Discover**: 目標、範囲、リスク、acceptance checks を固定します。
3. **Plan**: spec を更新し、`writing-plans` で実行可能な slice に分けます。
4. **Design Review**: 影響面に応じてアーキテクチャ、QA、セキュリティ、フロントエンドのレビューを行います。
5. **Implement**: Technical Architect が主線を担当し、Developer が独立 slice を、Frontend Designer が UI を担当します。
6. **Verify**: QA が最小十分な検証を行い、フロントエンドはブラウザ証拠を提供します。
7. **Secure**: release surface、dependency、permission、sensitive data flow がある場合はセキュリティレビューを行います。
8. **Fix Loop**: 確認済みの失敗は Root Cause Fixer が最小修正し、再検証します。
9. **Close**: 変更、証拠、リスク、再開地点を要約します。
10. **Evolve**: 繰り返す失敗、古い trigger、review loop、再利用できる学びを EvolutionEvent として記録します。

## 自己進化

`best-copilot` は agent が自由に自分自身を書き換えることを許しません。進化は証拠に基づき、ロールバック可能である必要があります。

1. **Read**: タスク結果、失敗コマンド、review finding、ユーザー修正、memory、spec drift を読みます。
2. **Select**: 最小の改善対象(agent、skill、instruction、prompt、memory、README、spec template)を選びます。
3. **Propose**: 証拠、範囲、検証、rollback を含む Evolution Proposal を作ります。
4. **Validate**: frontmatter/schema、trigger eval、static check、review、command evidence で検証します。
5. **Write**: 承認された学びだけを `.github/**`、`memories/repo/**`、`spec/**` に書き戻します。

承認された改善は `EvolutionEvent`: `signal -> target -> mutation -> validation -> rollback -> status` として記録します。

## 強み

- Copilot-first で、`copilot plugin marketplace add` で marketplace を追加し、`copilot plugin install best-copilot@best-copilot` でインストールできます。
- Codex-compatible: `.codex` adapter が同じ `.github` 真実源を再利用します。
- `/init` 後に実行するため、新しいリポジトリでの推測を減らします。
- 大きな作業は Senior PM が段階的に調整します。
- RAG-lite memory により、全履歴を読まずに文脈を復元できます。
- spec は要件と acceptance を、memory は recovery と検証済み事実を担当します。
- デフォルト skills は高頻度のエンジニアリング能力に絞ります。
- 完了主張には、コマンド、静的検査、ブラウザ証拠、または明確な blocker が必要です。
- 検証済みの workflow 学習はロールバック可能な EvolutionEvent になります。

## 謝辞と参考

このプロジェクトは以下の公開プロジェクトのアイデアと設計から多くを学んでいます。

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
