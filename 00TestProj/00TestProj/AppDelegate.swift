//
//  AppDelegate.swift
//  00TestProj
//
//  Created by Александр Фофонов on 26.01.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum UserDefaultStorageKeys: String {
        case lastSessionDate = "last session date"
        case profile = "profile"
    }
    
    let assembly = Assembly()
    lazy var dataStorage = assembly.dataStorage
    lazy var apiClient = assembly.apiClient
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        apiClient.request(
            ProfileResponseData.self,
            url: Bundle.main.url(forResource: "Profile", withExtension: "json")
        ) { result in
            // выходим, если теряем селф, так как и нечего тут больше делать
            guard let self = self else {
                return
            }
            
            switch result {
            case .succeess(let data):
                self.dataStorage.save(value: data.data?.profile, key: UserDefaultStorageKeys.profile)
            case error(let error):
                print("[Api] \(error)")
            }
        }
        
        
        // код apiClientа ассинхронен, сюда можем без всего войти
//        if let profile: Profile = dataStorage.value(key: UserDefaultStorageKeys.profile) {
//            print(profile)
//        }
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    
    }

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

}
