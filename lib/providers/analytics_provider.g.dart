// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weeklyComparisonHash() => r'f7c3e2d1ef88f2709ab6d4a714bd7369f467a456';

/// See also [weeklyComparison].
@ProviderFor(weeklyComparison)
final weeklyComparisonProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  weeklyComparison,
  name: r'weeklyComparisonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeklyComparisonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklyComparisonRef
    = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$todayMacrosHash() => r'dcd5eb5e588a03a5c796c6e0f96d2af5adca90f6';

/// See also [todayMacros].
@ProviderFor(todayMacros)
final todayMacrosProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
  todayMacros,
  name: r'todayMacrosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayMacrosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayMacrosRef = AutoDisposeFutureProviderRef<Map<String, double>>;
String _$weeklyAverageHash() => r'2f7f04673a52fefb652300905d4bc53eb883410a';

/// See also [weeklyAverage].
@ProviderFor(weeklyAverage)
final weeklyAverageProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
  weeklyAverage,
  name: r'weeklyAverageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeklyAverageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklyAverageRef = AutoDisposeFutureProviderRef<Map<String, double>>;
String _$calorieGoalStreakHash() => r'a3626f313fd6a160188456ca8f11c0f6f7b432ca';

/// See also [calorieGoalStreak].
@ProviderFor(calorieGoalStreak)
final calorieGoalStreakProvider = AutoDisposeFutureProvider<int>.internal(
  calorieGoalStreak,
  name: r'calorieGoalStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calorieGoalStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalorieGoalStreakRef = AutoDisposeFutureProviderRef<int>;
String _$monthlyHighlightsHash() => r'06067eedb9aa6bd44fc3498bd7764665495b12ef';

/// See also [monthlyHighlights].
@ProviderFor(monthlyHighlights)
final monthlyHighlightsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  monthlyHighlights,
  name: r'monthlyHighlightsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyHighlightsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyHighlightsRef
    = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$calorieHistoryHash() => r'd0e535491c1a8261c268c9397f836fb81fe76b85';

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

abstract class _$CalorieHistory
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final int days;

  FutureOr<List<Map<String, dynamic>>> build(
    int days,
  );
}

/// See also [CalorieHistory].
@ProviderFor(CalorieHistory)
const calorieHistoryProvider = CalorieHistoryFamily();

/// See also [CalorieHistory].
class CalorieHistoryFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [CalorieHistory].
  const CalorieHistoryFamily();

  /// See also [CalorieHistory].
  CalorieHistoryProvider call(
    int days,
  ) {
    return CalorieHistoryProvider(
      days,
    );
  }

  @override
  CalorieHistoryProvider getProviderOverride(
    covariant CalorieHistoryProvider provider,
  ) {
    return call(
      provider.days,
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
  String? get name => r'calorieHistoryProvider';
}

/// See also [CalorieHistory].
class CalorieHistoryProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CalorieHistory, List<Map<String, dynamic>>> {
  /// See also [CalorieHistory].
  CalorieHistoryProvider(
    int days,
  ) : this._internal(
          () => CalorieHistory()..days = days,
          from: calorieHistoryProvider,
          name: r'calorieHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calorieHistoryHash,
          dependencies: CalorieHistoryFamily._dependencies,
          allTransitiveDependencies:
              CalorieHistoryFamily._allTransitiveDependencies,
          days: days,
        );

  CalorieHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant CalorieHistory notifier,
  ) {
    return notifier.build(
      days,
    );
  }

  @override
  Override overrideWith(CalorieHistory Function() create) {
    return ProviderOverride(
      origin: this,
      override: CalorieHistoryProvider._internal(
        () => create()..days = days,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CalorieHistory,
      List<Map<String, dynamic>>> createElement() {
    return _CalorieHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalorieHistoryProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalorieHistoryRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _CalorieHistoryProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CalorieHistory,
        List<Map<String, dynamic>>> with CalorieHistoryRef {
  _CalorieHistoryProviderElement(super.provider);

  @override
  int get days => (origin as CalorieHistoryProvider).days;
}

String _$categoryBreakdownHash() => r'5ecd9c16fddd80e853926e8bdc9ac1a3e80e7eb1';

/// See also [CategoryBreakdown].
@ProviderFor(CategoryBreakdown)
final categoryBreakdownProvider = AutoDisposeAsyncNotifierProvider<
    CategoryBreakdown, Map<String, int>>.internal(
  CategoryBreakdown.new,
  name: r'categoryBreakdownProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryBreakdownHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoryBreakdown = AutoDisposeAsyncNotifier<Map<String, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
