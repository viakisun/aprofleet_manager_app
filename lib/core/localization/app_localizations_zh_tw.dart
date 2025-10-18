class AppLocalizationsZhTw {
  static const Map<String, String> values = {
    // App Name
    'appName': 'AproFleet 管理器',

    // Navigation
    'navRealTime': '即時',
    'navCartManagement': '車輛',
    'navMaintenance': '維護',
    'navAlerts': '警報',
    'navAnalytics': '分析',
    'navSettings': '設定',

    // Cart Registration
    'registerCart': '註冊車輛',
    'cartRegistration': '車輛註冊',
    'vinNumber': 'VIN 號碼',
    'manufacturer': '製造商',
    'model': '型號',
    'year': '年份',
    'color': '顏色',
    'batteryType': '電池類型',
    'voltage': '電壓',
    'seating': '座位數',
    'maxSpeed': '最高速度',
    'gpsTrackerId': 'GPS 追蹤器 ID',
    'telemetryDeviceId': '遙測設備 ID',
    'componentSerials': '組件序號',
    'imagePaths': '圖片路徑',
    'purchaseDate': '購買日期',
    'warrantyExpiry': '保固到期',
    'insuranceNumber': '保險號碼',
    'odometer': '里程表',

    // Work Order Creation
    'createWorkOrder': '建立工作單',
    'workOrderCreation': '工作單建立',
    'workOrderType': '工作單類型',
    'priority': '優先級',
    'description': '描述',
    'technician': '技術員',
    'parts': '零件',
    'location': '位置',
    'notes': '備註',
    'checklist': '檢查清單',
    'scheduledAt': '計劃時間',
    'estimatedDuration': '預計時長',

    // Common
    'search': '搜尋',
    'filter': '篩選',
    'add': '新增',
    'save': '儲存',
    'cancel': '取消',
    'confirm': '確認',
    'delete': '刪除',
    'edit': '編輯',
    'view': '檢視',
    'track': '追蹤',
    'details': '詳情',
    'service': '服務',
    'refresh': '重新整理',
    'export': '匯出',
    'loading': '載入中...',
    'error': '錯誤',
    'success': '成功',
    'warning': '警告',
    'info': '資訊',

    // Cart Status
    'statusActive': '運行中',
    'statusIdle': '閒置',
    'statusCharging': '充電中',
    'statusMaintenance': '維護中',
    'statusOffline': '離線',

    // Priority
    'priorityCritical': '緊急',
    'priorityHigh': '高',
    'priorityNormal': '普通',
    'priorityLow': '低',

    // Alert Severity
    'alertCritical': '緊急',
    'alertWarning': '警告',
    'alertInfo': '資訊',
    'alertSuccess': '成功',

    // Work Order Types
    'woEmergency': '緊急維修',
    'woPreventive': '預防性維護',
    'woBattery': '電池服務',
    'woTire': '輪胎服務',
    'woSafety': '安全檢查',
    'woOther': '其他',

    // Manufacturers
    'manufacturerDYInnovate': 'DY Innovate',
    'manufacturerEZGO': 'E-Z-GO',
    'manufacturerClubCar': 'Club Car',
    'manufacturerYamaha': '山葉',
    'manufacturerCushman': 'Cushman',

    // Analytics Dashboard
    'analyticsPeriod': '期間:',
    'analyticsWeek': '週',
    'analyticsMonth': '月',
    'analyticsKpiTitle': '關鍵績效指標',
    'analyticsChartsTitle': '效能圖表',
    'analyticsFleetPerformance': '車隊效能',
    'analyticsBatteryHealth': '電池健康趨勢',
    'analyticsMaintenanceDistribution': '維護分布',
    'analyticsCostAnalysis': '成本分析',

    // KPI Labels
    'kpiAvailability': '可用率',
    'kpiMTTR': 'MTTR',
    'kpiUtilization': '日利用率',
    'kpiDailyDistance': '日行駛距離',

    // Units
    'unitPercent': '%',
    'unitMinutes': '分鐘',
    'unitKilometers': '公里',
    'unitKilometersPerHour': '公里/小時',
    'unitVolts': 'V',
    'unitAmperes': 'A',
    'unitCelsius': '°C',

    // Maintenance Distribution
    'maintenancePreventive': '預防性',
    'maintenanceBattery': '電池',
    'maintenanceTire': '輪胎',
    'maintenanceEmergency': '緊急',
    'maintenanceOther': '其他',

    // Cost Analysis
    'costTotal': '總計',
    'costLabor': '人工',
    'costParts': '零件',
    'costOther': '其他',

    // KPI Labels
    'kpiAvailabilityRate': '可用率',

    // Settings & Menu (新增)
    'settingsTitle': '設定',
    'languageAndRegion': '語言和地區',
    'account': '帳戶',
    'appSettings': '應用程式設定',
    'support': '支援',
    'profileSettings': '個人資料設定',
    'managePersonalInfo': '管理您的個人資訊',
    'security': '安全性',
    'securityDescription': '密碼、雙重驗證和安全設定',
    'privacy': '隱私',
    'privacyDescription': '資料使用和隱私控制',
    'notifications': '通知',
    'notificationsDescription': '推播通知和警報',
    'theme': '主題',
    'themeDescription': '深色模式（始終開啟）',
    'storage': '儲存空間',
    'storageDescription': '快取和資料管理',
    'helpFaq': '說明和常見問題',
    'helpDescription': '取得說明和尋找答案',
    'reportIssue': '回報問題',
    'reportDescription': '回報錯誤或問題',
    'about': '關於',
    'aboutDescription': '應用程式版本和資訊',
    'signOut': '登出',
    'signOutConfirm': '您確定要登出嗎？',
    'signedOutSuccess': '成功登出',

    // Hamburger Menu (新增)
    'quickActions': '快速操作',
    'dashboard': '儀表板',
    'dashboardSubtitle': '前往主儀表板',
    'scanQrCode': '掃描 QR 碼',
    'scanQrSubtitle': '掃描車輛 QR 碼',
    'refreshData': '重新整理資料',
    'refreshDataSubtitle': '同步最新資料',
    'dataRefreshed': '資料已重新整理',
    'language': '語言',
    'english': '英語',
    'korean': '韓語',
    'japanese': '日語',
    'chineseSimplified': '簡體中文',
    'chineseTraditional': '繁體中文',

    // Inventory Stats (新增)
    'total': '總計',
    'active': '活躍',
    'charging': '充電',
    'maintenance': '維護',
    'offline': '離線',

    // Cart Details & Metrics (新增)
    'battery': '電池',
    'speed': '速度',
    'systemMetrics': '系統指標',
    'live': '即時',
    'telemetry': '遙測',

    // Work Order & Alerts (新增)
    'workOrderStatus': '工作單狀態',
    'alertRules': '警報規則',
    'escalationPath': '升級路徑',
    'estimatedTime': '預計時間',

    // Common UI Elements (新增)
    'comingSoon': '即將推出',
    'ok': '確定',
    'version': '版本',
    'product': '產品',
    'languageChanged': '語言已更改為',

    // Work Order Type Selector (新增)
    'emergency': '緊急',
    'preventive': '預防性',
    'tire': '輪胎',
    'safety': '安全',
    'other': '其他',

    // Priority Selector (新增)
    'priorityLevel': '優先級',
    'critical': '緊急',
    'high': '高',
    'normal': '普通',
    'low': '低',

    // Alert Summary Cards (新增)
    'alertSummary': '警報摘要',
    'totalAlerts': '總警報',
    'resolved': '已解決',

    // Cart Detail Monitor (新增)
    'primaryTelemetry': '主要遙測',
    'motor': '馬達',
    'main': '主',
    'daily': '每日',
    'energy': '能耗',
    'alerts': '警報',
    'remoteControls': '遠端控制',
    'emergencyControls': '緊急控制',
    'emergencyStop': '緊急停止',
    'stopCart': '停止車輛',

    // About Dialog (新增)
    'aboutAproFleetManager': '關於 AproFleet 管理器',
    'versionInfo': '版本: 1.0.0',
    'manufacturerInfo': '製造商: DY Innovate',
    'productInfo': '產品: APRO 高爾夫球車',

    // Work Order Filters
    'woFilterAll': '全部',
    'woFilterUrgent': '緊急',
    'woFilterPending': '待處理',
    'woFilterInProgress': '進行中',
    'woFilterCompleted': '已完成',
    'woFilterTimeline': '時間線',

    // Work Order Stats
    'woStatsUrgent': '緊急',
    'woStatsPending': '待處理',
    'woStatsInProgress': '進行中',
    'woStatsToday': '今天',

    // Work Order Status
    'woStatusDraft': '草稿',
    'woStatusPending': '待處理',
    'woStatusInProgress': '進行中',
    'woStatusOnHold': '暫停',
    'woStatusCompleted': '已完成',
    'woStatusCancelled': '已取消',

    // Priority Levels
    'woPriorityP1': 'P1 (緊急)',
    'woPriorityP2': 'P2 (高)',
    'woPriorityP3': 'P3 (正常)',
    'woPriorityP4': 'P4 (低)',

    // Work Order Types
    'woTypeEmergency': '緊急維修',
    'woTypePreventive': '預防性維護',
    'woTypeBattery': '電池',
    'woTypeTire': '輪胎',
    'woTypeSafety': '安全檢查',
    'woTypeOther': '其他',

    // Time Format
    'woTimeDays': '天',
    'woTimeHours': '小時',
    'woTimeMinutes': '分鐘',
    'woTimeAgo': '前',

    // Messages
    'woNoWorkOrders': '未找到工作訂單',
    'woErrorLoading': '加載工作訂單時出錯',
    'woRetry': '重試',

    // Hamburger Menu
    'menuSettings': '設定',
    'menuLanguage': '語言',
    'menuSettingsTitle': '設定',
    'menuSettingsSubtitle': '應用偏好設定和配置',
    'menuEnglish': 'English',
    'menuKorean': '한국어',
    'menuJapanese': '日本語',
    'menuChineseSimplified': '简体中文',
    'menuChineseTraditional': '繁體中文',
    'menuSignOut': '登出',
    'menuSignOutTitle': '登出',
    'menuSignOutMessage': '確定要登出嗎？',
    'menuSignOutSuccess': '成功登出',

    // Alert Screen
    'alertTabAll': '全部',
    'alertTabUnread': '未讀',
    'alertTabCart': '車輛',
    'alertTabBattery': '電池',
    'alertTabMaintenance': '維護',
    'alertTabGeofence': '地理圍欄',
    'alertTabSystem': '系統',
    'alertErrorLoading': '加載警報時出錯',
    'alertRetry': '重試',
    'alertNoAlerts': '未找到警報',
    'alertAcknowledge': '確認',
    'alertViewCart': '查看車輛',
    'alertCreateWorkOrder': '創建工作訂單',
    'alertTimeJustNow': '剛剛',
    'alertTimeDaysAgo': '天前',
    'alertTimeHoursAgo': '小時前',
    'alertTimeMinutesAgo': '分鐘前',

    // Alert Severity
    'alertSeverityCritical': '緊急',
    'alertSeverityWarning': '警告',
    'alertSeverityInfo': '資訊',
    'alertSeveritySuccess': '成功',

    // Alert Status
    'alertStatusTriggered': '已觸發',
    'alertStatusNotified': '已通知',
    'alertStatusAcknowledged': '已確認',
    'alertStatusEscalated': '已升級',
    'alertStatusResolved': '已解決',

    // Alert Source
    'alertSourceEmergency': '緊急',
    'alertSourceBattery': '電池',
    'alertSourceMaintenance': '維護',
    'alertSourceGeofence': '地理圍欄',
    'alertSourceTemperature': '溫度',
    'alertSourceSystem': '系統',
  };
}
