import SwiftUI

struct CategoryRowView: View {
    let category: Category
    let amount: Double

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(category.color)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: category.icon)
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            Spacer()

            Text("$\(amount, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CategoryRowView(category: .food, amount: 125.50)
}
