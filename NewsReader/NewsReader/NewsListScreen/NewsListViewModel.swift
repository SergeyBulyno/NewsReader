
//
//  NewsListViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import Foundation
typealias VoidClosure = () -> Void
typealias ResultClosure = (Bool) -> Void
//typealias NewsItemsClosure = (Bool) -> Void


protocol ViewModelProtocol {
    func fetchData()
    
    var isLoadingClosure: ResultClosure? { get set }
    //var reloadData: (([NewsItem])->Void)? { get set }
}

class NewsListViewModel {
    var isLoadingClosure: ((Bool) -> Void)?
    //TODO: use combine and observable
    var isLoading: Bool = false {
        didSet {
            self.isLoadingClosure?(isLoading)
        }
    }
    
    private let services: NewsListServices
    
    init(newsServices: NewsListServices) {
        services = newsServices
    }
}

extension NewsListViewModel: ViewModelProtocol {
    //MARK: - Fetch data
    func fetchData() {
        let sources = self.getEnabledSources()
        isLoading = sources.count > 0
        for source in sources {
            Task {
                do {
                    let items = try await RSSParser().parseFeed(url: source.url,
                                                                    sourceName: source.name)
//                    print("\(Thread.isMainThread) ")
//                    print("\(items)")
                } catch let error {
                    
                    print((error as? RSSError)?.localizedDescription ?? "")
                }
                DispatchQueue.main.async {[weak self] in
                    self?.isLoading = false
                }
            }
        }
    }
    
    func getEnabledSources() -> [NewsSource] {
        let allSources = [
//                            NewsSource(name: "Ведомости",
//                                                      url: "https://www.vedomosti.ru/info/rss",
//                                                      isEnabled: true),
            NewsSource(name: "Лента.ру",
                       url: "http://lenta.ru/rss",
                       isEnabled: true),
            NewsSource(name: "RBC",
                       url:"http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/rbc.ru/news.rss",
                       isEnabled: true)
        ]
        
        return allSources
    }
}
