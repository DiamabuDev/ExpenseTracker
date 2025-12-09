import Foundation

protocol BudgetRepositoryProtocol {
    func getBudgets() -> [Budget]
    func addBudget(_ budget: Budget)
    func updateBudget(_ budget: Budget)
    func deleteBudget(withId id: UUID)
    func getBudget(for category: Category, month: Date) -> Budget?
}

class BudgetRepository: BudgetRepositoryProtocol {
    private let userDefaults = UserDefaults.standard
    private let budgetsKey = "budgets"

    func getBudgets() -> [Budget] {
        guard let data = userDefaults.data(forKey: budgetsKey),
              let budgets = try? JSONDecoder().decode([Budget].self, from: data) else {
            return []
        }
        return budgets
    }

    func addBudget(_ budget: Budget) {
        var budgets = getBudgets()
        budgets.append(budget)
        saveBudgets(budgets)
    }

    func updateBudget(_ budget: Budget) {
        var budgets = getBudgets()
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
            saveBudgets(budgets)
        }
    }

    func deleteBudget(withId id: UUID) {
        var budgets = getBudgets()
        budgets.removeAll { $0.id == id }
        saveBudgets(budgets)
    }

    func getBudget(for category: Category, month: Date) -> Budget? {
        return getBudgets().first {
            $0.category == category &&
            Calendar.current.isDate($0.month, equalTo: month, toGranularity: .month)
        }
    }

    private func saveBudgets(_ budgets: [Budget]) {
        if let data = try? JSONEncoder().encode(budgets) {
            userDefaults.set(data, forKey: budgetsKey)
        }
    }
}
