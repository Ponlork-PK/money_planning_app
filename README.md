# 💰 Money Planning App

A modern, cross-platform personal finance management application built with **Flutter** and powered by **Supabase**. Track income and expenses, manage loans, generate financial reports, and stay on top of your money — all in one clean, intuitive interface.

---

## ✨ Features

### 📊 Dashboard
- At-a-glance summary of **balance**, **income**, and **expense**
- Today's recent transactions with pull-to-refresh
- Quick-access button to add new transactions

### 💸 Transaction Management
- Create, view, edit, and delete income/expense transactions
- Categorize transactions with custom categories
- Assign payment methods (auto-created if new)
- Full-text search by item name, note, or exact amount
- Multi-currency support (**USD** / **KHR**)

### 🏦 Loan Tracker
- Track loans from **banks**, **microfinance**, and **personal/family** lenders
- Auto-generated payment schedules with interest calculations
- Mark individual payments as paid
- Early settlement support
- Filter loans by lender type
- Visual progress indicator for repayment

### 📈 Reports & Analytics
- Income vs. expense comparison with animated bar charts
- Filter by period: **daily**, **weekly**, or **monthly**
- Top 5 transactions by amount
- Spending breakdown by category
- **Export to PDF** — full financial reports with summary tables, category breakdowns, and transaction details

### ⚙️ Settings & Preferences
- Default currency selection (USD / KHR)
- 🌙 Dark mode / ☀️ Light mode toggle
- 🌐 Multi-language support (**English** & **ខ្មែរ Khmer**)
- Notification preferences
- Secure logout with confirmation

### 🔐 Authentication
- Email & password authentication via **Supabase Auth**
- Persistent login sessions with **SharedPreferences**
- Per-user data isolation (Row Level Security)

### ⚡ Real-Time Sync
- **Supabase Realtime** subscriptions on transactions, loans, and loan payments
- All screens auto-refresh when data changes from any device

---

## 🏗️ Architecture

The project follows a clean **MVC-style** architecture using the **GetX** ecosystem for state management, routing, and dependency injection.

```
lib/
├── config/              # Environment configuration (.env loader)
├── controllers/         # Business logic & state management (GetX)
│   ├── loan_controller/ # Loan-specific controllers
│   └── settings_controller/
├── models/              # Data models (Dashboard, Transaction, Loan, Category, Report)
├── screens/             # UI screens organized by feature
│   ├── dashboard/
│   ├── home/
│   ├── loans/
│   ├── login/
│   ├── report/
│   ├── settings/
│   └── transactions/
├── services/            # API service (Supabase), Realtime service, PDF generation
├── utils/               # Constants, colors, themes, routes, helpers, i18n
├── widgets/             # Reusable UI components
└── main.dart            # App entry point & initialization
```

---

## 🛠️ Tech Stack

| Layer            | Technology                                                       |
| ---------------- | ---------------------------------------------------------------- |
| **Framework**    | Flutter 3.6+ (Dart)                                              |
| **State Mgmt**   | [GetX](https://pub.dev/packages/get)                            |
| **Backend**      | [Supabase](https://supabase.com) (PostgreSQL + Auth + Realtime) |
| **Charts**       | [fl_chart](https://pub.dev/packages/fl_chart)                   |
| **PDF Export**   | [pdf](https://pub.dev/packages/pdf) + [printing](https://pub.dev/packages/printing) |
| **HTTP**         | [http](https://pub.dev/packages/http)                           |
| **Date Picker**  | [calendar_date_picker2](https://pub.dev/packages/calendar_date_picker2) |
| **Connectivity** | [connectivity_plus](https://pub.dev/packages/connectivity_plus) |
| **Env Config**   | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)       |
| **Storage**      | [shared_preferences](https://pub.dev/packages/shared_preferences) |

---

## 📋 Prerequisites

- **Flutter SDK** ≥ 3.6.0
- **Dart SDK** ≥ 3.6.0
- A **Supabase** project with the required tables and RPC functions
- **Xcode** (for iOS) or **Android Studio** (for Android)

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/money_planning_app.git
cd money_planning_app
```

### 2. Configure Environment Variables

Create a `.env` file in the project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_KEY=your-service-key
```

> **⚠️ Important:** Never commit the `.env` file to version control. Ensure it is listed in your `.gitignore`.

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

---

## 🗄️ Database Schema

The app expects the following tables in your Supabase project:

| Table              | Description                          |
| ------------------ | ------------------------------------ |
| `transactions`     | Income and expense records           |
| `categories`       | User-defined transaction categories  |
| `payment_methods`  | Payment method labels (auto-created) |
| `loans`            | Loan records with terms and rates    |
| `loan_payments`    | Scheduled loan payment installments  |

Additionally, a Supabase RPC function `get_dashboard_summary` is used to compute aggregated balance, income, and expense totals.

> **💡 Tip:** Enable **Row Level Security (RLS)** on all tables and scope policies to `auth.uid()` to ensure per-user data isolation.

---

## 🌍 Localization

The app supports two languages out of the box:

| Language | Code  | Fallback |
| -------- | ----- | -------- |
| English  | `en`  |          |
| Khmer    | `km`  | ✅        |

Translations are managed via GetX's `Translations` class in [`lib/utils/language.dart`](lib/utils/language.dart). To add a new language, extend the `AppLanguages` enum and provide the corresponding translation map.

---

## 🎨 Theming

The app ships with fully polished **Light** and **Dark** themes using Material 3 design tokens. Themes are defined in [`lib/utils/theme.dart`](lib/utils/theme.dart) and can be toggled at runtime from Settings.

---

## 📁 Key Files

| File | Purpose |
| ---- | ------- |
| [`lib/main.dart`](lib/main.dart) | App bootstrap, Supabase init, theme & locale setup |
| [`lib/services/api_service.dart`](lib/services/api_service.dart) | Singleton Supabase client — all CRUD operations |
| [`lib/services/realtime_service.dart`](lib/services/realtime_service.dart) | Realtime subscriptions & listener management |
| [`lib/services/report_pdf_service.dart`](lib/services/report_pdf_service.dart) | PDF report generation |
| [`lib/config/environment.dart`](lib/config/environment.dart) | Reads `.env` variables for Supabase credentials |
| [`lib/utils/app_routes.dart`](lib/utils/app_routes.dart) | Route definitions (GetX named routing) |
| [`lib/utils/theme.dart`](lib/utils/theme.dart) | Light & Dark theme definitions |
| [`lib/utils/base_constants.dart`](lib/utils/base_constants.dart) | App-wide constants & table names |

---

## 🤝 Contributing

Contributions are welcome! To get started:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/your-feature`)
3. **Commit** your changes (`git commit -m "Add your feature"`)
4. **Push** to the branch (`git push origin feature/your-feature`)
5. **Open** a Pull Request

Please ensure your code follows the existing project structure and passes `flutter analyze` with no issues.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

<p align="center">
  Built with ❤️ using Flutter & Supabase
</p>
