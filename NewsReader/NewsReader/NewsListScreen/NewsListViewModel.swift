
//
//  NewsListViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import Foundation
import UIKit

class NewsListViewModel {
    var isLoadingClosure: ResultClosure?
    var reloadDataClosure: (([NewsItemViewModel]) -> Void)?
    //TODO: use combine and observable
    var isLoading: Bool = false {
        didSet {
            self.isLoadingClosure?(isLoading)
        }
    }
    
    private(set) var newsItems: [NewsItemViewModel] = []
    private let services: NewsListServices
    
    private let placeholderImage: UIImage
    init(newsServices: NewsListServices) {
        services = newsServices
        placeholderImage = UIImage(named:"placeholder")!
    }
}

extension NewsListViewModel: ViewModelProtocol {
    var title: String {
        return self.services.localizationProvider.string(forKey: "news_title", placeholder: "Новости")
    }
    
    typealias itemVM = NewsItemViewModel
    
    //MARK: - Fetch data
    func fetchData() {
        let sources = self.getEnabledSources()
        isLoading = sources.count > 0
        for source in sources {
            Task {
                do {
                    let items = try await RSSParser().parseFeed(url: source.url,
                                                                sourceName: source.name)
                    let vmItems = items.map { NewsItemViewModel(newsItem: $0, placeholderImage: placeholderImage, imageCacheService: services.imageCacheService) }
                    DispatchQueue.main.async { [weak self] in
                        self?.showData(items: vmItems)
                    }
                    //                   print("\(Thread.isMainThread) ")
                    //print("\(items)")
                } catch let error {
                    print((error as? RSSError)?.localizedDescription ?? "")
                }
                //TODO: Use MainActor
                DispatchQueue.main.async {[weak self] in
                    self?.isLoading = false
                    
                }
            }
        }
    }
    
    private func showData(items: [NewsItemViewModel]) {
        self.newsItems = items
        self.reloadDataClosure?(items)
    }
    
    private func getEnabledSources() -> [NewsSource] {
        let allSources = [
            //                            NewsSource(name: "Ведомости",
            //                                                      url: "https://www.vedomosti.ru/info/rss",
            //                                                      isEnabled: true),
//            NewsSource(name: "Лента.ру",
//                       url: "http://lenta.ru/rss",
//                       isEnabled: true),
            NewsSource(name: "RBC",
                       url:"http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/rbc.ru/news.rss",
                       isEnabled: true)
        ]
        
        return allSources
    }
}
