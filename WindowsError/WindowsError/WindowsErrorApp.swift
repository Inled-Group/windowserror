import SwiftUI
import AVFoundation

@main
struct WindowsErrorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .pasteboard) { }
            CommandGroup(replacing: .undoRedo) { }
            CommandGroup(replacing: .windowSize) { }
        }
    }
}

struct ContentView: View {
    @StateObject private var audioPlayer = AudioPlayerManager()
    @State private var showError = true
    @State private var showSecondDialog = false
    
    var body: some View {
        Group {
            if showError && !showSecondDialog {
                WindowsErrorDialog(
                    onClose: {
                        showError = false
                        audioPlayer.stopAudio()
                        NSApplication.shared.terminate(nil)
                    },
                    onFix: {
                        showSecondDialog = true
                    }
                )
            } else if showSecondDialog {
                SecondErrorDialog(onClose: {
                    showSecondDialog = false
                    showError = false
                    audioPlayer.stopAudio()
                    NSApplication.shared.terminate(nil)
                })
            }
        }
        .frame(width: showSecondDialog ? 400 : 380, height: showSecondDialog ? 180 : 150)
        .onAppear {
            audioPlayer.playAudio()
        }
    }
}

struct WindowsErrorDialog: View {
    let onClose: () -> Void
    let onFix: () -> Void
    @State private var isHoveringClose = false
    @State private var isHoveringFix = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Barra de título con gradiente XP auténtico
            HStack {
                HStack(spacing: 4) {
                    // Icono pequeño de error en la barra de título
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .shadow(color: .black.opacity(0.5), radius: 0, x: 1, y: 1)
                    
                    Text("Error")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 0, x: 1, y: 1)
                }
                
                Spacer()
                
                Button(action: onClose) {
                    Text("×")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 21, height: 21)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(isHoveringClose ?
                                      Color(red: 0.9, green: 0.3, blue: 0.3) :
                                      Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(isHoveringClose ?
                                               Color(red: 0.8, green: 0.2, blue: 0.2) :
                                               Color.clear, lineWidth: 1)
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    isHoveringClose = hovering
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 0.0, green: 0.4, blue: 1.0), location: 0.0),
                        .init(color: Color(red: 0.0, green: 0.3, blue: 0.8), location: 0.5),
                        .init(color: Color(red: 0.0, green: 0.2, blue: 0.6), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .offset(y: -9)
            )
            
            // Contenido principal con fondo XP
            HStack(spacing: 12) {
                // Icono de error más realista
                VStack {
                    ZStack {
                        // Círculo con gradiente rojo
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 1.0, green: 0.4, blue: 0.4),
                                        Color(red: 0.9, green: 0.1, blue: 0.1),
                                        Color(red: 0.7, green: 0.0, blue: 0.0)
                                    ]),
                                    center: UnitPoint(x: 0.3, y: 0.3),
                                    startRadius: 5,
                                    endRadius: 25
                                )
                            )
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(Color(red: 0.5, green: 0.0, blue: 0.0), lineWidth: 1)
                            )
                        
                        // X blanca con sombra
                        Text("✕")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                    }
                }
                .padding(.leading, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Windows ha fallado correctamente")
                        .font(.system(size: 11))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text("Le agradecemos su confianza depositada en Windows")
                        .font(.system(size: 11))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.94, green: 0.94, blue: 0.94),
                        Color(red: 0.90, green: 0.90, blue: 0.90)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Área de botones con estilo XP
            HStack {
                Spacer()
                
                Button("Cerrar") {
                    onFix()
                }
                .font(.system(size: 11))
                .foregroundColor(.black)
                .frame(width: 75, height: 23)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: isHoveringFix ? [
                                    Color(red: 0.98, green: 0.98, blue: 0.98),
                                    Color(red: 0.92, green: 0.92, blue: 0.92),
                                    Color(red: 0.85, green: 0.85, blue: 0.85)
                                ] : [
                                    Color(red: 0.95, green: 0.95, blue: 0.95),
                                    Color(red: 0.88, green: 0.88, blue: 0.88),
                                    Color(red: 0.82, green: 0.82, blue: 0.82)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.0, green: 0.3, blue: 0.8),
                                            Color(red: 0.6, green: 0.6, blue: 0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .overlay(
                            // Highlight superior
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                .padding(1)
                        )
                )
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    isHoveringFix = hovering
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.94, green: 0.94, blue: 0.94),
                        Color(red: 0.90, green: 0.90, blue: 0.90)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
        .overlay(
            // Borde exterior de la ventana
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.0, green: 0.3, blue: 0.8),
                            Color(red: 0.6, green: 0.6, blue: 0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            // Borde interior brillante
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                .padding(1)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 2, y: 4)
    }
}

struct SecondErrorDialog: View {
    let onClose: () -> Void
    @State private var isHoveringClose = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Barra de título con gradiente XP auténtico
            HStack {
                HStack(spacing: 4) {
                    // Icono de advertencia en la barra de título
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .shadow(color: .black.opacity(0.5), radius: 0, x: 1, y: 1)
                    
                    Text("¡Alerta del sistema!")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 0, x: 1, y: 1)
                }
                
                Spacer()
                
                Button(action: onClose) {
                    Text("×")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 21, height: 21)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(isHoveringClose ?
                                      Color(red: 0.9, green: 0.3, blue: 0.3) :
                                      Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(isHoveringClose ?
                                               Color(red: 0.8, green: 0.2, blue: 0.2) :
                                               Color.clear, lineWidth: 1)
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    isHoveringClose = hovering
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 0.0, green: 0.4, blue: 1.0), location: 0.0),
                        .init(color: Color(red: 0.0, green: 0.3, blue: 0.8), location: 0.5),
                        .init(color: Color(red: 0.0, green: 0.2, blue: 0.6), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .offset(y: -9)
            )
            
            // Contenido principal con fondo XP
            HStack(spacing: 12) {
                // Icono de advertencia más grande
                VStack {
                    ZStack {
                        // Triángulo con gradiente amarillo
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                        
                        // Signo de exclamación
                        Image(systemName: "exclamationmark")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.black)
                            .offset(y: -2)
                    }
                }
                .padding(.leading, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Windows se ha borrado correctamente")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Ahora puedes instalar Linux")
                        .font(.system(size: 11))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text("Error Code: 0x80070005")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(red: 0.5, green: 0.0, blue: 0.0))
                        .padding(.top, 4)
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.94, green: 0.94, blue: 0.94),
                        Color(red: 0.90, green: 0.90, blue: 0.90)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Mensaje adicional
            VStack(alignment: .leading) {
                Text("Desinstalar Windows puede convertirte en adicto al Open-Source")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 12)
            }
            .padding(.bottom, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.94, green: 0.94, blue: 0.94),
                        Color(red: 0.90, green: 0.90, blue: 0.90)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
        .overlay(
            // Borde exterior de la ventana
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.0, green: 0.3, blue: 0.8),
                            Color(red: 0.6, green: 0.6, blue: 0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            // Borde interior brillante
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                .padding(1)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 2, y: 4)
    }
}

class AudioPlayerManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    func playAudio() {
        guard let url = Bundle.main.url(forResource: "windowserror", withExtension: "wav") else {
            print("No se pudo encontrar windowserror.wav en el bundle")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Error al reproducir audio: \(error)")
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
