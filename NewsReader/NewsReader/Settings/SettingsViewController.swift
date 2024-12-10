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
    var closeVCClosure: VoidClosure?
    var clearCacheClosure: VoidClosure?
    
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .zero
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
    private let articleSourcesLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var articleLabels: [LabelSwitchView]?
    private var articleLabelsView: UIView = UIView()
    
    private var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    private let hSpace: CGFloat = 10
    private let vSpace: CGFloat = 6
    private let sliderHeight: CGFloat = 70
    private let clearButtonHeight: CGFloat = 50
    
    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Invalid way of decoding this class")
    }
    
    deinit {
        print(Self.self, " deinit")
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
            viewModel.saveSettings()
            closeVCClosure?()
        }
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.delegate = self
        contentView.addSubview(intervalLabel)
        intervalLabel.text = viewModel.intervalLabelText
        setupIntervalSlider()
        
        contentView.addSubview(articleSourcesLabel)
        articleSourcesLabel.text = viewModel.articleSourcesLabelText
        setupSourceViews()
        contentView.addSubview(clearButton)
        clearButton.addTarget(self, action: #selector(tapClear) , for: .touchUpInside)
        clearButton.setTitle(viewModel.clearButtonTitle, for: .normal)
        clearButton.setTitleColor(.red, for: .normal)
    }
    
    private func setupIntervalSlider() {
        intervalSlider.maxCount = UInt(viewModel.intervalsLabelsText.count)
        intervalSlider.index = viewModel.itervalIndex
        intervalSlider.labels = viewModel.intervalsLabelsText
        intervalSlider.labelColor = .black
        intervalSlider.labelFont = UIFont.systemFont(ofSize: 14)
        intervalSlider.tintColor = .gray
        intervalSlider.sliderCircleColor = .darkGray
        intervalSlider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        contentView.addSubview(intervalSlider)
    }
    
    @objc private func tapClear(sender: UISlider, event: UIEvent) {
        clearCacheClosure?()
    }
    
    @objc private func didChangeSliderValue(sender: UISlider, event: UIEvent) {
        viewModel.itervalIndex = intervalSlider.index
    }
    
    private func setupSourceViews() {
        contentView.addSubview(articleLabelsView)
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
        articleLabels?.forEach{ articleLabelsView.addSubview($0) }
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        intervalSlider.translatesAutoresizingMaskIntoConstraints = false
        articleSourcesLabel.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        articleLabelsView.translatesAutoresizingMaskIntoConstraints = false
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
            intervalSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: hSpace),
            intervalSlider.heightAnchor.constraint(equalToConstant: sliderHeight),
            intervalSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -hSpace),
            
            articleSourcesLabel.topAnchor.constraint(equalTo: intervalSlider.bottomAnchor, constant: vSpace*2),
            articleSourcesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleSourcesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            articleLabelsView.topAnchor.constraint(equalTo: articleSourcesLabel.bottomAnchor, constant: vSpace),
            articleLabelsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleLabelsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            clearButton.topAnchor.constraint(equalTo: articleLabelsView.bottomAnchor, constant: vSpace*2),
            clearButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clearButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: clearButtonHeight),
            clearButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -vSpace)
        ])
        
        setupSourcesConstraint()
    }
    
    private func setupSourcesConstraint() {
        var topView: UIView? = nil
        var topOffset: CGFloat = 0.0
        articleLabels?.forEach({ view in
            view.translatesAutoresizingMaskIntoConstraints = false
            let topAnc = topView?.bottomAnchor ?? articleLabelsView.topAnchor
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnc, constant: topOffset),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
            topView = view
            topOffset = vSpace
        })
        topView?.bottomAnchor.constraint(equalTo: articleLabelsView.bottomAnchor).isActive = true
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

