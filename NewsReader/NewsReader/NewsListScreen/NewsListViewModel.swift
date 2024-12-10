
//
//  NewsListViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import Foundation
import UIKit
import RealmSwift

final class NewsListViewModel {
    var isLoadingClosure: ResultClosure?
    var reloadDataClosure: (([NewsItemViewModel]) -> Void)?
    //TODO: use combine and observable
    var isLoading: Bool = false {
        didSet {
            self.isLoadingClosure?(isLoading)
        }
    }
    private var timer: Timer?
    private(set) var newsItems: [NewsItemViewModel] = []
    private let services: NewsListServices
    private let newsSources: [NewsSource]
    
    private let placeholderImage: UIImage
    
    init(services: NewsListServices,
         newsSources: [NewsSource]) {
        self.services = services
        self.newsSources = newsSources
        self.placeholderImage = UIImage(named:"placeholder")!
        startTimer()
    }
    
    deinit {
        print(Self.self, " deinit")
        stopTimer()
    }
    
    var selectItemClosure:((NewsItemViewModel) ->Void)?
    var openSettingsClosure:VoidClosure?
    
    func selectItem(at indexPath: IndexPath) {
        guard indexPath.row < newsItems.count else { return }
        self.selectItemClosure?(newsItems[indexPath.row])
    }
    
    //MARK: - Timer functionality
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: services.settings.refreshInterval, repeats: true, block: { [weak self] _ in
            self?.fetchData()
        })
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func updateSettings() {
        fetchData()
    }
    
    func clearCache() {
        showData(items: [])
    }
    
}

extension NewsListViewModel: ViewModelLoadableProtocol, ViewModelControllerProtocol {
    var title: String {
        return self.services.localizationProvider.string(forKey: "news_list_title", placeholder: "Новости")
    }
    
    typealias itemVM = NewsItemViewModel
    
    //MARK: - Fetch data
    func fetchData() {
        let sources = self.getEnabledSources()
        isLoading = sources.count > 0 && newsItems.count == 0
        
        Task { @MainActor in
            do {
                let remoteItems = try await self.services.parser.fetchAndParseFeed(urlSourcePairs: sources.map{ ($0.url, $0.name) })
                let databaseService = self.services.databaseService
                let updatedWithRead = databaseService.updateWithRead(remoteItems)
                databaseService.saveNewsItems(updatedWithRead)
                
                let items = databaseService.fetchNewsItems(sourceNames: sources.map{ $0.name })
                filterItems(items)
                let vmItems = items.map {
                    return NewsItemViewModel(newsItem: $0,
                                             placeholderImage: placeholderImage,
                                             imageCacheService: services.imageCacheService)
                }
                self.showData(items: vmItems)
            } catch let error {
                print((error as? RSSError)?.localizedDescription ?? "")
            }
            self.isLoading = false
        }
    }
    
    private func showData(items: [NewsItemViewModel]) {
        //print("\(Thread.isMainThread) ")
        self.newsItems = items
        self.reloadDataClosure?(items)
    }
    
    private func getEnabledSources() -> [NewsSource] {
        let enabledSources = services.settings.enabledSources
        return newsSources.filter{source in
            return enabledSources[source.name] ?? source.isEnabled
        }
    }
    
    private func filterItems(_ items: [NewsItem]) {
        items.forEach { item in
            let found = items.first{
                if item === $0 {
                    return false
                }
                return $0.id == item.id
            }
            if found != nil {
                print("!!!!!id\(item) - \(found!)")
            }
        }
    }
}
