import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/geojson_data.dart';
import '../../services/geojson_service.dart';

class GolfCourseRouteState {
  final GeoJsonData? data;
  final bool isLoading;
  final String? error;

  GolfCourseRouteState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  String? get routeName => data?.features.firstOrNull?.properties.name;
  String? get description => data?.features.firstOrNull?.properties.description;
  int? get totalCoordinates =>
      data?.features.firstOrNull?.properties.totalCoordinates;
  String? get collectionDate =>
      data?.features.firstOrNull?.properties.collectionDate;
}

class GolfCourseRouteNotifier extends StateNotifier<GolfCourseRouteState> {
  GolfCourseRouteNotifier() : super(GolfCourseRouteState());

  Future<void> loadRoute() async {
    if (state.isLoading) return; // 이미 로딩 중이면 중복 요청 방지

    state = GolfCourseRouteState(isLoading: true);
    try {
      final data = await GeoJsonService.instance.loadGolfCourseData();
      state = GolfCourseRouteState(data: data, isLoading: false);
    } catch (e) {
      state = GolfCourseRouteState(
        error: e is Exception ? e.toString() : 'Unknown error occurred',
        isLoading: false,
      );
    }
  }
}

final golfCourseRouteProvider =
    StateNotifierProvider<GolfCourseRouteNotifier, GolfCourseRouteState>(
  (ref) => GolfCourseRouteNotifier(),
);
