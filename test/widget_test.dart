import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aprofleet_manager/main.dart';
import 'package:aprofleet_manager/core/services/providers.dart';
import 'package:aprofleet_manager/core/services/mock/mock_ws_hub.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // MockWsHub를 테스트 모드로 설정하여 타이머 비활성화
    final mockWsHub = MockWsHub();
    mockWsHub.enableTestMode(); // 테스트 모드 활성화
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // MockWsHub를 테스트 모드 인스턴스로 override
          mockWsHubProvider.overrideWith((ref) => mockWsHub),
        ],
        child: const AproFleetApp(),
      ),
    );

    // Wait for the app to initialize but don't settle to avoid timer issues
    await tester.pump();

    // Verify that the app loads (basic smoke test)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
