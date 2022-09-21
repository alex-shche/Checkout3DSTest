//
//  InputText.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 17/09/2022.
//

import UIKit

final class InputText: UIView {
    enum KeyboardType {
        case numbers
    }
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let textField = UITextField()
    
    private var model: InputText.Model?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func update(with model: InputText.Model) {
        self.model = model
        textField.text = model.text
        textField.placeholder = model.placeholder
        titleLabel.text = model.title
        
        switch model.keyboardType {
        case .numbers:
            textField.keyboardType = .numberPad
        }
    }
}

private extension InputText {
    private func setup() {
        setupViews()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupViews() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 4

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        
        textField.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupHierarchy() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(textField)
    }
    
    private func setupConstraints(){
        contentStackView.pinToSuperviewEdges()
    }
}

private extension InputText {
    @objc private func textFieldDidChange() {
        model?.text = textField.text
        model?.onTextChanged(textField.text ?? "")
    }
}
