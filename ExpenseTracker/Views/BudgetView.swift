import SwiftUI

struct BudgetView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel
    @StateObject private var budgetViewModel: BudgetViewModel
    @State private var showingAddBudget = false

    init(expenseViewModel: ExpenseViewModel) {
        self.expenseViewModel = expenseViewModel
        _budgetViewModel = StateObject(wrappedValue: BudgetViewModel(expenseViewModel: expenseViewModel))
    }

    var body: some View {
        NavigationView {
            List {
                if budgetViewModel.getCurrentMonthBudgets().isEmpty {
                    ContentUnavailableView(
                        "No Budgets",
                        systemImage: "chart.pie",
                        description: Text("Set a budget to track your spending")
                    )
                } else {
                    ForEach(budgetViewModel.getCurrentMonthBudgets()) { budget in
                        BudgetRowView(
                            budget: budget,
                            spent: expenseViewModel.getTotalExpenses(for: budget.category, in: budget.month),
                            budgetViewModel: budgetViewModel
                        )
                    }
                }
            }
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBudget = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView(budgetViewModel: budgetViewModel)
            }
        }
    }
}

struct BudgetRowView: View {
    let budget: Budget
    let spent: Double
    @ObservedObject var budgetViewModel: BudgetViewModel

    var progress: Double {
        min(spent / budget.limit, 1.0)
    }

    var isOverBudget: Bool {
        spent > budget.limit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: budget.category.icon)
                    .foregroundColor(budget.category.color)
                Text(budget.category.rawValue)
                    .font(.headline)
                Spacer()
                Text("$\(budget.limit, specifier: "%.0f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            ProgressView(value: progress)
                .tint(isOverBudget ? .red : budget.category.color)

            HStack {
                Text("$\(spent, specifier: "%.2f") spent")
                    .font(.subheadline)
                Spacer()
                Text("$\(budget.limit - spent, specifier: "%.2f") remaining")
                    .font(.subheadline)
                    .foregroundColor(isOverBudget ? .red : .secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    BudgetView(expenseViewModel: ExpenseViewModel())
}
