//
//  NewsItem.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import Foundation

class NewsItem {
    var id: String {
        return uuid.uuidString
    }
    var uuid: UUID = UUID()
    var title: String = ""
    var link: String = ""
    var newsDescription: String = ""
    var pubDate: Date = Date()
    var imageUrl: String = ""
    var sourceName: String = ""
    var isRead: Bool = false
    
}
