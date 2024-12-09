//
//  LabelSwitchView.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/5/24.
//
import Foundation
import UIKit

class LabelSwitchView: UIView {
    
    var switchClosure: ResultClosure?
    
    let label = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let switcher = {
        let switcher = UISwitch()
        switcher.backgroundColor = .white
        switcher.onTintColor = .gray
        return switcher
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(Self.self, " deinit")
    }
    
    private func setupSubviews() {
        addSubview(label)
        addSubview(switcher)
        switcher.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
    }
    
    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        switcher.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: switcher.leadingAnchor, constant: -6),
            
            switcher.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            switcher.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func setSwitchOn(_ on: Bool = true, animated: Bool = true) {
        switcher.setOn(on, animated: animated)
    }
    
    @objc func didSwitch() {
        switchClosure?(switcher.isOn)
    }
   
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 30)
    }
}
