
import SwiftUI

struct FocusView: View {
    
    @State private var focusDuration: TimeInterval = 25 * 60 // Convertendo para segundos
    @State private var timeRemaining: TimeInterval = 25 * 60
    @State private var timer: Timer?
    @State private var isRunning: Bool = false
    @State private var isPaused: Bool = false
    
    var body: some View {
        
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 38) {
                
                VStack(spacing: 16) {
                    Text("Foco").font(.headline)
                    
                    Text(verbatim: "*Para tarefas com mínimo").font(.subheadline).foregroundStyle(Color("LightGray"))
                    + Text(" 10 min").font(.subheadline).bold().foregroundStyle(Color("LightGray"))
                    + Text(" de duração*").font(.subheadline).foregroundStyle(Color("LightGray"))
                }
                
                Spacer()
                    .frame(height: 50)
                
                VStack(spacing: 64) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 4)
                            .frame(width: 284, height: 284)
                            .foregroundStyle(Color("Gray2"))
                        Circle()
                            .trim(from: 0, to: (1 - timeRemaining / focusDuration))
                            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .square))
                            .frame(width: 284, height: 284)
                            .rotationEffect(.degrees(-90))
                            .foregroundStyle(Color("Primary"))
                            .animation(isRunning ? .spring().speed(0.2) : nil)
                            Text(formattedTime())
                                .font(.system(size: 48))
                                .fontWeight(.light)
                        if isPaused {
                            Text("Pausado")
                                .padding(.top, 80)
                                .font(.system(size: 16))
                                .fontWeight(.regular)
                                .foregroundStyle(Color("Gray"))
                        }
                    }
                    
                    if !isRunning && !isPaused {
                        // Botão de Começar (quando o timer não está em execução)
                        Button(action: {
                            startTimer()
                        }) {
                            Image(systemName: "play.fill")
                                .foregroundColor(Color.white)
                            Text("Começar")
                                .font(.headline)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 133, height: 50)
                        .background(Color("Primary"))
                        .cornerRadius(12)
                    } else {
                        // Botões quando o timer está em execução ou pausado
                        HStack(spacing: 100) {
                            // Botão de Parar
                            Button(action: {
                                resetTimer()
                            }) {
                                Image(systemName: "stop.fill")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 26))
                            }
                            .frame(width: 80, height: 80)
                            .background(Color("Gray"))
                            .cornerRadius(40)
                            
                            // Botão de Pausar/Continuar
                            Button(action: {
                                if isPaused {
                                    resumeTimer()
                                } else {
                                    pauseTimer()
                                }
                            }) {
                                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 26))
                            }
                            .frame(width: 80, height: 80)
                            .background(Color("Primary"))
                            .cornerRadius(40)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    func formattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimer() {
        isRunning = true
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerFinished()
            }
        }
    }
    
    func pauseTimer() {
        isPaused = true
        timer?.invalidate()
    }
    
    func resumeTimer() {
        isPaused = false
        startTimer()
    }
    
    func resetTimer() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        timeRemaining = focusDuration
    }
    
    func timerFinished() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        // Aqui você pode adicionar algum feedback quando o timer terminar
    }
}

#Preview {
    FocusView()
}
