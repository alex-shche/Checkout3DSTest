//
//  StatusViewController.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 23/09/2022.
//

import UIKit

final class StatusViewController: UIViewController {
    private enum Constants {
        static let imageSize: CGFloat = 72
    }
    private let stackView = UIStackView()
    private let statusImageView = UIImageView()
    private let statusTitleLabel = UILabel()
    
    private let viewModel: StatusViewModel
    
    init(viewModel: StatusViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        viewModel.onView(.didLoad)
    }
}

extension StatusViewController {
    func setup() {
        setupViews()
        setupHierarchy()
        setupConstraints()
    }
    func setupViews() {
        view.backgroundColor = .white
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        statusTitleLabel.font = UIFont.systemFont(ofSize: 20)
        statusTitleLabel.textAlignment = .center
        statusTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(statusImageView)
        stackView.addArrangedSubview(statusTitleLabel)
    }
    
    func setupConstraints() {
        statusImageView.setWidth(Constants.imageSize)
        statusImageView.setHeight(Constants.imageSize)

        NSLayoutConstraint.activate(
            [
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
    
    func bindViewModel() {
        viewModel.onReloadContent = { [weak self] in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        statusImageView.image = viewModel.image.image
        statusTitleLabel.text = viewModel.title
    }
}
