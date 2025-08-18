//
//  UIViewController+Extention.swift
//  ToDoTracker
//
//  Created by Max on 18.08.2025.
//

import UIKit
import ObjectiveC

extension UIViewController {
    @objc func xai_swizzled_viewDidLoad() {
        self.xai_swizzled_viewDidLoad()
        if self.navigationItem.backBarButtonItem == nil {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        }
    }
}

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let navBarAppearance = UINavigationBar.appearance()

    // Цвет иконки (стрелка назад)
    navBarAppearance.tintColor = .systemYellow

    // Цвет текста кнопки назад
    let backBarAppearance = UIBarButtonItem.appearance()
    backBarAppearance.setTitleTextAttributes([.foregroundColor: UIColor.systemYellow], for: .normal)
    
    // Swizzling для добавления надписи "Назад" глобально
    let originalSelector = #selector(UIViewController.viewDidLoad)
    let swizzledSelector = #selector(UIViewController.xai_swizzled_viewDidLoad)
    let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)!
    let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)!
    method_exchangeImplementations(originalMethod, swizzledMethod)
    
    return true
}
