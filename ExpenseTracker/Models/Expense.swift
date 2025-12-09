import Foundation
import SwiftUI

struct Expense: Identifiable, Codable, Equatable {
    let id: UUID
    var amount: Double
    var category: Category
    var date: Date
    var note: String
    var tags: [String]

    init(id: UUID = UUID(), amount: Double, category: Category, date: Date = Date(), note: String = "", tags: [String] = []) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
        self.tags = tags
    }
}

extension Expense {
    static var sample: Expense {
        Expense(
            amount: 45.99,
            category: .food,
            date: Date(),
            note: "Lunch at restaurant",
            tags: ["dining", "work"]
        )
    }
}
