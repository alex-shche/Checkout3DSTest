//
//  CardDetails.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 17/09/2022.
//

import UIKit

final class CardDetails: UIView {
    private let contentStackView = UIStackView()
    private let cardNumberInput = InputText()
    
    private let securityInformationStackView = UIStackView()
    private let expireDateInput = InputText()
    private let cvvInput = InputText()
    
    private var model: CardDetails.Model?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func update(with model: CardDetails.Model) {
        self.model = model
        
        cardNumberInput.update(with: model.cardNumberInputModel)
        expireDateInput.update(with: model.expiryDateInputModel)
        cvvInput.update(with: model.cvvInputModel)
    }
}

private extension CardDetails {
    private func setup() {
        setupViews()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupViews() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 16
        
        securityInformationStackView.axis = .horizontal
        securityInformationStackView.distribution = .fillEqually
        securityInformationStackView.spacing = 16
    }
    
    private func setupHierarchy() {
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(cardNumberInput)
        contentStackView.addArrangedSubview(securityInformationStackView)
        
        securityInformationStackView.addArrangedSubview(expireDateInput)
        securityInformationStackView.addArrangedSubview(cvvInput)
    }
    
    private func setupConstraints(){
        contentStackView.pinToSuperviewEdges()
    }
}
