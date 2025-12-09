import Foundation

struct Budget: Identifiable, Codable, Equatable {
    let id: UUID
    var category: Category
    var limit: Double
    var month: Date

    init(id: UUID = UUID(), category: Category, limit: Double, month: Date = Date()) {
        self.id = id
        self.category = category
        self.limit = limit
        self.month = month
    }

    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }
}

extension Budget {
    static var sample: Budget {
        Budget(category: .food, limit: 500.0, month: Date())
    }
}
