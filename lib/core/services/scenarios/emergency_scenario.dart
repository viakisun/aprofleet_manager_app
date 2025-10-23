import 'package:latlong2/latlong.dart';
import '../../../domain/models/scenario_event.dart';
import '../../../domain/models/alert.dart';
import '../../../domain/models/alert_action.dart';
import '../../../domain/models/cart.dart';
import '../../../domain/models/work_order.dart';

/// Emergency Scenario - Critical situations requiring immediate response
class EmergencyScenario {
  static Scenario get scenario {
    return Scenario(
      id: 'emergency',
      name: '긴급 상황 (Emergency)',
      description: '긴급 대응이 필요한 중대 이벤트 시나리오',
      totalDuration: const Duration(minutes: 10),
      events: [
        // 09:30 - APRO-004 통신 두절
        ScenarioEvent.alert(
          offsetSeconds: 0,
          cartId: 'APRO-004',
          title: '통신 두절',
          message: '3분간 무응답 - 마지막 위치: 6번 홀 근처',
          severity: AlertSeverity.critical,
          priority: Priority.p1,
          availableActions: [
            AlertActionType.requestFieldCheck,
            AlertActionType.activateGPS,
            AlertActionType.escalateToManager,
          ],
          recommendedAction: AlertActionType.requestFieldCheck,
          actionOutcomes: {
            AlertActionType.requestFieldCheck: AlertActionResult.success(
              '현장 확인 팀 출동 - 직원이 5분 내 도착 예정',
              nextState: 'investigating',
            ),
            AlertActionType.activateGPS: AlertActionResult.success(
              'GPS 추적 활성화 - 실시간 위치 모니터링 시작',
              nextState: 'tracking',
            ),
            AlertActionType.escalateToManager: AlertActionResult.success(
              '관리자에게 알림 전송 완료',
              nextState: 'escalated',
            ),
          },
        ),

        // 09:31 - Info: 현장 확인 팀 출동 (if user selected field check)
        ScenarioEvent.info(
          offsetSeconds: 60,
          title: '현장 확인 팀',
          message: '직원 출동 - 예상 도착: 4분 후',
          cartId: 'SYSTEM',
        ),

        // 09:33 - APRO-004 텔레메트리 업데이트 (충격 감지)
        ScenarioEvent.info(
          offsetSeconds: 180,
          cartId: 'APRO-004',
          title: '센서 데이터 수신',
          message: '충격 감지 센서 활성화 - 급정거 가능성',
        ),

        // 09:35 - APRO-004 위치 재확인
        ScenarioEvent.positionUpdate(
          offsetSeconds: 300,
          cartId: 'APRO-004',
          title: 'GPS 신호 재확보',
          newPosition: LatLng(35.9561, 127.0068), // 6번 홀 벙커 근처
        ),

        ScenarioEvent.alert(
          offsetSeconds: 305,
          cartId: 'APRO-004',
          title: 'GPS 위치 재확인',
          message: '위치: 6번 홀 벙커 근처 - 정상 경로 이탈 확인',
          severity: AlertSeverity.warning,
          priority: Priority.p2,
          availableActions: [
            AlertActionType.attemptReconnect,
            AlertActionType.requestFieldCheck,
            AlertActionType.contactDriver,
          ],
          recommendedAction: AlertActionType.attemptReconnect,
          actionOutcomes: {
            AlertActionType.attemptReconnect: AlertActionResult.withNextAlert(
              '재시작 명령 전송 - 통신 복구 시도 중',
              delay: const Duration(minutes: 2),
              nextState: 'reconnecting',
            ),
            AlertActionType.requestFieldCheck: AlertActionResult.success(
              '견인 서비스 배차 - 구조 작업 시작',
              nextState: 'towing',
            ),
            AlertActionType.contactDriver: AlertActionResult.success(
              '운전자 연락 시도 - 음성 통화 연결',
              nextState: 'contacting',
            ),
          },
        ),

        // 09:40 - APRO-004 통신 복구 (if user selected reconnect)
        ScenarioEvent.stateChange(
          offsetSeconds: 420,
          cartId: 'APRO-004',
          title: '통신 복구',
          message: '시스템 재시작 성공 - 정상 통신 재개',
          newStatus: CartStatus.idle,
        ),

        // 09:45 - APRO-009 구역 이탈 경고
        ScenarioEvent.alert(
          offsetSeconds: 480,
          cartId: 'APRO-009',
          title: 'Geofence 이탈',
          message: '허용 구역 벗어남 - 현재 위치: 골프장 경계 외부',
          severity: AlertSeverity.critical,
          priority: Priority.p1,
          availableActions: [
            AlertActionType.sendEmergencyReturn,
            AlertActionType.contactDriver,
            AlertActionType.notifySecurity,
          ],
          recommendedAction: AlertActionType.sendEmergencyReturn,
          actionOutcomes: {
            AlertActionType.sendEmergencyReturn: AlertActionResult.success(
              '긴급 귀환 명령 전송 - 자동 제어 활성화',
              nextState: 'returning',
            ),
            AlertActionType.contactDriver: AlertActionResult.success(
              '운전자 연락 완료 - 상황 확인 중',
              nextState: 'verifying',
            ),
            AlertActionType.notifySecurity: AlertActionResult.success(
              '보안팀 알림 전송 - 추적 시작',
              nextState: 'tracking',
            ),
          },
        ),

        // 09:48 - APRO-009 위치 업데이트 (귀환 중)
        ScenarioEvent.positionUpdate(
          offsetSeconds: 540,
          cartId: 'APRO-009',
          title: '귀환 경로 진행 중',
          newPosition: LatLng(35.9565, 127.0070),
        ),

        // 09:50 - APRO-009 정상 구역 진입
        ScenarioEvent.stateChange(
          offsetSeconds: 600,
          cartId: 'APRO-009',
          title: '정상 구역 복귀',
          message: 'Geofence 내부 진입 - 경고 해제',
          newStatus: CartStatus.active,
        ),

        // 09:52 - APRO-002 급제동 감지
        ScenarioEvent.alert(
          offsetSeconds: 660,
          cartId: 'APRO-002',
          title: '충격 센서 감지',
          message: '급제동/충격 감지 - 안전 확인 필요',
          severity: AlertSeverity.warning,
          priority: Priority.p2,
          availableActions: [
            AlertActionType.requestSafetyCheck,
            AlertActionType.scheduleMaintenance,
            AlertActionType.assignReplacement,
          ],
          recommendedAction: AlertActionType.requestSafetyCheck,
          actionOutcomes: {
            AlertActionType.requestSafetyCheck: AlertActionResult.success(
              '안전 확인 요청 전송 - 고객 안전 체크 진행',
              nextState: 'safety_check',
            ),
            AlertActionType.scheduleMaintenance: AlertActionResult.success(
              '정비 점검 예약 완료 - 손상 확인 대기',
              nextState: 'scheduled',
            ),
            AlertActionType.assignReplacement: AlertActionResult.success(
              '대체 카트 APRO-011 배정 - 5분 내 도착 예정',
              nextState: 'replacing',
            ),
          },
        ),

        // 09:55 - APRO-002 안전 확인 완료
        ScenarioEvent.info(
          offsetSeconds: 780,
          cartId: 'APRO-002',
          title: '안전 확인 완료',
          message: '고객 이상 없음 - 카트 점검 예약됨',
        ),

        // 09:58 - 시나리오 종료 메시지
        ScenarioEvent.info(
          offsetSeconds: 870,
          title: '시나리오 완료',
          message: '모든 긴급 상황 대응 완료 - 정상 운영 복귀',
          cartId: 'SYSTEM',
        ),
      ],
    );
  }
}
