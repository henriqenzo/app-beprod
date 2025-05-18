
import SwiftUI

struct FocusView: View {
    
    init() {
        // Muda a cor de fundo do item selecionado do segmentedControl
        UISegmentedControl.appearance().selectedSegmentTintColor = .primary
    }
    
    func handleOpenAddTaskModal() {
        print("Abriu modal.")
    }
    
    var body: some View {
        
        ZStack {
            Color("Background").ignoresSafeArea() //Adiciona bgColor para a tela (ignorando a safeArea)
            
            VStack(spacing: 38) {
                
                
                VStack(spacing: 16) {
                    
                    Text("Foco").font(.headline)
                    
                    Text(verbatim: "*Para tarefas com mínimo").font(.subheadline).foregroundStyle(Color("LightGray"))
                    + Text(" 10 min").font(.subheadline).bold().foregroundStyle(Color("LightGray"))
                    + Text(" de duração*").font(.subheadline).foregroundStyle(Color("LightGray"))

                
                }
                
                Spacer()
                
                
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        
    }
}

#Preview {
    FocusView()
}
