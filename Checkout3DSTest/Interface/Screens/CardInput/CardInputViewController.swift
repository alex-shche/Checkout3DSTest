//
//  ViewController.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 17/09/2022.
//

import UIKit

final class CardInputViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.pinToSuperviewEdges([.leading, .trailing], padding: 16)
        NSLayoutConstraint.activate(
            [stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let cardDetails = CardDetails()
    private let payButton = LargeButton()
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private let viewModel: CardInputViewModel
    
    init(viewModel: CardInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
                   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.onView(.didLoad)
    }
}

private extension CardInputViewController {
    func setupViews() {
        view.backgroundColor = .white
        stackView.addArrangedSubview(cardDetails)
        stackView.addArrangedSubview(payButton)
    }
    
    func bindViewModel() {
        viewModel.onReloadContent = { [weak self] in
            guard let self = self else { return }
            self.cardDetails.update(with: self.viewModel.cardDetailsModel)
            self.payButton.update(with: self.viewModel.payButtonModel)
        }
        viewModel.onShowLoading = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.payButton.removeFromSuperview()
                self.stackView.addArrangedSubview(self.spinner)
                self.spinner.startAnimating()
            } else {
                self.spinner.stopAnimating()
                self.spinner.removeFromSuperview()
                self.stackView.addArrangedSubview(self.payButton)
            }
        }
    }
}
