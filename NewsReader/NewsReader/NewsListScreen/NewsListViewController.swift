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
        viewModel.isLoadingClosure = { [weak self] isLoading in
            self?.showLoading(isLoading)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
//MARK: Loading indicator
    private var loadingIndicator: UIActivityIndicatorView?
    
    private func showLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator = UIActivityIndicatorView(style: .medium)
            loadingIndicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            loadingIndicator?.center = view.center
            loadingIndicator?.color = .gray
            if let loadingIndicator {
                view.addSubview(loadingIndicator)
                view.bringSubviewToFront(loadingIndicator)
            }
            loadingIndicator?.startAnimating()
        } else {
            loadingIndicator?.stopAnimating()
            loadingIndicator?.removeFromSuperview()
            loadingIndicator = nil
        }
    }
}

