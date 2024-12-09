//
//  RootFlowCoordinator.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import UIKit

class RootFlowCoordinator: FlowCoordinatorProtocol {
    var stopClosure: VoidClosure?
    var navigator: NavigatorProtocol
    
    init(navigator: NavigatorProtocol) {
        self.navigator = navigator
    }
    
    private let settings = AppSettings()
    private func updateSettings() {
        var mappedSources = [String: Bool]()
        NewsSource.enabledSources.forEach({
            mappedSources[$0.name] = $0.isEnabled
        })
        settings.updateSources(mappedSources)
    }
    
    func start() {
        updateSettings()
        showNewsViewController()
    }
    
    func stop() {
        
    }
    
    private var newsViewController: NewsListViewController?
    private func showNewsViewController() {
        let newsServices = NewsListServices(settings: settings,
                                            parser: NewsParser(),
                                            imageCacheService: ImageCacheService(),
                                            databaseService: NewsDatabaseService(),
                                            localizationProvider: LocalizationProvider())
        let newsSources = NewsSource.enabledSources
        let viewModel = NewsListViewModel(services: newsServices,
                                          newsSources: newsSources)
        viewModel.selectItemClosure = { [weak self] newsItem in
            guard let self else { return }
            self.showNewsDetailsViewController(services: newsServices,
                                               newsItemVM: newsItem)
        }
        viewModel.openSettingsClosure = { [weak self] in
            guard let self else { return }
            self.showSettingsViewController(services: newsServices,
                                            newsSources: newsSources) {[weak viewModel] in
                viewModel?.updateSettings()
            }
        }
        
        newsViewController = NewsListViewController(viewModel)
        navigator.show(viewController: newsViewController!, animated: true)
    }
    
    private func showNewsDetailsViewController(services: NewsListServices,
                                               newsItemVM: NewsItemViewModel) {
        let databaseService = services.databaseService
        databaseService.markAsRead(newsItemVM.newsItem)
        newsItemVM.markAsReadClosure?()
        
        let viewModel = NewsDetailsViewModel(services: services,
                                             newsItem: newsItemVM)
        let viewController = NewsDetailsViewController(viewModel)
        navigator.show(viewController: viewController, animated: true)
    }
    
    private func showSettingsViewController(services: NewsListServices,
                                            newsSources: [NewsSource],
                                            updateClosure: @escaping VoidClosure) {
        let viewModel = SettingsViewModel(services: services,
                                          newsSources: newsSources)
        let viewController = SettingsViewController(viewModel)
        viewController.closeVCClosure = updateClosure
        navigator.show(viewController: viewController, animated: true)
    }
    
}

extension NewsSource {
    static var enabledSources: [NewsSource] {
        return [
            NewsSource(name: "Ведомости",
                       url: "https://www.vedomosti.ru/rss/articles",
                       isEnabled: true),
            NewsSource(name: "BBC",
                       url: "http://feeds.bbci.co.uk/news/rss.xml",
                       isEnabled: false),
            NewsSource(name: "RBC",
                       url:"http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/rbc.ru/news.rss",
                       isEnabled: true)
        ]
        
    }
}


