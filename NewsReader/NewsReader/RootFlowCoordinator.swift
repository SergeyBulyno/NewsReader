//
//  RootFlowCoordinator.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import UIKit

class RootFlowCoordinator: FlowCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showNewsViewController()
    }
    
    func stop() {
        
    }
    
    private var newsViewController: NewsListViewController?
    private func showNewsViewController() {
        
        newsViewController = NewsListViewController()
        navigationController.pushViewController(newsViewController!, animated: true)
    }
    
    private func showSettingsViewController() {
        
    }
    
    private func showNewsDetailsViewController() {
        
    }
}
