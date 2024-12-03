//
//  UICollectionViewCell+ReuseIdentifier.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
