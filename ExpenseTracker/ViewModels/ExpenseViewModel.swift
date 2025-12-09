import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var selectedCategory: Category?
    @Published var selectedDate: Date?
    @Published var totalExpenses: Double = 0
    @Published var expensesByCategory: [Category: Double] = [:]

    private let repository: ExpenseRepositoryProtocol

    init(repository: ExpenseRepositoryProtocol = ExpenseRepository()) {
        self.repository = repository
        loadExpenses()
    }

    func loadExpenses() {
        expenses = repository.getExpenses()
        calculateTotals()
    }

    func addExpense(_ expense: Expense) {
        repository.addExpense(expense)
        loadExpenses()
    }

    func updateExpense(_ expense: Expense) {
        repository.updateExpense(expense)
        loadExpenses()
    }

    func deleteExpense(_ expense: Expense) {
        repository.deleteExpense(withId: expense.id)
        loadExpenses()
    }

    func filteredExpenses() -> [Expense] {
        var filtered = expenses

        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }

        if let date = selectedDate {
            filtered = filtered.filter {
                Calendar.current.isDate($0.date, inSameDayAs: date)
            }
        }

        return filtered.sorted { $0.date > $1.date }
    }

    func getExpenses(for month: Date) -> [Expense] {
        return expenses.filter {
            Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month)
        }
    }

    func getTotalExpenses(for category: Category, in month: Date) -> Double {
        return getExpenses(for: month)
            .filter { $0.category == category }
            .reduce(0) { $0 + $1.amount }
    }

    private func calculateTotals() {
        totalExpenses = expenses.reduce(0) { $0 + $1.amount }

        expensesByCategory = Category.allCases.reduce(into: [:]) { result, category in
            result[category] = expenses
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.amount }
        }
    }

    func getMonthlyTotal() -> Double {
        let now = Date()
        return getExpenses(for: now).reduce(0) { $0 + $1.amount }
    }

    func clearFilters() {
        selectedCategory = nil
        selectedDate = nil
    }
}
