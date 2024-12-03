//
//  NewsItemViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

import Foundation

class NewsItemViewModel {
    var id: UUID {
        return newsItem.uuid
    }
    
    private(set) var newsItem: NewsItem

    var title: String {
        return newsItem.title
    }

    var description: String {
        return newsItem.newsDescription
    }

    var pubDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: newsItem.pubDate)
    }

    var sourceName: String {
        return newsItem.sourceName
    }

    var imageUrl: String {
        return newsItem.imageUrl
    }

    var isRead: Bool {
        return newsItem.isRead
    }

    var isExpanded : Bool {
        didSet {
            updateLayoutClosure?()
        }
    }
    
    var sourceIsAvailable: Bool = true
    
    var updateLayoutClosure: VoidClosure?
    
    init(newsItem: NewsItem, isExtpandedMode: Bool = false) {
        self.newsItem = newsItem
        self.isExpanded = isExtpandedMode
    }

}

extension NewsItemViewModel: Hashable {
    static func == (lhs: NewsItemViewModel, rhs: NewsItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
