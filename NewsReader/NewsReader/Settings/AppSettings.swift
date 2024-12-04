//
//  AppSettings.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//
import Foundation

class AppSettings {

    private let refreshIntervalKey = "refreshInterval"
    private let enabledSourcesKey = "enabledSources"

    var refreshInterval: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: refreshIntervalKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: refreshIntervalKey)
        }
    }

    var enabledSources: [String: Bool] {
        get {
            return UserDefaults.standard.dictionary(forKey: enabledSourcesKey) as? [String: Bool] ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: enabledSourcesKey)
        }
    }

    init() {
        if UserDefaults.standard.object(forKey: refreshIntervalKey) == nil {
            //refreshInterval = 1800 // 30 минут
            refreshInterval = 10
        }
    }
}

