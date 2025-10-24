class AppLocalizationsZhCn {
  static const Map<String, String> values = {
    // App Name
    'appName': 'AproFleet 管理器',

    // Navigation
    'navRealTime': '车队',
    'navCartManagement': '车辆',
    'navMaintenance': '服务',
    'navAlerts': '警报',
    'navAnalytics': '分析',
    'navSettings': '设置',

    // Cart Registration
    'registerCart': '注册车辆',
    'cartRegistration': '车辆注册',
    'vinNumber': 'VIN 号码',
    'manufacturer': '制造商',
    'model': '型号',
    'year': '年份',
    'color': '颜色',
    'batteryType': '电池类型',
    'voltage': '电压',
    'seating': '座位数',
    'maxSpeed': '最高速度',
    'gpsTrackerId': 'GPS 跟踪器 ID',
    'telemetryDeviceId': '遥测设备 ID',
    'componentSerials': '组件序列号',
    'imagePaths': '图片路径',
    'purchaseDate': '购买日期',
    'warrantyExpiry': '保修到期',
    'insuranceNumber': '保险号码',
    'odometer': '里程表',

    // Work Order Creation
    'createWorkOrder': '创建工作单',
    'workOrderCreation': '工作单创建',
    'workOrderType': '工作单类型',
    'priority': '优先级',
    'description': '描述',
    'technician': '技术员',
    'parts': '零件',
    'location': '位置',
    'notes': '备注',
    'checklist': '检查清单',
    'scheduledAt': '计划时间',
    'estimatedDuration': '预计时长',

    // Common
    'search': '搜索',
    'filter': '筛选',
    'add': '添加',
    'save': '保存',
    'cancel': '取消',
    'confirm': '确认',
    'delete': '删除',
    'edit': '编辑',
    'view': '查看',
    'track': '跟踪',
    'details': '详情',
    'service': '服务',
    'refresh': '刷新',
    'export': '导出',
    'loading': '加载中...',
    'error': '错误',
    'success': '成功',
    'warning': '警告',
    'info': '信息',

    // Cart Status
    'statusActive': '运行中',
    'statusIdle': '空闲',
    'statusCharging': '充电中',
    'statusMaintenance': '维护中',
    'statusOffline': '离线',

    // Priority
    'priorityCritical': '紧急',
    'priorityHigh': '高',
    'priorityNormal': '普通',
    'priorityLow': '低',

    // Alert Severity
    'alertCritical': '紧急',
    'alertWarning': '警告',
    'alertInfo': '信息',
    'alertSuccess': '成功',

    // Work Order Types
    'woEmergency': '紧急维修',
    'woPreventive': '预防性维护',
    'woBattery': '电池服务',
    'woTire': '轮胎服务',
    'woSafety': '安全检查',
    'woOther': '其他',

    // Manufacturers
    'manufacturerDYInnovate': 'DY Innovate',
    'manufacturerEZGO': 'E-Z-GO',
    'manufacturerClubCar': 'Club Car',
    'manufacturerYamaha': '雅马哈',
    'manufacturerCushman': 'Cushman',

    // Analytics Dashboard
    'analyticsPeriod': '期间:',
    'analyticsWeek': '周',
    'analyticsMonth': '月',
    'analyticsKpiTitle': '关键绩效指标',
    'analyticsChartsTitle': '性能图表',
    'analyticsFleetPerformance': '车队性能',
    'analyticsBatteryHealth': '电池健康趋势',
    'analyticsMaintenanceDistribution': '维护分布',
    'analyticsCostAnalysis': '成本分析',

    // KPI Labels
    'kpiAvailability': '可用率',
    'kpiMTTR': 'MTTR',
    'kpiUtilization': '日利用率',
    'kpiDailyDistance': '日行驶距离',

    // Units
    'unitPercent': '%',
    'unitMinutes': '分钟',
    'unitKilometers': '公里',
    'unitKilometersPerHour': '公里/小时',
    'unitVolts': 'V',
    'unitAmperes': 'A',
    'unitCelsius': '°C',

    // Maintenance Distribution
    'maintenancePreventive': '预防性',
    'maintenanceBattery': '电池',
    'maintenanceTire': '轮胎',
    'maintenanceEmergency': '紧急',
    'maintenanceOther': '其他',

    // Cost Analysis
    'costTotal': '总计',
    'costLabor': '人工',
    'costParts': '零件',
    'costOther': '其他',

    // KPI Labels
    'kpiAvailabilityRate': '可用率',

    // Settings & Menu (新增)
    'settingsTitle': '设置',
    'languageAndRegion': '语言和地区',
    'account': '账户',
    'appSettings': '应用设置',
    'support': '支持',
    'profileSettings': '个人资料设置',
    'managePersonalInfo': '管理您的个人信息',
    'security': '安全',
    'securityDescription': '密码、双因素认证和安全设置',
    'privacy': '隐私',
    'privacyDescription': '数据使用和隐私控制',
    'notifications': '通知',
    'notificationsDescription': '推送通知和警报',
    'theme': '主题',
    'themeDescription': '深色模式（始终开启）',
    'storage': '存储',
    'storageDescription': '缓存和数据管理',
    'helpFaq': '帮助和常见问题',
    'helpDescription': '获取帮助和查找答案',
    'reportIssue': '报告问题',
    'reportDescription': '报告错误或问题',
    'about': '关于',
    'aboutDescription': '应用版本和信息',
    'signOut': '退出登录',
    'signOutConfirm': '您确定要退出登录吗？',
    'signedOutSuccess': '成功退出登录',

    // Hamburger Menu (新增)
    'quickActions': '快速操作',
    'dashboard': '仪表板',
    'dashboardSubtitle': '转到主仪表板',
    'scanQrCode': '扫描二维码',
    'scanQrSubtitle': '扫描车辆二维码',
    'refreshData': '刷新数据',
    'refreshDataSubtitle': '同步最新数据',
    'dataRefreshed': '数据已刷新',
    'language': '语言',
    'english': '英语',
    'korean': '韩语',
    'japanese': '日语',
    'chineseSimplified': '简体中文',
    'chineseTraditional': '繁体中文',

    // Inventory Stats (新增)
    'total': '总计',
    'active': '活跃',
    'charging': '充电',
    'maintenance': '维护',
    'offline': '离线',

    // Cart Details & Metrics (新增)
    'battery': '电池',
    'speed': '速度',
    'systemMetrics': '系统指标',
    'live': '实时',
    'telemetry': '遥测',

    // Work Order & Alerts (新增)
    'workOrderStatus': '工作单状态',
    'alertRules': '警报规则',
    'escalationPath': '升级路径',
    'estimatedTime': '预计时间',

    // Common UI Elements (新增)
    'comingSoon': '即将推出',
    'ok': '确定',
    'version': '版本',
    'product': '产品',
    'languageChanged': '语言已更改为',

    // Work Order Type Selector (新增)
    'emergency': '紧急',
    'preventive': '预防性',
    'tire': '轮胎',
    'safety': '安全',
    'other': '其他',

    // Priority Selector (新增)
    'priorityLevel': '优先级',
    'critical': '紧急',
    'high': '高',
    'normal': '普通',
    'low': '低',

    // Alert Summary Cards (新增)
    'alertSummary': '警报摘要',
    'totalAlerts': '总警报',
    'resolved': '已解决',

    // Cart Detail Monitor (新增)
    'primaryTelemetry': '主要遥测',
    'motor': '电机',
    'main': '主',
    'daily': '每日',
    'energy': '能耗',
    'alerts': '警报',
    'remoteControls': '远程控制',
    'emergencyControls': '紧急控制',
    'emergencyStop': '紧急停止',
    'stopCart': '停止车辆',

    // About Dialog (新增)
    'aboutAproFleetManager': '关于 AproFleet 管理器',
    'versionInfo': '版本: 1.0.0',
    'manufacturerInfo': '制造商: DY Innovate',
    'productInfo': '产品: APRO 高尔夫球车',

    // Work Order Filters
    'woFilterAll': '全部',
    'woFilterUrgent': '紧急',
    'woFilterPending': '待处理',
    'woFilterInProgress': '进行中',
    'woFilterCompleted': '已完成',
    'woFilterTimeline': '时间线',

    // Work Order Stats
    'woStatsUrgent': '紧急',
    'woStatsPending': '待处理',
    'woStatsInProgress': '进行中',
    'woStatsToday': '今天',

    // Work Order Status
    'woStatusDraft': '草稿',
    'woStatusPending': '待处理',
    'woStatusInProgress': '进行中',
    'woStatusOnHold': '暂停',
    'woStatusCompleted': '已完成',
    'woStatusCancelled': '已取消',

    // Priority Levels
    'woPriorityP1': 'P1 (紧急)',
    'woPriorityP2': 'P2 (高)',
    'woPriorityP3': 'P3 (正常)',
    'woPriorityP4': 'P4 (低)',

    // Work Order Types
    'woTypeEmergency': '紧急维修',
    'woTypePreventive': '预防性维护',
    'woTypeBattery': '电池',
    'woTypeTire': '轮胎',
    'woTypeSafety': '安全检查',
    'woTypeOther': '其他',

    // Time Format
    'woTimeDays': '天',
    'woTimeHours': '小时',
    'woTimeMinutes': '分钟',
    'woTimeAgo': '前',

    // Messages
    'woNoWorkOrders': '未找到工作订单',
    'woErrorLoading': '加载工作订单时出错',
    'woRetry': '重试',

    // Hamburger Menu
    'menuSettings': '设置',
    'menuLanguage': '语言',
    'menuSettingsTitle': '设置',
    'menuSettingsSubtitle': '应用偏好设置和配置',
    'menuEnglish': 'English',
    'menuKorean': '한국어',
    'menuJapanese': '日本語',
    'menuChineseSimplified': '简体中文',
    'menuChineseTraditional': '繁體中文',
    'menuSignOut': '退出登录',
    'menuSignOutTitle': '退出登录',
    'menuSignOutMessage': '确定要退出登录吗？',
    'menuSignOutSuccess': '成功退出登录',

    // Alert Screen
    'alertTabAll': '全部',
    'alertTabUnread': '未读',
    'alertTabCart': '车辆',
    'alertTabBattery': '电池',
    'alertTabMaintenance': '维护',
    'alertTabGeofence': '地理围栏',
    'alertTabSystem': '系统',
    'alertErrorLoading': '加载警报时出错',
    'alertRetry': '重试',
    'alertNoAlerts': '未找到警报',
    'alertAcknowledge': '确认',
    'alertViewCart': '查看车辆',
    'alertCreateWorkOrder': '创建工作订单',
    'alertTimeJustNow': '刚刚',
    'alertTimeDaysAgo': '天前',
    'alertTimeHoursAgo': '小时前',
    'alertTimeMinutesAgo': '分钟前',

    // Alert Severity
    'alertSeverityCritical': '紧急',
    'alertSeverityWarning': '警告',
    'alertSeverityInfo': '信息',
    'alertSeveritySuccess': '成功',

    // Alert Status
    'alertStatusTriggered': '已触发',
    'alertStatusNotified': '已通知',
    'alertStatusAcknowledged': '已确认',
    'alertStatusEscalated': '已升级',
    'alertStatusResolved': '已解决',

    // Alert Source
    'alertSourceEmergency': '紧急',
    'alertSourceBattery': '电池',
    'alertSourceMaintenance': '维护',
    'alertSourceGeofence': '地理围栏',
    'alertSourceTemperature': '温度',
    'alertSourceSystem': '系统',
  };
}
