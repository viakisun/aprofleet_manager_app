// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mockApiHash() => r'd87e999996cf681685c173b9ad31b426665d4e6c';

/// See also [mockApi].
@ProviderFor(mockApi)
final mockApiProvider = AutoDisposeProvider<MockApi>.internal(
  mockApi,
  name: r'mockApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mockApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MockApiRef = AutoDisposeProviderRef<MockApi>;
String _$mockWsHubHash() => r'5b8d6665074bbc29ffe3546f63a533a5de6a5688';

/// See also [mockWsHub].
@ProviderFor(mockWsHub)
final mockWsHubProvider = AutoDisposeProvider<MockWsHub>.internal(
  mockWsHub,
  name: r'mockWsHubProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mockWsHubHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MockWsHubRef = AutoDisposeProviderRef<MockWsHub>;
String _$cartsHash() => r'c6df05031cf51e1a1648d3b0d76cda3d03124da6';

/// See also [carts].
@ProviderFor(carts)
final cartsProvider = AutoDisposeFutureProvider<List<Cart>>.internal(
  carts,
  name: r'cartsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartsRef = AutoDisposeFutureProviderRef<List<Cart>>;
String _$cartHash() => r'88ee9b213bab68b927684f6ad6101f3dc94ddf7e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [cart].
@ProviderFor(cart)
const cartProvider = CartFamily();

/// See also [cart].
class CartFamily extends Family<AsyncValue<Cart?>> {
  /// See also [cart].
  const CartFamily();

  /// See also [cart].
  CartProvider call(
    String cartId,
  ) {
    return CartProvider(
      cartId,
    );
  }

  @override
  CartProvider getProviderOverride(
    covariant CartProvider provider,
  ) {
    return call(
      provider.cartId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cartProvider';
}

/// See also [cart].
class CartProvider extends AutoDisposeFutureProvider<Cart?> {
  /// See also [cart].
  CartProvider(
    String cartId,
  ) : this._internal(
          (ref) => cart(
            ref as CartRef,
            cartId,
          ),
          from: cartProvider,
          name: r'cartProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$cartHash,
          dependencies: CartFamily._dependencies,
          allTransitiveDependencies: CartFamily._allTransitiveDependencies,
          cartId: cartId,
        );

  CartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cartId,
  }) : super.internal();

  final String cartId;

  @override
  Override overrideWith(
    FutureOr<Cart?> Function(CartRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CartProvider._internal(
        (ref) => create(ref as CartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cartId: cartId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Cart?> createElement() {
    return _CartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CartProvider && other.cartId == cartId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cartId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CartRef on AutoDisposeFutureProviderRef<Cart?> {
  /// The parameter `cartId` of this provider.
  String get cartId;
}

class _CartProviderElement extends AutoDisposeFutureProviderElement<Cart?>
    with CartRef {
  _CartProviderElement(super.provider);

  @override
  String get cartId => (origin as CartProvider).cartId;
}

String _$workOrdersHash() => r'f39514b8dd9465bed346ffb80fd2d3da4496f47a';

/// See also [workOrders].
@ProviderFor(workOrders)
final workOrdersProvider = AutoDisposeFutureProvider<List<WorkOrder>>.internal(
  workOrders,
  name: r'workOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$workOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkOrdersRef = AutoDisposeFutureProviderRef<List<WorkOrder>>;
String _$workOrderHash() => r'7c265255a2ac026b4ec36eea255c039ff4bdf9fe';

/// See also [workOrder].
@ProviderFor(workOrder)
const workOrderProvider = WorkOrderFamily();

/// See also [workOrder].
class WorkOrderFamily extends Family<AsyncValue<WorkOrder?>> {
  /// See also [workOrder].
  const WorkOrderFamily();

  /// See also [workOrder].
  WorkOrderProvider call(
    String workOrderId,
  ) {
    return WorkOrderProvider(
      workOrderId,
    );
  }

  @override
  WorkOrderProvider getProviderOverride(
    covariant WorkOrderProvider provider,
  ) {
    return call(
      provider.workOrderId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workOrderProvider';
}

/// See also [workOrder].
class WorkOrderProvider extends AutoDisposeFutureProvider<WorkOrder?> {
  /// See also [workOrder].
  WorkOrderProvider(
    String workOrderId,
  ) : this._internal(
          (ref) => workOrder(
            ref as WorkOrderRef,
            workOrderId,
          ),
          from: workOrderProvider,
          name: r'workOrderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workOrderHash,
          dependencies: WorkOrderFamily._dependencies,
          allTransitiveDependencies: WorkOrderFamily._allTransitiveDependencies,
          workOrderId: workOrderId,
        );

  WorkOrderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workOrderId,
  }) : super.internal();

  final String workOrderId;

  @override
  Override overrideWith(
    FutureOr<WorkOrder?> Function(WorkOrderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkOrderProvider._internal(
        (ref) => create(ref as WorkOrderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workOrderId: workOrderId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WorkOrder?> createElement() {
    return _WorkOrderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkOrderProvider && other.workOrderId == workOrderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workOrderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkOrderRef on AutoDisposeFutureProviderRef<WorkOrder?> {
  /// The parameter `workOrderId` of this provider.
  String get workOrderId;
}

class _WorkOrderProviderElement
    extends AutoDisposeFutureProviderElement<WorkOrder?> with WorkOrderRef {
  _WorkOrderProviderElement(super.provider);

  @override
  String get workOrderId => (origin as WorkOrderProvider).workOrderId;
}

String _$alertsHash() => r'72e95c587b12ca93ff7f5d5cc20c75d3d1ed62c4';

/// See also [alerts].
@ProviderFor(alerts)
final alertsProvider = AutoDisposeFutureProvider<List<Alert>>.internal(
  alerts,
  name: r'alertsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$alertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlertsRef = AutoDisposeFutureProviderRef<List<Alert>>;
String _$alertHash() => r'58ab08d934a6cff01800c092649f45e464514975';

/// See also [alert].
@ProviderFor(alert)
const alertProvider = AlertFamily();

/// See also [alert].
class AlertFamily extends Family<AsyncValue<Alert?>> {
  /// See also [alert].
  const AlertFamily();

  /// See also [alert].
  AlertProvider call(
    String alertId,
  ) {
    return AlertProvider(
      alertId,
    );
  }

  @override
  AlertProvider getProviderOverride(
    covariant AlertProvider provider,
  ) {
    return call(
      provider.alertId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'alertProvider';
}

/// See also [alert].
class AlertProvider extends AutoDisposeFutureProvider<Alert?> {
  /// See also [alert].
  AlertProvider(
    String alertId,
  ) : this._internal(
          (ref) => alert(
            ref as AlertRef,
            alertId,
          ),
          from: alertProvider,
          name: r'alertProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$alertHash,
          dependencies: AlertFamily._dependencies,
          allTransitiveDependencies: AlertFamily._allTransitiveDependencies,
          alertId: alertId,
        );

  AlertProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.alertId,
  }) : super.internal();

  final String alertId;

  @override
  Override overrideWith(
    FutureOr<Alert?> Function(AlertRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AlertProvider._internal(
        (ref) => create(ref as AlertRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        alertId: alertId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Alert?> createElement() {
    return _AlertProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlertProvider && other.alertId == alertId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, alertId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AlertRef on AutoDisposeFutureProviderRef<Alert?> {
  /// The parameter `alertId` of this provider.
  String get alertId;
}

class _AlertProviderElement extends AutoDisposeFutureProviderElement<Alert?>
    with AlertRef {
  _AlertProviderElement(super.provider);

  @override
  String get alertId => (origin as AlertProvider).alertId;
}

String _$telemetryHash() => r'e1d5ed10c6767389c3f20594f6c4a37500e5495a';

/// See also [telemetry].
@ProviderFor(telemetry)
const telemetryProvider = TelemetryFamily();

/// See also [telemetry].
class TelemetryFamily extends Family<AsyncValue<Telemetry?>> {
  /// See also [telemetry].
  const TelemetryFamily();

  /// See also [telemetry].
  TelemetryProvider call(
    String cartId,
  ) {
    return TelemetryProvider(
      cartId,
    );
  }

  @override
  TelemetryProvider getProviderOverride(
    covariant TelemetryProvider provider,
  ) {
    return call(
      provider.cartId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'telemetryProvider';
}

/// See also [telemetry].
class TelemetryProvider extends AutoDisposeFutureProvider<Telemetry?> {
  /// See also [telemetry].
  TelemetryProvider(
    String cartId,
  ) : this._internal(
          (ref) => telemetry(
            ref as TelemetryRef,
            cartId,
          ),
          from: telemetryProvider,
          name: r'telemetryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$telemetryHash,
          dependencies: TelemetryFamily._dependencies,
          allTransitiveDependencies: TelemetryFamily._allTransitiveDependencies,
          cartId: cartId,
        );

  TelemetryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cartId,
  }) : super.internal();

  final String cartId;

  @override
  Override overrideWith(
    FutureOr<Telemetry?> Function(TelemetryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TelemetryProvider._internal(
        (ref) => create(ref as TelemetryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cartId: cartId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Telemetry?> createElement() {
    return _TelemetryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TelemetryProvider && other.cartId == cartId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cartId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TelemetryRef on AutoDisposeFutureProviderRef<Telemetry?> {
  /// The parameter `cartId` of this provider.
  String get cartId;
}

class _TelemetryProviderElement
    extends AutoDisposeFutureProviderElement<Telemetry?> with TelemetryRef {
  _TelemetryProviderElement(super.provider);

  @override
  String get cartId => (origin as TelemetryProvider).cartId;
}

String _$kpiHash() => r'973ad2d9e8294eada3412d876af714d40e33ce63';

/// See also [kpi].
@ProviderFor(kpi)
final kpiProvider = AutoDisposeFutureProvider<Kpi>.internal(
  kpi,
  name: r'kpiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$kpiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef KpiRef = AutoDisposeFutureProviderRef<Kpi>;
String _$usersHash() => r'acac2e0eb914c52a825a09c313d135260e118c26';

/// See also [users].
@ProviderFor(users)
final usersProvider = AutoDisposeFutureProvider<List<UserProfile>>.internal(
  users,
  name: r'usersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UsersRef = AutoDisposeFutureProviderRef<List<UserProfile>>;
String _$telemetryStreamHash() => r'5eee7161cb4ee91efe8fd6bb96c9d69cc09fdb99';

/// See also [telemetryStream].
@ProviderFor(telemetryStream)
const telemetryStreamProvider = TelemetryStreamFamily();

/// See also [telemetryStream].
class TelemetryStreamFamily extends Family<AsyncValue<Telemetry>> {
  /// See also [telemetryStream].
  const TelemetryStreamFamily();

  /// See also [telemetryStream].
  TelemetryStreamProvider call(
    String cartId,
  ) {
    return TelemetryStreamProvider(
      cartId,
    );
  }

  @override
  TelemetryStreamProvider getProviderOverride(
    covariant TelemetryStreamProvider provider,
  ) {
    return call(
      provider.cartId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'telemetryStreamProvider';
}

/// See also [telemetryStream].
class TelemetryStreamProvider extends AutoDisposeStreamProvider<Telemetry> {
  /// See also [telemetryStream].
  TelemetryStreamProvider(
    String cartId,
  ) : this._internal(
          (ref) => telemetryStream(
            ref as TelemetryStreamRef,
            cartId,
          ),
          from: telemetryStreamProvider,
          name: r'telemetryStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$telemetryStreamHash,
          dependencies: TelemetryStreamFamily._dependencies,
          allTransitiveDependencies:
              TelemetryStreamFamily._allTransitiveDependencies,
          cartId: cartId,
        );

  TelemetryStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cartId,
  }) : super.internal();

  final String cartId;

  @override
  Override overrideWith(
    Stream<Telemetry> Function(TelemetryStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TelemetryStreamProvider._internal(
        (ref) => create(ref as TelemetryStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cartId: cartId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Telemetry> createElement() {
    return _TelemetryStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TelemetryStreamProvider && other.cartId == cartId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cartId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TelemetryStreamRef on AutoDisposeStreamProviderRef<Telemetry> {
  /// The parameter `cartId` of this provider.
  String get cartId;
}

class _TelemetryStreamProviderElement
    extends AutoDisposeStreamProviderElement<Telemetry>
    with TelemetryStreamRef {
  _TelemetryStreamProviderElement(super.provider);

  @override
  String get cartId => (origin as TelemetryStreamProvider).cartId;
}

String _$positionStreamHash() => r'4dfef1963051cd3ea1e816ff395396b577d307b1';

/// See also [positionStream].
@ProviderFor(positionStream)
const positionStreamProvider = PositionStreamFamily();

/// See also [positionStream].
class PositionStreamFamily extends Family<AsyncValue<Cart>> {
  /// See also [positionStream].
  const PositionStreamFamily();

  /// See also [positionStream].
  PositionStreamProvider call(
    String cartId,
  ) {
    return PositionStreamProvider(
      cartId,
    );
  }

  @override
  PositionStreamProvider getProviderOverride(
    covariant PositionStreamProvider provider,
  ) {
    return call(
      provider.cartId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'positionStreamProvider';
}

/// See also [positionStream].
class PositionStreamProvider extends AutoDisposeStreamProvider<Cart> {
  /// See also [positionStream].
  PositionStreamProvider(
    String cartId,
  ) : this._internal(
          (ref) => positionStream(
            ref as PositionStreamRef,
            cartId,
          ),
          from: positionStreamProvider,
          name: r'positionStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$positionStreamHash,
          dependencies: PositionStreamFamily._dependencies,
          allTransitiveDependencies:
              PositionStreamFamily._allTransitiveDependencies,
          cartId: cartId,
        );

  PositionStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cartId,
  }) : super.internal();

  final String cartId;

  @override
  Override overrideWith(
    Stream<Cart> Function(PositionStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PositionStreamProvider._internal(
        (ref) => create(ref as PositionStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cartId: cartId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Cart> createElement() {
    return _PositionStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PositionStreamProvider && other.cartId == cartId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cartId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PositionStreamRef on AutoDisposeStreamProviderRef<Cart> {
  /// The parameter `cartId` of this provider.
  String get cartId;
}

class _PositionStreamProviderElement
    extends AutoDisposeStreamProviderElement<Cart> with PositionStreamRef {
  _PositionStreamProviderElement(super.provider);

  @override
  String get cartId => (origin as PositionStreamProvider).cartId;
}

String _$alertStreamHash() => r'f5e12a715fad677ae556aa7b75d2ae52891dbca9';

/// See also [alertStream].
@ProviderFor(alertStream)
final alertStreamProvider = AutoDisposeStreamProvider<Alert>.internal(
  alertStream,
  name: r'alertStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$alertStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlertStreamRef = AutoDisposeStreamProviderRef<Alert>;
String _$initializeAppHash() => r'3574bf6105e9f4002fd45939ba7e6709fb571a7d';

/// See also [initializeApp].
@ProviderFor(initializeApp)
final initializeAppProvider = AutoDisposeFutureProvider<void>.internal(
  initializeApp,
  name: r'initializeAppProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initializeAppHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitializeAppRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
