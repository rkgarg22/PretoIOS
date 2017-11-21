
import UIKit

class SelectLanguageVC: UIViewController {
    
    @IBOutlet var backButton:UIButton!
    
    
    // localization outlet
    @IBOutlet weak var spanishButton:UIButton!
    @IBOutlet weak var englishButton:UIButton!
    @IBOutlet weak var titleLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        spanishButton.setTitle(NSLocalizedString("spanish", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text"), for: .normal)
        englishButton.setTitle(NSLocalizedString("english", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text"), for: .normal)
        titleLabel.text = NSLocalizedString("Language", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "title text")
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func spanishButtonAction(_ sender: Any) {
        userDefault.set(spanishLanguageIdentifier, forKey: USER_DEFAULT_language_Key)
        userDefault.set([spanishLanguageIdentifier], forKey: "AppleLanguages")
        applicationDelegate.fetchLanguageBundle()
        
        if getLoginUserId() == "" {
            moveToNextScreen()
        }
        else{
            showAlertAndMoveBack()
        }
    }
    
    @IBAction func englishButtonAction(_ sender: Any) {
        userDefault.set(englishLanguageIdentifier, forKey: USER_DEFAULT_language_Key)
        userDefault.set([englishLanguageIdentifier], forKey: "AppleLanguages")
        applicationDelegate.fetchLanguageBundle()
                        
        if getLoginUserId() == "" {
            moveToNextScreen()
        }
        else{
            showAlertAndMoveBack()
        }
    }
    
    func moveToNextScreen() {
        //let selectLoginMethodVcObj = self.storyboard?.instantiateViewController(withIdentifier: "selectLoginMethodVc") as! SelectLoginMethodVC
        //self.navigationController?.pushViewController(selectLoginMethodVcObj, animated: true)
        
        let homeVcObj = self.storyboard?.instantiateViewController(withIdentifier: "homeVc") as! HomeVC
        self.navigationController?.pushViewController(homeVcObj, animated: true)
    }
    
    func hideBackButton() {
        if getLoginUserId() == "" {
            backButton.isHidden = true
        }
    }
    
    func showAlertAndMoveBack() {
        let alert = UIAlertController(title: NSLocalizedString("successAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "success title for alert"), message: NSLocalizedString("changeLanguageSuccess", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "success message shown after changing language"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.okButtonTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "OK button title in alert"), style: .default, handler: { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
