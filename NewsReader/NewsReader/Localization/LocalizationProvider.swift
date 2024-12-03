//
//  LocalizationProvider.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//

class LocalizationProvider {
    
    func string(forKey: String, fromTable: String? = nil, placeholder: String? = nil) -> String {
        return placeholder ?? ""
    }
    
}
