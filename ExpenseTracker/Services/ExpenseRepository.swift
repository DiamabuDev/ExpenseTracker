import Foundation

protocol ExpenseRepositoryProtocol {
    func getExpenses() -> [Expense]
    func addExpense(_ expense: Expense)
    func updateExpense(_ expense: Expense)
    func deleteExpense(withId id: UUID)
    func getExpenses(for category: Category) -> [Expense]
    func getExpenses(for date: Date) -> [Expense]
}

class ExpenseRepository: ExpenseRepositoryProtocol {
    private let userDefaults = UserDefaults.standard
    private let expensesKey = "expenses"

    func getExpenses() -> [Expense] {
        guard let data = userDefaults.data(forKey: expensesKey),
              let expenses = try? JSONDecoder().decode([Expense].self, from: data) else {
            return []
        }
        return expenses
    }

    func addExpense(_ expense: Expense) {
        var expenses = getExpenses()
        expenses.append(expense)
        saveExpenses(expenses)
    }

    func updateExpense(_ expense: Expense) {
        var expenses = getExpenses()
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            saveExpenses(expenses)
        }
    }

    func deleteExpense(withId id: UUID) {
        var expenses = getExpenses()
        expenses.removeAll { $0.id == id }
        saveExpenses(expenses)
    }

    func getExpenses(for category: Category) -> [Expense] {
        return getExpenses().filter { $0.category == category }
    }

    func getExpenses(for date: Date) -> [Expense] {
        return getExpenses().filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    private func saveExpenses(_ expenses: [Expense]) {
        if let data = try? JSONEncoder().encode(expenses) {
            userDefaults.set(data, forKey: expensesKey)
        }
    }
}
