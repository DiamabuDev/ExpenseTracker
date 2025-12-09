import SwiftUI

struct MonthPickerView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel

    private var isCurrentMonth: Bool {
        Calendar.current.isDate(expenseViewModel.selectedMonth, equalTo: Date(), toGranularity: .month)
    }

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                expenseViewModel.goToPreviousMonth()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }

            VStack(spacing: 2) {
                Text(expenseViewModel.selectedMonthString)
                    .font(.headline)
                    .fontWeight(.semibold)

                if !isCurrentMonth {
                    Button(action: {
                        expenseViewModel.goToCurrentMonth()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.uturn.left")
                                .font(.caption2)
                            Text("Back to current")
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
            .frame(minWidth: 180)

            Button(action: {
                expenseViewModel.goToNextMonth()
            }) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            .disabled(isCurrentMonth)
            .opacity(isCurrentMonth ? 0.3 : 1.0)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MonthPickerView(expenseViewModel: ExpenseViewModel())
}
