class AppLocalizationsKo {
  static const Map<String, String> values = {
    // App Name
    'appName': 'AproFleet 매니저',

    // Navigation
    'navRealTime': '플릿',
    'navCartManagement': '차량',
    'navMaintenance': '서비스',
    'navAlerts': '알림',
    'navAnalytics': '분석',
    'navSettings': '설정',

    // Cart Registration
    'registerCart': '카트 등록',
    'cartRegistration': '카트 등록',
    'vinNumber': 'VIN 번호',
    'manufacturer': '제조사',
    'model': '모델',
    'year': '연도',
    'color': '색상',
    'batteryType': '배터리 타입',
    'voltage': '전압',
    'seating': '좌석 수',
    'maxSpeed': '최고 속도',
    'gpsTrackerId': 'GPS 트래커 ID',
    'telemetryDeviceId': '텔레메트리 디바이스 ID',
    'componentSerials': '컴포넌트 시리얼',
    'imagePaths': '이미지 경로',
    'purchaseDate': '구매일',
    'warrantyExpiry': '보증 만료일',
    'insuranceNumber': '보험 번호',
    'odometer': '주행거리계',

    // Work Order Creation
    'createWorkOrder': '작업 지시서 생성',
    'workOrderCreation': '작업 지시서 생성',
    'workOrderType': '작업 지시서 타입',
    'priority': '우선순위',
    'description': '설명',
    'technician': '기술자',
    'parts': '부품',
    'location': '위치',
    'notes': '메모',
    'checklist': '체크리스트',
    'scheduledAt': '예정일시',
    'estimatedDuration': '예상 소요시간',

    // Common
    'search': '검색',
    'filter': '필터',
    'add': '추가',
    'save': '저장',
    'cancel': '취소',
    'confirm': '확인',
    'delete': '삭제',
    'edit': '편집',
    'view': '보기',
    'track': '추적',
    'details': '세부정보',
    'service': '서비스',
    'refresh': '새로고침',
    'export': '내보내기',
    'loading': '로딩 중...',
    'error': '오류',
    'success': '성공',
    'warning': '경고',
    'info': '정보',

    // Cart Status
    'statusActive': '운행중',
    'statusIdle': '대기중',
    'statusCharging': '충전중',
    'statusMaintenance': '정비중',
    'statusOffline': '오프라인',

    // Priority
    'priorityCritical': '긴급',
    'priorityHigh': '높음',
    'priorityNormal': '보통',
    'priorityLow': '낮음',

    // Alert Severity
    'alertCritical': '긴급',
    'alertWarning': '경고',
    'alertInfo': '정보',
    'alertSuccess': '성공',

    // Work Order Types
    'woEmergency': '긴급 수리',
    'woPreventive': '예방 정비',
    'woBattery': '배터리 서비스',
    'woTire': '타이어 서비스',
    'woSafety': '안전 점검',
    'woOther': '기타',

    // Manufacturers
    'manufacturerDYInnovate': 'DY Innovate',
    'manufacturerEZGO': 'E-Z-GO',
    'manufacturerClubCar': 'Club Car',
    'manufacturerYamaha': '야마하',
    'manufacturerCushman': 'Cushman',

    // Analytics Dashboard
    'analyticsPeriod': '기간:',
    'analyticsWeek': '주간',
    'analyticsMonth': '월간',
    'analyticsKpiTitle': '핵심 성과 지표',
    'analyticsChartsTitle': '성과 차트',
    'analyticsFleetPerformance': '플릿 성능',
    'analyticsBatteryHealth': '배터리 상태 추세',
    'analyticsMaintenanceDistribution': '정비 분포',
    'analyticsCostAnalysis': '비용 분석',

    // KPI Labels
    'kpiAvailability': '가동률',
    'kpiMTTR': 'MTTR',
    'kpiUtilization': '일일 활용도',
    'kpiDailyDistance': '일일 주행거리',

    // Units
    'unitPercent': '%',
    'unitMinutes': '분',
    'unitKilometers': 'km',
    'unitKilometersPerHour': 'km/h',
    'unitVolts': 'V',
    'unitAmperes': 'A',
    'unitCelsius': '°C',

    // Maintenance Distribution
    'maintenancePreventive': '예방',
    'maintenanceBattery': '배터리',
    'maintenanceTire': '타이어',
    'maintenanceEmergency': '긴급',
    'maintenanceOther': '기타',

    // Cost Analysis
    'costTotal': '총계',
    'costLabor': '인건비',
    'costParts': '부품비',
    'costOther': '기타',

    // KPI Labels
    'kpiAvailabilityRate': '가용률',

    // Settings & Menu (新增)
    'settingsTitle': '설정',
    'languageAndRegion': '언어 및 지역',
    'account': '계정',
    'appSettings': '앱 설정',
    'support': '지원',
    'profileSettings': '프로필 설정',
    'managePersonalInfo': '개인 정보 관리',
    'security': '보안',
    'securityDescription': '비밀번호, 2단계 인증 및 보안 설정',
    'privacy': '개인정보 보호',
    'privacyDescription': '데이터 사용 및 개인정보 보호 제어',
    'notifications': '알림',
    'notificationsDescription': '푸시 알림 및 경고',
    'theme': '테마',
    'themeDescription': '다크 모드 (항상 켜짐)',
    'storage': '저장소',
    'storageDescription': '캐시 및 데이터 관리',
    'helpFaq': '도움말 및 FAQ',
    'helpDescription': '도움말 및 답변 찾기',
    'reportIssue': '문제 신고',
    'reportDescription': '버그 또는 문제 신고',
    'about': '정보',
    'aboutDescription': '앱 버전 및 정보',
    'signOut': '로그아웃',
    'signOutConfirm': '로그아웃하시겠습니까?',
    'signedOutSuccess': '성공적으로 로그아웃되었습니다',

    // Hamburger Menu (新增)
    'quickActions': '빠른 작업',
    'dashboard': '대시보드',
    'dashboardSubtitle': '메인 대시보드로 이동',
    'scanQrCode': 'QR 코드 스캔',
    'scanQrSubtitle': '카트 QR 코드 스캔',
    'refreshData': '데이터 새로고침',
    'refreshDataSubtitle': '최신 데이터 동기화',
    'dataRefreshed': '데이터가 새로고침되었습니다',
    'language': '언어',
    'english': '영어',
    'korean': '한국어',
    'japanese': '일본어',
    'chineseSimplified': '중국어 간체',
    'chineseTraditional': '중국어 번체',

    // Inventory Stats (新增)
    'total': '전체',
    'active': '활성',
    'charging': '충전',
    'maintenance': '정비',
    'offline': '오프라인',

    // Cart Details & Metrics (新增)
    'battery': '배터리',
    'speed': '속도',
    'systemMetrics': '시스템 지표',
    'live': '실시간',
    'telemetry': '텔레메트리',

    // Work Order & Alerts (新增)
    'workOrderStatus': '작업 지시서 상태',
    'alertRules': '경고 규칙',
    'escalationPath': '에스컬레이션 경로',
    'estimatedTime': '예상 시간',

    // Common UI Elements (新增)
    'comingSoon': '곧 출시',
    'ok': '확인',
    'version': '버전',
    'product': '제품',
    'languageChanged': '언어가 다음으로 변경되었습니다',

    // Work Order Type Selector (新增)
    'emergency': '긴급',
    'preventive': '예방',
    'tire': '타이어',
    'safety': '안전',
    'other': '기타',

    // Priority Selector (新增)
    'priorityLevel': '우선순위',
    'critical': '긴급',
    'high': '높음',
    'normal': '보통',
    'low': '낮음',

    // Alert Summary Cards (新增)
    'alertSummary': '경고 요약',
    'totalAlerts': '전체 경고',
    'resolved': '해결됨',

    // Cart Detail Monitor (新增)
    'primaryTelemetry': '주요 텔레메트리',
    'motor': '모터',
    'main': '메인',
    'daily': '일일',
    'energy': '에너지',
    'alerts': '경고',
    'remoteControls': '원격 제어',
    'emergencyControls': '비상 제어',
    'emergencyStop': '비상 정지',
    'stopCart': '카트 정지',

    // About Dialog (新增)
    'aboutAproFleetManager': 'AproFleet 매니저 정보',
    'versionInfo': '버전: 1.0.0',
    'manufacturerInfo': '제조사: DY Innovate',
    'productInfo': '제품: APRO 골프 카트',

    // Work Order Filters
    'woFilterAll': '전체',
    'woFilterUrgent': '긴급',
    'woFilterPending': '대기',
    'woFilterInProgress': '진행중',
    'woFilterCompleted': '완료',
    'woFilterTimeline': '타임라인',

    // Work Order Stats
    'woStatsUrgent': '긴급',
    'woStatsPending': '대기중',
    'woStatsInProgress': '진행중',
    'woStatsToday': '오늘',

    // Work Order Status
    'woStatusDraft': '초안',
    'woStatusPending': '대기중',
    'woStatusInProgress': '진행중',
    'woStatusOnHold': '보류',
    'woStatusCompleted': '완료됨',
    'woStatusCancelled': '취소됨',

    // Priority Levels
    'woPriorityP1': 'P1 (긴급)',
    'woPriorityP2': 'P2 (높음)',
    'woPriorityP3': 'P3 (보통)',
    'woPriorityP4': 'P4 (낮음)',

    // Work Order Types
    'woTypeEmergency': '긴급 수리',
    'woTypePreventive': '예방 정비',
    'woTypeBattery': '배터리',
    'woTypeTire': '타이어',
    'woTypeSafety': '안전',
    'woTypeOther': '기타',

    // Time Format
    'woTimeDays': '일',
    'woTimeHours': '시간',
    'woTimeMinutes': '분',
    'woTimeAgo': '전',

    // Messages
    'woNoWorkOrders': '작업 지시서가 없습니다',
    'woErrorLoading': '작업 지시서 로드 중 오류 발생',
    'woRetry': '다시 시도',

    // Hamburger Menu
    'menuSettings': '설정',
    'menuLanguage': '언어',
    'menuSettingsTitle': '설정',
    'menuSettingsSubtitle': '앱 환경설정 및 구성',
    'menuEnglish': 'English',
    'menuKorean': '한국어',
    'menuJapanese': '日本語',
    'menuChineseSimplified': '简体中文',
    'menuChineseTraditional': '繁體中文',
    'menuSignOut': '로그아웃',
    'menuSignOutTitle': '로그아웃',
    'menuSignOutMessage': '정말 로그아웃하시겠습니까?',
    'menuSignOutSuccess': '성공적으로 로그아웃되었습니다',

    // Alert Screen
    'alertTabAll': '전체',
    'alertTabUnread': '읽지 않음',
    'alertTabCart': '카트',
    'alertTabBattery': '배터리',
    'alertTabMaintenance': '정비',
    'alertTabGeofence': '지오펜스',
    'alertTabSystem': '시스템',
    'alertErrorLoading': '알림 로드 중 오류 발생',
    'alertRetry': '다시 시도',
    'alertNoAlerts': '알림이 없습니다',
    'alertAcknowledge': '확인',
    'alertViewCart': '카트 보기',
    'alertCreateWorkOrder': '작업 지시서 생성',
    'alertTimeJustNow': '방금 전',
    'alertTimeDaysAgo': '일 전',
    'alertTimeHoursAgo': '시간 전',
    'alertTimeMinutesAgo': '분 전',

    // Alert Severity
    'alertSeverityCritical': '긴급',
    'alertSeverityWarning': '경고',
    'alertSeverityInfo': '정보',
    'alertSeveritySuccess': '성공',

    // Alert Status
    'alertStatusTriggered': '발생',
    'alertStatusNotified': '알림됨',
    'alertStatusAcknowledged': '확인됨',
    'alertStatusEscalated': '에스컬레이션',
    'alertStatusResolved': '해결됨',

    // Alert Source
    'alertSourceEmergency': '긴급',
    'alertSourceBattery': '배터리',
    'alertSourceMaintenance': '정비',
    'alertSourceGeofence': '지오펜스',
    'alertSourceTemperature': '온도',
    'alertSourceSystem': '시스템',
  };
}
