//
//  LargeButton.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import UIKit

final class LargeButton: UIView {
    private let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private var model: LargeButton.Model?
    
    func update(with model: LargeButton.Model) {
        self.model?.onEnabledChanged = { _ in }
        self.model = model
        
        button.setTitle(model.title, for: .normal)
        button.isEnabled = model.isEnabled
        
        model.onEnabledChanged = { [weak self] in
            guard let self = self else { return }
            self.button.isEnabled = $0
            self.button.layer.borderColor = $0 ? UIColor.black.cgColor : UIColor.gray.cgColor
        }
    }
}


private extension LargeButton {
    private func setup() {
        setupViews()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupViews() {
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    private func setupHierarchy() {
        addSubview(button)
    }
    
    private func setupConstraints(){
        button.pinToSuperviewEdges()
        button.setHeight(48.0)
    }
    
    @objc private func onButtonTap() {
        model?.onTap()
    }
}
