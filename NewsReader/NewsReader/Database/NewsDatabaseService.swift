//
//  NewsDatabaseService.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//
import RealmSwift

class NewsDatabaseService {
    private let db: DatabaseService
        
    init(db: DatabaseService = DatabaseService()) {
        self.db = db
    }
    
    func saveNewsItems(_ items: [NewsItem]) {
        try? db.saveOrUpdateAllObjects(objects: items)
    }
    
    func fetchNewsItems() -> [NewsItem] {
        guard let sortedItems = fetchNewsItemSorted() else { return []}
        return sortedItems.toArray()
    }
    
    func fetchNewsItemSorted() -> Results<NewsItem>? {
        return db.fetchResults(by: NewsItem.self)?.sorted(byKeyPath: "pubDate", ascending: false)
    }
    
    func fetchAllNews() -> [NewsItem] {
        return db.fetch(by: NewsItem.self)
    }
    
    func markAsRead(_ item: NewsItem) {
        try? db.update({
            item.isRead = true
        })
    }
    
    func clearCache() {
        try? db.deleteAll()
    }
}

extension NewsDatabaseService {
    func updateWithRead(_ items: [NewsItem]) -> [NewsItem] {
        let mappedItems = items.map { item in
            if let it = db.fetchObject(by: NewsItem.self, key: item.guid) {
                item.isRead = it.isRead
            }
            return item
        }
        return mappedItems
    }
}
