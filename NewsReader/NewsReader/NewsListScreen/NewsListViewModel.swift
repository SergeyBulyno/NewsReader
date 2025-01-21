
//
//  NewsListViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import Foundation
import UIKit
import RealmSwift

final class NewsListViewModel {
    var isLoadingClosure: ResultClosure?
    var reloadDataClosure: (([NewsItemViewModel]) -> Void)?
    //TODO: use combine and observable
    var isLoading: Bool = false {
        didSet {
            self.isLoadingClosure?(isLoading)
        }
    }
    private var timer: Timer?
    private(set) var newsItems: [NewsItemViewModel] = []
    private let services: NewsListServices
    private let newsSources: [NewsSource]
    
    private let placeholderImage: UIImage
    
    init(services: NewsListServices,
         newsSources: [NewsSource]) {
        self.services = services
        self.newsSources = newsSources
        self.placeholderImage = UIImage(named:"placeholder")!
        startTimer()
    }
    
    deinit {
        print(Self.self, " deinit")
        stopTimer()
    }
    
    var selectItemClosure:((NewsItemViewModel) ->Void)?
    var openSettingsClosure:VoidClosure?
    
    func selectItem(at indexPath: IndexPath) {
        guard indexPath.row < newsItems.count else { return }
        self.selectItemClosure?(newsItems[indexPath.row])
    }
    
    //MARK: - Timer functionality
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: services.settings.refreshInterval, repeats: true, block: { [weak self] _ in
            self?.fetchData()
        })
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func updateSettings() {
        fetchData()
    }
    
    func clearCache() {
        showData(items: [])
    }
    
}

extension NewsListViewModel: ViewModelLoadableProtocol, ViewModelControllerProtocol {
    var title: String {
        return self.services.localizationProvider.string(forKey: "news_list_title", placeholder: "Новости")
    }
    
    typealias itemVM = NewsItemViewModel
    
    //MARK: - Fetch data
    func fetchData() {
        let sources = self.getEnabledSources()
        isLoading = sources.count > 0 && newsItems.count == 0
        
        Task { @MainActor in
            do {
                let remoteItems = try await self.services.parser.fetchAndParseFeed(urlSourcePairs: sources.map{ ($0.url, $0.name) })
                let databaseService = self.services.databaseService
                let updatedWithRead = databaseService.updateWithRead(remoteItems)
                databaseService.saveNewsItems(updatedWithRead)
                
                let items = databaseService.fetchNewsItems(sourceNames: sources.map{ $0.name })
                var vmItems = convertToViewModels(items: items)
                vmItems = await makeBeauty(items: vmItems)
                print("!!Thread db1: \(Thread.isMainThread)")
                self.showData(items: vmItems)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("!!Thread db2: \(Thread.isMainThread)")
                    self.showData(items: vmItems)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    print("!!Thread db3: \(Thread.isMainThread)")
                    self.showData(items: vmItems)
                }
            } catch let error {
                print((error as? RSSError)?.localizedDescription ?? "")
            }
            self.isLoading = false
        }
    }
    
    private func showData(items: [NewsItemViewModel]) {
        Task { @MainActor in
            let update = await self.shouldUpdateData(items)
            if update {
                print("!!Thread update: \(Thread.isMainThread)")
                self.newsItems = items
                self.reloadDataClosure?(items)
            }
        }
    }
    
    private func shouldUpdateData(_ items: [NewsItemViewModel]) async -> Bool {
        print("!!Thread check: \(Thread.isMainThread)")
        return self.newsItems != items
    }
    
    private func getEnabledSources() -> [NewsSource] {
        let enabledSources = services.settings.enabledSources
        return newsSources.filter{source in
            return enabledSources[source.name] ?? source.isEnabled
        }
    }
    
    private func convertToViewModels(items: [NewsItem]) -> [NewsItemViewModel] {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            let vmItems = items.map {
                return NewsItemViewModel(newsItem: $0,
                                         dateFormatter: formatter,
                                         placeholderImage: self.placeholderImage,
                                         imageCacheService: self.services.imageCacheService)
            }
        return vmItems
    }
    
    private func makeBeauty(items: [NewsItemViewModel]) async -> [NewsItemViewModel] {
        items.forEach({ $0.updateTitle()})
        return items
    }
    
}
