import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel
    @State private var showingAddExpense = false
    @State private var showingFilters = false

    var body: some View {
        NavigationView {
            List {
                if expenseViewModel.filteredExpenses().isEmpty {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: "tray.fill",
                        description: Text("Add your first expense to get started")
                    )
                } else {
                    ForEach(expenseViewModel.filteredExpenses()) { expense in
                        NavigationLink(destination: ExpenseDetailView(expense: expense, expenseViewModel: expenseViewModel)) {
                            ExpenseRowView(expense: expense)
                        }
                    }
                    .onDelete(perform: deleteExpenses)
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExpense = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenseViewModel: expenseViewModel)
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(expenseViewModel: expenseViewModel)
            }
        }
    }

    private func deleteExpenses(at offsets: IndexSet) {
        for index in offsets {
            let expense = expenseViewModel.filteredExpenses()[index]
            expenseViewModel.deleteExpense(expense)
        }
    }
}

#Preview {
    ExpenseListView(expenseViewModel: ExpenseViewModel())
}
