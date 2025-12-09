import SwiftUI

struct HomeView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Month Picker
                    MonthPickerView(expenseViewModel: expenseViewModel)
                        .padding(.horizontal)

                    // Monthly Summary Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Total Spending")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))

                        Text("$\(expenseViewModel.getMonthlyTotal(), specifier: "%.2f")")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)

                    // Category Breakdown
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Spending by Category")
                            .font(.headline)
                            .padding(.horizontal)

                        if expenseViewModel.expensesByCategory.values.allSatisfy({ $0 == 0 }) {
                            VStack(spacing: 8) {
                                Image(systemName: "chart.pie")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No spending data yet")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                        } else {
                            ForEach(Category.allCases) { category in
                                if let amount = expenseViewModel.expensesByCategory[category], amount > 0 {
                                    CategoryRowView(category: category, amount: amount)
                                }
                            }
                        }
                    }

                    // Recent Expenses
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Expenses")
                            .font(.headline)
                            .padding(.horizontal)

                        if expenseViewModel.expenses.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "tray")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No expenses yet")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Tap + to add your first expense")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                        } else {
                            ForEach(Array(expenseViewModel.expenses.prefix(5))) { expense in
                                ExpenseRowView(expense: expense)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Expense Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExpense = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenseViewModel: expenseViewModel)
            }
        }
    }
}

#Preview {
    HomeView(expenseViewModel: ExpenseViewModel())
}
