//
//  ViewModelProtocol.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

typealias VoidClosure = () -> Void
typealias ResultClosure = (Bool) -> Void

protocol ViewModelLoadableProtocol {
    associatedtype itemVM
    func fetchData()
    
    var isLoadingClosure: ResultClosure? { get set }
    var reloadDataClosure: (([itemVM]) -> Void)? { get set }
}

protocol ViewModelControllerProtocol {
    var title: String {get}
}
