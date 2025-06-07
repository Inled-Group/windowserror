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
    
    var body: some View {
        ZStack {
            // Fondo estilo Windows XP
            LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.8),
                    Color(red: 0.1, green: 0.6, blue: 0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if showError {
                WindowsErrorDialog(onClose: {
                    showError = false
                    audioPlayer.stopAudio()
                    NSApplication.shared.terminate(nil)
                })
            }
        }
        .frame(width: 420, height: 180)
        .onAppear {
            audioPlayer.playAudio()
        }
    }
}

struct WindowsErrorDialog: View {
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Barra de título estilo Windows XP
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    Text("Error")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: onClose) {
                    Text("×")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 20, height: 18)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color(red: 0.6, green: 0.6, blue: 0.6), lineWidth: 1)
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.45, blue: 0.9),
                        Color(red: 0.1, green: 0.35, blue: 0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Contenido del diálogo estilo Windows XP
            HStack(spacing: 12) {
                // Icono de error más grande estilo XP
                VStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 48))
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 1)
                }
                .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("WinReg.exe")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text("Windows ha fallado correctamente")
                        .font(.system(size: 11))
                        .foregroundColor(.black)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.94, green: 0.94, blue: 0.94),
                        Color(red: 0.88, green: 0.88, blue: 0.88)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Separador
            Rectangle()
                .fill(Color(red: 0.7, green: 0.7, blue: 0.7))
                .frame(height: 1)
            
            // Área de botones estilo Windows XP
            HStack {
                Spacer()
                Button("Aceptar") {
                    onClose()
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 75, height: 25)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.95, green: 0.95, blue: 0.95),
                                    Color(red: 0.85, green: 0.85, blue: 0.85)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.6, green: 0.6, blue: 0.6),
                                            Color(red: 0.4, green: 0.4, blue: 0.4)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 1, y: 1)
                )
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(1.0)
                .onHover { isHovered in
                    // Efecto hover más sutil
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.94, green: 0.94, blue: 0.94),
                        Color(red: 0.88, green: 0.88, blue: 0.88)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.4, green: 0.4, blue: 0.4),
                            Color(red: 0.6, green: 0.6, blue: 0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.4), radius: 8, x: 4, y: 4)
    }
}

class AudioPlayerManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    func playAudio() {
        // Buscar el archivo de audio en el bundle
        guard let url = Bundle.main.url(forResource: "windowserror", withExtension: "wav") else {
            print("No se pudo encontrar windowserror.wav en el bundle")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Reproducir en bucle infinito
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
