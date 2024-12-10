//
//  NewsListServices.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

struct NewsListServices {
    let settings: AppSettings
    let parser: NewsParser
    let imageCacheService: ImageCacheService
    let databaseService: NewsDatabaseService
    let localizationProvider: LocalizationProvider
    
    func clearCaches() {
        print("cache will clear!")
        imageCacheService.clearCache()
        databaseService.clearCache()
    }
}
