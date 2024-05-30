import SwiftUI

struct ShopContentView: View {
    
    @Environment(\.presentationMode) var preMode
    @EnvironmentObject var userGameData: UserGameData
    @StateObject var shopAppData = ShopAppData()
    
    @State var buyStatusErrorVisible = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if shopAppData.page > 0 {
                        withAnimation {
                            shopAppData.page -= 1
                        }
                    }
                } label: {
                    Image("arrow_back")
                }
                .opacity(shopAppData.page > 0 ? 1 : 0.5)
                
                Spacer()
                
                if let currentItem = shopAppData.currentSelectedItem {
                    ZStack {
                        Image("title_bg")
                        Text(currentItem.id == "bonus" ? "BONUS" : "CHART")
                            .font(.custom("ZenAntique-Regular", size: 34))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                Button {
                    if shopAppData.page < allShopAppItems.count - 1 {
                        withAnimation {
                            shopAppData.page += 1
                        }
                    }
                } label: {
                    Image("arrow_forward")
                }
                .opacity(shopAppData.page < allShopAppItems.count - 1 ? 1 : 0.5)
            }
            Spacer()
            
            if let currentItem = shopAppData.currentSelectedItem {
                if currentItem.id != userGameData.chart {
                    if !shopAppData.itemsInStock.contains(where: { $0.id == currentItem.id }) {
                        ZStack {
                            Image("rules_bg")
                            HStack {
                                if currentItem.id == "bonus" {
                                    Image("bonus")
                                }
                                Text("\(currentItem.price)")
                                    .font(.custom("ZenAntique-Regular", size: 34))
                                    .foregroundColor(.white)
                                Image("coin")
                            }
                        }
                        .offset(y: 20)
                    }
                    Button {
                        if !shopAppData.itemsInStock.contains(where: { $0.id == currentItem.id }) {
                            let buyStatus = shopAppData.buyShopAppItem(userGameData)
                            withAnimation {
                                buyStatusErrorVisible = !buyStatus
                            }
                        } else {
                            userGameData.chart = currentItem.id
                        }
                    } label: {
                        Image("select_btn")
                    }
                    .offset(y: -20)
                    
                    if buyStatusErrorVisible {
                        Text("Error buy this item! You don't have enought money (game credits)!")
                            .font(.custom("ZenAntique-Regular", size: 24))
                            .foregroundColor(.white)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        buyStatusErrorVisible = false
                                    }
                                }
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
            Image(shopAppData.currentBackground)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width + 10, height: UIScreen.main.bounds.height + 20)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    ShopContentView()
        .environmentObject(UserGameData())
}
