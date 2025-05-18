
import SwiftUI

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
    MainTabView()
}
