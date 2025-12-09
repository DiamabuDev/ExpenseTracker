import SwiftUI

struct FilterView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("Category") {
                    Picker("Filter by Category", selection: $expenseViewModel.selectedCategory) {
                        Text("All Categories")
                            .tag(Category?.none)

                        ForEach(Category.allCases) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(Category?.some(category))
                        }
                    }
                }

                Section("Date") {
                    Toggle("Filter by Date", isOn: Binding(
                        get: { expenseViewModel.selectedDate != nil },
                        set: { if !$0 { expenseViewModel.selectedDate = nil } }
                    ))

                    if expenseViewModel.selectedDate != nil {
                        DatePicker("Select Date", selection: Binding(
                            get: { expenseViewModel.selectedDate ?? Date() },
                            set: { expenseViewModel.selectedDate = $0 }
                        ), displayedComponents: .date)
                    }
                }

                Section {
                    Button("Clear All Filters") {
                        expenseViewModel.clearFilters()
                    }
                    .disabled(expenseViewModel.selectedCategory == nil && expenseViewModel.selectedDate == nil)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FilterView(expenseViewModel: ExpenseViewModel())
}
