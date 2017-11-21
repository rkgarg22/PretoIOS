
import UIKit

class HelpVC: UIViewController {
    
    // localization outlet
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var howDoesItWorkButton:UIButton!
    @IBOutlet weak var faqButton:UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = NSLocalizedString("helpTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "title text")
        howDoesItWorkButton.setTitle(NSLocalizedString("howDoesItWork", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text"), for: .normal)
        faqButton.setTitle(NSLocalizedString("faq", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text"), for: .normal)
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func howDoesItWorkButtonAction(_ sender: Any) {
        let howDosItWorkVcObj = self.storyboard?.instantiateViewController(withIdentifier: "howDoesItWorkVc") as! HowDosItWorkVC
        self.navigationController?.pushViewController(howDosItWorkVcObj, animated: true)
    }
    
    @IBAction func faqButtonAction(_ sender: Any) {
        if getCurrentLanguage() == "en" {
            let faqEnglishVcObj = self.storyboard?.instantiateViewController(withIdentifier: "faqEnglishVc") as! FaqEnglishVC
            self.navigationController?.pushViewController(faqEnglishVcObj, animated: true)
        }
        else{
            let faqVcObj = self.storyboard?.instantiateViewController(withIdentifier: "faqVc") as! FaqVC
            self.navigationController?.pushViewController(faqVcObj, animated: true)
        }
    }
    
    @IBAction func homeButtonAction(_ sender: AnyObject) {
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: HomeVC.self){
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
}
