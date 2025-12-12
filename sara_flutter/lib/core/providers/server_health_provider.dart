import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/ai_service_manager.dart';
import '../services/sara_server_service.dart';

part 'server_health_provider.g.dart';

/// Provider for AI Service Manager (singleton)
@riverpod
AiServiceManager aiServiceManager(AiServiceManagerRef ref) {
  final manager = AiServiceManager();
  ref.onDispose(() => manager.dispose());
  return manager;
}

/// Provider for server health status with auto-refresh every 30 seconds
@riverpod
class ServerHealthNotifier extends _$ServerHealthNotifier {
  Timer? _timer;

  @override
  Future<ServiceStatus> build() async {
    // Start monitoring
    _startMonitoring();
    
    // Initial check
    return _checkHealth();
  }

  void _startMonitoring() {
    // Cancel existing timer if any
    _timer?.cancel();
    
    // Check health every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      // Invalidate to trigger rebuild
      ref.invalidateSelf();
    });
    
    // Clean up timer on dispose
    ref.onDispose(() {
      _timer?.cancel();
    });
  }

  Future<ServiceStatus> _checkHealth() async {
    final manager = ref.read(aiServiceManagerProvider);
    return await manager.getServiceStatus();
  }

  /// Manually refresh health status
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Reset SARA status (force retry after failure)
  void resetSaraStatus() {
    final manager = ref.read(aiServiceManagerProvider);
    manager.resetSaraStatus();
    ref.invalidateSelf();
  }
}

/// Simple health status provider (for widgets that just need current status)
@riverpod
Future<bool> saraServerHealthy(SaraServerHealthyRef ref) async {
  final status = await ref.watch(serverHealthNotifierProvider.future);
  return status.saraAvailable;
}

/// Provider for current service status color (green/orange/red)
@riverpod
Color serviceStatusColor(ServiceStatusColorRef ref) {
  final statusAsync = ref.watch(serverHealthNotifierProvider);
  
  return statusAsync.when(
    data: (status) {
      switch (status.statusColor) {
        case ServiceStatusColor.green:
          return Colors.green;
        case ServiceStatusColor.orange:
          return Colors.orange;
        case ServiceStatusColor.red:
          return Colors.red;
      }
    },
    loading: () => Colors.orange,
    error: (_, __) => Colors.red,
  );
}

/// Provider for status text in Arabic
@riverpod
String serviceStatusText(ServiceStatusTextRef ref) {
  final statusAsync = ref.watch(serverHealthNotifierProvider);
  
  return statusAsync.when(
    data: (status) => status.statusTextAr,
    loading: () => 'جاري التحقق...',
    error: (_, __) => 'خطأ في الاتصال',
  );
}
