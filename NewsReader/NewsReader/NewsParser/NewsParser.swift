//
//  NewsParser.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/9/24.
//

import Foundation

protocol NewsParserProtocol {
    func fetchAndParseFeed(urlSourcePairs: [(String, String)]) async throws -> [NewsItem];
}

class NewsParser: NewsParserProtocol {
    
    func fetchAndParseFeed(urlSourcePairs: [(String, String)]) async throws -> [NewsItem] {
        let items = try await withThrowingTaskGroup(of: [NewsItem].self) { group in
            urlSourcePairs.forEach { item in
                group.addTask {
                    try await NewsRSSParser().parseFeed(url: item.0,
                                                        sourceName: item.1)
                }
            }
            return try await group.reduce(into: [NewsItem]()) { $0.append(contentsOf: $1) }
        }
        return items
    }
}
