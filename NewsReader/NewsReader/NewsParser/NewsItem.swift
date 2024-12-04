//
//  NewsItem.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import Foundation
import RealmSwift

class NewsItem: Object {
    @Persisted var id: UUID
    @Persisted(primaryKey: true) var guid: String = ""
    @Persisted var title: String = ""
    @Persisted var link: String = ""
    @Persisted var newsDescription: String = ""
    @Persisted var pubDate: Date = Date()
    @Persisted var imageUrl: String = ""
    @Persisted var sourceName: String = ""
    @Persisted var isRead: Bool = false
    
}
