//
//  AutolayoutHelpers.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 17/09/2022.
//

import UIKit

enum ConstraintEdge: CaseIterable {
    case top, bottom, leading, trailing
}

extension UIView {
    func pinToSuperviewEdges(_ edges: [ConstraintEdge] = [.top, .bottom, .leading, .trailing], padding: CGFloat = 0) {
        guard let superview = self.superview else { return }
        for edge in edges {
            switch edge {
            case .top:
                pinToTopEdge(of: superview, padding: padding)
            case .bottom:
                pinToBottomEdge(of: superview, padding: -padding)
            case .leading:
                pinToLeadingEdge(of: superview, padding: padding)
            case .trailing:
                pinToTrailingEdge(of: superview, padding: -padding)
            }
        }
    }
    
    func pinToTopEdge(of view: UIView, padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: padding)
        constraint.isActive = true
    }
    
    func pinToBottomEdge(of view: UIView, padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)
        constraint.isActive = true
    }
    
    func pinToLeadingEdge(of view: UIView, padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding)
        constraint.isActive = true
    }
    
    func pinToTrailingEdge(of view: UIView, padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding)
        constraint.isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
    }
}
