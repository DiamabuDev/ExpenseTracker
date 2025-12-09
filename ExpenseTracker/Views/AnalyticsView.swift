import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Month Picker
                    MonthPickerView(expenseViewModel: expenseViewModel)
                        .padding(.horizontal)

                    // Total Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Spending")
                            .font(.headline)
                        Text("$\(expenseViewModel.totalExpenses, specifier: "%.2f")")
                            .font(.system(size: 36, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)

                    // Category Chart
                    if !expenseViewModel.expensesByCategory.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Spending by Category")
                                .font(.headline)

                            Chart {
                                ForEach(Category.allCases) { category in
                                    if let amount = expenseViewModel.expensesByCategory[category], amount > 0 {
                                        SectorMark(
                                            angle: .value("Amount", amount),
                                            innerRadius: .ratio(0.5),
                                            angularInset: 2
                                        )
                                        .foregroundStyle(category.color)
                                        .annotation(position: .overlay) {
                                            Text("$\(amount, specifier: "%.0f")")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            .frame(height: 300)

                            // Legend
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Category.allCases) { category in
                                    if let amount = expenseViewModel.expensesByCategory[category], amount > 0 {
                                        HStack {
                                            Circle()
                                                .fill(category.color)
                                                .frame(width: 12, height: 12)
                                            Text(category.rawValue)
                                            Spacer()
                                            Text("$\(amount, specifier: "%.2f")")
                                                .fontWeight(.semibold)
                                        }
                                    }
                                }
                            }
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    }

                    // Transaction Count
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Total Transactions")
                            .font(.headline)

                        Text("\(expenseViewModel.getExpenses(for: expenseViewModel.selectedMonth).count)")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    AnalyticsView(expenseViewModel: ExpenseViewModel())
}
