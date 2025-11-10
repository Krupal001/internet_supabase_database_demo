# Clean Architecture with Cubit

This project follows **Clean Architecture** principles with **Cubit** for state management.

## 📁 Project Structure

```
lib/
├── core/                          # Core utilities shared across features
│   ├── di/                        # Dependency Injection
│   │   └── injection_container.dart
│   ├── error/                     # Error handling
│   │   └── failures.dart
│   └── utils/                     # Utilities
│       └── result.dart            # Simple Result class (replaces Either)
│
└── features/                      # Feature modules
    └── counter/                   # Example: Counter feature
        ├── data/                  # Data Layer
        │   ├── datasources/       # Data sources (API, Local DB)
        │   │   └── counter_local_datasource.dart
        │   ├── models/            # Data models (JSON serialization)
        │   │   └── counter_model.dart
        │   └── repositories/      # Repository implementations
        │       └── counter_repository_impl.dart
        │
        ├── domain/                # Domain Layer (Business Logic)
        │   ├── entities/          # Business entities
        │   │   └── counter_entity.dart
        │   ├── repositories/      # Repository contracts
        │   │   └── counter_repository.dart
        │   └── usecases/          # Use cases (business operations)
        │       ├── get_counter_usecase.dart
        │       ├── increment_counter_usecase.dart
        │       └── reset_counter_usecase.dart
        │
        └── presentation/          # Presentation Layer (UI)
            ├── cubit/             # State management with Cubit
            │   ├── counter_cubit.dart
            │   └── counter_state.dart
            └── pages/             # UI pages
                └── counter_page.dart
```

## 🏗️ Architecture Layers

### 1. **Domain Layer** (Business Logic)
- **Entities**: Pure business objects (e.g., `CounterEntity`)
- **Repositories**: Abstract contracts defining data operations
- **Use Cases**: Single-responsibility business operations
- ✅ **No dependencies** on other layers
- ✅ Contains only **pure Dart code**

### 2. **Data Layer** (Data Management)
- **Models**: Data representations with JSON serialization
- **Data Sources**: Interfaces for data access (API, local storage)
- **Repository Implementations**: Concrete implementations of domain repositories
- ✅ Depends on **Domain Layer**
- ✅ Handles data transformation and error handling

### 3. **Presentation Layer** (UI)
- **Cubit**: State management (simpler than Bloc)
- **States**: Different UI states (Loading, Loaded, Error)
- **Pages/Widgets**: UI components
- ✅ Depends on **Domain Layer**
- ✅ Uses **Cubit** for state management

## 🎯 Key Concepts

### Result Class (Simple Error Handling)
Instead of using `dartz` with `Either`, we use a simple `Result` class:

```dart
// Success case
Result.success(data);

// Failure case
Result.failure(ServerFailure('Error message'));

// Using fold to handle both cases
result.fold(
  onFailure: (failure) => print(failure.message),
  onSuccess: (data) => print(data),
);
```

### Cubit vs Bloc
**Cubit** is simpler than Bloc:
- ✅ No events needed - just call methods directly
- ✅ Less boilerplate code
- ✅ Easier to understand for beginners
- ✅ Perfect for simple to medium complexity state management

```dart
// Using Cubit
context.read<CounterCubit>().incrementCounter();

// Listening to state changes
BlocBuilder<CounterCubit, CounterState>(
  builder: (context, state) {
    if (state is CounterLoaded) {
      return Text('${state.counter.value}');
    }
    return CircularProgressIndicator();
  },
)
```

### Dependency Injection with GetIt
All dependencies are registered in `injection_container.dart`:

```dart
// Register factory (new instance each time)
sl.registerFactory(() => CounterCubit(...));

// Register singleton (single instance)
sl.registerLazySingleton(() => GetCounterUseCase(sl()));

// Use in code
final cubit = sl<CounterCubit>();
```

## 🚀 How to Add a New Feature

1. **Create feature folder** under `lib/features/your_feature/`

2. **Domain Layer**:
   - Create entity in `domain/entities/`
   - Create repository interface in `domain/repositories/`
   - Create use cases in `domain/usecases/`

3. **Data Layer**:
   - Create model in `data/models/`
   - Create data source in `data/datasources/`
   - Implement repository in `data/repositories/`

4. **Presentation Layer**:
   - Create states in `presentation/cubit/your_feature_state.dart`
   - Create cubit in `presentation/cubit/your_feature_cubit.dart`
   - Create UI in `presentation/pages/`

5. **Register dependencies** in `core/di/injection_container.dart`

## 📦 Dependencies

- **flutter_bloc**: State management with Cubit/Bloc
- **equatable**: Value equality for states and entities
- **get_it**: Dependency injection
- **supabase_flutter**: Backend database (optional)

## ✅ Benefits

- ✅ **Separation of Concerns**: Each layer has a single responsibility
- ✅ **Testability**: Easy to unit test each layer independently
- ✅ **Maintainability**: Easy to modify and extend
- ✅ **Scalability**: Easy to add new features
- ✅ **Clean Code**: No dependencies from inner to outer layers
- ✅ **Easy to Understand**: Simple Result class instead of complex Either

## 🎓 Learning Resources

- [Flutter Bloc Documentation](https://bloclibrary.dev/)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GetIt Documentation](https://pub.dev/packages/get_it)
