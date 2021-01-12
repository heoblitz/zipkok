//
//  WkWebViewSimpleBar.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import WebKit

class WkWebViewSimpleBar: WKWebView {
    var accessoryView: UIView?

    override var inputAccessoryView: UIView? {
        return accessoryView
    }
}
