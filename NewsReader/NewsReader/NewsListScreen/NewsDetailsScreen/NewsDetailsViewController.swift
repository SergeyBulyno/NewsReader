//
//  NewsDetailsViewController.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//

import Foundation
import WebKit

class NewsDetailsViewController: UIViewController {
    
    private(set) var viewModel: NewsDetailsViewModel
    private weak var webView: WKWebView!
    
    init(_ viewModel: NewsDetailsViewModel) {
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
        webView.load(URLRequest(url: URL(string: viewModel.urlString)!))
    }
    
    private func setupSubviews() {
        let webView = WKWebView()
        self.webView = webView
        view.addSubview(webView)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension NewsDetailsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    // Not called in ios 12???
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
}
