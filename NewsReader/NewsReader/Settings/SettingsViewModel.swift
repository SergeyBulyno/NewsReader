//
//  SettingsViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//

import Foundation

final class SettingsViewModel {
    private let services: NewsListServices
    
    var intervalLabelText: String {
        return self.services.localizationProvider.string(forKey: "news_settings_interval_title", placeholder: "Интервал")
    }
    
    var articleSourceAvailabelLabelText: String {
        return self.services.localizationProvider.string(forKey: "news_settings_article_sources_available_title", placeholder: "Показывать источник")
    }
    
    var articleSourcesLabelText: String {
        return self.services.localizationProvider.string(forKey: "news_settings_article_sources_title", placeholder: "Источники:")
    }
    
    private var newsSources: [NewsSource]
    
    var sourcesValues: [String: Bool]!
    var itervalIndex: UInt!
    
    var sourcesOrder: [String] {
        return sourcesValues.keys.sorted()
    }
    
    let intervalPairs = [(1800, "30мин"),
                         (3600, "1час"),
                         (7200, "2часа"),
                         (10800, "3часа"),
                         (21600, "6часов"),
                         (86400, "день")]
   
    
    var intervalsLabelsText: [String] {
        return intervalPairs.map{ $0.1 }
    }

    private func setupInitValues() {
        self.sourcesValues = services.settings.enabledSources.filter { item in
            let name = newsSources.first{ $0.name == item.key }
            return name != nil
        }
        self.itervalIndex = UInt(intervalPairs.map { TimeInterval($0.0) }.firstIndex(of: services.settings.refreshInterval) ?? 1)
    }
    
    func saveSettings() {
        services.settings.enabledSources = sourcesValues
        services.settings.refreshInterval = TimeInterval(intervalPairs[Int(itervalIndex)].0)
    }
    
    init(services: NewsListServices,
         newsSources: [NewsSource]) {
        self.services = services
        self.newsSources = newsSources
        setupInitValues()
    }
}

extension SettingsViewModel: ViewModelControllerProtocol {
    var title: String {
        return self.services.localizationProvider.string(forKey: "news_settings_title", placeholder: "Настройки")
    }
}
