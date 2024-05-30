import SwiftUI

struct MenuContent: View {
    
    @State var userGameData: UserGameData = UserGameData()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Image("pilot")
                        .offset(x: -60, y: 30)
                    Spacer()
                    VStack(spacing: 16) {
                        NavigationLink(destination: LvlsContentView()
                            .environmentObject(userGameData)
                            .navigationBarBackButtonHidden(true)) {
                            ZStack {
                                Image("btn_bg")
                                Text("PLAY")
                                    .font(.custom("ZenAntique-Regular", size: 32))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button {
                            exit(0)
                        } label: {
                            ZStack {
                                Image("btn_bg")
                                Text("QUIT")
                                    .font(.custom("ZenAntique-Regular", size: 32))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack {
                            NavigationLink(destination: OptionsGameView()
                                .navigationBarBackButtonHidden(true)) {
                                Image("settings_btn")
                            }
                            NavigationLink(destination: RulesDataView()
                                .navigationBarBackButtonHidden(true)) {
                                Image("rules_btn")
                            }
                            NavigationLink(destination: ShopContentView()
                                .environmentObject(userGameData)
                                .navigationBarBackButtonHidden(true)) {
                                Image("shop_btn")
                            }
                        }
                        .offset(y: 40)
                    }
                    Spacer()
                }
            }
            .background(
                Image("menu_background")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width + 10, height: UIScreen.main.bounds.height + 20)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MenuContent()
}
