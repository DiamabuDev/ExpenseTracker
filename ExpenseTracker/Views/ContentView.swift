import SwiftUI

struct ContentView: View {
    @StateObject private var expenseViewModel = ExpenseViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(expenseViewModel: expenseViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ExpenseListView(expenseViewModel: expenseViewModel)
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }
                .tag(1)

            BudgetView(expenseViewModel: expenseViewModel)
                .tabItem {
                    Label("Budget", systemImage: "chart.pie.fill")
                }
                .tag(2)

            AnalyticsView(expenseViewModel: expenseViewModel)
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
