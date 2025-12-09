import SwiftUI

struct EditExpenseView: View {
    let expense: Expense
    @ObservedObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss

    @State private var amount: String
    @State private var selectedCategory: Category
    @State private var date: Date
    @State private var note: String
    @State private var tags: String

    init(expense: Expense, expenseViewModel: ExpenseViewModel) {
        self.expense = expense
        self.expenseViewModel = expenseViewModel
        _amount = State(initialValue: String(format: "%.2f", expense.amount))
        _selectedCategory = State(initialValue: expense.category)
        _date = State(initialValue: expense.date)
        _note = State(initialValue: expense.note)
        _tags = State(initialValue: expense.tags.joined(separator: ", "))
    }

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
            .navigationTitle("Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        updateExpense()
                    }
                    .disabled(amount.isEmpty || Double(amount) == nil)
                }
            }
        }
    }

    private func updateExpense() {
        guard let amountValue = Double(amount) else { return }

        let tagArray = tags
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let updatedExpense = Expense(
            id: expense.id,
            amount: amountValue,
            category: selectedCategory,
            date: date,
            note: note,
            tags: tagArray
        )

        expenseViewModel.updateExpense(updatedExpense)
        dismiss()
    }
}

#Preview {
    EditExpenseView(expense: .sample, expenseViewModel: ExpenseViewModel())
}
