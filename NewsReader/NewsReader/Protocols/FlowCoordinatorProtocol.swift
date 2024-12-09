//
//  FlowCoordinatorProtocol.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import UIKit

protocol FlowCoordinatorProtocol {
    var navigator: NavigatorProtocol { get }
    var stopClosure: VoidClosure? { get set }
    func start()
    func stop()
}
