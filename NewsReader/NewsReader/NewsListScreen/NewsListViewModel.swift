
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
    
    private let placeholderImage: UIImage
    
    init(services: NewsListServices) {
        self.services = services
        self.placeholderImage = UIImage(named:"placeholder")!
        startTimer()
    }
    
    deinit {
        print("[%@] deinit", Self.self)
        stopTimer()
    }
    
    var selectItemClosure:((NewsItemViewModel) ->Void)?
    
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
}

extension NewsListViewModel: ViewModelProtocol, ViewModelControllerProtocol {
    var title: String {
        return self.services.localizationProvider.string(forKey: "news_list_title", placeholder: "Новости")
    }
    
    typealias itemVM = NewsItemViewModel
    
    //MARK: - Fetch data
    func fetchData() {
        let sources = self.getEnabledSources()
        isLoading = sources.count > 0
        for source in sources {
            Task { @MainActor in
                do {
                    //TODO: Move to separated service
                    let remoteItems = try await RSSParser().parseFeed(url: source.url,
                                                                      sourceName: source.name)
                    
                    //let newArray = Array(remoteItems[0..<3])
                    let updatedWithRead = self.services.databaseService.updateWithRead(remoteItems)
                    let databaseService = self.services.databaseService
                    databaseService.saveNewsItems(updatedWithRead)
                    let items = databaseService.fetchNewsItems()
                    items.forEach({ print("Fetched db: \($0.isRead)")})
                    
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
    }
    
    private func showData(items: [NewsItemViewModel]) {
        //print("\(Thread.isMainThread) ")
        self.newsItems = items
        self.reloadDataClosure?(items)
    }
    
    private func getEnabledSources() -> [NewsSource] {
        let allSources = [
            //            NewsSource(name: "Ведомости",
            //                       url: "https://www.vedomosti.ru/rss/articles",
            //                       isEnabled: true),
            //                        NewsSource(name: "Лента.ру",
            //                                   url: "http://lenta.ru/rss",
            //                                   isEnabled: true),
            NewsSource(name: "RBC",
                       url:"http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/rbc.ru/news.rss",
                       isEnabled: true)
        ]
        
        return allSources
    }
}
