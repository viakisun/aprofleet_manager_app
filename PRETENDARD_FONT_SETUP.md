# Pretendard Variable Font Setup

## 📥 Download Pretendard Variable Font

Pretendard Variable 폰트는 VIA 디자인 시스템의 핵심 타이포그래피입니다.

### 1. 다운로드 방법

**공식 GitHub 저장소:**
https://github.com/orioncactus/pretendard/releases

**최신 릴리스에서 다운로드:**
- `Pretendard-X.X.X.zip` 파일 다운로드
- 압축 해제 후 `/variable/` 폴더 찾기
- `PretendardVariable.ttf` 파일 확인

### 2. 폰트 파일 설치

다운로드한 `PretendardVariable.ttf` 파일을 다음 경로에 복사:

```
aprofleet_manager_app/
└── assets/
    └── fonts/
        └── PretendardVariable.ttf  ← 여기에 복사
```

### 3. 폰트 적용 확인

폰트가 제대로 설치되었는지 확인:

```bash
# 폰트 파일 확인
ls assets/fonts/PretendardVariable.ttf

# Flutter clean 및 재빌드
flutter clean
flutter pub get
flutter run
```

### 4. 폰트 라이선스

**Pretendard는 OFL(SIL Open Font License) 1.1 라이선스를 사용합니다.**
- ✅ 상업적 사용 가능
- ✅ 수정 및 재배포 가능
- ✅ 임베딩 가능
- ⚠️ 라이선스 파일 포함 필수

라이선스 파일은 다운로드한 폰트 패키지에 포함되어 있습니다.

## 📱 폰트 특징

### Variable Font Weights (100-900)
- Thin (100)
- Extra Light (200)
- Light (300)
- Regular (400)
- Medium (500)
- Semibold (600)
- Bold (700)
- Extra Bold (800)
- Black (900)

### 지원 언어
- 한국어 (완벽한 한글 지원)
- 영어 (Latin)
- 일본어 (Hiragana, Katakana)
- 중국어 간체/번체 일부

### 디자인 특징
- 현대적이고 깔끔한 디자인
- 가독성이 우수한 스크린 최적화
- 한글/영문 조화가 뛰어남
- Apple/Google 시스템 폰트와 유사한 느낌

## 🎨 VIA 디자인 토큰에서 사용

폰트가 설치되면 VIA 디자인 토큰이 자동으로 Pretendard Variable을 사용합니다:

```dart
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

// 자동으로 Pretendard Variable 적용됨
Text(
  'Golf Cart Manager',
  style: ViaDesignTokens.headingLarge,
);

// Weight 지정
Text(
  'Active Carts: 12',
  style: ViaDesignTokens.displayMedium.copyWith(
    fontWeight: ViaDesignTokens.fontWeightBold,
  ),
);
```

## ⚠️ Fallback Font

Pretendard Variable 폰트가 없는 경우 자동으로 SF Pro Display로 폴백됩니다.

개발 중에는 SF Pro Display로도 테스트 가능하지만, 최종 빌드에서는 반드시 Pretendard Variable을 포함해야 합니다.

## 📝 다음 단계

폰트 설치 완료 후:
1. `flutter clean`
2. `flutter pub get`
3. `flutter run`

앱을 실행하면 VIA 디자인 시스템이 Pretendard Variable 폰트로 렌더링됩니다.
