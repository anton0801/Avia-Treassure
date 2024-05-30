import Foundation

struct ShopAppItem {
    let id: String
    let price: Int
}

var allShopAppItems = [
    ShopAppItem(id: "bonus", price: 10),
    ShopAppItem(id: "chart_1", price: 25),
    ShopAppItem(id: "chart_2", price: 25),
    ShopAppItem(id: "chart_3", price: 25),
    ShopAppItem(id: "chart_4", price: 25),
    ShopAppItem(id: "chart_5", price: 25)
]

class ShopAppData: ObservableObject {
    
    @Published var page = 0 {
        didSet {
            currentSelectedItem = allShopAppItems[page]
            if let currentSelectedItem = currentSelectedItem {
                if currentSelectedItem.id == "bonus" {
                    currentBackground = UserDefaults.standard.string(forKey: "background") ?? "base_chart"
                } else {
                    currentBackground = currentSelectedItem.id
                }
            }
        }
    }
    @Published var currentSelectedItem: ShopAppItem? = nil
    @Published var currentBackground = UserDefaults.standard.string(forKey: "background") ?? "base_chart"
    
    @Published var itemsInStock: [ShopAppItem] = [] {
        didSet {
            UserDefaults.standard.set(itemsInStock.map { $0.id }.joined(separator: ","), forKey: "items_in_stock")
        }
    }
    
    init() {
        page = 0
    }
    
    func buyShopAppItem(_ userGameData: UserGameData) -> Bool {
        if let shopAppItem = currentSelectedItem {
            if userGameData.money >= shopAppItem.price {
                if shopAppItem.id == "bonus" {
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "bonus_count") + 1, forKey: "bonus_count")
                } else {
                    UserDefaults.standard.set(true, forKey: "\(shopAppItem.id)_bought")
                    var t = [ShopAppItem]()
                    t.append(contentsOf: itemsInStock)
                    t.append(shopAppItem)
                    itemsInStock = t
                }
                return true
            }
        }
        return false
    }
    
}
