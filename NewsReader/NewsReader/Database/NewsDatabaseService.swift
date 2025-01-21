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
    
    func fetchNewsItems(sourceNames: [String]?) -> [NewsItem] {
        return fetchNewsItemSortedByDate(sourceNames: sourceNames) ?? []
    }
    
    func fetchNewsItemSortedByDate(sourceNames: [String]?) -> [NewsItem]? {
        guard let sourceNames = sourceNames, sourceNames.count > 0 else {
            return []
        }
        return db.fetchResults(by: NewsItem.self)?.filter({ item in
            return sourceNames.contains{ $0 == item.sourceName}
        }).sorted(by: { item1, item2 in
            return item1.pubDate > item2.pubDate
        })
    }
    
    func fetchItem(forID id: String) -> NewsItem? {
        return db.fetchObject(by: NewsItem.self, key: id)
    }
    
    
    func fetchAllNews() -> [NewsItem] {
        return db.fetch(by: NewsItem.self)
    }
    
    func markAsRead(_ itemID: String) {
        guard let item = fetchItem(forID: itemID) else { return }
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
