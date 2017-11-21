//
//  InstagramVC.swift
//  Preto
//
//  Created by apple on 20/08/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class InstagramVC: UIViewController ,UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    
    var instagramUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(applicationDelegate.isConnectedToNetwork == true){
            applicationDelegate.showActivityIndicatorView()
            if let requestURL = URL(string:instagramUrl) {
                let request = URLRequest(url: requestURL)
                webView.loadRequest(request)
            }
        }
        else{
            showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        applicationDelegate.hideActivityIndicatorView()
    }
    
    // MARK: WebView delegate
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        applicationDelegate.hideActivityIndicatorView()
    }
    
    // MARK: UIButton Actions
    @IBAction func backButton(sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
}
