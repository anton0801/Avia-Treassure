import SwiftUI

struct RulesDataView: View {
    
    @Environment(\.presentationMode) var preMode
    
    var rulesText = [
        "The planes got confused",
        "You need to untangle the ropes",
        "you need the lines to be straight and not intersect with each other"
    ]
    @State var rulesIndex = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    preMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow_back")
                }
                Spacer()
                Image("rules_title")
                    .offset(x: -45)
                Spacer()
            }
            .padding()
            Spacer()
            
            HStack {
                Button {
                    if rulesIndex > 0 {
                        withAnimation {
                            rulesIndex -= 1
                        }
                    }
                } label: {
                    Image("arrow_back")
                }
                .opacity(rulesIndex > 0 ? 1 : 0.5)
                
                ZStack {
                    Image("rules_bg")
                        .resizable()
                        .frame(width: 290, height: 180)
                    Text(rulesText[rulesIndex])
                        .font(.custom("ZenAntique-Regular", size: 20))
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    if rulesIndex < rulesText.count - 1 {
                        withAnimation {
                            rulesIndex += 1
                        }
                    }
                } label: {
                    Image("arrow_forward")
                }
                .opacity(rulesIndex < rulesText.count - 1 ? 1 : 0.5)
            }
            
            Spacer()
            Spacer()
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
    RulesDataView()
}
