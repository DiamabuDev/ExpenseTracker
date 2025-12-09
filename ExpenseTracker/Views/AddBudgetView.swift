import SwiftUI

struct AddBudgetView: View {
    @ObservedObject var budgetViewModel: BudgetViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedCategory: Category = .food
    @State private var limit: String = ""
    @State private var month: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                }

                Section("Budget Limit") {
                    HStack {
                        Text("$")
                            .font(.title2)
                        TextField("0.00", text: $limit)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                    }
                }

                Section("Month") {
                    DatePicker("Month", selection: $month, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBudget()
                    }
                    .disabled(limit.isEmpty || Double(limit) == nil)
                }
            }
        }
    }

    private func saveBudget() {
        guard let limitValue = Double(limit) else { return }

        let budget = Budget(
            category: selectedCategory,
            limit: limitValue,
            month: month
        )

        budgetViewModel.addBudget(budget)
        dismiss()
    }
}

#Preview {
    AddBudgetView(budgetViewModel: BudgetViewModel(expenseViewModel: ExpenseViewModel()))
}
