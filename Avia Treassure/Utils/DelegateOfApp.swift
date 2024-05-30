import Foundation
import SwiftUI

class DelegateOfApp: NSObject, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.landscape

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return DelegateOfApp.orientationLock
    }
    
}
