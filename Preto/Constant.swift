
import UIKit

// MARK: google

let googleDirectionApiKey = "AIzaSyALvX400dGfcPMp7XDYu6tiyg_moKsRc9Q"
let googleMapSdkApiKey = "AIzaSyALvX400dGfcPMp7XDYu6tiyg_moKsRc9Q"


let wazeItunesUrl = "http://itunes.apple.com/us/app/id323229106"
let jungleBoxUrl = "http://www.junglebox.com/co/"
let blueAppThemeColor = UIColor(colorLiteralRed: 0/255, green: 25/255, blue: 138/255, alpha: 1)


// MARK: Constant strings

let mailRecipient = "contacto@preto.co"
let howDoesItWorkurl = "https://youtu.be/WViVVzHhGYA"

//http://18.219.42.27/webservices/
var baseUrl = "http://18.219.42.27/webservices/"
let deviceType = "iOS"
let successKey = "success"
let errorKey = "error"
let resultKey = "result"
let englishLanguageIdentifier = "en"
let spanishLanguageIdentifier = "es"
let greenDotColourString = "319E2E"
let greyDotColourString = "626366"
let redDotColourString = "DF0314"


// MARK: userDefault
let userDefault = UserDefaults.standard
let USER_DEFAULT_userId_Key = "userID"
let USER_DEFAULT_language_Key = "language"
let USER_DEFAULT_emailId_Key = "emailID"
let USER_DEFAULT_LOGIN_CHECK_Key = "Login"
let USER_DEFAULT_FireBaseToken = "fireBaseTokenId"
let USER_DEFAULT_SocialMediaLogin_Key = "socialMediaLogin"


func getLoginUserId() -> String {
    let usrDefault = UserDefaults.standard
    let usrId = usrDefault.value(forKey: USER_DEFAULT_userId_Key) as? String ?? ""
    return usrId
}

func getCurrentLanguage() -> String {
    let usrDefault = UserDefaults.standard
    if let selectedLanguage = usrDefault.value(forKey: USER_DEFAULT_language_Key) as? String {
        return selectedLanguage
    }
    else{
        return "es"
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func convertHtmlStringToPlainString(htmlString:String) -> String {
    if htmlString == "" {
        return ""
    }
    else{
        do {
            let plainString = try NSAttributedString(data: htmlString.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
            return plainString.string
        }
        catch{
            print("\(error)")
            return ""
        }
    }
}

func moveToSelectLoginMethodScreen(reference:UIViewController) {
    
    let alert = UIAlertController(title: nil, message: NSLocalizedString("loginAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "login alert message"),preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("loginAlertOkText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "login alert message"), style: .default, handler: { (UIAlertAction) in
        let selectLoginMethodVcObj = reference.storyboard?.instantiateViewController(withIdentifier: "selectLoginMethodVc") as! SelectLoginMethodVC
        reference.navigationController?.pushViewController(selectLoginMethodVcObj, animated: true)
    }))
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("loginAlertCancelText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "login alert message"), style: .default, handler: { (UIAlertAction) in
        alert.dismiss(animated: true, completion: nil)
    }))
    
    reference.present(alert, animated: true, completion: nil)
    
}



// MARK: appDelegate reference
let applicationDelegate = UIApplication.shared.delegate as!(AppDelegate)

// MARK: showAlert Function
func showAlert (_ reference:UIViewController, message:String, title:String){
    var alert = UIAlertController()
    if title == "" {
        alert = UIAlertController(title: nil, message: message,preferredStyle: UIAlertControllerStyle.alert)
    }
    else{
        alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertControllerStyle.alert)
    }
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("loginAlertOkText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "login alert message"), style: UIAlertActionStyle.default, handler: nil))
    reference.present(alert, animated: true, completion: nil)
    
}

