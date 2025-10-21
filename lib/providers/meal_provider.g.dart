// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealRepositoryHash() => r'607e889699211d3aa17bae522b1760e3090fa208';

/// See also [mealRepository].
@ProviderFor(mealRepository)
final mealRepositoryProvider = AutoDisposeProvider<MealRepository>.internal(
  mealRepository,
  name: r'mealRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealRepositoryRef = AutoDisposeProviderRef<MealRepository>;
String _$preferencesRepositoryHash() =>
    r'181079df52432df434cca7032ebdc396eebc222d';

/// See also [preferencesRepository].
@ProviderFor(preferencesRepository)
final preferencesRepositoryProvider =
    AutoDisposeProvider<PreferencesRepository>.internal(
  preferencesRepository,
  name: r'preferencesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$preferencesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreferencesRepositoryRef
    = AutoDisposeProviderRef<PreferencesRepository>;
String _$dailyProgressHash() => r'f2aa5b0fd3cefc24ea505976d70f478dfdd5f74f';

/// See also [dailyProgress].
@ProviderFor(dailyProgress)
final dailyProgressProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
  dailyProgress,
  name: r'dailyProgressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyProgressRef = AutoDisposeFutureProviderRef<Map<String, double>>;
String _$caloriesRemainingHash() => r'a662c0d1b86ecb85f90af55742076d07525e291b';

/// See also [caloriesRemaining].
@ProviderFor(caloriesRemaining)
final caloriesRemainingProvider = AutoDisposeFutureProvider<double>.internal(
  caloriesRemaining,
  name: r'caloriesRemainingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$caloriesRemainingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CaloriesRemainingRef = AutoDisposeFutureProviderRef<double>;
String _$shouldResetDailyHash() => r'699392ae79add93792d66aa08147ac8e42390695';

/// See also [shouldResetDaily].
@ProviderFor(shouldResetDaily)
final shouldResetDailyProvider = AutoDisposeFutureProvider<bool>.internal(
  shouldResetDaily,
  name: r'shouldResetDailyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shouldResetDailyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShouldResetDailyRef = AutoDisposeFutureProviderRef<bool>;
String _$todayMealsHash() => r'193dabdca919b1043db6868ae1b6d3e1179a430b';

/// See also [TodayMeals].
@ProviderFor(TodayMeals)
final todayMealsProvider =
    AutoDisposeAsyncNotifierProvider<TodayMeals, List<ConsumedMeal>>.internal(
  TodayMeals.new,
  name: r'todayMealsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayMealsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodayMeals = AutoDisposeAsyncNotifier<List<ConsumedMeal>>;
String _$dailyNutritionHash() => r'4867787ca716869977059bd7164c55ec29ff322c';

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

abstract class _$DailyNutrition
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, double>> {
  late final DateTime date;

  FutureOr<Map<String, double>> build(
    DateTime date,
  );
}

/// See also [DailyNutrition].
@ProviderFor(DailyNutrition)
const dailyNutritionProvider = DailyNutritionFamily();

/// See also [DailyNutrition].
class DailyNutritionFamily extends Family<AsyncValue<Map<String, double>>> {
  /// See also [DailyNutrition].
  const DailyNutritionFamily();

  /// See also [DailyNutrition].
  DailyNutritionProvider call(
    DateTime date,
  ) {
    return DailyNutritionProvider(
      date,
    );
  }

  @override
  DailyNutritionProvider getProviderOverride(
    covariant DailyNutritionProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'dailyNutritionProvider';
}

/// See also [DailyNutrition].
class DailyNutritionProvider extends AutoDisposeAsyncNotifierProviderImpl<
    DailyNutrition, Map<String, double>> {
  /// See also [DailyNutrition].
  DailyNutritionProvider(
    DateTime date,
  ) : this._internal(
          () => DailyNutrition()..date = date,
          from: dailyNutritionProvider,
          name: r'dailyNutritionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyNutritionHash,
          dependencies: DailyNutritionFamily._dependencies,
          allTransitiveDependencies:
              DailyNutritionFamily._allTransitiveDependencies,
          date: date,
        );

  DailyNutritionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  FutureOr<Map<String, double>> runNotifierBuild(
    covariant DailyNutrition notifier,
  ) {
    return notifier.build(
      date,
    );
  }

  @override
  Override overrideWith(DailyNutrition Function() create) {
    return ProviderOverride(
      origin: this,
      override: DailyNutritionProvider._internal(
        () => create()..date = date,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DailyNutrition, Map<String, double>>
      createElement() {
    return _DailyNutritionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyNutritionProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyNutritionRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, double>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DailyNutritionProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DailyNutrition,
        Map<String, double>> with DailyNutritionRef {
  _DailyNutritionProviderElement(super.provider);

  @override
  DateTime get date => (origin as DailyNutritionProvider).date;
}

String _$weeklyNutritionHash() => r'5a91bebd5f8923090757864fac6027c507b11d00';

abstract class _$WeeklyNutrition
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, double>> {
  late final DateTime weekStart;

  FutureOr<Map<String, double>> build(
    DateTime weekStart,
  );
}

/// See also [WeeklyNutrition].
@ProviderFor(WeeklyNutrition)
const weeklyNutritionProvider = WeeklyNutritionFamily();

/// See also [WeeklyNutrition].
class WeeklyNutritionFamily extends Family<AsyncValue<Map<String, double>>> {
  /// See also [WeeklyNutrition].
  const WeeklyNutritionFamily();

  /// See also [WeeklyNutrition].
  WeeklyNutritionProvider call(
    DateTime weekStart,
  ) {
    return WeeklyNutritionProvider(
      weekStart,
    );
  }

  @override
  WeeklyNutritionProvider getProviderOverride(
    covariant WeeklyNutritionProvider provider,
  ) {
    return call(
      provider.weekStart,
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
  String? get name => r'weeklyNutritionProvider';
}

/// See also [WeeklyNutrition].
class WeeklyNutritionProvider extends AutoDisposeAsyncNotifierProviderImpl<
    WeeklyNutrition, Map<String, double>> {
  /// See also [WeeklyNutrition].
  WeeklyNutritionProvider(
    DateTime weekStart,
  ) : this._internal(
          () => WeeklyNutrition()..weekStart = weekStart,
          from: weeklyNutritionProvider,
          name: r'weeklyNutritionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weeklyNutritionHash,
          dependencies: WeeklyNutritionFamily._dependencies,
          allTransitiveDependencies:
              WeeklyNutritionFamily._allTransitiveDependencies,
          weekStart: weekStart,
        );

  WeeklyNutritionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.weekStart,
  }) : super.internal();

  final DateTime weekStart;

  @override
  FutureOr<Map<String, double>> runNotifierBuild(
    covariant WeeklyNutrition notifier,
  ) {
    return notifier.build(
      weekStart,
    );
  }

  @override
  Override overrideWith(WeeklyNutrition Function() create) {
    return ProviderOverride(
      origin: this,
      override: WeeklyNutritionProvider._internal(
        () => create()..weekStart = weekStart,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        weekStart: weekStart,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WeeklyNutrition, Map<String, double>>
      createElement() {
    return _WeeklyNutritionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyNutritionProvider && other.weekStart == weekStart;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, weekStart.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeeklyNutritionRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, double>> {
  /// The parameter `weekStart` of this provider.
  DateTime get weekStart;
}

class _WeeklyNutritionProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WeeklyNutrition,
        Map<String, double>> with WeeklyNutritionRef {
  _WeeklyNutritionProviderElement(super.provider);

  @override
  DateTime get weekStart => (origin as WeeklyNutritionProvider).weekStart;
}

String _$foodSearchHash() => r'c94beae80a78ca6a4f183e585498a7c930323682';

abstract class _$FoodSearch
    extends BuildlessAutoDisposeAsyncNotifier<List<Food>> {
  late final String query;
  late final String? category;

  FutureOr<List<Food>> build(
    String query, {
    String? category,
  });
}

/// See also [FoodSearch].
@ProviderFor(FoodSearch)
const foodSearchProvider = FoodSearchFamily();

/// See also [FoodSearch].
class FoodSearchFamily extends Family<AsyncValue<List<Food>>> {
  /// See also [FoodSearch].
  const FoodSearchFamily();

  /// See also [FoodSearch].
  FoodSearchProvider call(
    String query, {
    String? category,
  }) {
    return FoodSearchProvider(
      query,
      category: category,
    );
  }

  @override
  FoodSearchProvider getProviderOverride(
    covariant FoodSearchProvider provider,
  ) {
    return call(
      provider.query,
      category: provider.category,
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
  String? get name => r'foodSearchProvider';
}

/// See also [FoodSearch].
class FoodSearchProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FoodSearch, List<Food>> {
  /// See also [FoodSearch].
  FoodSearchProvider(
    String query, {
    String? category,
  }) : this._internal(
          () => FoodSearch()
            ..query = query
            ..category = category,
          from: foodSearchProvider,
          name: r'foodSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$foodSearchHash,
          dependencies: FoodSearchFamily._dependencies,
          allTransitiveDependencies:
              FoodSearchFamily._allTransitiveDependencies,
          query: query,
          category: category,
        );

  FoodSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.category,
  }) : super.internal();

  final String query;
  final String? category;

  @override
  FutureOr<List<Food>> runNotifierBuild(
    covariant FoodSearch notifier,
  ) {
    return notifier.build(
      query,
      category: category,
    );
  }

  @override
  Override overrideWith(FoodSearch Function() create) {
    return ProviderOverride(
      origin: this,
      override: FoodSearchProvider._internal(
        () => create()
          ..query = query
          ..category = category,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FoodSearch, List<Food>>
      createElement() {
    return _FoodSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodSearchProvider &&
        other.query == query &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FoodSearchRef on AutoDisposeAsyncNotifierProviderRef<List<Food>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `category` of this provider.
  String? get category;
}

class _FoodSearchProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FoodSearch, List<Food>>
    with FoodSearchRef {
  _FoodSearchProviderElement(super.provider);

  @override
  String get query => (origin as FoodSearchProvider).query;
  @override
  String? get category => (origin as FoodSearchProvider).category;
}

String _$foodsByCategoryHash() => r'9227a6716fdcfcee435b07f1cc6f4d53b7974fa3';

abstract class _$FoodsByCategory
    extends BuildlessAutoDisposeAsyncNotifier<List<Food>> {
  late final String category;

  FutureOr<List<Food>> build(
    String category,
  );
}

/// See also [FoodsByCategory].
@ProviderFor(FoodsByCategory)
const foodsByCategoryProvider = FoodsByCategoryFamily();

/// See also [FoodsByCategory].
class FoodsByCategoryFamily extends Family<AsyncValue<List<Food>>> {
  /// See also [FoodsByCategory].
  const FoodsByCategoryFamily();

  /// See also [FoodsByCategory].
  FoodsByCategoryProvider call(
    String category,
  ) {
    return FoodsByCategoryProvider(
      category,
    );
  }

  @override
  FoodsByCategoryProvider getProviderOverride(
    covariant FoodsByCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'foodsByCategoryProvider';
}

/// See also [FoodsByCategory].
class FoodsByCategoryProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FoodsByCategory, List<Food>> {
  /// See also [FoodsByCategory].
  FoodsByCategoryProvider(
    String category,
  ) : this._internal(
          () => FoodsByCategory()..category = category,
          from: foodsByCategoryProvider,
          name: r'foodsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$foodsByCategoryHash,
          dependencies: FoodsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              FoodsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  FoodsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  FutureOr<List<Food>> runNotifierBuild(
    covariant FoodsByCategory notifier,
  ) {
    return notifier.build(
      category,
    );
  }

  @override
  Override overrideWith(FoodsByCategory Function() create) {
    return ProviderOverride(
      origin: this,
      override: FoodsByCategoryProvider._internal(
        () => create()..category = category,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FoodsByCategory, List<Food>>
      createElement() {
    return _FoodsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FoodsByCategoryRef on AutoDisposeAsyncNotifierProviderRef<List<Food>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _FoodsByCategoryProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FoodsByCategory, List<Food>>
    with FoodsByCategoryRef {
  _FoodsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as FoodsByCategoryProvider).category;
}

String _$nutritionGoalsHash() => r'0a43fa8218d917ce055187401467c703b54461aa';

/// See also [NutritionGoals].
@ProviderFor(NutritionGoals)
final nutritionGoalsProvider = AutoDisposeAsyncNotifierProvider<NutritionGoals,
    Map<String, double>>.internal(
  NutritionGoals.new,
  name: r'nutritionGoalsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nutritionGoalsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NutritionGoals = AutoDisposeAsyncNotifier<Map<String, double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
