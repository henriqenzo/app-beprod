
import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        
        TabView {
            TasksView()
                .tabItem {
                    Image(systemName: "checkmark.square.fill")
                    Text("Tarefas")
                }
            FocusView()
                .tabItem {
                    Image(systemName: "smallcircle.circle.fill")
                    Text("Foco")
                }
            ConstancyView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Constância")
                }
        }
            .accentColor(Color("Primary"))
            .onAppear {
                // Altera a cor de fundo da TabBar (iOS 15+)
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(Color("Gray4")) // Sua cor de fundo
                
                // Aplica para todas as situações (scroll, etc)
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        
    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserTask.self, configurations: config)
            let viewModel = TasksViewModel(context: container.mainContext)

            return MainTabView()
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    }

    return PreviewWrapper()
}
