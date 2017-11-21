

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

protocol FacebookDelegate:class{
    func fbGraphApiData(_ dict:NSDictionary)
}

class FacebookIntegration: NSObject {
    
    weak var delegate:FacebookDelegate?
    
    class var sharedInstance : FacebookIntegration{
        struct Singleton{
            static let instance = FacebookIntegration()
        }
        return Singleton.instance;
    }
    
    func fbLogin(_ reference:UIViewController){
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile","user_friends","user_location"],from: reference, handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.isCancelled){
                    return
                }
                else if(fbloginresult.grantedPermissions.contains("email")){
                    if((FBSDKAccessToken.current()) != nil){
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,first_name, last_name,age_range,gender, picture.width(480).height(480),location"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                                let dict = result as!(NSDictionary)
                                print(dict)
                                self.delegate?.fbGraphApiData(dict)
                            }
                        })
                    }
                    fbLoginManager.logOut()
                }
            }
            else{
                print(error as Any)
            }
        })
    }
}
