# 📝 Clean Architecture Cheat Sheet

## 🎯 Quick Reference

### File Naming Convention
```
feature_name_entity.dart       # Domain entity
feature_name_repository.dart   # Domain repository interface
verb_feature_name_usecase.dart # Use case (get_, create_, update_, delete_)
feature_name_model.dart        # Data model
feature_name_datasource.dart   # Data source
feature_name_repository_impl.dart # Repository implementation
feature_name_state.dart        # Cubit states
feature_name_cubit.dart        # Cubit
feature_name_page.dart         # UI page
```

### Folder Structure Template
```
features/
└── your_feature/
    ├── data/
    │   ├── datasources/
    │   │   └── your_feature_datasource.dart
    │   ├── models/
    │   │   └── your_feature_model.dart
    │   └── repositories/
    │       └── your_feature_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   └── your_feature_entity.dart
    │   ├── repositories/
    │   │   └── your_feature_repository.dart
    │   └── usecases/
    │       ├── get_your_feature_usecase.dart
    │       ├── create_your_feature_usecase.dart
    │       └── update_your_feature_usecase.dart
    └── presentation/
        ├── cubit/
        │   ├── your_feature_cubit.dart
        │   └── your_feature_state.dart
        └── pages/
            └── your_feature_page.dart
```

## 📋 Code Templates

### 1. Entity Template
```dart
import 'package:equatable/equatable.dart';

class YourEntity extends Equatable {
  final String id;
  final String name;

  const YourEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
```

### 2. Repository Interface Template
```dart
import '../../../../core/utils/result.dart';
import '../entities/your_entity.dart';

abstract class YourRepository {
  Future<Result<YourEntity>> getItem(String id);
  Future<Result<List<YourEntity>>> getAll();
  Future<Result<YourEntity>> create(YourEntity item);
  Future<Result<YourEntity>> update(YourEntity item);
  Future<Result<void>> delete(String id);
}
```

### 3. Use Case Template
```dart
import '../../../../core/utils/result.dart';
import '../entities/your_entity.dart';
import '../repositories/your_repository.dart';

class GetYourItemUseCase {
  final YourRepository repository;

  GetYourItemUseCase(this.repository);

  Future<Result<YourEntity>> call(String id) async {
    return await repository.getItem(id);
  }
}
```

### 4. Model Template
```dart
import '../../domain/entities/your_entity.dart';

class YourModel extends YourEntity {
  const YourModel({
    required super.id,
    required super.name,
  });

  factory YourModel.fromJson(Map<String, dynamic> json) {
    return YourModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory YourModel.fromEntity(YourEntity entity) {
    return YourModel(
      id: entity.id,
      name: entity.name,
    );
  }
}
```

### 5. Data Source Template
```dart
import '../models/your_model.dart';

abstract class YourDataSource {
  Future<YourModel> getItem(String id);
  Future<List<YourModel>> getAll();
  Future<YourModel> create(YourModel item);
  Future<YourModel> update(YourModel item);
  Future<void> delete(String id);
}

class YourDataSourceImpl implements YourDataSource {
  // Implementation here
  @override
  Future<YourModel> getItem(String id) async {
    // Fetch from API/Database
    throw UnimplementedError();
  }
}
```

### 6. Repository Implementation Template
```dart
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/your_entity.dart';
import '../../domain/repositories/your_repository.dart';
import '../datasources/your_datasource.dart';

class YourRepositoryImpl implements YourRepository {
  final YourDataSource dataSource;

  YourRepositoryImpl({required this.dataSource});

  @override
  Future<Result<YourEntity>> getItem(String id) async {
    try {
      final item = await dataSource.getItem(id);
      return Result.success(item);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
```

### 7. State Template
```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/your_entity.dart';

abstract class YourState extends Equatable {
  const YourState();
  
  @override
  List<Object?> get props => [];
}

class YourInitial extends YourState {
  const YourInitial();
}

class YourLoading extends YourState {
  const YourLoading();
}

class YourLoaded extends YourState {
  final YourEntity item;
  
  const YourLoaded(this.item);
  
  @override
  List<Object> get props => [item];
}

class YourListLoaded extends YourState {
  final List<YourEntity> items;
  
  const YourListLoaded(this.items);
  
  @override
  List<Object> get props => [items];
}

class YourError extends YourState {
  final String message;
  
  const YourError(this.message);
  
  @override
  List<Object> get props => [message];
}
```

### 8. Cubit Template
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_your_item_usecase.dart';
import '../../domain/usecases/create_your_item_usecase.dart';
import 'your_state.dart';

class YourCubit extends Cubit<YourState> {
  final GetYourItemUseCase getItemUseCase;
  final CreateYourItemUseCase createItemUseCase;

  YourCubit({
    required this.getItemUseCase,
    required this.createItemUseCase,
  }) : super(const YourInitial());

  Future<void> loadItem(String id) async {
    emit(const YourLoading());
    
    final result = await getItemUseCase(id);
    
    result.fold(
      onFailure: (failure) => emit(YourError(failure.message)),
      onSuccess: (item) => emit(YourLoaded(item)),
    );
  }

  Future<void> createItem(YourEntity item) async {
    emit(const YourLoading());
    
    final result = await createItemUseCase(item);
    
    result.fold(
      onFailure: (failure) => emit(YourError(failure.message)),
      onSuccess: (item) => emit(YourLoaded(item)),
    );
  }
}
```

### 9. Page Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/your_cubit.dart';
import '../cubit/your_state.dart';

class YourPage extends StatelessWidget {
  const YourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Feature'),
      ),
      body: BlocBuilder<YourCubit, YourState>(
        builder: (context, state) {
          if (state is YourInitial) {
            return const Center(child: Text('Press button to load'));
          }
          
          if (state is YourLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is YourError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      // Retry logic
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is YourLoaded) {
            return Center(
              child: Text('Item: ${state.item.name}'),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### 10. Dependency Injection Template
```dart
// In injection_container.dart

// Cubit (Factory - new instance each time)
sl.registerFactory(
  () => YourCubit(
    getItemUseCase: sl(),
    createItemUseCase: sl(),
  ),
);

// Use cases (Lazy Singleton)
sl.registerLazySingleton(() => GetYourItemUseCase(sl()));
sl.registerLazySingleton(() => CreateYourItemUseCase(sl()));

// Repository (Lazy Singleton)
sl.registerLazySingleton<YourRepository>(
  () => YourRepositoryImpl(dataSource: sl()),
);

// Data source (Lazy Singleton)
sl.registerLazySingleton<YourDataSource>(
  () => YourDataSourceImpl(),
);
```

## 🚀 Common Commands

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Run tests
flutter test

# Generate coverage
flutter test --coverage

# Clean build
flutter clean

# Analyze code
flutter analyze

# Format code
dart format lib/
```

## 💡 Quick Tips

1. **Always start with Domain layer** - Define entities and use cases first
2. **One use case = One action** - Keep them simple and focused
3. **Use Result.fold()** - Always handle both success and failure cases
4. **Register in DI** - Don't forget to add new classes to injection_container.dart
5. **Test each layer** - Write tests as you build each layer
6. **Keep states simple** - Only store what UI needs to display
7. **Cubit methods should be async** - Use Future<void> for all actions
8. **Use const constructors** - For better performance

## 🎯 Common Patterns

### Loading Pattern
```dart
Future<void> loadData() async {
  emit(const YourLoading());
  final result = await useCase();
  result.fold(
    onFailure: (f) => emit(YourError(f.message)),
    onSuccess: (data) => emit(YourLoaded(data)),
  );
}
```

### Create/Update Pattern
```dart
Future<void> saveData(YourEntity entity) async {
  emit(const YourLoading());
  final result = await saveUseCase(entity);
  result.fold(
    onFailure: (f) => emit(YourError(f.message)),
    onSuccess: (data) {
      emit(YourSuccess('Saved successfully'));
      loadData(); // Reload list
    },
  );
}
```

### Delete Pattern
```dart
Future<void> deleteData(String id) async {
  emit(const YourLoading());
  final result = await deleteUseCase(id);
  result.fold(
    onFailure: (f) => emit(YourError(f.message)),
    onSuccess: (_) {
      emit(YourSuccess('Deleted successfully'));
      loadData(); // Reload list
    },
  );
}
```

## 📚 Remember

- **Domain** = Business logic (no Flutter imports)
- **Data** = Implementation details
- **Presentation** = UI and state management
- **Dependencies flow inward** = Presentation → Domain ← Data
