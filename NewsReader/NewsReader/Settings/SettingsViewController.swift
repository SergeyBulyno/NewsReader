//
//  SettingsViewController.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/4/24.
//
import UIKit
import StepSlider

final class SettingsViewController: UIViewController {
    
    private(set) var viewModel: SettingsViewModel
    
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .zero
        //scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
    
        return scrollView
    }()
    
    private let contentView = UIView()
    private let intervalLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let intervalSlider = StepSlider()
        
    private let showSourceLabel = LabelSwitchView()
    private let articleSourcesLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var articleLabels: [LabelSwitchView]?
    
    private let hSpace: CGFloat = 10
    private let vSpace: CGFloat = 6
    
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
        setupConstraints()
    }
     
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            print(intervalSlider.index)
            viewModel.saveSettings()
        }
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.delegate = self
        contentView.addSubview(intervalLabel)
        intervalLabel.text = viewModel.intervalLabelText
        setupIntervalSlider()
        contentView.addSubview(showSourceLabel)
        showSourceLabel.label.text = viewModel.articleSourceAvailabelLabelText
        
        contentView.addSubview(articleSourcesLabel)
        articleSourcesLabel.text = viewModel.articleSourcesLabelText
        setupSourceViews()
    }
    
    private func setupIntervalSlider() {
        intervalSlider.maxCount = 6
        intervalSlider.index = viewModel.itervalIndex
        intervalSlider.labels = viewModel.intervalsLabelsText
        intervalSlider.labelColor = .black
        intervalSlider.labelFont = UIFont.systemFont(ofSize: 14)
        intervalSlider.tintColor = .gray
        intervalSlider.sliderCircleColor = .darkGray
        intervalSlider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        contentView.addSubview(intervalSlider)
    }
    
    @objc private func didChangeSliderValue(sender: UISlider, event: UIEvent) {
        viewModel.itervalIndex = intervalSlider.index
    }
    
    private func setupSourceViews() {
        self.articleLabels = viewModel.sourcesOrder.map { name in
            let view = LabelSwitchView()
            view.label.text = name
            let value = viewModel.sourcesValues[name]!
            view.setSwitchOn(value)
            view.switchClosure = {[weak self] newValue in
                self?.viewModel.sourcesValues[name] = newValue
            }
            return view
        }
        articleLabels?.forEach{ contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        intervalSlider.translatesAutoresizingMaskIntoConstraints = false
        showSourceLabel.translatesAutoresizingMaskIntoConstraints = false
        articleSourcesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentTopConstraint = contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        contentTopConstraint.priority = .defaultLow
        let contentBottomConstraint = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        contentBottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentTopConstraint,
            contentBottomConstraint,
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hSpace),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hSpace),
            
            intervalLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: vSpace),
            intervalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            intervalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            intervalSlider.topAnchor.constraint(equalTo: intervalLabel.bottomAnchor, constant: vSpace),
            intervalSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            intervalSlider.heightAnchor.constraint(equalToConstant: 70),
            intervalSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            showSourceLabel.topAnchor.constraint(equalTo: intervalSlider.bottomAnchor, constant: vSpace*2),
            showSourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showSourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            articleSourcesLabel.topAnchor.constraint(equalTo: showSourceLabel.bottomAnchor, constant: vSpace*2),
            articleSourcesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleSourcesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        setupSourcesConstraint()
    }
    
    private func setupSourcesConstraint() {
        var topView: UIView = articleSourcesLabel
        articleLabels?.forEach({ view in
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: vSpace),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
            topView = view
        })
        topView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -vSpace).isActive = true
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    // Not called in ios 12???
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

