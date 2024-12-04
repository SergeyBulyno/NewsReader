//
//  SettingsViewController.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//
import UIKit

final class SettingsViewController: UIViewController {
    
    private(set) var viewModel: SettingsViewModel
    
    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Invalid way of decoding this class")
    }
    
    deinit {
        print("[%@] deinit", Self.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = self.viewModel.title
        setupSubviews()
    }
     
    private func setupSubviews() {
        
    }
    
    
}
