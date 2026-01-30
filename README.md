# Draftea Pokedex

Una aplicación Flutter para explorar Pokémon usando la PokeAPI.

## 🚀 Comenzando

### Prerrequisitos

- Flutter SDK instalado (versión 3.0 o superior)
- Dart SDK
- Para desarrollo móvil:
  - **Android**: Android Studio con Android SDK
  - **iOS**: Xcode (solo en macOS)
- Para desarrollo web: Navegador web (Chrome recomendado)

### Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/fn-dev93/pokedex.git
cd draftea_pokedex
```

2. Instala las dependencias:
```bash
flutter pub get
```

## 📱 Ejecución multiplataforma

### Android

1. Conecta un dispositivo Android o inicia un emulador/navegador

2. Ejecuta la aplicación:
```bash
# Modo desarrollo
flutter run --flavor development --target lib/main_development.dart

# Modo staging
flutter run --flavor staging --target lib/main_staging.dart

# Modo production
flutter run --flavor production --target lib/main_production.dart
```

## 🧪 Ejecutar Tests

```bash
# Todos los tests
flutter test

# Con cobertura
flutter test --coverage
```

## 🏛️ Arquitectura y Escalabilidad

### Patrón Arquitectónico

Este proyecto implementa **Clean Architecture** combinada con **BLoC/Cubit** para la gestión de estado, una arquitectura robusta y escalable adecuada para productos reales en todas las plataformas (Mobile, Web, Desktop).

### Capas de la Arquitectura

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI + BLoC/Cubit State Management)     │
│  - pokemon/view/                        │
│  - pokemon/widgets/                     │
│  - pokemon/cubit/                       │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         Domain Layer                    │
│  (Models & Business Logic)              │
│  - pokemon/models/                      │
│  - pokemon/helpers/                     │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         Data Layer                      │
│  (Repository Pattern + Data Sources)    │
│  - pokemon/data/pokemon_repository.dart │
│  - pokemon_api_client.dart              │
│  - pokemon_local_data_source.dart       │
└─────────────────────────────────────────┘
```

### Características de Escalabilidad

#### 1. **Separación de Responsabilidades**
- **Presentation**: Cubits manejan la lógica de UI y estados
- **Domain**: Modelos inmutables con lógica de negocio
- **Data**: Repository pattern con múltiples fuentes de datos

#### 2. **Gestión de Estado con BLoC/Cubit**
- Estados predecibles y testeables
- Flujo unidireccional de datos
- Separación clara entre UI y lógica de negocio

#### 3. **Repository Pattern**
- Abstracción de fuentes de datos (API + Cache local)
- Estrategia **offline-first**: funciona sin conexión
- Fácil mockear para testing
- Permite cambiar implementaciones sin afectar la UI

#### 4. **Inyección de Dependencias**
- Dependencias inyectadas en constructores
- Facilita testing con mocks
- Bajo acoplamiento entre componentes

#### 5. **Multi-Environment Support**
- Flavors separados: development, staging, production
- Configuración específica por entorno
- Bootstrap centralizado para inicialización

#### 6. **Almacenamiento Local con Hive**
- Cache eficiente multiplataforma (Mobile, Web, Desktop)
- Sin SQL, optimizado para Flutter
- Soporte para tipos personalizados con adapters

### Escalabilidad para Producto Real

Cada módulo es **autónomo** con su propia estructura:
- `cubit/` - Gestión de estado
- `data/` - Repositorio y fuentes de datos
- `models/` - Modelos de dominio
- `view/` - Pantallas
- `widgets/` - Componentes reutilizables

#### CI/CD Ready
- Flavors permiten deployments automatizados
- Tests ejecutables en pipeline
- Build separados por plataforma y entorno

### Decisiones Técnicas Clave

| Decisión | Razón | Beneficio para Escalar |
|----------|-------|------------------------|
| **BLoC/Cubit** | Estado predecible y testeable | Mantiene complejidad bajo control |
| **Repository Pattern** | Abstracción de datos | Fácil cambiar backend/cache |
| **Hive** | Rápido y multiplataforma | Funciona igual en Mobile/Web |
| **Feature Modules** | Separación por dominio | Equipos pueden trabajar en paralelo |
| **Inyección de Deps** | Bajo acoplamiento | Testing y mantenimiento simples |


## Trade-offs
- Utilizar el package dio para llamar a los endpoints directamente en lugar de hacer un cliente robusto
- Enfoque del testing únicamente sobre los cubits en lugar de la app completa
- Diseño de la app sencillo y sin búsquedas personalizadas




## 🔄 Gestión de Estado y Side-Effects

**Flujo UI → Estado → Datos:**
```
UI (BlocListener/BlocBuilder) 
  → emitEvent(Cubit)
  → Repository.fetch() 
  → [API + Cache]
  → emitNewState()
  → Widget rebulid
```

**Evitar acoplamiento:** Cubit solo conoce Repository (abstracción), no DIO ni Hive directamente. UI solo escucha Cubit, no llamadas HTTP.

---

## 💾 Offline y Caché

| Acción | Estrategia |
|--------|-----------|
| **Guardado** | Hive guarda lista de Pokémon al obtener de API |
| **Invalidación** | No hay versionado; válido mientras no se borre la app |
| **Conflictos** | Preferir remoto si hay conexión; mostrar badge "Offline" si no |

---

## 🌐 Flutter Web

**Decisiones para buena UX:**
- Responsive con `MediaQuery` y `LayoutBuilder`
- Navegación con `go_router` (deeplinking en URL)
- Grilla de Pokémon adaptable 
        width >= 1400 => 8 colas
        width >= 1200 => 6 colas
        width >= 900  => 5 colas
        width >= 600  => 4 colas

**Limitaciones anticipadas:** Scroll infinito pesado con 1000+ Pokémon → solución: paginación.

---

## ✨ Calidad de Código (3 Decisiones)

1. **Immutability (Equatable + Hive):** Modelos con `Equatable` y `@HiveType` para comparación segura
   ```dart
   @HiveType(typeId: 0)
   class Pokemon extends Equatable {
     const Pokemon({required this.id, required this.name});
     @HiveField(0) final int id;
     @HiveField(1) final String name;
     @override List<Object?> get props => [id, name];
   }
   ```

2. **Single Responsibility:** `pokemon_repository.dart` solo orquesta; datos vienen de `pokemon_api_client.dart` o `pokemon_local_data_source.dart`

3. **Type Safety:** Enum para estados de Cubit (`initial`, `loading`, `success`, `error`) evita strings mágicos

---

## 🧪 Testing

**Testeado:** Cubits (100% lógica de estado) - 15 tests unitarios

**No testeado:** Repository, API client, Hive persistence, Widgets

**Top 3 a agregar (prioridad):**
1. Repository (mocking API + Hive para offline fallback)
2. Edge cases en Cubits (errores, timeouts, estados vacíos)
3. Widgets principales (BlocBuilder integration)

---

## 📝 Git

**Estructura de commits:**
```
1. initial: app base - models, api client, repository, cubit
2. refactor(ui): widget segregation + localizations
3. feat(tests): unit tests for pokemon_cubit 
4. Doc(readme): readme added
```

**Estrategia:** Commit inicial monolítico con app funcional, luego features incrementales separadas. **Ventaja:** Fácil seguir progreso, cada PR es testeable y reviewable.

---

## 📋 Pendientes (Top 5)

| # | Tarea | Cómo |
|---|-------|------|
| 1 | **Búsqueda/Filtro** | Add search box → filter en-memoria o API con query param |
| 2 | **Navegar entre Pokémon** | Bottom sheet con stats, tipos, evoluciones desde la página de detalle|
| 3 | **Tests de Repository** | Mock DIO + Mock Hive, verificar offline fallback |
| 4 | **Paginación customizada** | seleccionar la cantidad de pokémon que el usuario desee cargar |
| 5 | **Robustez en el cliente** | Manejar errores y timeouts de manera elegante y centralizada |

---

## Contacto
    fernandoj.nav@gmail.com
    https://www.linkedin.com/in/fndev-93/