import SwiftUI

@main
struct Avia_TreassureApp: App {
    
    @UIApplicationDelegateAdaptor(DelegateOfApp.self) var delegateOfApp
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
