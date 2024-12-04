//
//  NewsListCollectionViewCell.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

import UIKit

class NewsListCollectionViewCell: UICollectionViewCell {
    var cellViewModel: NewsItemViewModel! {
        didSet {
            updateData(cellViewModel)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        //updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[%@] deinit", Self.self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadingImageView.image = nil
        loadingImageView.isHidden = true
        fetchTask?.cancel()
    }
    
    private var closedConstraint: NSLayoutConstraint?
    private var openConstraint: NSLayoutConstraint?
    
    //MARK: - Init Views
    private let hSpace: CGFloat = 6
    private let vSpace: CGFloat = 4
    private let cornerRadius: CGFloat = 4
    private let hSideOffset: CGFloat = 8
    
    private let pubDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var pubStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pubDateLabel, sourceLabel])
        stack.axis = .horizontal
        stack.spacing = hSpace
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 2
        return label
    }()
    
    private let loadingImageView: UIImageView = UIImageView()
    private let newsContentView = UIView()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, loadingImageView])
        stack.axis = .horizontal
        stack.spacing = hSpace
        stack.distribution = .fill
        stack.alignment = .top
        return stack
    }()
    
    private let newsReadView: UIView = {
        let circle = UIView(frame: CGRectMake(0, 0, 3, 3))
        circle.backgroundColor = .red
        circle.layer.cornerRadius = circle.frame.size.width/2
        return circle
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemGray
        label.numberOfLines = 4
        return label
    }()
    
    private let toggleIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .black
        imageView.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    //MARK: - Setup Subviews
    private func setupSubviews() {
        backgroundColor = .systemGray6
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        
        contentView.addSubview(newsContentView)
        newsContentView.addSubview(pubStackView)
        newsContentView.addSubview(titleStackView)
        newsContentView.addSubview(subtitleLabel)
        newsContentView.addSubview(toggleIndicator)
        contentView.addSubview(toggleButton)
        toggleButton.addTarget(self, action: #selector(toggleCell(button:)), for: .touchUpInside)
        
        newsContentView.addSubview(newsReadView)
    }
    
    @objc func toggleCell(button: UIButton) {
        updateExpandable(!cellViewModel.isExpanded)
        cellViewModel.isExpanded = !cellViewModel.isExpanded
    }
    
    //MARK: - Layout Subviews
    func setupConstraints() {
        newsContentView.translatesAutoresizingMaskIntoConstraints = false
        pubStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleIndicator.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        newsReadView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: hSideOffset),
            newsContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: hSideOffset),
            newsContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -hSideOffset),
            newsContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -hSideOffset),
            
            loadingImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 40),
            loadingImageView.widthAnchor.constraint(equalTo: loadingImageView.heightAnchor, multiplier: 60/40),
            
            pubStackView.topAnchor.constraint(equalTo: newsContentView.topAnchor),
            pubStackView.leadingAnchor.constraint(equalTo: newsContentView.leadingAnchor),
            pubStackView.trailingAnchor.constraint(equalTo: newsContentView.trailingAnchor),
            
            titleStackView.topAnchor.constraint(equalTo: pubStackView.bottomAnchor, constant: vSpace),
            titleStackView.leadingAnchor.constraint(equalTo: newsContentView.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: newsContentView.trailingAnchor),
            
            toggleIndicator.centerXAnchor.constraint(equalTo: newsContentView.centerXAnchor),
            toggleIndicator.bottomAnchor.constraint(equalTo: newsContentView.bottomAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: vSpace),
            subtitleLabel.leadingAnchor.constraint(equalTo: newsContentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: newsContentView.trailingAnchor),
            
            toggleButton.topAnchor.constraint(equalTo: toggleIndicator.topAnchor, constant: -vSpace),
            toggleButton.bottomAnchor.constraint(equalTo: toggleIndicator.bottomAnchor, constant: vSpace),
            toggleButton.leadingAnchor.constraint(equalTo: newsContentView.leadingAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: newsContentView.trailingAnchor),
            
            
            newsReadView.centerYAnchor.constraint(equalTo: titleStackView.centerYAnchor),
            newsReadView.trailingAnchor.constraint(equalTo: titleStackView.leadingAnchor, constant: -3.0),
            newsReadView.heightAnchor.constraint(equalToConstant: newsReadView.frame.height),
            newsReadView.widthAnchor.constraint(equalToConstant: newsReadView.frame.width),
        ])
        
        toggleIndicator.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleStackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        closedConstraint = titleStackView.bottomAnchor.constraint(equalTo: toggleIndicator.topAnchor)
        closedConstraint?.isActive = true
        openConstraint = subtitleLabel.bottomAnchor.constraint(equalTo: toggleIndicator.topAnchor)
        openConstraint?.priority = .defaultLow
    }
    
    //MARK: - Update data
    private func updateData(_ viewModel: NewsItemViewModel) {
        titleLabel.text = viewModel.title
        newsReadView.isHidden = viewModel.isRead
        pubDateLabel.text = viewModel.pubDate
        sourceLabel.isHidden = !viewModel.sourceAvailable
        if viewModel.sourceAvailable {
            sourceLabel.text = viewModel.sourceName
        }
        loadImageView(loadingImageView, from: viewModel)
        updateExpandable(viewModel.isExpanded)
        subtitleLabel.text = viewModel.description
    }
    private var fetchTask: Task<(), Never>?
    
    func loadImageView(_ imageView: UIImageView, from viewModel: NewsItemViewModel) {
        guard viewModel.imageAvailable else { return }
        imageView.isHidden = false
        imageView.image = viewModel.placeholderImage
        fetchTask = Task { @MainActor in
            if let fetchTask = self.fetchTask, !fetchTask.isCancelled {
                if let image = try? await viewModel.fetchImage() {
                    imageView.image = image
                }
            }
        }
    }
    
    private func updateExpandable(_ isExpand: Bool) {
        closedConstraint?.isActive = !isExpand
        openConstraint?.isActive = isExpand
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            
            // Set the rotation just under 180º so that it rotates back the same way
            let upsideDown = CGAffineTransform(rotationAngle: .pi * 0.999 )
            self.toggleIndicator.transform = isExpand ? upsideDown :.identity
            
            self.subtitleLabel.alpha = isExpand ? 1 : 0
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
}
