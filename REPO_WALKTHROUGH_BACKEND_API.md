# Repo Walkthrough (Backend + API Focus)

---

## SECTION 1 — What this system is

**What problem the system solves (from actual code)**  
The system is a disease surveillance dashboard for early warning of communicable diseases in Greater Accra. It allows:

- **Reporting**: Health workers submit disease reports (with draft → submit workflow on the web).
- **Reference data**: Diseases and locations (districts) are maintained and used to filter reports.
- **Analytics**: Baseline and trend metrics, anomaly detection (Isolation Forest), and ARIMA forecasting.
- **Alerts**: Threshold/CUSUM-based alerts with statuses, notes, and escalations.
- **Investigations**: Tasks linked to alerts, assignable to users.
- **Dashboard**: Aggregated KPIs, time-series, top diseases, map points, recent alerts/investigations, situation overview, detection metrics, data quality.
- **Exports & audit**: Export metadata (CSV/PDF) and audit logs for traceability.
- **Access control**: Roles and user–role assignments used for dashboard and evaluation permissions.

**Main components**

- **Django backend**: Monolithic app under `disease_surveillance_dashboard/` plus top-level `reference_data` app; config in `config/`.
- **REST API**: DRF under `/api/v1/` (router) and `/api/v1/dashboard/` (function-based dashboard endpoints); token + session auth.
- **DB**: PostgreSQL (via `DATABASE_URL`); Redis for Celery.
- **Web dashboard**: Django templates (dashboard, reporting, users, allauth); no separate SPA in repo.
- **Flutter / mobile app**: Not found in repository (no `pubspec.yaml`, no `lib/`).

**What appears complete vs incomplete**

- **Complete**: Report CRUD (web + API), report statuses (DRAFT/SUBMITTED), draft edit flow, My Submissions list, reference data (Disease/Location), analytics/alerts/investigations/exports/audit models and ViewSets, dashboard aggregation services and API, role-based dashboard access, token auth, OpenAPI schema (drf-spectacular), Celery + beat + Flower wiring, pytest test layout.
- **Incomplete or placeholder**: `users.tasks.get_users_count` is a demo Celery task (“pointless … to demonstrate usage”). Export model supports async processing “in future implementations” but no Celery export task found. One TODO in `users.tests.test_views` (pytest-django scope). `config.settings.base` has TODOs on `CELERY_TASK_TIME_LIMIT` / `CELERY_TASK_SOFT_TIME_LIMIT` (“set to whatever value is adequate”). WebSocket app only echoes ping/pong.

---

## SECTION 2 — Clean Repository Tree (Backend-Focused)

Omitted: `build/`, `dist/`, `.dart_tool/`, `.idea/`, `.vscode/`, `node_modules/`, `__pycache__/`, `*.pyc`, `*.log`. `android/` and `ios/` are not present.

```
disease-surveillance-dashboard/
├── config/
│   ├── api_router.py          # DRF router for /api/v1/
│   ├── asgi.py                # ASGI app (HTTP + WebSocket)
│   ├── celery_app.py          # Celery app
│   ├── settings/
│   │   ├── base.py
│   │   ├── local.py
│   │   ├── production.py
│   │   └── test.py
│   ├── urls.py                # Root URLconf
│   ├── websocket.py           # WebSocket handler (ping/pong)
│   └── wsgi.py
├── disease_surveillance_dashboard/
│   ├── access_control/        # Roles, UserRoles
│   │   ├── api/ (views, serializers, urls)
│   │   ├── migrations/
│   │   └── models.py
│   ├── alerts/                # Alert, AlertStatus, AlertNote, AlertEscalation
│   │   ├── migrations/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── services.py
│   │   └── views.py
│   ├── analytics/             # BaselineMetric, TrendMetric
│   │   ├── migrations/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── services.py
│   │   └── views.py
│   ├── dashboard/             # Web dashboard + dashboard API
│   │   ├── api.py             # Dashboard API view functions
│   │   ├── api_urls.py
│   │   ├── services.py
│   │   ├── urls.py            # Web pages
│   │   ├── utils.py           # user_can_access_dashboard, user_has_role
│   │   └── views.py
│   ├── exports/               # Export, AuditLog
│   │   ├── migrations/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   └── views.py
│   ├── investigations/        # InvestigationTask
│   │   ├── migrations/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   └── views.py
│   ├── reporting/             # Report, ReportStatus, DuplicateFlag
│   │   ├── forms.py
│   │   ├── migrations/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── urls.py            # Web: new, edit, my-submissions
│   │   └── views.py           # Web views + DRF ViewSets
│   ├── users/
│   │   ├── api/ (views, serializers)
│   │   ├── migrations/
│   │   ├── models.py          # User (email as USERNAME_FIELD)
│   │   ├── tasks.py           # Celery: get_users_count
│   │   └── urls.py
│   ├── contrib/sites/migrations/
│   ├── static/
│   └── templates/
├── reference_data/
│   ├── management/commands/
│   │   └── seed_reference_data.py
│   ├── migrations/
│   ├── models.py              # Disease, Location
│   ├── serializers.py
│   └── views.py
├── locale/
├── manage.py
├── pyproject.toml             # uv/poetry-style; deps + pytest/mypy/ruff
├── uv.lock
├── docker-compose.local.yml
├── compose/                   # local & production Docker
└── tests/                    # e.g. test_merge_production_dotenvs_in_dotenv.py
```

---

## SECTION 3 — Backend Entry Points

- **manage.py**  
  Sets `DJANGO_SETTINGS_MODULE` to `config.settings.local`, adds `disease_surveillance_dashboard` to `sys.path`, then runs `execute_from_command_line`. Used for `runserver`, `migrate`, `createsuperuser`, `seed_reference_data`, etc.

- **Main settings**  
  Base: `config.settings.base`. Local dev: `config.settings.local` (used by manage.py). Production: `config.settings.production` (used by `wsgi.py`). Tests: `config.settings.test` (pytest `--ds=config.settings.test` in pyproject).

- **Root urls.py**  
  `config.urls`: home, about, admin, `users/`, `accounts/` (allauth), `dashboard/`, `reports/`, static/media; then API: `api/v1/` (router), `api/v1/dashboard/` (dashboard API), `api/auth-token/`, `api/schema/`, `api/docs/`. Debug-only: 400/403/404/500, debug toolbar.

- **wsgi.py**  
  Sets `DJANGO_SETTINGS_MODULE` to `config.settings.production`, appends `disease_surveillance_dashboard` to path, exposes `application = get_wsgi_application()`.

- **asgi.py**  
  Default settings `config.settings.local`. Exposes a single `application`: HTTP goes to Django ASGI app; WebSocket goes to `config.websocket.websocket_application`.

- **Environment variables**  
  Loaded via `django-environ` in `config.settings.base`: `env = environ.Env()`. If `READ_DOT_ENV_FILE` is True (from `DJANGO_READ_DOT_ENV_FILE`, default False), `env.read_env(BASE_DIR / ".env")`. Database: `env.db("DATABASE_URL")`. Other keys (e.g. `DJANGO_DEBUG`, `DJANGO_SECRET_KEY`, `REDIS_URL`) use `env()` with optional defaults. No separate config package; all in settings modules.

---

## SECTION 4 — Django Apps & Responsibilities

| App | Purpose | Key models | Key serializers | Key views/viewsets | Signals / tasks / commands |
|-----|--------|------------|-----------------|--------------------|----------------------------|
| **users** | Custom user (email login), profile, allauth | User (AbstractUser; email=USERNAME_FIELD, full_name, phone) | UserSerializer (name, url) | UserViewSet (list/retrieve/update + `me`) | Celery: `get_users_count`. No signals. |
| **access_control** | Roles and assignments | Role, UserRole (unique user+role) | RoleSerializer, UserRoleSerializer | RoleViewSet, UserRoleViewSet; UserRoleViewSet has action `user_roles` (GET ?user_id=) | None. |
| **reporting** | Disease reports and statuses | ReportStatus, Report, DuplicateFlag | ReportStatusSerializer, ReportSerializer, DuplicateFlagSerializer | **Web**: ReportCreateView, ReportUpdateView, MySubmissionsView. **API**: ReportStatusViewSet, ReportViewSet, DuplicateFlagViewSet | None. |
| **reference_data** | Master disease/location lists | Disease, Location | DiseaseSerializer, LocationSerializer | DiseaseViewSet, LocationViewSet | Management: `seed_reference_data` (Disease, Location). |
| **analytics** | Computed metrics | BaselineMetric, TrendMetric | BaselineMetricSerializer, TrendMetricSerializer | BaselineMetricViewSet, TrendMetricViewSet | None. |
| **alerts** | Alerts and related entities | AlertStatus, Alert, AlertNote, AlertEscalation | AlertStatusSerializer, AlertSerializer, AlertNoteSerializer, AlertEscalationSerializer | AlertStatusViewSet, AlertViewSet (custom action `evaluate` POST), AlertNoteViewSet, AlertEscalationViewSet | Services: `evaluate_trend_and_generate_alert`. |
| **investigations** | Tasks for alerts | InvestigationTask | InvestigationTaskSerializer | InvestigationTaskViewSet | None. |
| **exports** | Export metadata and audit | Export, AuditLog | ExportSerializer, AuditLogSerializer | ExportViewSet, AuditLogViewSet | None. |
| **dashboard** | Web dashboard + dashboard API | None (uses other apps’ models) | None | **Web**: views in `views.py`. **API**: 13 `@api_view` functions in `api.py` (summary, cases-timeseries, anomalies, forecast, top-diseases, map-points, recent-alerts, recent-investigations, situation-overview, detection-metrics, data-quality, evaluate) | Services in `services.py`; `utils.py`: `user_can_access_dashboard`, `user_has_role`. |

---

## SECTION 5 — API Surface Overview

- **API base path(s)**  
  - `/api/v1/` — DRF router (all ViewSets below).  
  - `/api/v1/dashboard/` — Dashboard aggregation endpoints (function-based).  
  - `/api/auth-token/` — DRF `obtain_auth_token` (POST username+password → token).  
  - `/api/schema/`, `/api/docs/` — drf-spectacular OpenAPI and Swagger UI.

- **Authentication**  
  DRF: `SessionAuthentication` and `TokenAuthentication`. Default permission: `IsAuthenticated`. Token obtained via `POST /api/auth-token/` (form or JSON). Dashboard endpoints and router endpoints require an authenticated user unless overridden; Swagger is `IsAdminUser`.

Endpoints below are those registered in `config.urls` and `config.api_router` and `dashboard.api_urls`. Router uses `DefaultRouter` in DEBUG else `SimpleRouter`; ViewSets get standard list/create/retrieve/update/partial_update/destroy where applicable.

| Method | Path | Purpose | Auth | Serializer | Model |
|--------|------|--------|------|------------|--------|
| POST | /api/auth-token/ | Obtain auth token | No | — | — |
| GET | /api/v1/users/ | List users (filtered to current user only) | Yes | UserSerializer | User |
| GET/PUT/PATCH | /api/v1/users/{id}/ | Retrieve/update user | Yes | UserSerializer | User |
| GET | /api/v1/users/me/ | Current user | Yes | UserSerializer | User |
| * | /api/v1/access-control/roles/ | CRUD roles | Yes | RoleSerializer | Role |
| * | /api/v1/access-control/user-roles/ | CRUD user-roles | Yes | UserRoleSerializer | UserRole |
| GET | /api/v1/access-control/user-roles/user_roles/?user_id= | List roles for user | Yes | UserRoleSerializer | UserRole |
| * | /api/v1/reporting/statuses/ | CRUD report statuses | Yes | ReportStatusSerializer | ReportStatus |
| * | /api/v1/reporting/reports/ | CRUD reports | Yes | ReportSerializer | Report |
| * | /api/v1/reporting/duplicate-flags/ | CRUD duplicate flags | Yes | DuplicateFlagSerializer | DuplicateFlag |
| * | /api/v1/analytics/baselines/ | CRUD baseline metrics | Yes | BaselineMetricSerializer | BaselineMetric |
| * | /api/v1/analytics/trends/ | CRUD trend metrics | Yes | TrendMetricSerializer | TrendMetric |
| * | /api/v1/alerts/statuses/ | CRUD alert statuses | Yes | AlertStatusSerializer | AlertStatus |
| * | /api/v1/alerts/alerts/ | CRUD alerts | Yes | AlertSerializer | Alert |
| POST | /api/v1/alerts/alerts/evaluate/ | Evaluate trend → create alert | Yes | — | Alert |
| * | /api/v1/alerts/notes/ | CRUD alert notes | Yes | AlertNoteSerializer | AlertNote |
| * | /api/v1/alerts/escalations/ | CRUD alert escalations | Yes | AlertEscalationSerializer | AlertEscalation |
| * | /api/v1/investigations/tasks/ | CRUD investigation tasks | Yes | InvestigationTaskSerializer | InvestigationTask |
| * | /api/v1/exports/ | CRUD exports | Yes | ExportSerializer | Export |
| * | /api/v1/audit-logs/ | CRUD audit logs | Yes | AuditLogSerializer | AuditLog |
| * | /api/v1/diseases/ | CRUD diseases | Yes | DiseaseSerializer | Disease |
| * | /api/v1/locations/ | CRUD locations | Yes | LocationSerializer | Location |
| GET | /api/v1/dashboard/summary/ | Summary KPIs | Yes | — | — |
| GET | /api/v1/dashboard/cases-timeseries/ | Daily cases series | Yes | — | — |
| GET | /api/v1/dashboard/anomalies/ | Anomaly detection | Yes | — | — |
| GET | /api/v1/dashboard/forecast/ | ARIMA forecast | Yes | — | — |
| GET | /api/v1/dashboard/top-diseases/ | Top diseases | Yes | — | — |
| GET | /api/v1/dashboard/map-points/ | Map points | Yes | — | — |
| GET | /api/v1/dashboard/recent-alerts/ | Recent alerts | Yes | — | — |
| GET | /api/v1/dashboard/recent-investigations/ | Recent investigations | Yes | — | — |
| GET | /api/v1/dashboard/situation-overview/ | Situation overview | Yes | — | — |
| GET | /api/v1/dashboard/detection-metrics/ | Detection metrics | Yes | — | — |
| GET | /api/v1/dashboard/data-quality/ | Data quality | Yes | — | — |
| POST | /api/v1/dashboard/evaluate/ | Trigger evaluation (role-restricted) | Yes | — | — |

---

## SECTION 6 — Request Lifecycle (Concrete Example)

**Example: GET /api/v1/reporting/reports/?status=1**

1. **Client** sends GET with `Authorization: Token <key>` (or session cookie).
2. **config.urls** matches `api/v1/` → `config.api_router`.
3. **api_router** routes `reporting/reports/` to `ReportViewSet` (basename `report`).
4. **ReportViewSet** (reporting.views): `queryset = Report.objects.select_related("disease", "location", "reported_by", "status")`; no `get_queryset` override that filters by user for list. DRF applies filters from query params via `filterset_fields = ["disease", "location", "status", "reported_by", "report_source"]` (if django-filter is installed and enabled; otherwise filtering may be via custom logic or not applied — filterset not explicitly configured in ViewSet beyond the attribute). So for this example, `status=1` would filter by status id if filterset is active.
5. **Authentication**: `IsAuthenticated` — request.user must be authenticated.
6. **Serializer**: `ReportSerializer` (ModelSerializer, `fields = "__all__"`) serializes each Report (with nested FK ids as in default ModelSerializer).
7. **Model**: Report; DB read via queryset.
8. **Response**: JSON list of report objects (status, disease, location, reported_by, etc. as IDs unless nested serializers are added).

**Example: GET /api/v1/dashboard/summary/?start_date=2026-01-01&end_date=2026-01-31**

1. **Client** sends GET with auth.
2. **config.urls** → `api/v1/dashboard/` → `dashboard.api_urls` → `dashboard_summary`.
3. **dashboard.api.dashboard_summary**: `@api_view(["GET"])`; `check_dashboard_access(request.user)` (403 if user lacks dashboard role); parses `start_date`, `end_date`, `disease_id`, `location_id` from query params; calls `get_summary_metrics(...)` from `dashboard.services`.
4. **dashboard.services.get_summary_metrics**: Builds date range, filters Report and Alert querysets, aggregates (Sum case_count, counts); returns dict `cases_7d`, `cases_30d`, `reports_7d`, `active_alerts`.
5. **Response**: `Response(metrics)` returns that dict as JSON.

---

## SECTION 7 — Core Data Model Overview

- **User** (users): Email as USERNAME_FIELD, full_name, phone, created_at. No username. Related: submitted_reports, user_roles, reviewed_duplicate_flags, alert_notes, assigned_tasks, created_tasks, exports, audit_logs.

- **Role** (access_control): role_name (unique), description. Related: user_assignments (UserRole), escalations_from, escalations_to.

- **UserRole** (access_control): user (FK), role (FK), assigned_at. UniqueConstraint (user, role).

- **ReportStatus** (reporting): status_name (unique), description, created_at. Related: reports.

- **Report** (reporting): disease (FK reference_data.Disease), location (FK reference_data.Location), reported_by (FK User), observed_at, submitted_at, case_notes, status (FK ReportStatus), report_source (char, nullable), case_count, sex, age_group, severity_level (all with choices). Indexes on disease/location/observed_at, status, reported_by, sex, age_group. Related: duplicate_flags. Properties: is_draft, is_submitted (by status_name).

- **DuplicateFlag** (reporting): report (FK), flagged_reason, flagged_at, reviewed_by (FK User, nullable), review_outcome, reviewed_at.

- **Disease** (reference_data): disease_name (unique), is_active, created_at. Related: reports, alerts, baseline_metrics, trend_metrics.

- **Location** (reference_data): district_name, area_name (nullable), latitude, longitude (nullable), is_active, created_at. Related: reports, alerts, baseline_metrics, trend_metrics.

- **AlertStatus** (alerts): status_name (unique), description, created_at. Related: alerts.

- **Alert** (alerts): disease (FK), location (FK), period_start, period_end, baseline_value, observed_value, threshold_rule, severity_level, status (FK AlertStatus), created_at. Related: notes, escalations, investigation_tasks.

- **AlertNote** (alerts): alert (FK), noted_by (FK User), note_text, noted_at.

- **AlertEscalation** (alerts): alert (FK), escalated_from_role (FK Role), escalated_to_role (FK Role), escalation_reason, escalated_at.

- **BaselineMetric** (analytics): disease (FK), location (FK), period_type, baseline_method, baseline_value, computed_for_start, computed_for_end, computed_at.

- **TrendMetric** (analytics): disease (FK), location (FK), period_start, period_end, total_cases, moving_avg, pct_change, computed_at.

- **InvestigationTask** (investigations): alert (FK), assigned_to (FK User, nullable), assigned_by (FK User, nullable), due_at, task_status (OPEN/IN_PROGRESS/COMPLETED), outcome, created_at, updated_at.

- **Export** (exports): export_type (CSV/PDF), generated_by (FK User, nullable), filters_used (JSON), generated_at, file_path, status (PENDING/COMPLETED/FAILED).

- **AuditLog** (exports): actor_user (FK User, nullable), action_type, entity_type, entity_id, timestamp, details (JSON).

---

## SECTION 8 — Background Jobs / Async

- **Where configured**: `config.celery_app` (Celery app); broker and result backend from `config.settings.base` (`REDIS_URL`). Beat: `CELERY_BEAT_SCHEDULER = django_celery_beat.schedulers.DatabaseScheduler`. Tasks discovered via `app.autodiscover_tasks()` from installed Django apps.

- **What exists**: `disease_surveillance_dashboard.users.tasks.get_users_count` — `@shared_task` that returns `User.objects.count()` (documented as a demo task). No other Celery tasks found in the repo (e.g. no export generation task).

- **How triggered**: `get_users_count` can be called programmatically or from beat if a schedule is added in Django admin for django_celery_beat. No automatic schedule for it in code.

So: a background job system (Celery + Beat) is configured; one demo task exists; no production async workflows (e.g. export generation) are implemented.

---

## SECTION 9 — Configuration & Local Run (Backend Only)

- **Dependencies**: Project uses **uv** (pyproject.toml + uv.lock). No requirements.txt in repo. Install with `uv sync` (or equivalent) at repo root. Production Docker uses `uv sync` with pyproject.toml/uv.lock.

- **Migrations**: `uv run python manage.py migrate` (run from repo root where manage.py lives). Optional: `uv run python manage.py migrate reporting` etc. for a single app.

- **Superuser**: `uv run python manage.py createsuperuser`. Email is the login field.

- **Run server**: `uv run python manage.py runserver` (from repo root). WSGI production: point WSGI server at `config.wsgi.application`.

- **Tests**: Pytest with Django: `uv run pytest` (uses `--ds=config.settings.test` from pyproject). Coverage: `uv run coverage run -m pytest`, then `uv run coverage html`. CI runs tests via Docker: `docker compose -f docker-compose.local.yml run django pytest`.

- **Seed reference data**: `uv run python manage.py seed_reference_data` (idempotent Disease and Location seeding). ReportStatus DRAFT/SUBMITTED are created in reporting migration or on first use in views via `get_or_create`.

---

## SECTION 10 — Key Code Snippets (3–4 Maximum)

**1. config/urls.py — API and web routing**

```python
# API URLS
urlpatterns += [
    path("api/v1/", include("config.api_router")),
    path("api/v1/dashboard/", include("disease_surveillance_dashboard.dashboard.api_urls")),
    path("api/auth-token/", obtain_auth_token, name="obtain_auth_token"),
    path("api/schema/", SpectacularAPIView.as_view(), name="api-schema"),
    path("api/docs/", SpectacularSwaggerView.as_view(url_name="api-schema"), name="api-docs"),
]
```

All REST and dashboard API entry points are under `/api/`; v1 router and dashboard are separate includes. Token auth endpoint is at `/api/auth-token/`.

---

**2. disease_surveillance_dashboard/reporting/views.py — ReportViewSet (API) and status helper**

```python
def _get_status(name: str) -> ReportStatus:
    status, _ = ReportStatus.objects.get_or_create(
        status_name=name,
        defaults={"description": _STATUS_DESCRIPTIONS.get(name, "")},
    )
    return status

class ReportViewSet(viewsets.ModelViewSet):
    queryset = Report.objects.select_related(
        "disease", "location", "reported_by", "status",
    )
    serializer_class = ReportSerializer
    filterset_fields = ["disease", "location", "status", "reported_by", "report_source"]
    search_fields = ["case_notes"]
```

Report API uses the same Report model as the web draft/submit flow. Status rows (e.g. DRAFT, SUBMITTED) are created on demand so the web flow does not depend on a specific migration having been run.

---

**3. disease_surveillance_dashboard/reporting/serializers.py — ReportSerializer**

```python
class ReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = "__all__"
        read_only_fields = ["submitted_at"]
```

API exposes all Report fields; `submitted_at` is read-only so clients cannot override it. Flutter (or any client) must send the same field set the backend expects (disease, location, reported_by, observed_at, status, case_count, sex, age_group, severity_level, report_source, case_notes, etc.) and will receive the same shape in responses.

---

**4. config/settings/base.py — DRF and auth**

```python
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework.authentication.SessionAuthentication",
        "rest_framework.authentication.TokenAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": ("rest_framework.permissions.IsAuthenticated",),
    "DEFAULT_SCHEMA_CLASS": "drf_spectacular.openapi.AutoSchema",
}
```

Every API request must be authenticated (session or token); default permission is IsAuthenticated. Schema is generated for OpenAPI/Swagger; Flutter can rely on token in `Authorization: Token <token>` for all `/api/` calls.

---

## SECTION 11 — Backend Risk Assessment

- **Dead imports**: Not fully audited; none called out as blocking.

- **Incomplete TODOs**: `config.settings.base`: CELERY_TASK_TIME_LIMIT / CELERY_TASK_SOFT_TIME_LIMIT left with “set to whatever value is adequate”. `users.tests.test_views`: TODO about pytest-django scope. `pyproject.toml` djlint: “TODO: remove T002 when fixed”.

- **Missing error handling**: Dashboard API parses query params (e.g. disease_id, location_id) with try/except and falls back to None; invalid dates may return None and be passed to services (service layer may assume valid range). ReportViewSet does not override create/update to enforce “only owner can edit” or “submitted is read-only” at API level; web views enforce draft/edit and ownership, but API allows full CRUD for any authenticated user on any report if they know the ID.

- **Inconsistent routing**: Web report edit is `/reports/<pk>/edit/`; API report update is `PUT/PATCH /api/v1/reporting/reports/<pk>/`. Naming is consistent within each layer but differs between web and API.

- **Security**: (1) Report API does not restrict list/detail/update to owner or to draft-only for updates; a mobile or other client could change another user’s report or a submitted report. (2) Dashboard endpoints use role checks (`user_can_access_dashboard`); ViewSets rely only on IsAuthenticated, so any authenticated user can hit e.g. alerts, investigations, exports. (3) Token auth: tokens do not expire unless custom logic or third-party package is added (not present in repo). (4) CORS: `CORS_URLS_REGEX = r"^/api/.*$"` — CORS is applied to API; exact origins depend on deployment (not in repo).

- **Runtime**: If django-filter is not in INSTALLED_APPS or not applied to the router, ViewSet `filterset_fields` may have no effect and list endpoints could return unfiltered querysets. Dependency list in pyproject does not show django-filter; filterset behavior should be verified.

---

## SECTION 12 — Preparing for Flutter Refactor

- **Stable endpoints for frontend**:  
  All ViewSets under `/api/v1/` and all dashboard endpoints under `/api/v1/dashboard/` are implemented and usable. Auth is stable: `POST /api/auth-token/` with credentials → token; then `Authorization: Token <token>` on every request. OpenAPI schema at `/api/schema/` reflects the current API.

- **Response shapes Flutter should mirror**:  
  - **Reports**: ReportSerializer returns all Report fields (ids for disease, location, reported_by, status). Client should treat `submitted_at` as read-only.  
  - **Users/me**: UserSerializer exposes `name` (from full_name) and `url` (hyperlinked to user detail).  
  - **Dashboard**: Summary, cases-timeseries, top-diseases, map-points, recent-alerts, recent-investigations, situation-overview, detection-metrics, data-quality return service-layer dicts (structure in dashboard.services and api responses). Flutter should match these JSON shapes (and optional query params like start_date, end_date, disease_id, location_id, limit).  
  - **Reference data**: Disease and Location list/detail match ModelSerializer `__all__` (id, disease_name, is_active, created_at; id, district_name, area_name, latitude, longitude, is_active, created_at).

- **Required vs optional**:  
  For report create/update via API: required fields follow Report model (disease, location, reported_by, observed_at, status, etc.); optional/nullable in model (e.g. case_notes, report_source) can be omitted or null. Dashboard GET params are generally optional (defaults in services). POST /api/v1/dashboard/evaluate/ requires `trend_metric_id` in body. POST /api/auth-token/ requires username (email) and password.

- **Mock data**:  
  Mock data used in Flutter (or in tests) should match: (1) Report status names (e.g. DRAFT, SUBMITTED) and FK ids consistent with reference_data and users; (2) User with email and optional full_name; (3) Dashboard payloads (e.g. summary: cases_7d, cases_30d, reports_7d, active_alerts; time-series arrays as returned by services). Using the same OpenAPI schema or copying response samples from the live API/docs will keep mocks aligned with the backend.

---

*End of document. No code was modified; all statements are based on the repository as inspected.*
