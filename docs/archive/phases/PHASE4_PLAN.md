# 📋 Phase 4 계획 - 전체 앱 VIA Design System 전환

**작성일:** 2025-10-23
**상태:** Planning & Roadmap
**목표:** 모든 화면을 VIA Design System으로 전환

---

## 🎯 현재 상태 (2025-10-23)

### ✅ 완료된 작업

#### Phase 1-2: 기본 VIA 컴포넌트 (완료)
- `ViaButton` - 4 variants (primary, secondary, ghost, danger)
- `ViaCard` - Glassmorphic cards
- `ViaChip` - Filter chips
- `ViaToast` - 4 variants with animations
- `ViaBottomSheet` - Draggable sheets with snap points
- `ViaModal` - Modal dialogs
- `ViaStatusBadge` - Status indicators
- `ViaPriorityBadge` - Priority indicators
- `ViaLoadingIndicator` - Loading states
- `ViaInput` - Text input fields (기존)

#### Phase 3: Live Map View (100% 완료) ✅
**파일:** 8개 컴포넌트 VIA 적용 완료
1. ✅ `ViaToast` - Slide animation, 4 variants
2. ✅ `ViaFilterSheet` - Draggable bottom sheet
3. ✅ `ViaStatusBar` - Animated status chips
4. ✅ `ViaCartListItem` - Scale animation, glow effects
5. ✅ `ViaIconButton` - 3 sizes, 3 variants (신규 생성)
6. ✅ `MapControls` - 6개 ViaIconButton
7. ✅ `MicroTag` - Smart badge colors
8. ✅ `ToneControlSlider` - VIA primary slider

**성과:**
- ~952 lines 개선 (신규 + 수정)
- 0 errors, 0 warnings
- 완전한 디자인 일관성
- Haptic feedback 전체 적용

---

## 📊 남은 작업 개요

### 우선순위 1: 빠른 개선 (Quick Wins) ⚡

#### 1.1 SnackBar → ViaToast 전환
**예상 시간:** 2-3시간
**영향력:** High (모든 화면에서 즉시 보임)

**작업 파일들:**
```
settings_page.dart (11곳)
alert_management_page.dart (예상 5곳)
work_order_creation_page.dart (예상 3곳)
cart_registration.dart (예상 2곳)
```

**Before:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Language changed')),
);
```

**After:**
```dart
ViaToast.show(
  context: context,
  message: 'Language changed',
  variant: ViaToastVariant.success,
);
```

**예상 효과:**
- 일관된 알림 디자인
- 부드러운 슬라이드 애니메이션
- Swipe to dismiss
- Haptic feedback

---

#### 1.2 AlertDialog → ViaBottomSheet/ViaModal 전환
**예상 시간:** 3-4시간
**영향력:** Medium-High

**작업 파일들:**
```
settings_page.dart
- Map Provider Dialog
- About Dialog
- Sign Out Dialog

alert_management_page.dart
- Search Dialog
```

**Before:**
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Title'),
    content: Text('Content'),
    actions: [
      TextButton(onPressed: () {}, child: Text('Cancel')),
      TextButton(onPressed: () {}, child: Text('OK')),
    ],
  ),
);
```

**After (Option A - ViaBottomSheet):**
```dart
ViaBottomSheet.show(
  context: context,
  header: Text('Title', style: ViaDesignTokens.headingMedium),
  child: Text('Content'),
  footer: Row(
    children: [
      Expanded(child: ViaButton.ghost(text: 'Cancel', onPressed: () {})),
      SizedBox(width: 12),
      Expanded(child: ViaButton.primary(text: 'OK', onPressed: () {})),
    ],
  ),
);
```

**After (Option B - ViaModal):**
```dart
ViaModal.show(
  context: context,
  title: 'Title',
  content: 'Content',
  primaryAction: ViaModalAction(
    text: 'OK',
    onPressed: () {},
  ),
  secondaryAction: ViaModalAction(
    text: 'Cancel',
    onPressed: () {},
  ),
);
```

---

### 우선순위 2: 주요 화면 전환 🎨

#### 2.1 Settings Page
**예상 시간:** 4-6시간
**복잡도:** Medium

**현재 사용 중인 non-VIA 컴포넌트:**
- ❌ `SnackBar` (11곳) → ViaToast
- ❌ `AlertDialog` (3곳) → ViaBottomSheet/ViaModal
- ✅ `SettingsSection` (이미 괜찮음, 필요시 ViaCard로)
- ✅ `SettingsMenuItem` (이미 괜찮음)
- ❌ `ActionButton` → ViaButton.danger

**작업 계획:**
1. 모든 SnackBar → ViaToast (1-2h)
2. 모든 AlertDialog → ViaBottomSheet (2-3h)
3. Sign Out button → ViaButton.danger (15min)
4. 테스트 및 검증 (30min)

---

#### 2.2 Alert Management Page
**예상 시간:** 6-8시간
**복잡도:** High

**현재 상태:**
- AlertNotificationCard (커스텀 디자인)
- AlertSummaryCards
- AlertFilters
- AlertDetailModal
- AlertRulesPanel

**작업 계획:**
1. **AlertNotificationCard → ViaCard 기반** (2-3h)
   - Severity indicator → VIA colors
   - Priority badge → ViaPriorityBadge
   - Unread dot → VIA critical color

2. **AlertSummaryCards → ViaCard** (1-2h)
   - 4개 summary cards VIA 스타일

3. **AlertFilters → ViaFilterSheet** (1-2h)
   - 이미 ViaFilterSheet 있음, 재사용

4. **AlertDetailModal → ViaBottomSheet** (1-2h)
   - Draggable modal
   - ViaButton actions

5. **Search Dialog → ViaInput** (30min-1h)

---

#### 2.3 Work Order Creation Page
**예상 시간:** 5-7시간
**복잡도:** High

**필요한 신규 컴포넌트:**
- ❓ ViaSelect (Dropdown)
- ❓ ViaTextArea (Multi-line input)
- ❓ ViaDatePicker
- ❓ ViaSwitch (Toggle)

**작업 계획:**
1. **Form inputs → ViaInput** (2-3h)
   - Cart ID input
   - Description textarea (ViaInput with maxLines)
   - Priority selection

2. **Date picker → ViaDatePicker** (1-2h)
   - 필요시 신규 생성

3. **Switches → ViaSwitch** (1h)
   - 신규 컴포넌트 생성

4. **Submit/Cancel → ViaButton** (30min)

---

#### 2.4 Cart Management Pages
**예상 시간:** 4-6시간
**복잡도:** Medium

**파일들:**
- cart_inventory_list.dart
- cart_registration.dart
- cart_detail_monitor.dart

**작업 계획:**
1. **Cart List Items → ViaCard** (2-3h)
2. **Registration Form → ViaInput** (1-2h)
3. **Detail panels → ViaCard** (1-2h)

---

### 우선순위 3: 신규 VIA 컴포넌트 생성 🔧

#### 3.1 ViaSwitch (Toggle)
**예상 시간:** 1-2시간
**필요 화면:** Settings, Work Order Creation

**디자인 사양:**
```dart
ViaSwitch(
  value: true,
  onChanged: (value) {},
  activeColor: ViaDesignTokens.primary,
  inactiveColor: ViaDesignTokens.textMuted,
  enableHaptic: true,
)
```

**기능:**
- Slide animation (150ms)
- Haptic feedback
- Disabled state
- Custom colors (optional)

---

#### 3.2 ViaCheckbox
**예상 시간:** 1-2시간
**필요 화면:** Alert filters, Work orders

**디자인 사양:**
```dart
ViaCheckbox(
  value: true,
  onChanged: (value) {},
  label: 'Option label',
  enableHaptic: true,
)
```

**기능:**
- Check animation
- Haptic feedback
- Label support
- Disabled state

---

#### 3.3 ViaSelect (Dropdown)
**예상 시간:** 2-3시간
**필요 화면:** Work Order Creation, Filters

**디자인 사양:**
```dart
ViaSelect<String>(
  value: 'option1',
  items: [
    ViaSelectItem(value: 'option1', label: 'Option 1'),
    ViaSelectItem(value: 'option2', label: 'Option 2'),
  ],
  onChanged: (value) {},
  label: 'Select option',
)
```

**기능:**
- Bottom sheet picker (모바일)
- Dropdown menu (데스크톱)
- Search support (optional)
- Custom item rendering

---

#### 3.4 ViaDatePicker
**예상 시간:** 2-3시간
**필요 화면:** Work Order Creation, Reporting

**디자인 사양:**
```dart
ViaDatePicker(
  selectedDate: DateTime.now(),
  onDateSelected: (date) {},
  label: 'Select date',
  minDate: DateTime.now(),
  maxDate: DateTime.now().add(Duration(days: 365)),
)
```

**기능:**
- Calendar view (ViaBottomSheet)
- Date range selection (optional)
- VIA styled calendar

---

## 📋 전체 작업 체크리스트

### Phase 4-1: Quick Wins (1주)
- [ ] Settings Page - SnackBar → ViaToast (2h)
- [ ] Settings Page - AlertDialog → ViaBottomSheet (3h)
- [ ] Settings Page - ActionButton → ViaButton (30min)
- [ ] Alert Management - Search Dialog → ViaInput (1h)
- [ ] 전체 프로젝트 grep으로 SnackBar 찾아서 전환 (3-4h)

**예상 총 시간:** 10-12시간 (1.5일)

### Phase 4-2: 신규 컴포넌트 (1주)
- [ ] ViaSwitch 생성 및 테스트 (2h)
- [ ] ViaCheckbox 생성 및 테스트 (2h)
- [ ] ViaSelect 생성 및 테스트 (3h)
- [ ] ViaDatePicker 생성 및 테스트 (3h)

**예상 총 시간:** 10시간 (1.5일)

### Phase 4-3: Alert Management (1주)
- [ ] AlertNotificationCard → ViaCard (3h)
- [ ] AlertSummaryCards → ViaCard (2h)
- [ ] AlertFilters → ViaFilterSheet (2h)
- [ ] AlertDetailModal → ViaBottomSheet (2h)

**예상 총 시간:** 9시간 (1-2일)

### Phase 4-4: Work Order Pages (1주)
- [ ] Work Order Creation - Form inputs (3h)
- [ ] Work Order Creation - Date picker (2h)
- [ ] Work Order Creation - Buttons (1h)
- [ ] Work Order List - List items (2h)

**예상 총 시간:** 8시간 (1일)

### Phase 4-5: Cart Management (3-4일)
- [ ] Cart Inventory List (3h)
- [ ] Cart Registration (3h)
- [ ] Cart Detail Monitor (2h)

**예상 총 시간:** 8시간 (1일)

---

## 🎨 VIA Design Patterns

### Pattern 1: SnackBar → ViaToast

**Before:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Message')),
);
```

**After:**
```dart
ViaToast.show(
  context: context,
  message: 'Message',
  variant: ViaToastVariant.success,
);
```

**Variants:**
- `ViaToastVariant.success` - Green (00C97B)
- `ViaToastVariant.error` - Red (C23D3D)
- `ViaToastVariant.warning` - Orange (FFAA00)
- `ViaToastVariant.info` - Blue (3B83CC)

---

### Pattern 2: AlertDialog → ViaBottomSheet

**Before:**
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
      TextButton(child: Text('OK'), onPressed: () {}),
    ],
  ),
);
```

**After:**
```dart
ViaBottomSheet.show(
  context: context,
  snapPoints: [0.3, 0.6],
  header: Text('Confirm', style: ViaDesignTokens.headingMedium),
  child: Text('Are you sure?', style: ViaDesignTokens.bodyMedium),
  footer: Row(
    children: [
      Expanded(
        child: ViaButton.ghost(
          text: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      SizedBox(width: ViaDesignTokens.spacingMd),
      Expanded(
        child: ViaButton.primary(
          text: 'OK',
          onPressed: () {
            // Action
            Navigator.pop(context);
          },
        ),
      ),
    ],
  ),
);
```

---

### Pattern 3: List Items → ViaCard

**Before:**
```dart
Container(
  margin: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.grey[900],
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    title: Text('Title'),
    subtitle: Text('Subtitle'),
    onTap: () {},
  ),
)
```

**After:**
```dart
ViaCard(
  onTap: () {},
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Title', style: ViaDesignTokens.headingSmall),
      SizedBox(height: ViaDesignTokens.spacingSm),
      Text('Subtitle', style: ViaDesignTokens.bodySmall),
    ],
  ),
)
```

---

### Pattern 4: Text Input → ViaInput

**Before:**
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
  ),
  onChanged: (value) {},
)
```

**After:**
```dart
ViaInput(
  label: 'Email',
  placeholder: 'Enter your email',
  type: ViaInputType.email,
  onChanged: (value) {},
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  },
)
```

---

### Pattern 5: Buttons → ViaButton

**Before:**
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Submit'),
)

TextButton(
  onPressed: () {},
  child: Text('Cancel'),
)

OutlinedButton(
  onPressed: () {},
  child: Text('Learn More'),
)
```

**After:**
```dart
ViaButton.primary(
  text: 'Submit',
  onPressed: () {},
  icon: Icons.check,
)

ViaButton.ghost(
  text: 'Cancel',
  onPressed: () {},
)

ViaButton.secondary(
  text: 'Learn More',
  onPressed: () {},
)
```

---

## 🚀 실행 전략

### Week 1: Quick Wins
**목표:** 즉각적인 UX 개선

1. **Day 1-2:** SnackBar → ViaToast 전체 전환
2. **Day 3-4:** Settings Page 완료
3. **Day 5:** AlertDialog → ViaBottomSheet (주요 화면만)

**예상 결과:** 모든 알림이 VIA 스타일로 통일

---

### Week 2: 컴포넌트 기반 강화
**목표:** 재사용 가능한 VIA 컴포넌트 확보

1. **Day 1:** ViaSwitch, ViaCheckbox
2. **Day 2:** ViaSelect
3. **Day 3-4:** ViaDatePicker
4. **Day 5:** 컴포넌트 테스트 및 문서화

**예상 결과:** 모든 폼 요소에 VIA 적용 가능

---

### Week 3-4: 화면별 전환
**목표:** 주요 화면 100% VIA 전환

1. **Week 3:** Alert Management, Work Order Creation
2. **Week 4:** Cart Management, Analytics

**예상 결과:** 전체 앱 80-90% VIA 전환 완료

---

## 📊 예상 타임라인

```
Week 1 (Quick Wins)
├── Settings Page (100%)
├── SnackBar → ViaToast (전체)
└── 주요 Dialogs → ViaBottomSheet

Week 2 (Components)
├── ViaSwitch
├── ViaCheckbox
├── ViaSelect
└── ViaDatePicker

Week 3 (Screens)
├── Alert Management (100%)
└── Work Order Creation (100%)

Week 4 (Screens)
├── Cart Management (100%)
├── Analytics Dashboard (80%)
└── Final polish & documentation
```

---

## 💡 Best Practices

### 1. 점진적 전환
- ✅ 한 화면씩 완전히 전환
- ✅ 각 전환 후 테스트
- ❌ 여러 화면을 동시에 부분적으로 전환하지 않기

### 2. 일관성 유지
- ✅ 모든 버튼은 ViaButton
- ✅ 모든 알림은 ViaToast
- ✅ 모든 카드는 ViaCard
- ❌ Material 컴포넌트와 VIA 혼용하지 않기

### 3. 애니메이션 통일
- ✅ durationFast (150ms) - 작은 인터랙션
- ✅ durationNormal (300ms) - 모달, 시트
- ✅ curveStandard (easeInOut) - 기본
- ✅ curveDeceleration (easeOut) - 등장

### 4. Haptic Feedback
- ✅ 모든 버튼 탭
- ✅ 토글 스위치
- ✅ 체크박스
- ❌ 텍스트 입력에는 사용하지 않기

---

## 📝 체크포인트

### Checkpoint 1: Week 1 완료
- [ ] Settings Page 100% VIA
- [ ] 모든 SnackBar → ViaToast
- [ ] flutter analyze: 0 errors
- [ ] 사용자 테스트 완료

### Checkpoint 2: Week 2 완료
- [ ] 4개 신규 컴포넌트 생성
- [ ] 컴포넌트 문서화 완료
- [ ] Storybook/예시 페이지 생성

### Checkpoint 3: Week 3 완료
- [ ] Alert Management 100% VIA
- [ ] Work Order Creation 100% VIA
- [ ] E2E 테스트 통과

### Checkpoint 4: Week 4 완료
- [ ] 전체 앱 90% 이상 VIA
- [ ] 성능 테스트 통과
- [ ] Phase 4 완료 문서

---

## 🎯 성공 지표

### 코드 품질
- [ ] flutter analyze: 0 errors, 0 warnings
- [ ] 모든 VIA 컴포넌트 테스트 커버리지 80% 이상
- [ ] 코드 리뷰 완료

### 디자인 일관성
- [ ] 모든 화면 VIA Design System 준수
- [ ] 일관된 spacing, typography, colors
- [ ] 일관된 animation durations

### 사용자 경험
- [ ] 모든 인터랙션 haptic feedback
- [ ] 부드러운 애니메이션 (60fps)
- [ ] Accessibility 기준 충족

---

**다음 단계:** Quick Wins부터 시작! 🚀

Settings Page의 SnackBar를 ViaToast로 전환하는 것으로 Phase 4 시작하기.
