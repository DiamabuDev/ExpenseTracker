import XCTest
@testable import ExpenseTracker

final class BudgetViewModelTests: XCTestCase {
    var sut: BudgetViewModel!
    var mockRepository: MockBudgetRepository!
    var expenseViewModel: ExpenseViewModel!
    var mockExpenseRepository: MockExpenseRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockBudgetRepository()
        mockExpenseRepository = MockExpenseRepository()
        expenseViewModel = ExpenseViewModel(repository: mockExpenseRepository)
        sut = BudgetViewModel(repository: mockRepository, expenseViewModel: expenseViewModel)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        expenseViewModel = nil
        mockExpenseRepository = nil
        super.tearDown()
    }

    func testLoadBudgets() {
        // Given
        let budget1 = Budget(category: .food, limit: 500)
        let budget2 = Budget(category: .transport, limit: 300)
        mockRepository.budgets = [budget1, budget2]

        // When
        sut.loadBudgets()

        // Then
        XCTAssertEqual(sut.budgets.count, 2)
    }

    func testAddBudget() {
        // Given
        let budget = Budget(category: .food, limit: 500)

        // When
        sut.addBudget(budget)

        // Then
        XCTAssertEqual(sut.budgets.count, 1)
        XCTAssertEqual(mockRepository.addBudgetCalled, true)
    }

    func testUpdateBudget() {
        // Given
        let budget = Budget(category: .food, limit: 500)
        sut.addBudget(budget)

        // When
        let updatedBudget = Budget(id: budget.id, category: .food, limit: 600)
        sut.updateBudget(updatedBudget)

        // Then
        XCTAssertEqual(mockRepository.updateBudgetCalled, true)
    }

    func testDeleteBudget() {
        // Given
        let budget = Budget(category: .food, limit: 500)
        sut.addBudget(budget)

        // When
        sut.deleteBudget(budget)

        // Then
        XCTAssertEqual(mockRepository.deleteBudgetCalled, true)
    }

    func testGetBudget() {
        // Given
        let budget = Budget(category: .food, limit: 500, month: Date())
        mockRepository.budgets = [budget]
        sut.loadBudgets()

        // When
        let foundBudget = sut.getBudget(for: .food)

        // Then
        XCTAssertNotNil(foundBudget)
        XCTAssertEqual(foundBudget?.limit, 500)
    }

    func testGetRemainingBudget() {
        // Given
        let budget = Budget(category: .food, limit: 500, month: Date())
        mockRepository.budgets = [budget]
        sut.loadBudgets()

        let expense = Expense(amount: 150, category: .food, date: Date())
        mockExpenseRepository.expenses = [expense]
        expenseViewModel.loadExpenses()

        // When
        let remaining = sut.getRemainingBudget(for: .food)

        // Then
        XCTAssertEqual(remaining, 350)
    }

    func testGetBudgetProgress() {
        // Given
        let budget = Budget(category: .food, limit: 500, month: Date())
        mockRepository.budgets = [budget]
        sut.loadBudgets()

        let expense = Expense(amount: 250, category: .food, date: Date())
        mockExpenseRepository.expenses = [expense]
        expenseViewModel.loadExpenses()

        // When
        let progress = sut.getBudgetProgress(for: .food)

        // Then
        XCTAssertEqual(progress, 0.5, accuracy: 0.01)
    }

    func testIsOverBudget() {
        // Given
        let budget = Budget(category: .food, limit: 500, month: Date())
        mockRepository.budgets = [budget]
        sut.loadBudgets()

        let expense = Expense(amount: 600, category: .food, date: Date())
        mockExpenseRepository.expenses = [expense]
        expenseViewModel.loadExpenses()

        // When
        let isOver = sut.isOverBudget(for: .food)

        // Then
        XCTAssertTrue(isOver)
    }

    func testGetCurrentMonthBudgets() {
        // Given
        let now = Date()
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        let currentBudget = Budget(category: .food, limit: 500, month: now)
        let pastBudget = Budget(category: .transport, limit: 300, month: lastMonth)
        mockRepository.budgets = [currentBudget, pastBudget]
        sut.loadBudgets()

        // When
        let currentMonthBudgets = sut.getCurrentMonthBudgets()

        // Then
        XCTAssertEqual(currentMonthBudgets.count, 1)
        XCTAssertEqual(currentMonthBudgets.first?.category, .food)
    }
}

// MARK: - Mock Repository

class MockBudgetRepository: BudgetRepositoryProtocol {
    var budgets: [Budget] = []
    var addBudgetCalled = false
    var updateBudgetCalled = false
    var deleteBudgetCalled = false

    func getBudgets() -> [Budget] {
        return budgets
    }

    func addBudget(_ budget: Budget) {
        addBudgetCalled = true
        budgets.append(budget)
    }

    func updateBudget(_ budget: Budget) {
        updateBudgetCalled = true
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
        }
    }

    func deleteBudget(withId id: UUID) {
        deleteBudgetCalled = true
        budgets.removeAll { $0.id == id }
    }

    func getBudget(for category: Category, month: Date) -> Budget? {
        return budgets.first {
            $0.category == category &&
            Calendar.current.isDate($0.month, equalTo: month, toGranularity: .month)
        }
    }
}
