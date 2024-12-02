
//
//  NewsListViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import Foundation

protocol ViewModelProtocol {
    func fetchData()
}

class NewsListViewModel {
    private let services: NewsListServices
    
    init(newsServices: NewsListServices) {
        services = newsServices
        fetchData()
    }
    
    
}

extension NewsListViewModel: ViewModelProtocol {
    //MARK: - Fetch data
    func fetchData() {
        let sources = self.getEnabledSources()
        for source in sources {
            Task {
                   do {
                       let items = try await services.parser.parseFeed(url: source.url,
                                                                       sourceName: source.name)
                       print("\(Thread.isMainThread) ")
                       print("\(items)")
                   } catch let error {
                       print((error as? RSSError)?.localizedDescription ?? "")
                   }
               }
        }
    }

    func getEnabledSources() -> [NewsSource] {
        let allSources = [
//                NewsSource(name: "Ведомости",
//                                          url: "https://www.vedomosti.ru/info/rss",
//                                          isEnabled: true),
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
