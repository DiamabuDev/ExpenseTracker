import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss

    @State private var amount: String = ""
    @State private var selectedCategory: Category = .food
    @State private var date: Date = Date()
    @State private var note: String = ""
    @State private var tags: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Amount") {
                    HStack {
                        Text("$")
                            .font(.title2)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                    }
                }

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

                Section("Details") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)

                    TextField("Note (optional)", text: $note)

                    TextField("Tags (comma separated)", text: $tags)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExpense()
                    }
                    .disabled(amount.isEmpty || Double(amount) == nil)
                }
            }
        }
    }

    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }

        let tagArray = tags
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let expense = Expense(
            amount: amountValue,
            category: selectedCategory,
            date: date,
            note: note,
            tags: tagArray
        )

        expenseViewModel.addExpense(expense)
        dismiss()
    }
}

#Preview {
    AddExpenseView(expenseViewModel: ExpenseViewModel())
}
