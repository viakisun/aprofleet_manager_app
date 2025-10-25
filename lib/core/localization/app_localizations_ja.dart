class AppLocalizationsJa {
  static const Map<String, String> values = {
    // App Name
    'appName': 'AproFleet マネージャー',

    // Navigation
    'navRealTime': 'フリート',
    'navCartManagement': '車両',
    'navMaintenance': 'サービス',
    'navAlerts': 'アラート',
    'navAnalytics': 'アナリティクス',
    'navSettings': '設定',

    // Cart Registration
    'registerCart': 'カート登録',
    'cartRegistration': 'カート登録',
    'vinNumber': 'VIN番号',
    'manufacturer': 'メーカー',
    'model': 'モデル',
    'year': '年',
    'color': '色',
    'batteryType': 'バッテリータイプ',
    'voltage': '電圧',
    'seating': '座席数',
    'maxSpeed': '最高速度',
    'gpsTrackerId': 'GPSトラッカーID',
    'telemetryDeviceId': 'テレメトリーデバイスID',
    'componentSerials': 'コンポーネントシリアル',
    'imagePaths': '画像パス',
    'purchaseDate': '購入日',
    'warrantyExpiry': '保証期限',
    'insuranceNumber': '保険番号',
    'odometer': 'オドメーター',

    // Work Order Creation
    'createWorkOrder': '作業指示書作成',
    'workOrderCreation': '作業指示書作成',
    'workOrderType': '作業指示書タイプ',
    'priority': '優先度',
    'description': '説明',
    'technician': '技術者',
    'parts': '部品',
    'location': '場所',
    'notes': 'メモ',
    'checklist': 'チェックリスト',
    'scheduledAt': '予定日時',
    'estimatedDuration': '推定時間',

    // Common
    'search': '検索',
    'filter': 'フィルター',
    'add': '追加',
    'save': '保存',
    'cancel': 'キャンセル',
    'confirm': '確認',
    'delete': '削除',
    'edit': '編集',
    'view': '表示',
    'track': '追跡',
    'details': '詳細',
    'service': 'サービス',
    'refresh': '更新',
    'export': 'エクスポート',
    'loading': '読み込み中...',
    'error': 'エラー',
    'success': '成功',
    'warning': '警告',
    'info': '情報',

    // Cart Status
    'statusActive': '稼働中',
    'statusIdle': '待機中',
    'statusCharging': '充電中',
    'statusMaintenance': 'メンテナンス中',
    'statusOffline': 'オフライン',

    // Priority
    'priorityCritical': '緊急',
    'priorityHigh': '高',
    'priorityNormal': '通常',
    'priorityLow': '低',

    // Alert Severity
    'alertCritical': '緊急',
    'alertWarning': '警告',
    'alertInfo': '情報',
    'alertSuccess': '成功',

    // Work Order Types
    'woEmergency': '緊急修理',
    'woPreventive': '予防メンテナンス',
    'woBattery': 'バッテリーサービス',
    'woTire': 'タイヤサービス',
    'woSafety': '安全点検',
    'woOther': 'その他',

    // Manufacturers
    'manufacturerDYInnovate': 'DY Innovate',
    'manufacturerEZGO': 'E-Z-GO',
    'manufacturerClubCar': 'Club Car',
    'manufacturerYamaha': 'ヤマハ',
    'manufacturerCushman': 'Cushman',

    // Analytics Dashboard
    'analyticsPeriod': '期間:',
    'analyticsWeek': '週間',
    'analyticsMonth': '月間',
    'analyticsKpiTitle': '主要業績評価指標',
    'analyticsChartsTitle': 'パフォーマンスチャート',
    'analyticsFleetPerformance': 'フリート性能',
    'analyticsBatteryHealth': 'バッテリー健全性トレンド',
    'analyticsMaintenanceDistribution': 'メンテナンス分布',
    'analyticsCostAnalysis': 'コスト分析',

    // KPI Labels
    'kpiAvailability': '稼働率',
    'kpiMTTR': 'MTTR',
    'kpiUtilization': '日次稼働率',
    'kpiDailyDistance': '日次走行距離',

    // Units
    'unitPercent': '%',
    'unitMinutes': '分',
    'unitKilometers': 'km',
    'unitKilometersPerHour': 'km/h',
    'unitVolts': 'V',
    'unitAmperes': 'A',
    'unitCelsius': '°C',

    // Maintenance Distribution
    'maintenancePreventive': '予防',
    'maintenanceBattery': 'バッテリー',
    'maintenanceTire': 'タイヤ',
    'maintenanceEmergency': '緊急',
    'maintenanceOther': 'その他',

    // Cost Analysis
    'costTotal': '合計',
    'costLabor': '人件費',
    'costParts': '部品',
    'costOther': 'その他',

    // KPI Labels
    'kpiAvailabilityRate': '可用率',

    // Settings & Menu (新增)
    'settingsTitle': '設定',
    'languageAndRegion': '言語と地域',
    'account': 'アカウント',
    'appSettings': 'アプリ設定',
    'support': 'サポート',
    'profileSettings': 'プロフィール設定',
    'managePersonalInfo': '個人情報の管理',
    'security': 'セキュリティ',
    'securityDescription': 'パスワード、2段階認証、セキュリティ設定',
    'privacy': 'プライバシー',
    'privacyDescription': 'データ使用とプライバシー制御',
    'notifications': '通知',
    'notificationsDescription': 'プッシュ通知とアラート',
    'theme': 'テーマ',
    'themeDescription': 'ダークモード（常時オン）',
    'storage': 'ストレージ',
    'storageDescription': 'キャッシュとデータ管理',
    'helpFaq': 'ヘルプとFAQ',
    'helpDescription': 'ヘルプと回答を見つける',
    'reportIssue': '問題を報告',
    'reportDescription': 'バグや問題を報告',
    'about': '情報',
    'aboutDescription': 'アプリのバージョンと情報',
    'signOut': 'サインアウト',
    'signOutConfirm': 'サインアウトしますか？',
    'signedOutSuccess': 'サインアウトしました',

    // Hamburger Menu (新增)
    'quickActions': 'クイックアクション',
    'dashboard': 'ダッシュボード',
    'dashboardSubtitle': 'メインダッシュボードに移動',
    'scanQrCode': 'QRコードスキャン',
    'scanQrSubtitle': 'カートQRコードをスキャン',
    'refreshData': 'データを更新',
    'refreshDataSubtitle': '最新データを同期',
    'dataRefreshed': 'データが更新されました',
    'language': '言語',
    'english': '英語',
    'korean': '韓国語',
    'japanese': '日本語',
    'chineseSimplified': '中国語（簡体字）',
    'chineseTraditional': '中国語（繁体字）',

    // Inventory Stats (新增)
    'total': '合計',
    'active': 'アクティブ',
    'charging': '充電中',
    'maintenance': 'メンテナンス',
    'offline': 'オフライン',

    // Cart Details & Metrics (新增)
    'battery': 'バッテリー',
    'speed': '速度',
    'systemMetrics': 'システム指標',
    'live': 'ライブ',
    'telemetry': 'テレメトリー',

    // Work Order & Alerts (新增)
    'workOrderStatus': '作業指示書ステータス',
    'alertRules': 'アラートルール',
    'escalationPath': 'エスカレーションパス',
    'estimatedTime': '推定時間',

    // Common UI Elements (新增)
    'comingSoon': '近日公開',
    'ok': 'OK',
    'version': 'バージョン',
    'product': '製品',
    'languageChanged': '言語が以下に変更されました',

    // Work Order Type Selector (新增)
    'emergency': '緊急',
    'preventive': '予防',
    'tire': 'タイヤ',
    'safety': '安全',
    'other': 'その他',

    // Priority Selector (新增)
    'priorityLevel': '優先度',
    'critical': '緊急',
    'high': '高',
    'normal': '通常',
    'low': '低',

    // Alert Summary Cards (新增)
    'alertSummary': 'アラートサマリー',
    'totalAlerts': '総アラート',
    'resolved': '解決済み',

    // Cart Detail Monitor (新增)
    'primaryTelemetry': 'プライマリテレメトリー',
    'motor': 'モーター',
    'main': 'メイン',
    'daily': '日次',
    'energy': 'エネルギー',
    'alerts': 'アラート',
    'remoteControls': 'リモートコントロール',
    'emergencyControls': '緊急コントロール',
    'emergencyStop': '緊急停止',
    'stopCart': 'カート停止',

    // About Dialog (新增)
    'aboutAproFleetManager': 'AproFleet マネージャーについて',
    'versionInfo': 'バージョン: 1.0.0',
    'manufacturerInfo': 'メーカー: DY Innovate',
    'productInfo': '製品: APRO ゴルフカート',

    // Work Order Filters
    'woFilterAll': 'すべて',
    'woFilterUrgent': '緊急',
    'woFilterPending': '保留中',
    'woFilterInProgress': '進行中',
    'woFilterCompleted': '完了',
    'woFilterTimeline': 'タイムライン',

    // Work Order Stats
    'woStatsUrgent': '緊急',
    'woStatsPending': '保留中',
    'woStatsInProgress': '進行中',
    'woStatsToday': '今日',

    // Work Order Status
    'woStatusDraft': '下書き',
    'woStatusPending': '保留中',
    'woStatusInProgress': '進行中',
    'woStatusOnHold': '保留',
    'woStatusCompleted': '完了',
    'woStatusCancelled': 'キャンセル',

    // Priority Levels
    'woPriorityP1': 'P1 (緊急)',
    'woPriorityP2': 'P2 (高)',
    'woPriorityP3': 'P3 (通常)',
    'woPriorityP4': 'P4 (低)',

    // Work Order Types
    'woTypeEmergency': '緊急修理',
    'woTypePreventive': '予防保守',
    'woTypeBattery': 'バッテリー',
    'woTypeTire': 'タイヤ',
    'woTypeSafety': '安全点検',
    'woTypeOther': 'その他',

    // Time Format
    'woTimeDays': '日',
    'woTimeHours': '時間',
    'woTimeMinutes': '分',
    'woTimeAgo': '前',

    // Messages
    'woNoWorkOrders': '作業指示書が見つかりません',
    'woErrorLoading': '作業指示書の読み込み中にエラーが発生しました',
    'woRetry': '再試行',

    // Hamburger Menu
    'menuSettings': '設定',
    'menuLanguage': '言語',
    'menuSettingsTitle': '設定',
    'menuSettingsSubtitle': 'アプリの環境設定と構成',
    'menuEnglish': 'English',
    'menuKorean': '한국어',
    'menuJapanese': '日本語',
    'menuChineseSimplified': '简体中文',
    'menuChineseTraditional': '繁體中文',
    'menuSignOut': 'サインアウト',
    'menuSignOutTitle': 'サインアウト',
    'menuSignOutMessage': '本当にサインアウトしますか？',
    'menuSignOutSuccess': '正常にサインアウトしました',

    // Alert Screen
    'alertTabAll': 'すべて',
    'alertTabUnread': '未読',
    'alertTabCart': 'カート',
    'alertTabBattery': 'バッテリー',
    'alertTabMaintenance': 'メンテナンス',
    'alertTabGeofence': 'ジオフェンス',
    'alertTabSystem': 'システム',
    'alertErrorLoading': 'アラートの読み込み中にエラーが発生しました',
    'alertRetry': '再試行',
    'alertNoAlerts': 'アラートが見つかりません',
    'alertAcknowledge': '確認',
    'alertViewCart': 'カート表示',
    'alertCreateWorkOrder': '作業指示書作成',
    'alertTimeJustNow': '今',
    'alertTimeDaysAgo': '日前',
    'alertTimeHoursAgo': '時間前',
    'alertTimeMinutesAgo': '分前',

    // Alert Severity
    'alertSeverityCritical': '緊急',
    'alertSeverityWarning': '警告',
    'alertSeverityInfo': '情報',
    'alertSeveritySuccess': '成功',

    // Alert Status
    'alertStatusTriggered': '発生',
    'alertStatusNotified': '通知済み',
    'alertStatusAcknowledged': '確認済み',
    'alertStatusEscalated': 'エスカレーション',
    'alertStatusResolved': '解決済み',

    // Alert Source
    'alertSourceEmergency': '緊急',
    'alertSourceBattery': 'バッテリー',
    'alertSourceMaintenance': 'メンテナンス',
    'alertSourceGeofence': 'ジオフェンス',
    'alertSourceTemperature': '温度',
    'alertSourceSystem': 'システム',

    // Cart Inventory - Route View
    'cartsPositionedOnRoute': 'カートが経路上に配置されました',
    'cartPositionUpdateFailed': 'カート位置の更新に失敗しました',
  };
}
