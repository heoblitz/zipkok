//
//  LocationWebViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit
import WebKit

class LocationWebViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let postcodeURLString: String = "https://heoblitz.github.io/Kakao_postcode/"
    private var webView: WkWebViewSimpleBar?
    
    var completionHandler: ((LocationInfo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareWebView()
        setConstraints()
        prepareNavigationTitle()
    }
    
    static func storyboardInstance() -> LocationWebViewController? {
        let storyboard = UIStoryboard(name: LocationWebViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        webView = WkWebViewSimpleBar(frame: .zero, configuration: configuration)
        webView?.navigationDelegate = self
        webView?.scrollView.delegate = self
        webView?.scrollView.contentInsetAdjustmentBehavior = .never
        webView?.scrollView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        guard let url = URL(string: postcodeURLString) else { return }
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    
    private func setConstraints() {
        guard let webView = webView else { return }
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func prepareNavigationTitle() {
        navigationItem.title = "주소검색"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansCJKkr-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)]
    }
    
    private func alertMessage(for message: String) {
        let alert = UIAlertController(title: "test", message: message, preferredStyle: .alert)
        let admit = UIAlertAction(title: "확인", style: .default, handler: { _ in
            //self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(admit)
        present(alert, animated: true, completion: nil)
    }
}

extension LocationWebViewController: WKNavigationDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard let data = message.body as? [String:Any] else { return }
            // address = data["roadAddress"] as? String ?? ""
        
        if let roadAddress = data["roadAddress"] as? String {
            GeoCodingApi.shared.requestCoord(by: roadAddress) { [weak self] (latitude, longitude) in
                guard let self = self else { return }
                let locationInfo = LocationInfo(latitude: latitude, longitude: longitude, name: roadAddress)

                OperationQueue.main.addOperation {
                    self.completionHandler?(locationInfo)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

        // guard let previousVC = presentingViewController as? ViewController else { return }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

extension LocationWebViewController: WKScriptMessageHandler {
}

extension LocationWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
