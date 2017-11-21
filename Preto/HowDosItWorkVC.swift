
import UIKit

class HowDosItWorkVC: UIViewController ,UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var titleLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(applicationDelegate.isConnectedToNetwork == true){
            applicationDelegate.showActivityIndicatorView()
            let requestURL = URL(string:howDoesItWorkurl)
            let request = URLRequest(url: requestURL!)
            webView.loadRequest(request)
        }
        else{
            showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       titleLabel.text = NSLocalizedString("howDoesItWork", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text")
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
    
    @IBAction func homeButtonAction(_ sender: AnyObject) {
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: HomeVC.self){
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    

}
