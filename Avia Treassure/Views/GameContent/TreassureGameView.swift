import SwiftUI
import SpriteKit

struct TreassureGameView: View {
    
    @Environment(\.presentationMode) var preMode
    @EnvironmentObject var userGameData: UserGameData
    var lvlItem: LvlItem
    
    @State var gameScene: TreassureGameScene!
    
    @State var showWinContent = false
    @State var showLoseContent = false
    @State var showPauseContent = false
    
    var body: some View {
        ZStack {
            if let treassureGameScene = gameScene {
                SpriteView(scene: treassureGameScene)
                    .ignoresSafeArea()
            }
            
            if showPauseContent {
                pauseContent
            } else if showLoseContent {
                loseContent
            } else if showWinContent {
                winContent
            }
        }
        .onAppear {
            gameScene = TreassureGameScene(size: CGSize(width: 1335, height: 750), lvlItem: lvlItem)
            gameScene.lvlItem = lvlItem
            gameScene.pauseGame = {
                withAnimation {
                    showPauseContent = true
                }
            }
            gameScene.winGame = {
                withAnimation {
                    showWinContent = true
                }
            }
            gameScene.loseGame = {
                withAnimation {
                    showLoseContent = true
                }
            }
        }
    }
    
    private var pauseContent: some View {
        VStack {
            ZStack {
               Image("title_bg")
               Text("PAUSE")
                   .font(.custom("ZenAntique-Regular", size: 34))
                   .foregroundColor(.white)
            }
            
            Spacer()
            
            ZStack {
                Image("rules_bg")
                Text("GAME\nPAUSED")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.custom("ZenAntique-Regular", size: 32))
            }
            .offset(y: 15)
            Button {
                gameScene.continueGame()
                withAnimation {
                    showPauseContent = false
                }
            } label: {
                Image("arrow_forward")
            }
            .offset(y: -15)
            
            Button {
                gameScene = gameScene.restartGameScene()
                withAnimation {
                    showPauseContent = false
                }
            } label: {
                Image("restart")
            }
            
            Spacer()
        }
        .background(
            Image(UserDefaults.standard.string(forKey: "chart") ?? "base_chart")
                .resizable()
                .frame(width: UIScreen.main.bounds.width + 10, height: UIScreen.main.bounds.height + 20)
                .ignoresSafeArea()
        )
    }
    
    private var winContent: some View {
        VStack {
            ZStack {
               Image("title_bg")
               Text("WIN")
                   .font(.custom("ZenAntique-Regular", size: 34))
                   .foregroundColor(.white)
            }
            
            Spacer()
            
            ZStack {
                Image("rules_bg")
                Text("Nice job! You finished the level and earned 10 coins")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.custom("ZenAntique-Regular", size: 18))
                    .frame(width: 180)
            }
            .offset(y: 15)
            Button {
                preMode.wrappedValue.dismiss()
            } label: {
                Image("home")
            }
            .offset(y: -15)
            
            Button {
                gameScene = gameScene.restartGameScene()
                withAnimation {
                    showWinContent = false
                }
            } label: {
                Image("restart")
            }
            
            Spacer()
        }
        .background(
            Image(UserDefaults.standard.string(forKey: "chart") ?? "base_chart")
                .resizable()
                .frame(width: UIScreen.main.bounds.width + 10, height: UIScreen.main.bounds.height + 20)
                .ignoresSafeArea()
        )
        .onAppear {
            userGameData.money += 10
        }
    }
    
    private var loseContent: some View {
        VStack {
            ZStack {
               Image("title_bg")
               Text("LOSE")
                   .font(.custom("ZenAntique-Regular", size: 34))
                   .foregroundColor(.white)
            }
            
            Spacer()
            
            ZStack {
                Image("rules_bg")
                Text("Your try didn't work out, but give it another shot")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.custom("ZenAntique-Regular", size: 18))
                    .frame(width: 180)
            }
            .offset(y: 15)
            HStack {
                Button {
                    preMode.wrappedValue.dismiss()
                } label: {
                    Image("home")
                }
                
                Button {
                    gameScene = gameScene.restartGameScene()
                    withAnimation {
                        showLoseContent = false
                    }
                } label: {
                    Image("restart")
                }
            }
            .offset(y: -15)
            
            Spacer()
        }
        .background(
            Image(UserDefaults.standard.string(forKey: "chart") ?? "base_chart")
                .resizable()
                .frame(width: UIScreen.main.bounds.width + 10, height: UIScreen.main.bounds.height + 20)
                .ignoresSafeArea()
        )
        .onAppear {
            userGameData.money += 10
        }
    }
    
}

#Preview {
    TreassureGameView(lvlItem: allLevels[0])
        .environmentObject(UserGameData())
}
