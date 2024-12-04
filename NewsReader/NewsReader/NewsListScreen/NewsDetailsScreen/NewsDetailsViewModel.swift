//
//  NewsDetailsViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//

class NewsDetailsViewModel {
    var urlString: String {
        return newsItem.link
    }
    private let services: NewsListServices
    private let newsItem: NewsItemViewModel
    
    init(services: NewsListServices,
         newsItem: NewsItemViewModel) {
        self.services = services
        self.newsItem = newsItem
    }
}

extension NewsDetailsViewModel: ViewModelControllerProtocol {
    var title: String {
        return self.services.localizationProvider.string(forKey: "news_details_title", placeholder: "Это интересно:")
    }
}
