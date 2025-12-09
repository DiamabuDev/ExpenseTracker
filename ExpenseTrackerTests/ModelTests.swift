import XCTest
@testable import ExpenseTracker

final class ModelTests: XCTestCase {

    // MARK: - Expense Tests

    func testExpenseInitialization() {
        // Given
        let id = UUID()
        let amount = 50.0
        let category = Category.food
        let date = Date()
        let note = "Lunch"
        let tags = ["dining", "work"]

        // When
        let expense = Expense(id: id, amount: amount, category: category, date: date, note: note, tags: tags)

        // Then
        XCTAssertEqual(expense.id, id)
        XCTAssertEqual(expense.amount, amount)
        XCTAssertEqual(expense.category, category)
        XCTAssertEqual(expense.date, date)
        XCTAssertEqual(expense.note, note)
        XCTAssertEqual(expense.tags, tags)
    }

    func testExpenseEquality() {
        // Given
        let id = UUID()
        let expense1 = Expense(id: id, amount: 50, category: .food)
        let expense2 = Expense(id: id, amount: 50, category: .food)

        // Then
        XCTAssertEqual(expense1, expense2)
    }

    func testExpenseCodable() throws {
        // Given
        let expense = Expense(amount: 50, category: .food, note: "Test")

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(expense)
        let decoder = JSONDecoder()
        let decodedExpense = try decoder.decode(Expense.self, from: data)

        // Then
        XCTAssertEqual(expense.amount, decodedExpense.amount)
        XCTAssertEqual(expense.category, decodedExpense.category)
        XCTAssertEqual(expense.note, decodedExpense.note)
    }

    // MARK: - Budget Tests

    func testBudgetInitialization() {
        // Given
        let id = UUID()
        let category = Category.food
        let limit = 500.0
        let month = Date()

        // When
        let budget = Budget(id: id, category: category, limit: limit, month: month)

        // Then
        XCTAssertEqual(budget.id, id)
        XCTAssertEqual(budget.category, category)
        XCTAssertEqual(budget.limit, limit)
        XCTAssertEqual(budget.month, month)
    }

    func testBudgetEquality() {
        // Given
        let id = UUID()
        let budget1 = Budget(id: id, category: .food, limit: 500)
        let budget2 = Budget(id: id, category: .food, limit: 500)

        // Then
        XCTAssertEqual(budget1, budget2)
    }

    func testBudgetMonthYear() {
        // Given
        let dateComponents = DateComponents(year: 2024, month: 12, day: 1)
        let date = Calendar.current.date(from: dateComponents)!
        let budget = Budget(category: .food, limit: 500, month: date)

        // When
        let monthYear = budget.monthYear

        // Then
        XCTAssertTrue(monthYear.contains("December"))
        XCTAssertTrue(monthYear.contains("2024"))
    }

    func testBudgetCodable() throws {
        // Given
        let budget = Budget(category: .food, limit: 500)

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(budget)
        let decoder = JSONDecoder()
        let decodedBudget = try decoder.decode(Budget.self, from: data)

        // Then
        XCTAssertEqual(budget.category, decodedBudget.category)
        XCTAssertEqual(budget.limit, decodedBudget.limit)
    }

    // MARK: - Category Tests

    func testCategoryIcons() {
        // Test that all categories have icons
        for category in Category.allCases {
            XCTAssertFalse(category.icon.isEmpty)
        }
    }

    func testCategoryColors() {
        // Test that all categories have colors
        for category in Category.allCases {
            XCTAssertNotNil(category.color)
        }
    }

    func testCategoryRawValues() {
        // Test specific raw values
        XCTAssertEqual(Category.food.rawValue, "Food")
        XCTAssertEqual(Category.transport.rawValue, "Transport")
        XCTAssertEqual(Category.shopping.rawValue, "Shopping")
    }
}
