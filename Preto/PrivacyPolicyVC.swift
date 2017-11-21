
import UIKit

class PrivacyPolicyVC: UIViewController {
    
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
        titleLabel.text = NSLocalizedString("privacyPolicyTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "title text")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.isScrollEnabled = true
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }


}
