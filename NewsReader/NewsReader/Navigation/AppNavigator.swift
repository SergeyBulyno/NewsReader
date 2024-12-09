//
//  AppNavigator.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/9/24.
//
import UIKit

protocol NavigatorProtocol {
    var navigationController: UINavigationController { get set }
    func show(viewController: UIViewController, animated: Bool)
    func hide(viewController: UIViewController?, animated: Bool)
}

class AppNavigator: NavigatorProtocol {
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func show(viewController: UIViewController, animated: Bool) {
        self.navigationController.pushViewController(viewController, animated: animated)
    }
    
    func hide(viewController: UIViewController?, animated: Bool) {
        self.navigationController.popViewController(animated: animated)
    }
}
