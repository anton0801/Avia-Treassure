import SwiftUI

struct OptionsGameView: View {
    
    @Environment(\.presentationMode) var preMode
    
    @State var audioEnabled = false {
        didSet {
            UserDefaults.standard.set(audioEnabled, forKey: "audio_enabled")
        }
    }
    
    var body: some View {
        VStack {
            Image("settings_title")
            
            Spacer()
            
            ZStack {
                Image("rules_bg")
                    .resizable()
                    .frame(width: 250, height: 100)
                HStack {
                    Image("audio")
                    Button {
                        withAnimation {
                            audioEnabled = !audioEnabled
                        }
                    } label: {
                        if audioEnabled {
                            Image("full")
                        } else {
                            Image("empty")
                        }
                    }
                    .onAppear {
                        audioEnabled = UserDefaults.standard.bool(forKey: "audio_enabled")
                    }
                }
            }
            
            Spacer()
            
            Button {
                preMode.wrappedValue.dismiss()
            } label: {
                Image("home")
            }
        }
        .background(
            Image("levels_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width + 10, height: UIScreen.main.bounds.height + 20)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    OptionsGameView()
}
