//
//  NewsItemViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

import Foundation
import UIKit

class NewsItemViewModel {
    private(set) var id: UUID
    private(set) var guid: String
    private(set) var title: String
    private(set) var newsDescription: String
    private(set) var pubDate: Date
    private(set) var pubDateFormatted: String
    private(set) var sourceName: String
    private(set) var link: String
    private(set) var imageUrl: String
    var isRead: Bool
    var tagColor: UIColor?
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
    var markAsReadClosure: VoidClosure?
    private let imageCacheService: ImageCacheService
    init(newsItem: NewsItem,
         dateFormatter: DateFormatter,
         isExtpandedMode: Bool = false,
         placeholderImage: UIImage,
         imageCacheService: ImageCacheService) {
        self.id = newsItem.id
        self.guid = newsItem.guid
        
        self.title = newsItem.title
        self.newsDescription = newsItem.newsDescription
        self.pubDate = newsItem.pubDate
        self.pubDateFormatted = dateFormatter.string(from: pubDate)
        self.sourceName = newsItem.sourceName
        self.link = newsItem.link
        self.imageUrl = newsItem.imageUrl
        self.isRead = newsItem.isRead
        
        self.isExpanded = isExtpandedMode
        self.placeholderImage = placeholderImage
        self.imageCacheService = imageCacheService
    }
    
    func fetchImage(urlString: String) async throws -> UIImage {
        return try await self.imageCacheService.loadCachedImage(from: urlString)
    }
    
    func updateTitle() {
        print("!!Thread prepare: \(Thread.isMainThread)")
        self.title = "[SB]" + title
    }
    func markAsRead() {
        self.isRead = true
        self.markAsReadClosure?()
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
