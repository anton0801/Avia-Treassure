import Foundation


class UserGameData: ObservableObject {
    
    @Published var money: Int = UserDefaults.standard.integer(forKey: "money") {
        didSet {
            UserDefaults.standard.set(money, forKey: "money")
        }
    }
    
    @Published var chart: String = UserDefaults.standard.string(forKey: "chart") ?? "base_chart" {
        didSet {
            UserDefaults.standard.set(chart, forKey: "chart")
        }
    }
    
    init() {
        if !UserDefaults.standard.bool(forKey: "game_user_prefs_applyed") {
            money = 0
            chart = "base_chart"
            UserDefaults.standard.set(true, forKey: "game_user_prefs_applyed")
        }
    }
    
}
