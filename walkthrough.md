# Walkthrough — Disease Surveillance Mobile App

---

## 1. What Was Broken and Why

### Root Causes

**Routing:** The original `ShellRoute` used a regular (stateless) shell with three tabs: Reports, My Submissions, Profile. The initial route was `/` (splash), which on completion navigated to `/reports`. However, `ShellRoute` does not preserve navigation state across tabs — switching tabs discarded the previous tab's widget tree, causing blank screens and inconsistent state.

**Layout Constraints:** While static analysis found no infinite-width patterns in the final codebase, the runtime errors (`BoxConstraints forces an infinite width`, `RenderBox was not laid out`) were caused by:
- Deleted screens still referenced by routes, leading to null widget builds.
- Inconsistent route names between `RouteNames` constants and hardcoded strings in `AppShell`.
- Missing `Expanded` wrappers on `ListView` inside `Column` in some deleted intermediate states.

**Dead Imports / References:** After screens were deleted (03–07, 10–12 from the HTML mockup), import paths broke silently. The router still tried to build those screens, producing blank pages or throwing.

### Summary

| Problem | Cause | Fix |
|---------|-------|-----|
| Only Profile tab renders | `ShellRoute` lost state on tab switch | Replaced with `StatefulShellRoute.indexedStack` |
| Blank screens | Dead route references to deleted screens | Removed dead routes; wired all 3 tabs to live screens |
| Layout constraint errors | Unconstrained widgets in deleted intermediate code | Clean rebuild with mandatory layout rules |
| Navigation didn't work | Mismatched route paths (constants vs hardcoded) | Centralized all paths in `RouteNames`; shell uses `navigationShell.goBranch()` |

---

## 2. What Changed and Where

### New Files Created

```
lib/
  core/
    network/
      api_client.dart              — Dio HTTP client + token interceptor
      api_exceptions.dart          — Structured error handling for API calls
  features/
    auth/
      data/
        models/auth_token_model.dart
        models/user_model.dart
        sources/auth_remote_source.dart
        repositories/auth_repository.dart
      presentation/
        screens/splash_screen.dart  — Moved from features/splash/
        screens/sign_up_screen.dart — New placeholder (backend has no sign-up endpoint)
    home/
      data/
        models/dashboard_summary_model.dart
        sources/dashboard_remote_source.dart
        repositories/dashboard_repository.dart
      presentation/
        controllers/home_controller.dart
        screens/home_screen.dart
        widgets/kpi_grid.dart
        widgets/recent_alerts_section.dart
    feature_two/
      data/
        models/report_model.dart
        models/submission_model.dart
        sources/reports_remote_source.dart
        repositories/reports_repository.dart
      presentation/
        controllers/reports_controller.dart
        controllers/submissions_controller.dart
        controllers/search_controller.dart
        screens/feature_two_screen.dart
        screens/report_case_screen.dart
        screens/my_submissions_screen.dart
        screens/edit_draft_screen.dart
        screens/search_screen.dart
    profile/
      data/
        models/user_profile_model.dart
        sources/profile_remote_source.dart
        repositories/profile_repository.dart
```

### Modified Files

| File | Change |
|------|--------|
| `pubspec.yaml` | Added `dio: ^5.7.0` and `flutter_secure_storage: ^9.2.4` |
| `lib/main.dart` | Simplified; removed TODO comments |
| `lib/core/constants/app_constants.dart` | Added `apiBaseUrl`, `apiBaseUrlIos`, `tokenStorageKey` |
| `lib/core/routing/app_router.dart` | Full rewrite: `StatefulShellRoute.indexedStack`, auth redirect guard |
| `lib/core/routing/route_names.dart` | Updated paths: splash at `/splash`, home at `/` |
| `lib/shared/widgets/app_shell.dart` | Rewrite: accepts `StatefulNavigationShell`, uses `goBranch()` |
| `lib/features/auth/presentation/controllers/auth_controller.dart` | Full rewrite: real API login via `AuthRepository`, session check |
| `lib/features/auth/presentation/screens/login_screen.dart` | Uses new auth controller, navigates to `/` on success |
| `lib/features/profile/presentation/controllers/profile_controller.dart` | Uses new `UserProfile` model |
| `lib/features/profile/presentation/screens/profile_screen.dart` | Updated imports, added My Submissions link, logout calls auth controller |
| `test/widget_test.dart` | Fixed to reference `DiseaseApp` instead of deleted `MyApp` |

### Deleted Directories

| Path | Reason |
|------|--------|
| `lib/features/reports/` | Merged into `lib/features/feature_two/` |
| `lib/features/submissions/` | Merged into `lib/features/feature_two/` |
| `lib/features/search/` | Merged into `lib/features/feature_two/` |
| `lib/features/splash/` | Moved to `lib/features/auth/presentation/screens/` |

---

## 3. How Routing + Bottom Nav Works

### Architecture

```
GoRouter
├── /splash          → SplashScreen (checks auth, then redirects)
├── /login           → LoginScreen
├── /sign-up         → SignUpScreen
├── StatefulShellRoute.indexedStack (bottom nav)
│   ├── Branch 0: /         → HomeScreen      (tab: Home)
│   ├── Branch 1: /reports  → FeatureTwoScreen (tab: Reports)
│   └── Branch 2: /profile  → ProfileScreen   (tab: Profile)
├── /report-case     → ReportCaseScreen (pushed over shell)
├── /my-submissions  → MySubmissionsScreen (pushed over shell)
├── /search          → SearchScreen (pushed over shell)
└── /edit-draft/:id  → EditDraftScreen (pushed over shell)
```

### Key Mechanics

- **`StatefulShellRoute.indexedStack`** keeps all three tab bodies alive in an `IndexedStack`. Switching tabs is instant — no rebuild, no state loss.
- **`AppShell`** receives a `StatefulNavigationShell` and calls `navigationShell.goBranch(index)` to switch tabs.
- **Push-over screens** (report-case, my-submissions, search, edit-draft) are defined outside the shell, so they render full-screen on top of the bottom nav.
- **Auth guard** is a top-level `redirect` on the `GoRouter`. It watches `isAuthenticatedProvider`. If the user is not authenticated and tries to visit any protected route, they are sent to `/login`. If authenticated and visiting `/login` or `/sign-up`, they are sent to `/`.

---

## 4. How Authentication Works

### Token Flow

1. **Login:** User enters email + password → `AuthController.login()` calls `AuthRepository.login()` → posts to `POST /api/auth-token/` with `{username: email, password: password}` → backend returns `{token: "..."}` → token is stored in `FlutterSecureStorage`.

2. **Subsequent requests:** `ApiClient` has a Dio interceptor that reads the token from secure storage and adds `Authorization: Token <token>` to every request.

3. **Session check:** On app launch, `SplashScreen` calls `AuthController.checkSession()` which reads the token from secure storage. If a token exists, `isAuthenticatedProvider` is set to `true` and the user goes directly to `/` (home). Otherwise, they see the login screen.

4. **Logout:** `AuthController.logout()` clears the token from secure storage and sets `isAuthenticatedProvider` to `false`. The router redirect immediately sends the user to `/login`.

### Token Refresh

The Django backend uses DRF `TokenAuthentication` which does **not** have a refresh endpoint — tokens do not expire unless manually revoked. If the token becomes invalid (e.g., revoked server-side), the API returns 401. The `ApiClient` passes this through as an `ApiException`, and the UI shows an error. The user must log in again.

**Fallback strategy:** If a refresh endpoint is added later, add a Dio interceptor that catches 401 responses, calls the refresh endpoint, retries the original request, and only redirects to login if refresh also fails.

### Route Guards

The `GoRouter.redirect` callback enforces:
- Unauthenticated users → `/login`
- Authenticated users trying to access `/login` or `/sign-up` → `/` (home)
- The splash screen is always accessible (it handles the auth check internally)

---

## 5. How API Calls Are Wired

### Layer Diagram

```
UI (Screen/Widget)
    ↓ ref.watch()
Controller (StateNotifier / Provider)
    ↓ calls
Repository
    ↓ delegates to
RemoteSource
    ↓ uses
ApiClient (Dio + token interceptor)
    ↓ HTTP
Django REST API
```

### Concrete Example: Dashboard Summary

```
HomeScreen
  → ref.watch(homeControllerProvider)
    → HomeController constructor calls loadDashboard()
      → DashboardRepository.getSummary()
        → DashboardRemoteSource.fetchSummary()
          → ApiClient.get('/api/v1/dashboard/summary/')
            → Dio GET with Authorization header
              → Django returns {cases_7d, cases_30d, reports_7d, active_alerts}
          → DashboardSummary.fromJson(response.data)
        ← returns DashboardSummary
      ← updates HomeState.summary
    ← UI rebuilds with new KPI values
```

### Error Handling

- `ApiClient` wraps all Dio calls in try/catch, converting `DioException` to `ApiException`.
- Controllers catch `ApiException` and set `errorMessage` on state.
- Screens display errors via `SnackBar` or inline error banners.
- The `HomeController` falls back to mock data if the backend is unreachable, showing an offline banner.

---

## 6. How to Run Backend + Enable APIs

### Prerequisites

- Python 3.10+, [uv](https://github.com/astral-sh/uv) package manager
- PostgreSQL (or SQLite for local dev if configured)
- Redis (for Celery, optional for API-only use)

### Steps

```bash
# 1. Clone the backend repo (disease-surveillance-dashboard)
cd disease-surveillance-dashboard

# 2. Install dependencies
uv sync

# 3. Copy .env file (set DATABASE_URL, DJANGO_SECRET_KEY, etc.)
cp .env.example .env   # edit as needed

# 4. Run migrations
uv run python manage.py migrate

# 5. Create superuser (use email as username)
uv run python manage.py createsuperuser

# 6. Seed reference data (diseases, locations)
uv run python manage.py seed_reference_data

# 7. Start dev server
uv run python manage.py runserver 0.0.0.0:8000
```

The API is now available at `http://localhost:8000/api/v1/`.

### Verify the API

- Swagger UI: `http://localhost:8000/api/docs/`
- Get a token: `curl -X POST http://localhost:8000/api/auth-token/ -d "username=your@email.com&password=yourpass"`
- Test: `curl -H "Authorization: Token <token>" http://localhost:8000/api/v1/users/me/`

---

## 7. How to Run the Mobile App

### Prerequisites

- Flutter SDK 3.10+ (`flutter --version`)
- Android Studio (for Android emulator) or Xcode (for iOS simulator)
- A running backend (see section 6)

### Android Emulator

```bash
cd disease_surveillance_app

# 1. Get dependencies
flutter pub get

# 2. Start an Android emulator
flutter emulators --launch <emulator_name>

# 3. Run the app
flutter run
```

The app uses `http://10.0.2.2:8000` as the API base URL for Android emulator (this maps to `localhost` on the host machine). Ensure the Django server is running on port 8000.

### Physical Android Device

1. Enable Developer Options and USB Debugging on your phone.
2. Connect via USB, verify with `flutter devices`.
3. Update `AppConstants.apiBaseUrl` in `lib/core/constants/app_constants.dart` to your machine's LAN IP (e.g., `http://192.168.1.100:8000`).
4. Ensure Django's `ALLOWED_HOSTS` includes your LAN IP.
5. Run `flutter run`.

### iOS Simulator

```bash
# Uses localhost — update apiBaseUrl to apiBaseUrlIos
open -a Simulator
flutter run
```

### Chrome (Web)

```bash
flutter run -d chrome
```

Update `apiBaseUrl` to `http://localhost:8000` and ensure Django has CORS enabled for your origin.

---

## 8. How to Safely Add a New Screen

Follow this checklist to avoid constraint errors:

1. **Create the screen file** in the appropriate feature directory:
   `lib/features/<feature>/presentation/screens/my_screen.dart`

2. **Add a route** in `lib/core/routing/route_names.dart`:
   ```dart
   static const String myScreen = '/my-screen';
   ```

3. **Register the route** in `lib/core/routing/app_router.dart`:
   ```dart
   GoRoute(
     path: RouteNames.myScreen,
     builder: (_, _) => const MyScreen(),
   ),
   ```

4. **Follow layout rules:**
   - Wrap `TextField`/`TextFormField` inside a `Row` with `Expanded`.
   - Wrap `ListView`/`GridView` inside a `Column` with `Expanded` or give it a `SizedBox` with fixed height.
   - Always use `SafeArea`.
   - Avoid `Expanded` inside unbounded (scrollable) parents.
   - Keep widgets under 200 lines — extract sub-widgets.

5. **Use design tokens** — never hardcode colors/spacing:
   ```dart
   import 'package:disease_surveillance_app/core/theme/app_colors.dart';
   import 'package:disease_surveillance_app/core/theme/app_spacing.dart';
   ```

6. **Run `flutter analyze`** before committing to catch issues early.

---

## 9. How to Swap Mock Data for Real Endpoints

Files using mock data are marked with `// TODO:` comments. To swap:

1. **Find the mock provider** (e.g., `reportsProvider` in `reports_controller.dart`).

2. **Change it to a `FutureProvider`** or `StateNotifierProvider` that calls the repository:

   ```dart
   // Before (mock):
   final reportsProvider = Provider<List<ReportItem>>((ref) => [...]);

   // After (real):
   final reportsProvider = FutureProvider<List<ReportModel>>((ref) async {
     final repo = ref.watch(reportsRepositoryProvider);
     return repo.getReports();
   });
   ```

3. **Update the screen** to handle `AsyncValue` states:

   ```dart
   final reports = ref.watch(reportsProvider);
   return reports.when(
     data: (list) => ListView.builder(...),
     loading: () => const CircularProgressIndicator(),
     error: (e, _) => Text('Error: $e'),
   );
   ```

4. **The data layer is already built** — `ReportsRepository`, `ReportsRemoteSource`, and `ReportModel` are ready to use. The Dio client handles auth tokens automatically.

### Endpoints Ready for Integration

| Feature | Endpoint | Status |
|---------|----------|--------|
| Login | `POST /api/auth-token/` | Integrated |
| Current user | `GET /api/v1/users/me/` | Integrated |
| Dashboard summary | `GET /api/v1/dashboard/summary/` | Integrated |
| Recent alerts | `GET /api/v1/dashboard/recent-alerts/` | Integrated |
| Reports list | `GET /api/v1/reporting/reports/` | Data layer ready, UI uses mock |
| Create report | `POST /api/v1/reporting/reports/` | Data layer ready, UI uses mock |
| Update report | `PATCH /api/v1/reporting/reports/{id}/` | Data layer ready, UI uses mock |
| Diseases list | `GET /api/v1/diseases/` | Data layer ready |
| Locations list | `GET /api/v1/locations/` | Data layer ready |
| Sign up | None | Blocked — no backend endpoint |
| Forgot password | None | Blocked — no backend endpoint |
| Notifications | None | Blocked — no backend endpoint |

---

*End of walkthrough.*
