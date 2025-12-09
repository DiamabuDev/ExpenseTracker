import XCTest
@testable import ExpenseTracker

final class ExpenseViewModelTests: XCTestCase {
    var sut: ExpenseViewModel!
    var mockRepository: MockExpenseRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockExpenseRepository()
        sut = ExpenseViewModel(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testLoadExpenses() {
        // Given
        let expense1 = Expense(amount: 50, category: .food)
        let expense2 = Expense(amount: 100, category: .transport)
        mockRepository.expenses = [expense1, expense2]

        // When
        sut.loadExpenses()

        // Then
        XCTAssertEqual(sut.expenses.count, 2)
        XCTAssertEqual(sut.totalExpenses, 150)
    }

    func testAddExpense() {
        // Given
        let expense = Expense(amount: 50, category: .food)

        // When
        sut.addExpense(expense)

        // Then
        XCTAssertEqual(sut.expenses.count, 1)
        XCTAssertEqual(sut.expenses.first?.amount, 50)
        XCTAssertEqual(mockRepository.addExpenseCalled, true)
    }

    func testUpdateExpense() {
        // Given
        let expense = Expense(amount: 50, category: .food)
        sut.addExpense(expense)

        // When
        let updatedExpense = Expense(id: expense.id, amount: 75, category: .food)
        sut.updateExpense(updatedExpense)

        // Then
        XCTAssertEqual(mockRepository.updateExpenseCalled, true)
    }

    func testDeleteExpense() {
        // Given
        let expense = Expense(amount: 50, category: .food)
        sut.addExpense(expense)

        // When
        sut.deleteExpense(expense)

        // Then
        XCTAssertEqual(mockRepository.deleteExpenseCalled, true)
    }

    func testFilteredExpensesByCategory() {
        // Given
        let foodExpense = Expense(amount: 50, category: .food)
        let transportExpense = Expense(amount: 100, category: .transport)
        mockRepository.expenses = [foodExpense, transportExpense]
        sut.loadExpenses()

        // When
        sut.selectedCategory = .food

        // Then
        let filtered = sut.filteredExpenses()
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.category, .food)
    }

    func testGetMonthlyTotal() {
        // Given
        let now = Date()
        let thisMonthExpense = Expense(amount: 50, category: .food, date: now)
        let lastMonthExpense = Expense(amount: 100, category: .transport, date: Calendar.current.date(byAdding: .month, value: -1, to: now)!)
        mockRepository.expenses = [thisMonthExpense, lastMonthExpense]
        sut.loadExpenses()

        // When
        let monthlyTotal = sut.getMonthlyTotal()

        // Then
        XCTAssertEqual(monthlyTotal, 50)
    }

    func testGetTotalExpensesForCategory() {
        // Given
        let foodExpense1 = Expense(amount: 50, category: .food)
        let foodExpense2 = Expense(amount: 30, category: .food)
        let transportExpense = Expense(amount: 100, category: .transport)
        mockRepository.expenses = [foodExpense1, foodExpense2, transportExpense]
        sut.loadExpenses()

        // When
        let total = sut.getTotalExpenses(for: .food, in: Date())

        // Then
        XCTAssertEqual(total, 80)
    }

    func testExpensesByCategory() {
        // Given
        let foodExpense = Expense(amount: 50, category: .food)
        let transportExpense = Expense(amount: 100, category: .transport)
        mockRepository.expenses = [foodExpense, transportExpense]

        // When
        sut.loadExpenses()

        // Then
        XCTAssertEqual(sut.expensesByCategory[.food], 50)
        XCTAssertEqual(sut.expensesByCategory[.transport], 100)
    }

    func testClearFilters() {
        // Given
        sut.selectedCategory = .food
        sut.selectedDate = Date()

        // When
        sut.clearFilters()

        // Then
        XCTAssertNil(sut.selectedCategory)
        XCTAssertNil(sut.selectedDate)
    }
}

// MARK: - Mock Repository

class MockExpenseRepository: ExpenseRepositoryProtocol {
    var expenses: [Expense] = []
    var addExpenseCalled = false
    var updateExpenseCalled = false
    var deleteExpenseCalled = false

    func getExpenses() -> [Expense] {
        return expenses
    }

    func addExpense(_ expense: Expense) {
        addExpenseCalled = true
        expenses.append(expense)
    }

    func updateExpense(_ expense: Expense) {
        updateExpenseCalled = true
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }

    func deleteExpense(withId id: UUID) {
        deleteExpenseCalled = true
        expenses.removeAll { $0.id == id }
    }

    func getExpenses(for category: Category) -> [Expense] {
        return expenses.filter { $0.category == category }
    }

    func getExpenses(for date: Date) -> [Expense] {
        return expenses.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}
