//
//  SettingsViewModel.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//

final class SettingsViewModel {
    private let services: NewsListServices
    
    init(services: NewsListServices) {
        self.services = services
    }
}

extension SettingsViewModel: ViewModelControllerProtocol {
    var title: String {
        return self.services.localizationProvider.string(forKey: "news_settings_title", placeholder: "Настройки")
    }
}
