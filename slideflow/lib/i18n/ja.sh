#!/bin/bash
# 日本語メッセージ

MESSAGES=(
    # 一般的なメッセージ
    ["error"]="エラー"
    ["warning"]="警告"
    ["success"]="成功"
    ["done"]="完了"
    ["info"]="情報"
    
    # SlideFlow固有のメッセージ
    ["sf.title"]="SlideFlow - Markdownベースのプレゼンテーション管理ツール"
    ["sf.usage"]="使い方"
    ["sf.commands"]="コマンド"
    ["sf.options"]="オプション"
    ["sf.global_options"]="グローバルオプション"
    ["sf.examples"]="例"
    
    # コマンドの説明
    ["cmd.new.desc"]="新しいプレゼンテーションを作成"
    ["cmd.preview.desc"]="プレゼンテーションをプレビュー"
    ["cmd.ai.desc"]="AI支援（デフォルト：対話的フェーズ支援）"
    ["cmd.build.desc"]="プレゼンテーションをビルド"
    ["cmd.info.desc"]="プレゼンテーション情報を表示"
    ["cmd.list.desc"]="作成済みプレゼンテーションを一覧表示"
    ["cmd.templates.desc"]="利用可能なテンプレートを表示"
    ["cmd.phases.desc"]="AI支援のフェーズ一覧を表示"
    ["cmd.instructions.desc"]="AI指示書システムの状況確認"
    ["cmd.config.desc"]="設定の表示・変更"
    ["cmd.research.desc"]="調査フェーズのサポート"
    ["cmd.help.desc"]="このヘルプを表示"
    
    # AIオプションの説明
    ["ai.option.interactive"]="対話的フェーズ支援"
    ["ai.option.quick"]="簡易支援（tech/business/academic）"
    ["ai.option.phase"]="特定フェーズ（planning/research/design/creation/review）"
    ["ai.option.continue"]="前回セッション継続"
    
    # エラーメッセージ
    ["error.cannot_create_dir"]="エラー: ディレクトリを作成できません: %1"
    ["info.using_default_name"]="デフォルト名を使用します: %1"
    ["error.dir_not_found"]="エラー: ディレクトリが見つかりません: %1"
    ["error.no_slides"]="エラー: slides.mdが見つかりません"
    ["error.unknown_command"]="エラー: 不明なコマンド: %1"
    ["error.invalid_selection"]="無効な選択です。クリップボードにコピーします。"
    ["error.unsupported_format"]="エラー: 未対応のフォーマット '%1'"
    ["error.check_dir"]="プレゼンテーションディレクトリを確認してください: %1"
    ["error.template_dir_not_found"]="テンプレートディレクトリが見つかりません"
    ["error.supported_formats"]="対応フォーマット: html, pdf, pptx"
    ["error.path_not_found"]="パスが見つかりません: %1"
    ["error.not_presentation_file"]="プレゼンテーションファイルではありません"
    ["error.unknown_option"]="不明なオプション: %1"
    ["error.invalid_config_syntax"]="設定の書式が無効です。使い方: --config <key>=<value>"
    ["error.key_required"]="キーを指定してください"
    ["error.unknown_config_action"]="不明なアクション: %1"
    
    # 成功メッセージ
    ["success.created"]="作成完了！"
    ["success.next_steps"]="次のステップ:"
    ["success.preview_server"]="プレビューサーバーを起動しました"
    ["success.server_url"]="URL: %1"
    ["success.stop_server"]="サーバーを停止するには Ctrl+C を押してください"
    
    # インフォメッセージ
    ["info.creating"]="プレゼンテーションを作成中..."
    ["info.starting_server"]="プレビューサーバーを起動中..."
    ["info.building"]="ビルド中..."
    ["info.presentation_info"]="プレゼンテーション情報"
    ["info.title"]="タイトル"
    ["info.description"]="説明"
    ["info.author"]="作成者"
    ["info.date"]="日付"
    ["info.slides_count"]="スライド数"
    ["info.select_tool"]="使用するツールを選択してください (1-%1, Enter=1): "
    ["info.quick_support_complete"]="簡易AI支援が完了しました！"
    ["info.building_as"]="%1としてビルド中..."
    ["info.file_info"]="ファイル情報:"
    ["info.path"]="パス"
    ["info.size"]="サイズ"
    ["info.last_update"]="最終更新"
    ["info.metadata"]="メタデータ:"
    ["info.generated_files"]="生成済みファイル:"
    ["info.available_templates"]="利用可能なテンプレート"
    ["info.existing_presentations"]="作成済みプレゼンテーション"
    ["info.no_presentations"]="プレゼンテーションが見つかりません"
    ["info.create_first"]="最初のプレゼンテーションを作成:"
    ["info.features"]="機能:"
    ["info.usage_template"]="使用方法:"
    ["info.open_presentation"]="プレゼンテーションを開く:"
    ["info.multiple_presentations"]="複数のプレゼンテーションが見つかりました"
    ["info.please_specify"]="以下のいずれかを指定してください"
    ["info.config_updated"]="設定を更新しました: %1 = %2"
    ["info.config_usage"]="使い方: slideflow config [list|get <key>|set <key>=<value>]"
    ["info.available_phases"]="利用可能なフェーズ"
    ["info.phase_usage"]="フェーズを指定してAI支援を受ける:"
    ["info.phase_example"]="例:"
    
    # プロンプト
    ["prompt.select_template"]="テンプレートを選択してください"
    ["prompt.enter_title"]="タイトルを入力してください"
    ["prompt.enter_description"]="説明を入力してください（任意）"
    
    # AI関連
    ["ai.welcome"]="SlideFlow AI アシスタントへようこそ！"
    ["ai.phase_support"]="フェーズベース支援モード"
    ["ai.quick_support"]="クイック支援モード（%1）"
    ["ai.interactive_mode"]="対話的モード"
    ["ai.select_phase"]="支援が必要なフェーズを選択してください:"
    ["ai.processing"]="処理中..."
    ["ai.session_saved"]="セッションが保存されました"
    ["ai.continuing_session"]="前回のセッションを継続します"
    ["ai.support_mode"]="AI支援モード"
    ["ai.starting_interactive"]="対話的フェーズ支援を開始します"
    ["ai.hint_quick"]="ヒント: 簡易支援が必要な場合は 'slideflow ai --quick <type>' を使用してください"
    ["ai.working_dir"]="作業ディレクトリ: %1"
    ["ai.unknown_option"]="不明なオプションまたは無効なパス: %1"
    ["ai.usage_ai"]="使用方法: slideflow ai [--quick <type>|--phase <phase>|--continue] [path]"
    
    # その他
    ["note.path_omitted"]="注: [path]を省略した場合は現在のディレクトリが使用されます"
    ["misc.or"]="または"
    ["misc.unknown_command"]="不明なコマンド: %1"
    ["misc.no_presentation"]="プレゼンテーションが見つかりません"
    ["misc.bytes"]="バイト"
    
    # グローバルオプション
    ["opt.presentations_dir"]="プレゼンテーションディレクトリを指定"
    ["opt.config_list"]="現在の設定を表示"
    ["opt.config_set"]="設定値を変更"
    
    # フェーズの説明
    ["phase.planning.desc"]="プレゼンテーションの企画や構想を練るフェーズ"
    ["phase.planning.activities"]="目的の明確化、対象者分析、構成作成など"
    ["phase.research.desc"]="必要な情報を収集・整理するフェーズ"
    ["phase.research.activities"]="データ収集、事例調査、根拠の確認など"
    ["phase.design.desc"]="スライドのデザインやビジュアルを設計するフェーズ"
    ["phase.design.activities"]="レイアウト作成、色・フォント選定、図表設計など"
    ["phase.creation.desc"]="実際にコンテンツを作成するフェーズ"
    ["phase.creation.activities"]="テキスト作成、図表作成、スライド構築など"
    ["phase.review.desc"]="完成度を確認し改善するフェーズ"
    ["phase.review.activities"]="内容確認、校正、フィードバック反映など"
)