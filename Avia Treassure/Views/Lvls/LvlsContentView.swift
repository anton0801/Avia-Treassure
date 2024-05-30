import SwiftUI

struct LvlsContentView: View {
    
    @EnvironmentObject var userGameData: UserGameData
    @Environment(\.presentationMode) var preMode
    @StateObject var lvlsData: LvlsData = LvlsData()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        if lvlsData.page > 0 {
                            withAnimation {
                                lvlsData.page -= 1
                            }
                        }
                    } label: {
                        Image("arrow_back")
                    }
                    .opacity(lvlsData.page > 0 ? 1 : 0.5)
                    
                    Spacer()
                    
                    ZStack {
                        Image("title_bg")
                        Text("LEVELS")
                            .font(.custom("ZenAntique-Regular", size: 34))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    Button {
                        if lvlsData.page < 2 {
                            withAnimation {
                                lvlsData.page += 1
                            }
                        }
                    } label: {
                        Image("arrow_forward")
                    }
                    .opacity(lvlsData.page < 2 ? 1 : 0.5)
                }
                Spacer()
                LazyVGrid(columns: lvlsData.columns) {
                    ForEach(lvlsData.lvlsPerPage, id: \.id) { lvlItem in
                        NavigationLink(destination: TreassureGameView(lvlItem: lvlItem)
                            .navigationBarBackButtonHidden(true)
                            .environmentObject(userGameData)) {
                            ZStack {
                                Image("level_bg")
                                Text("\(lvlItem.level)")
                                    .font(.custom("ZenAntique-Regular", size: 32))
                                    .foregroundColor(.white)
                            }
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
}

#Preview {
    LvlsContentView()
        .environmentObject(UserGameData())
}
