# Industrial Dark UI System Migration Plan

## 📋 Overview

Migrate from current VIA Design System to **Industrial Dark UI System** — a professional-grade design language optimized for outdoor field operations under sunlight.

**Design Motto:** "Control in Clarity — 현장에서 즉시 인식되는 정교함"

---

## 🎯 Key Changes Summary

| Aspect | Current (VIA) | Target (Industrial Dark) | Reason |
|--------|---------------|-------------------------|---------|
| **Background** | `#0A0A0A` (near-black) | `#1A1A1A` (dark gray) | Reduce screen reflection, improve outdoor readability |
| **Card Surface** | `#1A1A1A` | `#222222` | Better tonal separation |
| **Depth Expression** | Subtle shadows + borders | **Outlines only** (#3A3A3A) | Clearer structure, no shadow artifacts |
| **Primary Accent** | Multiple colors | **Single blue** (#0072E5) | Focus, consistency |
| **Text Opacity** | Various | 85% / 60% (primary/secondary) | Standardized hierarchy |
| **Border Radius** | 8px (lg), 12px (xl) | **12px** (unified) | Consistent card treatment |
| **Elevation** | 0-24px | **0px** (eliminated) | Outline-based depth |
| **Navigation** | ~~Tabs~~ (removed) | Bottom Sheet + Filters | ✅ Already done! |

---

## 📐 New Design Tokens

### Colors

```dart
class IndustrialDarkTokens {
  // ========================================================================
  // BACKGROUNDS
  // ========================================================================
  static const Color bgBase = Color(0xFF1A1A1A);         // Main scaffold
  static const Color bgSurface = Color(0xFF222222);      // Cards, sheets
  static const Color bgOverlay = Color(0x40000000);      // Map overlay (25%)

  // ========================================================================
  // BORDERS & OUTLINES
  // ========================================================================
  static const Color outline = Color(0xFF3A3A3A);        // Structural borders
  static const Color outlineEmphasis = Color(0xFF505050); // Focused state

  // ========================================================================
  // TEXT
  // ========================================================================
  static const Color textPrimary = Color(0xD9FFFFFF);    // rgba(255,255,255,0.85)
  static const Color textSecondary = Color(0x99FFFFFF);  // rgba(255,255,255,0.6)
  static const Color textDisabled = Color(0x4DFFFFFF);   // rgba(255,255,255,0.3)

  // ========================================================================
  // ACCENT & ACTIONS
  // ========================================================================
  static const Color accentPrimary = Color(0xFF0072E5); // The ONLY colored accent
  static const Color accentHover = Color(0xFF005BB5);   // Pressed state

  // ========================================================================
  // FUNCTIONAL STATES (use sparingly)
  // ========================================================================
  static const Color error = Color(0xFFE84545);         // Errors/emergencies only
  static const Color warning = Color(0xFFFFC107);       // Caution (optional)
  static const Color success = Color(0xFF4CAF50);       // Confirmation (optional)

  // ========================================================================
  // TYPOGRAPHY
  // ========================================================================
  static const double fontSizeDisplay = 24.0;           // Headings
  static const double fontSizeBody = 16.0;              // Main content
  static const double fontSizeLabel = 14.0;             // Labels
  static const double fontSizeData = 18.0;              // Monospace telemetry

  static const FontWeight fontWeightBold = FontWeight.w600;   // Semibold
  static const FontWeight fontWeightMedium = FontWeight.w500; // Medium
  static const FontWeight fontWeightRegular = FontWeight.w400; // Regular

  static const double lineHeight = 1.4;                 // Outdoor legibility
  static const double letterSpacing = 0.2;              // Slight expansion

  // ========================================================================
  // SPACING
  // ========================================================================
  static const double spacingSection = 24.0;            // Between sections
  static const double spacingCard = 16.0;               // Card padding
  static const double spacingItem = 12.0;               // Between items
  static const double spacingCompact = 8.0;             // Tight spacing

  // ========================================================================
  // RADIUS
  // ========================================================================
  static const double radiusCard = 12.0;                // Unified card radius
  static const double radiusButton = 8.0;               // Button radius
  static const double radiusChip = 20.0;                // Filter chip (pill)

  // ========================================================================
  // BORDERS
  // ========================================================================
  static const double borderWidth = 2.0;                // Structural outline width
  static const double borderWidthThin = 1.0;            // Subtle dividers
}
```

---

## 🔄 Migration Tasks

### Phase 1: Core Token Replacement (Priority: HIGH)

**Goal:** Replace VIA tokens with Industrial Dark tokens system-wide.

#### 1.1 Create Industrial Dark Tokens File
**File:** `lib/core/theme/industrial_dark_tokens.dart`
- Copy token definitions from above
- Add helper methods for opacity calculations
- Add semantic aliases (e.g., `colorCardBg = bgSurface`)

#### 1.2 Update Existing Components
**Files to modify:**
- `lib/core/widgets/via/via_card.dart`
  - Background: `bgSurface`
  - Border: `2dp solid outline`
  - Radius: `radiusCard`
  - **Remove elevation completely**

- `lib/core/widgets/via/via_button.dart`
  - Primary: `accentPrimary` background
  - Secondary: transparent + `outline` border
  - Danger: `error` (use sparingly)
  - **Remove shadows**

- `lib/core/widgets/via/via_bottom_sheet.dart`
  - Background: `bgSurface`
  - Border top: `2dp solid outline`
  - **Remove elevation**

- `lib/core/widgets/via/via_control_bar.dart`
  - Background: `bgBase`
  - Border bottom: `2dp solid outline`
  - **No shadow**

#### 1.3 Update Theme File
**File:** `lib/theme/via_theme.dart` → Rename to `industrial_dark_theme.dart`
- Replace all `ViaDesignTokens` with `IndustrialDarkTokens`
- Remove `elevation` from all theme data
- Add `border` to replace shadow-based depth
- Update `scaffoldBackgroundColor` to `bgBase`
- Update `cardColor` to `bgSurface`

---

### Phase 2: Component Visual Refinement (Priority: MEDIUM)

#### 2.1 Alert Compact Card
**Changes:**
- Background: `bgSurface`
- Border: `2dp solid outline` (always visible)
- Active state: border changes to `accentPrimary`
- Remove unread glow effect, replace with `accentPrimary` border

#### 2.2 Work Order Card
**Changes:**
- Same treatment as Alert Card
- Priority badge: keep ViaPriority colors (functional state colors)
- Status badge: use minimal color (prefer text + icon)

#### 2.3 Map Markers
**Changes:**
- Normal: fill `accentPrimary` + 2px outline `#FFFFFF`
- Selected: fill `#FFFFFF` + 2px outline `accentPrimary`
- **Dual-tone for outdoor visibility**

#### 2.4 Bottom Sheets
**Changes:**
- Background: `bgSurface`
- Top border: `2dp solid outline`
- Handle bar: `outlineEmphasis`
- **No rounded shadows**

---

### Phase 3: Typography & Iconography (Priority: MEDIUM)

#### 3.1 Font Hierarchy
**Apply to all text:**
- Display/Heading: 24sp, Semibold, 85% opacity
- Body: 16sp, Regular–Medium, 85% opacity
- Label: 14sp, Medium, 60% opacity
- Monospace Data: 18sp, Medium (use Roboto Mono for telemetry)

#### 3.2 Icon Treatment
**Changes:**
- Use **filled icons** instead of outlined
- Default size: 24dp
- Important icons: 28dp
- Opacity: 85% (primary), 60% (secondary)

---

### Phase 4: Motion & Feedback (Priority: LOW)

#### 4.1 Transitions
**Update all animations:**
- Duration: 120–200ms
- Curve: `Curves.easeOut` or `Curves.linear`
- **Remove:** bounce, overshoot, elastic curves

#### 4.2 Feedback Patterns
**Success:**
- Subtle blue flash on `accentPrimary` background
- No toast notification (use inline confirmation)

**Error:**
- Red underline + haptic vibration
- Use `error` color sparingly

**Loading:**
- Thin `LinearProgressIndicator` only
- Color: `accentPrimary`
- **No circular spinner overlays**

---

### Phase 5: Accessibility & Field Usability (Priority: HIGH)

#### 5.1 Contrast Requirements
**Ensure WCAG AAA (7:1 ratio):**
- Text on `bgBase`: use `textPrimary` (85%)
- Text on `bgSurface`: use `textPrimary` (85%)
- Secondary text: use `textSecondary` (60%)
- **Test under simulated sunlight**

#### 5.2 Touch Targets
**Minimum sizes:**
- Buttons: 48dp height
- List items: 60–72dp height
- Horizontal spacing: ≥8dp
- **Support glove touch:** large tap areas, bold controls

#### 5.3 Semantic Labels
**Add to all icons:**
- `Semantics` widget with clear labels
- Screen reader support
- Tooltips for iconography

---

## 📊 Before/After Comparison

### Color Palette

| Token | VIA | Industrial Dark | Change |
|-------|-----|-----------------|---------|
| Background | `#0A0A0A` | `#1A1A1A` | Lighter gray |
| Card | `#1A1A1A` | `#222222` | More separation |
| Border | `rgba(255,255,255,0.04)` | `#3A3A3A` | Stronger outline |
| Primary | `#00A8FF` | `#0072E5` | Unified accent |
| Text | `#FFFFFF` | `rgba(255,255,255,0.85)` | Standardized |

### Component Structure

**VIA Card:**
```dart
Container(
  decoration: BoxDecoration(
    color: Color(0xFF1A1A1A),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Color(0x0AFFFFFF)),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
)
```

**Industrial Dark Card:**
```dart
Container(
  decoration: BoxDecoration(
    color: Color(0xFF222222),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Color(0xFF3A3A3A),
      width: 2,
    ),
    // No boxShadow!
  ),
)
```

---

## 🚀 Implementation Order

### Week 1: Foundation
1. Create `industrial_dark_tokens.dart`
2. Update theme file
3. Update scaffold background color
4. Test basic layout

### Week 2: Components
1. Migrate ViaCard
2. Migrate ViaButton
3. Migrate ViaBottomSheet
4. Migrate ViaControlBar
5. Test all pages

### Week 3: Refinement
1. Update Alert/WorkOrder cards
2. Update map markers
3. Typography adjustments
4. Icon treatment

### Week 4: Polish
1. Animation timing adjustments
2. Accessibility audit
3. Outdoor readability test
4. Documentation

---

## ✅ Success Criteria

1. **Visual Consistency:** All surfaces use `bgBase` or `bgSurface`, no pure black
2. **Depth Expression:** All depth achieved through outlines, zero elevation values
3. **Color Discipline:** Only `accentPrimary` (#0072E5) for interactive elements
4. **Readability:** Text contrast ≥ 7:1 under simulated sunlight
5. **Touch Usability:** All targets ≥ 48dp, glove-friendly spacing
6. **Performance:** No visual regressions, smooth transitions (120-200ms)

---

## 📝 Migration Checklist

- [ ] Phase 1: Core Token Replacement
  - [ ] Create `industrial_dark_tokens.dart`
  - [ ] Update theme file
  - [ ] Update ViaCard
  - [ ] Update ViaButton
  - [ ] Update ViaBottomSheet
  - [ ] Update ViaControlBar

- [ ] Phase 2: Component Refinement
  - [ ] Alert Compact Card
  - [ ] Work Order Card
  - [ ] Map Markers
  - [ ] Bottom Sheets

- [ ] Phase 3: Typography & Icons
  - [ ] Update font hierarchy
  - [ ] Switch to filled icons
  - [ ] Add monospace font for data

- [ ] Phase 4: Motion & Feedback
  - [ ] Update transition timings
  - [ ] Remove decorative animations
  - [ ] Implement feedback patterns

- [ ] Phase 5: Accessibility
  - [ ] Contrast audit (WCAG AAA)
  - [ ] Touch target audit
  - [ ] Add semantic labels

- [ ] Testing & Validation
  - [ ] Build and test on device
  - [ ] Outdoor readability test
  - [ ] Performance validation
  - [ ] Documentation

---

**Last Updated:** 2025-10-24
**Status:** 📋 **Planning Complete - Ready for Implementation**
