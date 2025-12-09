# Expense Tracker

A modern iOS expense tracking application built with SwiftUI following the MVVM architecture pattern.

## Features

- **Add/Edit/Delete Expenses** - Full CRUD operations for expense management
- **Categories & Tags** - Organize expenses with predefined categories and custom tags
- **Budget Tracking** - Set monthly budgets and monitor spending limits
- **Charts & Analytics** - Visual reports and spending insights
- **Filters** - Filter expenses by category and date
- **Native iOS Design** - SwiftUI-based interface with modern design patterns

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern:

### Models
- `Expense.swift` - Core expense data model
- `Category.swift` - Expense categories with colors and icons
- `Budget.swift` - Budget tracking model

### Views
- `ContentView.swift` - Main tab view container
- `HomeView.swift` - Dashboard with summary and recent expenses
- `ExpenseListView.swift` - List of all expenses with filtering
- `AddExpenseView.swift` - Form to create new expenses
- `EditExpenseView.swift` - Form to edit existing expenses
- `ExpenseDetailView.swift` - Detailed view of a single expense
- `BudgetView.swift` - Budget management and tracking
- `AnalyticsView.swift` - Charts and spending analytics
- Supporting views: `ExpenseRowView`, `CategoryRowView`, `FilterView`

### ViewModels
- `ExpenseViewModel.swift` - Manages expense state and business logic
- `BudgetViewModel.swift` - Manages budget state and calculations

### Services
- `ExpenseRepository.swift` - Data persistence for expenses
- `BudgetRepository.swift` - Data persistence for budgets

## Unit Testing

The project includes comprehensive unit tests for:
- Models (Codable, Equatable)
- ViewModels (business logic, filtering, calculations)
- Repository protocols (CRUD operations)

### Test Files
- `ModelTests.swift` - Tests for data models
- `ExpenseViewModelTests.swift` - Tests for expense view model
- `BudgetViewModelTests.swift` - Tests for budget view model

### Running Tests
1. Open the project in Xcode
2. Press `Cmd + U` to run all tests
3. View test results in the Test Navigator

## Tech Stack

- **iOS 17+**
- **SwiftUI** - Declarative UI framework
- **Combine** - Reactive programming
- **Swift Charts** - Native charting framework
- **UserDefaults** - Local data persistence
- **XCTest** - Unit testing framework

## Project Structure

```
ExpenseTracker/
├── ExpenseTracker/
│   ├── Models/
│   │   ├── Expense.swift
│   │   ├── Category.swift
│   │   └── Budget.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── HomeView.swift
│   │   ├── ExpenseListView.swift
│   │   ├── AddExpenseView.swift
│   │   ├── EditExpenseView.swift
│   │   ├── ExpenseDetailView.swift
│   │   ├── BudgetView.swift
│   │   ├── AnalyticsView.swift
│   │   └── ... (supporting views)
│   ├── ViewModels/
│   │   ├── ExpenseViewModel.swift
│   │   └── BudgetViewModel.swift
│   ├── Services/
│   │   ├── ExpenseRepository.swift
│   │   └── BudgetRepository.swift
│   └── ExpenseTrackerApp.swift
└── ExpenseTrackerTests/
    ├── ModelTests.swift
    ├── ExpenseViewModelTests.swift
    └── BudgetViewModelTests.swift
```

## Getting Started

### Prerequisites
- macOS 14+ (Sonoma or later)
- Xcode 15+
- iOS 17+ device or simulator

### Installation

1. Clone the repository
2. Open `ExpenseTracker.xcodeproj` in Xcode
3. Select your target device/simulator
4. Press `Cmd + R` to build and run

## Categories

The app supports 8 expense categories:
- Food
- Transport
- Shopping
- Entertainment
- Bills
- Health
- Education
- Other

## Future Enhancements

- [ ] iCloud sync
- [ ] Export to CSV/PDF
- [ ] Recurring expenses
- [ ] Multiple currencies
- [ ] Widgets
- [ ] Dark mode support
- [ ] Face ID/Touch ID protection

## License

This project is open source and available for personal and educational use.

## Author

Diana Maldonado
