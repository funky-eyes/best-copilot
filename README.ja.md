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

対象リポジトリにインストールされると、plugin は自身の agents と skills を提供します。初回利用時に Senior Project Expert が対象リポジトリ内の instructions、memory、spec の足場を作成できるため、以後のセッションはそのリポジトリ自身の状態から復帰できます。

## 初回利用

新しいリポジトリで意味のある作業を始める前に、Copilot にリポジトリを学習させます。

```text
/init
```

または:

```bash
copilot init
```

初期化後、大きな作業や複数モジュールにまたがる作業は **Senior Project Expert** から始めてください。この役割はリポジトリ情報をもとに要求を理解し、不足しているローカル workflow の足場を補い、作業を計画し、必要な specialist にルーティングし、検証証拠を明確に保ちます。

## 言語ポリシー

すべての agent は、まずユーザー入力の主要言語を識別します。ユーザーはある言語で問題を説明し、別の言語のログ、スタックトレース、コード、API レスポンスを貼り付けることがあります。主要言語は、貼り付けられた証拠ではなく、実際の依頼や説明に使われた言語です。

ユーザーが別の言語を明示しない限り、検出した主要言語で応答します。

## チームの入口

大きなタスクは **Senior Project Expert** から始めます。この役割は直接プロダクションコードを書かず、調整を担当します。

本当に大きな要求が来たとき、Senior Project Expert は単に agent を振り分けるだけではありません。全体のデリバリーを統括するリードとして動き、このリポジトリが前提にしている実際の workflow を回します。依頼に曖昧さがあれば brainstorming で方向を先に固定し、その方向を Spec Kit に落とし込み、複数ロールの design review を通したうえで、spec-driven・test-driven な実装へ進め、コードが出た後は Architect/Developer の相互レビューと QA・セキュリティ・フロントエンド検証までつなげます。

たとえばユーザーが「この callback フローを最適化してほしい」と言っても、すぐに実装 agent へ投げません。まず brainstorming で、それがレイテンシ改善なのか、正しさなのか、retry 安全性なのか、API 整理なのか、release risk の低減なのかを固定し、その結果を requirements・design・tasks に落とします。この 1 ステップが、後で 2〜3 ラウンドを間違った目標に費やす無駄を防ぎます。

また、1 つの変更が API 契約、バックグラウンド処理、UI を同時に触る場合でも、すべてを 1 本の長い会話に混ぜて押し込みません。範囲と non-goals を固定して Spec Kit にし、まず Technical Architect・Developer・QA が計画を揺さぶって確認し、セキュリティやフロントエンド体験が絡むなら Security Reviewer や Frontend Designer を加えます。その後、主線は Technical Architect、独立 slice は Developer、UI は Frontend Designer が担当し、新しい振る舞いや bugfix は可能な限り失敗テストから始めて実装へ入ります。最後に、それぞれの所有コードを相互レビューしたうえで QA / セキュリティ / フロントエンド検証へ進みます。

つまり目的は agent を増やすことではなく、開始時の当てずっぽうを減らし、中盤の再探索と手戻りを減らし、終盤になってから QA やリリース直前で大きな問題が噴き出すのを減らすことです。

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
| Technical Architect | バックエンド/フルスタック設計と主実装、API/データ/サービス境界、Developer 担当コードのアーキテクチャレビュー | フロントエンドの細部、小さな並列 slice |
| Developer | 固定された実装 slice、実装可否レビュー、Technical Architect 担当コードの複雑度レビュー | アーキテクチャ変更や範囲拡大 |
| Frontend Designer | ページ、コンポーネント、インタラクション、レスポンシブ、ブラウザ挙動、視覚検証 | バックエンド主線 |
| Quality Assurance Expert | 機能検証、回帰リスク、コードレビュー、merge readiness | セキュリティレビューと修正 |
| Security Reviewer | 権限、機密データフロー、依存関係リスク、release-surface セキュリティ | 通常の機能 QA |
| Root Cause Fixer | 失敗分析、最小パッチ、回帰検証 | 根拠のないリファクタリング |

## モデル戦略

これらの役割は、同じ汎用 agent に別名を付けただけではありません。各 agent は `.github/agents/*.agent.md` の frontmatter で明示的なモデルを宣言し、モデル選択は役割に必要な推論特性に合わせています。

| Agent | モデル | 推論特性 |
| --- | --- | --- |
| Senior Project Expert | GPT-5.4 | 長期的な調整、範囲制御、fan-out/fan-in 判断、closeout 判断 |
| Technical Architect | GPT-5.4 | 深いバックエンド/フルスタック推論、公開契約設計、データ/API 境界分析、主実装戦略、および Developer 担当コードのレビュー |
| Specification Writer | Gemini 3.1 Pro (Preview) | 広いコンテキスト統合、構造化 requirements/design/tasks、ADR、recovery records |
| Developer | Gemini 3.1 Pro (Preview) | 固定済み slice の集中実装、主線コードの実装可否レビュー、コード文脈への素早い整合、テスト、有界な検証 |
| Frontend Designer | Gemini 3.1 Pro (Preview) | UI/状態/文脈の統合、Ant Design 型のエンタープライズパターン、能動的なデザインシステム推論、レスポンシブ挙動、インタラクション品質、ブラウザ証拠計画 |
| Quality Assurance Expert | Claude Sonnet 4.6 | 低ノイズなレビュー、回帰推論、テスト十分性判断、merge-readiness 判断 |
| Security Reviewer | Gemini 3.1 Pro (Preview) | release surface 分析、権限境界、機密データフロー、依存関係と設定レビュー |
| Root Cause Fixer | Claude Sonnet 4.6 | 失敗の切り分け、仮説の絞り込み、最小パッチ選択、回帰証明 |

ルーティング方針も製品の一部です。オーケストレーションとアーキテクチャには深い計画向けのモデルを使い、実装と仕様には広いコンテキスト実行向けのモデルを使い、QA/修正には簡潔なレビュー/デバッグ向けモデルを使うことで、結論を具体的で実行可能に保ちます。

## 大きなタスクの流れ

大きな要求は、プロンプトからそのままパッチへ飛びません。悪い前提を早い段階で露出させ、設計レビューと独立レビューを実装前に入れ、実装と相互レビューと検証を分離するためのチェックポイントを通ります。

1. **Init**: リポジトリ情報が不足している場合は `/init` または `copilot init` を実行します。
2. **Discover**: 目標、範囲、リスク、acceptance checks を固定します。
3. **Brainstorm**: 要求に曖昧さがある、またはルートが実装方向を変える場合は、まず `brainstorming` で方向を固定し、誤った意味の分岐で実装を始めないようにします。
4. **Spec Kit**: Specification Writer が固定された方向を、このリポジトリの Spec Kit、つまり `requirements.md`、`design.md`、`tasks.md` に落とします。
5. **Design Review**: まず Technical Architect、Developer、QA が Spec Kit をレビューします。セキュリティやフロントエンド体験が関わる場合は Security Reviewer や Frontend Designer も加わり、危険な前提を実装前に崩します。
6. **SDD/TDD Implementation**: 主線は Technical Architect、独立 slice は Developer、UI は Frontend Designer が担当します。実装は Spec Kit を基準に進め、新しい振る舞いや bugfix は可能な限り失敗テストから始めます。
7. **Cross Review**: Technical Architect は Developer 担当コードを、Developer は Technical Architect 担当コードをレビューし、実装者が自分のコードを自分で通すことを防ぎます。
8. **Verify**: QA が最小十分な検証を行い、フロントエンドはブラウザ証拠を提供します。失敗は握りつぶさず fix loop に入れます。
9. **Secure**: release surface、dependency、permission、sensitive data flow がある場合はセキュリティレビューを行います。
10. **Fix Loop**: 確認済みの失敗は Root Cause Fixer が最小修正し、再検証します。
11. **Close**: 変更、証拠、リスク、再開地点を要約します。
12. **Evolve**: 繰り返す失敗、古い trigger、review loop、再利用できる学びを EvolutionEvent として記録します。

## 自己進化

`best-copilot` は agent が自由に自分自身を書き換えることを許しません。進化は証拠に基づき、ロールバック可能である必要があります。

1. **Read**: タスク結果、失敗コマンド、review finding、ユーザー修正、memory、spec drift を読みます。
2. **Select**: 最小の改善対象(agent、skill、instruction、prompt、memory、README、spec template)を選びます。
3. **Propose**: 証拠、範囲、検証、rollback を含む Evolution Proposal を作ります。
4. **Validate**: frontmatter/schema、trigger eval、static check、review、command evidence で検証します。
5. **Write**: 承認された学びだけを関連する `.github/**` カスタマイズ、または bootstrap skills が作成した対象リポジトリ内の memory/spec ファイルに書き戻します。

承認された改善は `EvolutionEvent`: `signal -> target -> mutation -> validation -> rollback -> status` として記録します。

## 強み

- より高い品質を既定値に: 大きな作業は実装前に設計とリスクを揺さぶり、その後も相互レビューと証拠ベース検証で再確認します。
- Spec Kit + TDD 駆動の実装: 方向を requirements/design/tasks に落とし、新しい振る舞いや bugfix は可能な限りテストを実行ゲートにしてから実装します。
- Architect/Developer 相互レビュー: 主線 owner と slice owner が互いのコードをレビューし、自己承認ループを断ちます。
- より高いスループットと少ない手戻り: `/init`、frozen packet、明示的 ownership により、同じリポジトリの再探索や誤方向への 2〜3 ラウンドの浪費を減らします。
- リポジトリ間で持ち運びやすい: この workflow は先に各リポジトリのコマンド、entrypoint、module boundary、unknown を学習してから動くため、異なるコードベースにも同じ思い込みを押し付けません。
- 失敗処理が明確: 失敗は楽観的な summary に埋もれず、fix loop や verification に明確な ownership と evidence を持って戻ります。
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
- [spec-kit](https://github.com/github/spec-kit)
- [Anthropic skill-creator](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator)
- [Anthropic code-simplifier](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-simplifier)
- [Anthropic code-review](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review)
- [Memento-Skills](https://github.com/Memento-Teams/Memento-Skills)
- [Evolver](https://github.com/EvoMap/evolver)
