//
//  NewsListViewController.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/1/24.
//

import UIKit

class NewsListViewController: UIViewController {
    private(set) var viewModel: NewsListViewModel
    
    init(_ viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        viewModel.fetchData()
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
    
    //MARK: Setup Subviews
    enum Section {
        case main
    }

    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, NewsItemViewModel>?
    
    private func setupController() {
        view.backgroundColor = .white
        self.title = self.viewModel.title
        setupSubviews()
        setupConstraints()
        setupObservers()
    }
    
    private func setupSubviews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: self.view.bounds,
                                              collectionViewLayout: listLayout)
        self.collectionView = collectionView
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        registerCells()
        
        setupDataSource()
        collectionView.delegate = self
    }
    
    private let listSpacing: CGFloat = 6
    private var listLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(50))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = listSpacing
        section.contentInsets = .init(top: listSpacing,
                                      leading: listSpacing,
                                      bottom: listSpacing,
                                      trailing: listSpacing)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func registerCells() {
        collectionView?.register(NewsListCollectionViewCell.self,
                                 forCellWithReuseIdentifier: NewsListCollectionViewCell.reuseIdentifier)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, NewsItemViewModel>(collectionView: collectionView!) {
            (collectionView, indexPath, viewModel) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsListCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? NewsListCollectionViewCell else {
                    fatalError("Could not cast cell as \(NewsListCollectionViewCell.self)")
            }
            
            cell.cellViewModel = viewModel
            viewModel.updateLayoutClosure = {[weak self] in
                self?.dataSource?.refresh()
            }
            return cell
        }
        collectionView?.dataSource = dataSource
        
        //updateSnapshot(animated: false)
    }
    
    //MARK: - Layout Subviews
    private func setupConstraints() {
        guard let collectionView else { return }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupObservers() {
        viewModel.isLoadingClosure = { [weak self] isLoading in
            self?.showLoading(isLoading)
        }
        viewModel.reloadDataClosure = { [weak self] _ in
            self?.reloadData()
        }
    }
    
    private func reloadData() {
        updateSnapshot(animated: false)
    }
    
    private func updateSnapshot(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItemViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.newsItems)
        dataSource?.apply(snapshot)
    }
}

//var snapshot = recipeListDataSource.snapshot()
//    // Update the recipe's data displayed in the collection view.
//    snapshot.reconfigureItems([recipeId])
//    recipeListDataSource.apply(snapshot, animatingDifferences: true).

extension NewsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectItem(at: indexPath)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension UICollectionViewDiffableDataSource {
   func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}


