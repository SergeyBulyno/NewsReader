//
//  Dictionary+Sugar.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/5/24.
//

extension Dictionary {
    
    static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }
}
