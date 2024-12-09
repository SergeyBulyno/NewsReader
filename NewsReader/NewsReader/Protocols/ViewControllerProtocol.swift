//
//  ViewControllerProtocol.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

protocol ViewControllerProtocol {
    var closeVCClosure: VoidClosure? { get set }
}

protocol ViewControllerReloadableProtocol {
    func reloadData()
}
