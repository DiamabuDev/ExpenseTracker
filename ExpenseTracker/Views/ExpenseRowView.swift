import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(expense.category.color)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: expense.category.icon)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.category.rawValue)
                    .font(.headline)

                if !expense.note.isEmpty {
                    Text(expense.note)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Text(expense.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("$\(expense.amount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(expense.category.color)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ExpenseRowView(expense: .sample)
    }
}
