//
//  RSSParser.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

import Foundation

final class RSSParser: NSObject {
    private var currentElement = ""
    private var currentItem: NewsItem?
    private var currentPubDate: String = ""
    private var items: [NewsItem] = []
    private var currentSourceName = ""
    
    private var parserContinuation: CheckedContinuation<[NewsItem], Error>?
    
    func parseFeed(url: String, sourceName: String) async throws -> [NewsItem] {
        guard let feedURL = URL(string: url) else { throw RSSError.invalidRequest }
        currentSourceName = sourceName
        let request = URLRequest(url: feedURL)
        let session = URLSession.init(configuration: .default)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RSSError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw RSSError.invalidResponseCode(httpResponse.statusCode)
        }
        
//        let str = String(decoding: data, as: UTF8.self)
//        print(str)
        
        return try await withCheckedThrowingContinuation { continuation in
            parserContinuation = continuation
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
    }
}

extension RSSParser: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        items = []
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //delegate?.didParseItems(items)
        parserContinuation?.resume(returning: items)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error: \(parseError)")
        parserContinuation?.resume(throwing: RSSError.invalidRSS(String(describing: parseError)))
       // delegate?.didFailWithError(parseError)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentItem?.title += string
        case "link":
            currentItem?.link += string
        case "description":
            currentItem?.newsDescription += string
        case "pubDate":
            currentPubDate += string
        case "guid":
            currentItem?.guid += string
        case "enclosure":
            // Handle in `didStartElement`
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String]) {
        
        currentElement = elementName
        
        if elementName == "item" {
            currentItem = NewsItem()
            currentPubDate = ""
            currentItem?.sourceName = currentSourceName
        }
        
        if elementName == "enclosure", let urlString = attributeDict["url"] {
            currentItem?.imageUrl = urlString
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        
        if elementName == "item", let item = currentItem {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
            if let date = formatter.date(from: currentPubDate) {
                item.pubDate = date
            }
            
            items.append(item)
            currentItem = nil
            currentPubDate = ""
        }
        
        currentElement = ""
    }
}
