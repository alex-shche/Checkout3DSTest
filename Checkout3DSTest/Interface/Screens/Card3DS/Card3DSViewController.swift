//
//  Card3DSViewController.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 22/09/2022.
//

import UIKit
import WebKit

final class Card3DSViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        return WKWebView(frame: .zero, configuration: webConfiguration)
    }()
    
    private var originalNavigation: WKNavigation?
    
    private let viewModel: Card3DSViewModel
    
    init(viewModel: Card3DSViewModel) {
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

private extension Card3DSViewController {
    func setupViews() {
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.pinToSuperviewEdges()
    }
    
    func bindViewModel() {
        viewModel.onLoadContent = { [weak self] url in
            guard let self = self else { return }
            let request = URLRequest(url: url)
            self.originalNavigation = self.webView.load(request)
        }
    }
}

extension Card3DSViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        viewModel.shouldAllowNavigation(webView.url) { result in
            if result {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }
    }
}
