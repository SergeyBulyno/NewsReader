//
//  ImageCacheService.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//
import UIKit
import Foundation

class ImageCacheService {
    private let cache = NSCache<NSString, UIImage>()

    init() {}
    
    func loadCachedImage(from urlString: String) async throws -> UIImage {
        if let image = cache.object(forKey: urlString as NSString) {
            return image
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let image = try await loadImage(for: url)
        self.cache.setObject(image, forKey: urlString as NSString)
        return image
    }
    
    func loadImageData(for url: URL) async throws -> Data {
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
    
    func loadImage(for url: URL) async throws -> UIImage {
        let data = try await loadImageData(for: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        //print("\(Thread.isMainThread)")
        return image
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
