import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var selectedCategory: Category?
    @Published var selectedDate: Date?
    @Published var selectedMonth: Date = Date()
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

        // Filter by selected month
        filtered = filtered.filter {
            Calendar.current.isDate($0.date, equalTo: selectedMonth, toGranularity: .month)
        }

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
        let monthExpenses = getExpenses(for: selectedMonth)
        totalExpenses = monthExpenses.reduce(0) { $0 + $1.amount }

        expensesByCategory = Category.allCases.reduce(into: [:]) { result, category in
            result[category] = monthExpenses
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.amount }
        }
    }

    func getMonthlyTotal() -> Double {
        return getExpenses(for: selectedMonth).reduce(0) { $0 + $1.amount }
    }

    func goToPreviousMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = newMonth
            calculateTotals()
        }
    }

    func goToNextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = newMonth
            calculateTotals()
        }
    }

    func goToCurrentMonth() {
        selectedMonth = Date()
        calculateTotals()
    }

    var selectedMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }

    func clearFilters() {
        selectedCategory = nil
        selectedDate = nil
    }
}
