//
//  NewsListViewController.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import UIKit

class NewsListViewController: UIViewController {
    private(set) var viewModel: NewsListViewModel
    
    init(_ newsViewModel: NewsListViewModel) {
        viewModel = newsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    

}

