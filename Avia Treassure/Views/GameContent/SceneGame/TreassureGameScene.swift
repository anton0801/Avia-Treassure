import Foundation
import SpriteKit
import SwiftUI

class TreassureGameScene: SKScene {
    
    var lvlItem: LvlItem!
    var planes: [PlaneNode] = []
    var lines: [(SKShapeNode, PlaneNode, PlaneNode)] = []
    
    init(size: CGSize, lvlItem: LvlItem) {
        self.lvlItem = lvlItem
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var pauseGame: () -> Void = { }
    var winGame: () -> Void = { }
    var loseGame: () -> Void = { }

    var gameStarted = false
    
    var levelLabel: SKLabelNode!
    
    var timeLabel: SKLabelNode!
    
    var creditsLabel: SKLabelNode!
    
    var pauseBtn: SKSpriteNode!
    var addTimeBtn: SKSpriteNode!
    var addTimeCountLabel: SKLabelNode!
    
    private var credits = UserDefaults.standard.integer(forKey: "credits")
    private var addTimeCount = UserDefaults.standard.integer(forKey: "bonus_count")
    
    private var gameTimer: Timer!
    private var time: Int = 10
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1335, height: 750)
        if lvlItem == nil {
            lvlItem = allLevels[0]
        }
        createSceneUI()
        setupLevel()
    }
    
    private func createSceneUI() {
        let background = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "chart") ?? "base_chart")
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
        
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.position = CGPoint(x: 80, y: size.height - 60)
        pauseBtn.size = CGSize(width: 120, height: 110)
        addChild(pauseBtn)
        
        addTimeBtn = SKSpriteNode(imageNamed: "add_bonus_time")
        addTimeBtn.position = CGPoint(x: size.width - 80, y: size.height - 60)
        addTimeBtn.size = CGSize(width: 120, height: 110)
        addChild(addTimeBtn)
        
        let countBg = SKSpriteNode(imageNamed: "count_bg")
        countBg.position = CGPoint(x: size.width - 120, y: size.height - 90)
        countBg.size = CGSize(width: 52, height: 48)
        addChild(countBg)
        
        addTimeCountLabel = SKLabelNode(text: "\(addTimeCount)")
        addTimeCountLabel.fontColor = .white
        addTimeCountLabel.fontName = "ZenAntique-Regular"
        addTimeCountLabel.fontSize = 28
        addTimeCountLabel.position = CGPoint(x: size.width - 120, y: size.height - 100)
        addChild(addTimeCountLabel)
        
        let timeBg = SKSpriteNode(imageNamed: "game_ui_value_bg")
        timeBg.position = CGPoint(x: size.width / 2 - (size.width / 4), y: size.height - 60)
        timeBg.size = CGSize(width: 190, height: 100)
        addChild(timeBg)
        
        timeLabel = SKLabelNode(text: "00:10")
        timeLabel.fontColor = .white
        timeLabel.fontName = "ZenAntique-Regular"
        timeLabel.fontSize = 28
        timeLabel.position = CGPoint(x: size.width / 2 - (size.width / 4), y: size.height - 68)
        addChild(timeLabel)
        
        let creditsBg = SKSpriteNode(imageNamed: "game_ui_value_bg")
        creditsBg.position = CGPoint(x: size.width / 2 + (size.width / 4), y: size.height - 60)
        creditsBg.size = CGSize(width: 190, height: 100)
        addChild(creditsBg)
        
        creditsLabel = SKLabelNode(text: "\(credits)")
        creditsLabel.fontColor = .white
        creditsLabel.fontName = "ZenAntique-Regular"
        creditsLabel.fontSize = 28
        creditsLabel.position = CGPoint(x: size.width / 2 + (size.width / 4) - 30, y: size.height - 68)
        addChild(creditsLabel)
        
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.position = CGPoint(x: size.width / 2 + (size.width / 4) + 30, y: size.height - 58)
        addChild(coinImage)
    }
    
    func setupLevel() {
        guard let level = lvlItem else { return }
        
        let levelBg = SKSpriteNode(imageNamed: "game_ui_value_bg")
        levelBg.position = CGPoint(x: size.width / 2, y: size.height - 80)
        levelBg.size = CGSize(width: 270, height: 150)
        addChild(levelBg)
        
        levelLabel = SKLabelNode(text: "LEVEL \(level.level)")
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 90)
        levelLabel.fontSize = 42
        levelLabel.fontName = "ZenAntique-Regular"
        levelLabel.fontColor = .white
        addChild(levelLabel)
        
        if gameTimer == nil {
            gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkGameTime), userInfo: nil, repeats: true)
        }
        
        for _ in 0..<level.numberOfPlanes {
            let plane = createPlane()
            planes.append(plane)
            addChild(plane)
        }
        
        createLines()
    }
    
    @objc func checkGameTime() {
        if gameStarted && !isPaused {
            time -= 1
            var timeS = "\(time)"
            if time <= 9 {
                timeS = "0\(time)"
            }
            timeLabel.text = "00:\(timeS)"
            if time == 0 {
                isPaused = true
                loseGame()
            }
        }
    }

    func createPlane() -> PlaneNode {
        let plane = PlaneNode(color: .clear, size: CGSize(width: 90, height: 80))
        plane.position = CGPoint(
            x: CGFloat.random(in: 50...size.width-50),
            y: CGFloat.random(in: 50...size.height-200)
        )
        plane.zPosition = 10
        plane.isUserInteractionEnabled = true
        return plane
    }

    func createLines() {
        lines.forEach { $0.0.removeFromParent() }
        lines.removeAll()
        
        var planeIndices = Array(planes.indices)
        planeIndices.shuffle()
        
        for i in 0..<planeIndices.count - 1 {
            let currentPlaneIndex = planeIndices[i]
            let nextPlaneIndex = planeIndices[(i + 1) % planeIndices.count]
            
            let line = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: planes[currentPlaneIndex].position)
            path.addLine(to: planes[nextPlaneIndex].position)
            line.path = path
            line.strokeColor = .white
            line.lineWidth = 8.0
            lines.append((line, planes[currentPlaneIndex], planes[nextPlaneIndex]))
            addChild(line)
        }
    }
    
    func updateLines() {
        for (line, plane1, plane2) in lines {
            let path = CGMutablePath()
            path.move(to: plane1.position)
            path.addLine(to: plane2.position)
            line.path = path
        }
    }

    override func update(_ currentTime: TimeInterval) {
        let gameStatus = checkIntersections()
        if !gameStarted && !isPaused {
            if !gameStatus {
                setupLevel()
            } else {
                gameStarted = true
            }
        }
        
        if gameStarted && !isPaused {
            if !gameStatus {
                isPaused = true
                winGame()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch == nil {
            return
        }
        let location = touch!.location(in: self)
        let nodesInLocation = nodes(at: location)
        
        if nodesInLocation.contains(pauseBtn) {
            isPaused = true
            pauseGame()
            return
        }
        
        if nodesInLocation.contains(addTimeBtn) {
            addTime()
            return
        }
    }
    
    func addTime() {
        if addTimeCount > 0 {
            addTimeCount -= 1
            addTimeCountLabel.text = "\(addTimeCount)"
            UserDefaults.standard.set(addTimeCount, forKey: "bonus_count")
            time += 10
            timeLabel.text = "\(time)"
        }
    }
    
    func continueGame() {
        isPaused = false
    }
    
    func restartGameScene() -> TreassureGameScene {
        let newGameScene = TreassureGameScene(size: CGSize(width: 1335, height: 750), lvlItem: lvlItem)
        newGameScene.pauseGame = pauseGame
        newGameScene.winGame = winGame
        newGameScene.loseGame = loseGame
        newGameScene.lvlItem = lvlItem
        view?.presentScene(newGameScene)
        return newGameScene
    }

    func checkIntersections() -> Bool {
        var hasIntersections = false
        for (line, _, _) in lines {
            line.strokeColor = .white
        }
        
        for i in 0..<lines.count {
            for j in i+1..<lines.count {
                if linesIntersect(line1: lines[i].0, line2: lines[j].0) {
                    hasIntersections = true
                }
            }
        }
        return hasIntersections
    }
    
    func linesIntersect(line1: SKShapeNode, line2: SKShapeNode) -> Bool {
        guard let path1 = line1.path, let path2 = line2.path else { return false }
        
        let points1 = points(from: path1)
        let points2 = points(from: path2)
        
        return segmentsIntersect(p1: points1[0], p2: points1[1], p3: points2[0], p4: points2[1])
    }
    
    func points(from path: CGPath) -> [CGPoint] {
        var points: [CGPoint] = []
        path.applyWithBlock { element in
            let pointsPointer = element.pointee.points
            let point = pointsPointer.pointee
            points.append(point)
        }
        return points
    }
    
    func segmentsIntersect(p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> Bool {
        let d1 = direction(p1, p2, p3)
        let d2 = direction(p1, p2, p4)
        let d3 = direction(p3, p4, p1)
        let d4 = direction(p3, p4, p2)
        return (d1 * d2 < 0) && (d3 * d4 < 0)
    }

    func direction(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> CGFloat {
        return (p3.y - p1.y) * (p2.x - p1.x) - (p2.y - p1.y) * (p3.x - p1.x)
    }
    
}

class PlaneNode: SKSpriteNode {
    
    var neighbors: [PlaneNode] = []
    var touchStart: CGPoint?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        let plane = SKSpriteNode(imageNamed: "plane")
        plane.size = size
        addChild(plane)
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let touch = touches.first {
           touchStart = touch.location(in: self)
       }
   }
   
   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let touch = touches.first, let touchStart = touchStart {
           let location = touch.location(in: parent!)
           position = location
           (parent as? TreassureGameScene)?.updateLines() // Обновляем линии при перемещении
       }
   }
    
}

#Preview {
    VStack {
        SpriteView(scene: TreassureGameScene(size: CGSize(width: 1335, height: 750), lvlItem: allLevels[0]))
            .ignoresSafeArea()
    }
}
