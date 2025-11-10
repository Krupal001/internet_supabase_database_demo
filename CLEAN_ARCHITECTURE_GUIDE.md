# 🎯 Clean Architecture Guide - Easy to Understand

## What is Clean Architecture?

Clean Architecture separates your code into **3 layers** that don't mix together. Think of it like a building with floors - each floor has its own purpose and rules.

## 🏢 The 3 Layers (Floors)

```
┌─────────────────────────────────────────────┐
│         PRESENTATION LAYER (UI)             │  ← What user sees
│  - Pages, Widgets                           │
│  - Cubit (manages state)                    │
│  - States (loading, success, error)         │
└─────────────────────────────────────────────┘
                    ↓ uses
┌─────────────────────────────────────────────┐
│         DOMAIN LAYER (Business Logic)       │  ← Business rules
│  - Entities (data objects)                  │
│  - Use Cases (what app can do)              │
│  - Repository contracts                     │
└─────────────────────────────────────────────┘
                    ↑ implements
┌─────────────────────────────────────────────┐
│         DATA LAYER (Data Management)        │  ← Where data comes from
│  - Models (JSON conversion)                 │
│  - Data Sources (API, Database)             │
│  - Repository implementations               │
└─────────────────────────────────────────────┘
```

## 📊 Flow Example: Increment Counter

Let's see how clicking the increment button flows through the layers:

```
1. USER clicks button
   ↓
2. PRESENTATION: CounterPage
   → calls: context.read<CounterCubit>().incrementCounter()
   ↓
3. PRESENTATION: CounterCubit
   → calls: incrementCounterUseCase()
   ↓
4. DOMAIN: IncrementCounterUseCase
   → calls: repository.incrementCounter()
   ↓
5. DATA: CounterRepositoryImpl
   → calls: localDataSource.getCounter()
   → increments value
   → calls: localDataSource.saveCounter()
   ↓
6. DATA: Returns Result.success(counter)
   ↓
7. DOMAIN: Returns result to Cubit
   ↓
8. PRESENTATION: Cubit emits new state
   → emit(CounterLoaded(counter))
   ↓
9. PRESENTATION: UI rebuilds with new value
   → BlocBuilder detects state change
   → Shows updated counter value
```

## 🎨 Understanding Each Component

### 1. Entity (Domain Layer)
**What**: Pure data object representing business concept
**Example**: `CounterEntity` - just holds counter value and timestamp
```dart
class CounterEntity {
  final int value;
  final DateTime lastUpdated;
}
```

### 2. Repository Interface (Domain Layer)
**What**: Contract defining what data operations are possible
**Example**: "I need to get, increment, and reset counter"
```dart
abstract class CounterRepository {
  Future<Result<CounterEntity>> getCounter();
  Future<Result<CounterEntity>> incrementCounter();
}
```

### 3. Use Case (Domain Layer)
**What**: Single action the app can perform
**Example**: "Increment the counter"
```dart
class IncrementCounterUseCase {
  Future<Result<CounterEntity>> call() {
    return repository.incrementCounter();
  }
}
```

### 4. Model (Data Layer)
**What**: Entity + JSON conversion abilities
**Example**: Can convert to/from JSON for storage
```dart
class CounterModel extends CounterEntity {
  Map<String, dynamic> toJson() { ... }
  factory CounterModel.fromJson(json) { ... }
}
```

### 5. Data Source (Data Layer)
**What**: Where actual data comes from (API, database, memory)
**Example**: Stores counter in memory
```dart
class CounterLocalDataSource {
  Future<CounterModel> getCounter() { ... }
  Future<CounterModel> saveCounter(counter) { ... }
}
```

### 6. Repository Implementation (Data Layer)
**What**: Actual implementation of repository interface
**Example**: Uses data source to get/save counter
```dart
class CounterRepositoryImpl implements CounterRepository {
  Future<Result<CounterEntity>> incrementCounter() {
    // Get current value
    // Add 1
    // Save new value
    // Return result
  }
}
```

### 7. State (Presentation Layer)
**What**: Different UI conditions
**Example**: Loading, Loaded, Error
```dart
abstract class CounterState {}
class CounterLoading extends CounterState {}
class CounterLoaded extends CounterState {
  final CounterEntity counter;
}
class CounterError extends CounterState {
  final String message;
}
```

### 8. Cubit (Presentation Layer)
**What**: Manages state, calls use cases
**Example**: When user clicks button, call use case and update state
```dart
class CounterCubit extends Cubit<CounterState> {
  void incrementCounter() async {
    emit(CounterLoading());
    final result = await incrementCounterUseCase();
    if (result.isSuccess) {
      emit(CounterLoaded(result.data));
    } else {
      emit(CounterError(result.failure.message));
    }
  }
}
```

### 9. Page/Widget (Presentation Layer)
**What**: UI that user sees
**Example**: Shows counter value, has increment button
```dart
BlocBuilder<CounterCubit, CounterState>(
  builder: (context, state) {
    if (state is CounterLoaded) {
      return Text('${state.counter.value}');
    }
    return CircularProgressIndicator();
  },
)
```

## 🔄 Result Class (Simple Error Handling)

Instead of complex `Either` from dartz, we use simple `Result`:

```dart
// ✅ Success
Result.success(myData)

// ❌ Failure
Result.failure(ServerFailure('Something went wrong'))

// Handle both cases
result.fold(
  onSuccess: (data) => print('Got data: $data'),
  onFailure: (failure) => print('Error: ${failure.message}'),
);
```

## 🎯 Why This Architecture?

### ✅ Benefits
1. **Easy to Test**: Test each layer separately
2. **Easy to Change**: Change database without touching UI
3. **Easy to Understand**: Each file has one job
4. **Easy to Scale**: Add new features without breaking old ones
5. **Team Friendly**: Multiple developers can work on different layers

### 📝 Rules
1. **Domain Layer** = No dependencies (pure Dart)
2. **Data Layer** = Can use Domain
3. **Presentation Layer** = Can use Domain (not Data directly)

## 🚀 Quick Start Checklist

To add a new feature:
- [ ] Create entity (Domain)
- [ ] Create repository interface (Domain)
- [ ] Create use cases (Domain)
- [ ] Create model (Data)
- [ ] Create data source (Data)
- [ ] Implement repository (Data)
- [ ] Create states (Presentation)
- [ ] Create cubit (Presentation)
- [ ] Create UI page (Presentation)
- [ ] Register in dependency injection

## 💡 Pro Tips

1. **One Use Case = One Action**: Don't make giant use cases
2. **Keep Entities Simple**: Just data, no logic
3. **Cubit for Simple, Bloc for Complex**: Start with Cubit
4. **Test Domain First**: It's the heart of your app
5. **Use Result Class**: Easier than Either from dartz

## 🎓 Remember

- **Domain** = What your app does (business logic)
- **Data** = Where information comes from
- **Presentation** = What user sees and interacts with

Each layer talks to the one below it, never above!
