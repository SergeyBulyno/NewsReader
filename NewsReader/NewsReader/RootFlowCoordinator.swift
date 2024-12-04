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
        let newsServices = NewsListServices(settings: AppSettings(),
                                            parser: RSSParser(),
                                            imageCacheService: ImageCacheService(),
                                            databaseService: NewsDatabaseService(),
                                            localizationProvider: LocalizationProvider())
        let viewModel = NewsListViewModel(services: newsServices)
        viewModel.selectItemClosure = { [weak self] newsItem in
            guard let self else { return }
            self.showNewsDetailsViewController(services: newsServices,
                                               newsItemVM: newsItem)
        }
        viewModel.openSettingsClosure = { [weak self] in
            guard let self else { return }
            self.showSettingsViewController(services: newsServices)
        }
        
        newsViewController = NewsListViewController(viewModel)
        navigationController.pushViewController(newsViewController!, animated: true)
    }
    
    private func showSettingsViewController(services: NewsListServices) {
        let viewModel = SettingsViewModel(services: services)
        let viewController = SettingsViewController(viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showNewsDetailsViewController(services: NewsListServices,
                                               newsItemVM: NewsItemViewModel) {
        let databaseService = services.databaseService
        databaseService.markAsRead(newsItemVM.newsItem)
        newsItemVM.markAsReadClosure?()
    
        let viewModel = NewsDetailsViewModel(services: services,
                                             newsItem: newsItemVM)
        let viewController = NewsDetailsViewController(viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
