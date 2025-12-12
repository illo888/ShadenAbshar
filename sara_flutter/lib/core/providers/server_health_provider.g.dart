// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_health_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiServiceManagerHash() => r'cea39f71db4e4c9bf7696f47139dafbce28ea20e';

/// Provider for AI Service Manager (singleton)
///
/// Copied from [aiServiceManager].
@ProviderFor(aiServiceManager)
final aiServiceManagerProvider = AutoDisposeProvider<AiServiceManager>.internal(
  aiServiceManager,
  name: r'aiServiceManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiServiceManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiServiceManagerRef = AutoDisposeProviderRef<AiServiceManager>;
String _$saraServerHealthyHash() => r'25c4e657dd95c34b4540593d2017857c13ab2a74';

/// Simple health status provider (for widgets that just need current status)
///
/// Copied from [saraServerHealthy].
@ProviderFor(saraServerHealthy)
final saraServerHealthyProvider = AutoDisposeFutureProvider<bool>.internal(
  saraServerHealthy,
  name: r'saraServerHealthyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saraServerHealthyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SaraServerHealthyRef = AutoDisposeFutureProviderRef<bool>;
String _$serviceStatusColorHash() =>
    r'f093296cbcd3dc163c04169d0a81de926f27827b';

/// Provider for current service status color (green/orange/red)
///
/// Copied from [serviceStatusColor].
@ProviderFor(serviceStatusColor)
final serviceStatusColorProvider =
    AutoDisposeProvider<ServiceStatusColor>.internal(
      serviceStatusColor,
      name: r'serviceStatusColorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$serviceStatusColorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServiceStatusColorRef = AutoDisposeProviderRef<ServiceStatusColor>;
String _$serviceStatusTextHash() => r'9f097c349b488fadec06e97d963d507e171fba4c';

/// Provider for status text in Arabic
///
/// Copied from [serviceStatusText].
@ProviderFor(serviceStatusText)
final serviceStatusTextProvider = AutoDisposeProvider<String>.internal(
  serviceStatusText,
  name: r'serviceStatusTextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serviceStatusTextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServiceStatusTextRef = AutoDisposeProviderRef<String>;
String _$serverHealthNotifierHash() =>
    r'361d0bb4f234809d93d24fddf35912aed242af4f';

/// Provider for server health status with auto-refresh every 30 seconds
///
/// Copied from [ServerHealthNotifier].
@ProviderFor(ServerHealthNotifier)
final serverHealthNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      ServerHealthNotifier,
      ServiceStatus
    >.internal(
      ServerHealthNotifier.new,
      name: r'serverHealthNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$serverHealthNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ServerHealthNotifier = AutoDisposeAsyncNotifier<ServiceStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
