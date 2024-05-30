import Foundation
import SwiftUI

struct LvlItem: Equatable {
    var id: String
    var level: Int
    let numberOfPlanes: Int
}

var allLevels = [
    LvlItem(id: "lvl1", level: 1, numberOfPlanes: 5),
    LvlItem(id: "lvl2", level: 2, numberOfPlanes: 5),
    LvlItem(id: "lvl3", level: 3, numberOfPlanes: 5),
    LvlItem(id: "lvl4", level: 4, numberOfPlanes: 6),
    LvlItem(id: "lvl5", level: 5, numberOfPlanes: 6),
    LvlItem(id: "lvl6", level: 6, numberOfPlanes: 6),
    LvlItem(id: "lvl7", level: 7, numberOfPlanes: 6),
    LvlItem(id: "lvl8", level: 8, numberOfPlanes: 6),
    LvlItem(id: "lvl9", level: 9, numberOfPlanes: 6),
    LvlItem(id: "lvl10", level: 10, numberOfPlanes: 7),
    LvlItem(id: "lvl11", level: 11, numberOfPlanes: 7),
    LvlItem(id: "lvl12", level: 12, numberOfPlanes: 7),
    LvlItem(id: "lvl13", level: 13, numberOfPlanes: 7),
    LvlItem(id: "lvl14", level: 14, numberOfPlanes: 7),
    LvlItem(id: "lvl15", level: 15, numberOfPlanes: 7),
    LvlItem(id: "lvl16", level: 16, numberOfPlanes: 7),
    LvlItem(id: "lvl17", level: 17, numberOfPlanes: 7),
    LvlItem(id: "lvl18", level: 18, numberOfPlanes: 7),
    LvlItem(id: "lvl19", level: 19, numberOfPlanes: 8),
    LvlItem(id: "lvl20", level: 20, numberOfPlanes: 8),
    LvlItem(id: "lvl21", level: 21, numberOfPlanes: 8),
    LvlItem(id: "lvl22", level: 22, numberOfPlanes: 8),
    LvlItem(id: "lvl23", level: 23, numberOfPlanes: 8),
    LvlItem(id: "lvl24", level: 24, numberOfPlanes: 10)
]

class LvlsData: ObservableObject {
    
    @Published var lvlsPerPage = [LvlItem]()
    @Published var page = 0 {
        didSet {
            calculateGridItemsInPage()
            setUpLvlItemsInPage()
        }
    }
    @Published var columns: [GridItem] = []
    
    var countPageItems = [
        0: 5,
        1: 4,
        2: 3
    ]
    
    init() {
        page = 0
    }
    
    func setUpLvlItemsInPage() {
        var t = [LvlItem]()
        t.append(contentsOf: allLevels)
        var truck: [[LvlItem]] = []
        for (_, count) in countPageItems {
            let countItemsInPage = count * 2
            var a = [LvlItem]()
            for (i, lvl) in t.enumerated() {
                a.append(lvl)
                if i == countItemsInPage - 1 {
                    truck.append(a)
                    t.removeAll { a.contains($0) }
                    break
                }
            }
        }
        lvlsPerPage = truck[page]
    }
    
    private func calculateGridItemsInPage() {
        let itemsInPage = countPageItems[page]!
        columns = []
        for _ in 1...itemsInPage {
            columns.append(GridItem(.fixed(100)))
        }
    }
    
}
