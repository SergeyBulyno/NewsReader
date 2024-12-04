//
//  NewsItemViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

import Foundation
import UIKit

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
    
    var link: String {
        return newsItem.link
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
    
    var sourceAvailable: Bool = true
    var imageAvailable: Bool {
        return !imageUrl.isEmpty
    }
    
    private(set) var placeholderImage: UIImage?
    var updateLayoutClosure: VoidClosure?
    private let imageCacheService: ImageCacheService
    init(newsItem: NewsItem,
         isExtpandedMode: Bool = false,
         placeholderImage: UIImage,
         imageCacheService: ImageCacheService) {
        self.newsItem = newsItem
        self.isExpanded = isExtpandedMode
        self.placeholderImage = placeholderImage
        self.imageCacheService = imageCacheService
    }
    
    func fetchImage() async throws -> UIImage {
        return try await self.imageCacheService.loadCachedImage(from: imageUrl)
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
