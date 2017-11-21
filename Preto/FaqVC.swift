
import UIKit

class FaqVC: UIViewController {
    
    // localization outlet
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var textView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isScrollEnabled = false
        let currentSize = textView.font!.pointSize
        if (UIScreen.main.bounds.height != 736){
            textView.font = textView.font!.withSize(currentSize-2)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = NSLocalizedString("faq", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.isScrollEnabled = true
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
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
