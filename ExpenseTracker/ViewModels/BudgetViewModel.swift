import Foundation
import Combine

class BudgetViewModel: ObservableObject {
    @Published var budgets: [Budget] = []

    private let repository: BudgetRepositoryProtocol
    private let expenseViewModel: ExpenseViewModel

    init(repository: BudgetRepositoryProtocol = BudgetRepository(), expenseViewModel: ExpenseViewModel) {
        self.repository = repository
        self.expenseViewModel = expenseViewModel
        loadBudgets()
    }

    func loadBudgets() {
        budgets = repository.getBudgets()
    }

    func addBudget(_ budget: Budget) {
        repository.addBudget(budget)
        loadBudgets()
    }

    func updateBudget(_ budget: Budget) {
        repository.updateBudget(budget)
        loadBudgets()
    }

    func deleteBudget(_ budget: Budget) {
        repository.deleteBudget(withId: budget.id)
        loadBudgets()
    }

    func getBudget(for category: Category, month: Date = Date()) -> Budget? {
        return budgets.first {
            $0.category == category &&
            Calendar.current.isDate($0.month, equalTo: month, toGranularity: .month)
        }
    }

    func getRemainingBudget(for category: Category, month: Date = Date()) -> Double {
        guard let budget = getBudget(for: category, month: month) else {
            return 0
        }

        let spent = expenseViewModel.getTotalExpenses(for: category, in: month)
        return budget.limit - spent
    }

    func getBudgetProgress(for category: Category, month: Date = Date()) -> Double {
        guard let budget = getBudget(for: category, month: month) else {
            return 0
        }

        let spent = expenseViewModel.getTotalExpenses(for: category, in: month)
        return min(spent / budget.limit, 1.0)
    }

    func isOverBudget(for category: Category, month: Date = Date()) -> Bool {
        return getRemainingBudget(for: category, month: month) < 0
    }

    func getCurrentMonthBudgets() -> [Budget] {
        let now = Date()
        return budgets.filter {
            Calendar.current.isDate($0.month, equalTo: now, toGranularity: .month)
        }
    }
}
