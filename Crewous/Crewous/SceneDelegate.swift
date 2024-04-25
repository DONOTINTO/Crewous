//
//  SceneDelegate.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // MARK: Navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.shadowColor = .clear
        // 일반 네이게이션 바 appearance settings
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        // 랜드스케이프 되었을 때 네이게이션 바 appearance settings
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        // 스크롤 엣지가 닿았을 때 네이게이션 바 appearance settings
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // MARK: Tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .clear
        tabBarAppearance.shadowColor = .clear
        // 스크롤 엣지가 닿았을 때 탭바 appearance settings
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        // 일반 탭바 appearance settings
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        
        let rootVC = SignInViewController()
        let naviVC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = naviVC
        
        #if DEBUG
        if UDManager.isLogin {
            
            let tabVC = makeTabVC()
            
            self.window?.rootViewController = tabVC
            
        } else {
            
            let rootVC = SignInViewController()
            let naviVC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = naviVC
        }
        #endif
        
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func makeTabVC() -> UITabBarController {
     
        let statsVC = StatsViewController()
        let statsNaviVC = UINavigationController(rootViewController: statsVC)
        
        let myCrewVC = MyCrewViewController()
        let myCrewNaviVC = UINavigationController(rootViewController: myCrewVC)
        
        let searchVC = SearchViewController()
        let SearchNaviVC = UINavigationController(rootViewController: searchVC)
        
        let tabVC = UITabBarController()
        tabVC.setViewControllers([statsNaviVC, myCrewNaviVC, SearchNaviVC], animated: true)
        tabVC.tabBar.items?[0].image = UIImage(systemName: "house")?.withTintColor(.customGray, renderingMode: .alwaysOriginal)
        tabVC.tabBar.items?[0].selectedImage = UIImage(systemName: "house.fill")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        tabVC.tabBar.items?[1].image = UIImage(systemName: "person.3.fill")?.withTintColor(.customGray, renderingMode: .alwaysOriginal)
        tabVC.tabBar.items?[1].selectedImage = UIImage(systemName: "person.3.fill")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        tabVC.tabBar.items?[2].image = UIImage(systemName: "magnifyingglass")?.withTintColor(.customGray, renderingMode: .alwaysOriginal)
        tabVC.tabBar.items?[2].selectedImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        
        return tabVC
    }
}

