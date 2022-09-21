//
//  Asset.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 23/09/2022.
//

import UIKit

enum Asset {
    enum Icon {
        static let icnSuccess = Image(name: "success")
        static let icnError = Image(name: "error")
    }
}

struct Image {
    let name: String
    var image: UIImage {
        guard let result = UIImage(named: name) else {
            fatalError("unable to load image")
        }
        return result
    }
}
