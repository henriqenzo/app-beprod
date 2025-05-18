

import SwiftUI

struct ConstancyView: View {
    var body: some View {
        
        ZStack {
            Color("Background").ignoresSafeArea() //Adiciona bgColor para a tela (ignorando a safeArea)
            
            VStack(spacing: 38) {
                
                
                VStack(spacing: 24) {
                    
                    Text("Constância").font(.headline)
                    
                    Rectangle()
                        .fill(Color("Gray3"))
                        .cornerRadius(10)
                       
                        
                        

                
                }
                
                Spacer()
                
                
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
       
    }
}

#Preview {
    ConstancyView()
}
