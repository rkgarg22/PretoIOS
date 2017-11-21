
import UIKit
import Alamofire

protocol loginServiceAlamofire {
    func loginResult(_ result:AnyObject)
    func loginError()
}

protocol signupServiceAlamofire {
    func signUpResult(_ result:AnyObject)
    func signUpError()
}

protocol forgotPasswordServiceAlamofire {
    func forgotPasswordResult(_ result:AnyObject)
    func forgotPasswordError()
}

protocol getRestaurantsListServiceAlamofire {
    func getRestaurantsListResult(_ result:AnyObject)
    func getRestaurantsListError()
}

protocol getFavouriteRestaurantsListServiceAlamofire {
    func getFavouriteRestaurantsListResult(_ result:AnyObject)
    func getFavouriteRestaurantsListError()
}

protocol getRestaurantDetailServiceAlamofire {
    func getRestaurantDetailResult(_ result:AnyObject)
    func getRestaurantDetailError()
}

protocol markLikeServiceAlamofire {
    func markLikeResult(_ result:AnyObject)
    func markLikeError()
}

protocol markFavouriteServiceAlamofire {
    func markFavouriteResult(_ result:AnyObject)
    func markFavouriteError()
}

protocol registerFirebaseTokenServiceAlamofire {
    func registerFirebaseTokenResult(_ result:AnyObject)
    func registerFirebaseTokenError()
}

protocol unRegisterFirebaseTokenServiceAlamofire {
    func unRegisterFirebaseTokenResult(_ result:AnyObject)
    func unRegisterFirebaseTokenError()
}

protocol getDirectionServiceAlamofire {
    func getDirectionsResult(result:AnyObject)
    func getDirectionsError()
}

protocol contactUsServiceAlamofire {
    func contactUsResult(result:AnyObject)
    func contactUsError()
}

protocol getJungleBoxBannerServiceAlamofire {
    func getJungleBoxBannerResult(result:AnyObject)
    func getJungleBoxBannerError()
}


class AlamofireIntegration: NSObject {
    
    class var sharedInstance : AlamofireIntegration{
        struct Singleton{
            static let instance = AlamofireIntegration()
        }
        return Singleton.instance;
    }
    
    var loginServiceDelegate:loginServiceAlamofire?
    var signupServiceDelegate:signupServiceAlamofire?
    var forgotPasswordServiceDelegate:forgotPasswordServiceAlamofire?
    var getRestaurantsListServiceDelegate:getRestaurantsListServiceAlamofire?
    var getFavouriteRestaurantsListServiceDelegate:getFavouriteRestaurantsListServiceAlamofire?
    var getRestaurantDetailServiceDelegate:getRestaurantDetailServiceAlamofire?
    var markLikeServiceDelegate:markLikeServiceAlamofire?
    var markFavouriteServiceDelegate:markFavouriteServiceAlamofire?
    var registerFirebaseTokenServiceDelegate: registerFirebaseTokenServiceAlamofire?
    var unRegisterFirebaseTokenServiceDelegate: unRegisterFirebaseTokenServiceAlamofire?
    var getDirectionServiceDelegate:getDirectionServiceAlamofire?
    var contactUsServiceDelegate:contactUsServiceAlamofire?
    var getJungleBoxBannerServiceDelegate:getJungleBoxBannerServiceAlamofire?
    
    
    
    
    
    func contactUs(_ parameters:[String : String]) {
        print(parameters)
        Alamofire.request(baseUrl+"contactUs.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if response.result.isFailure{
                    self.contactUsServiceDelegate?.contactUsError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.contactUsServiceDelegate?.contactUsResult(result: JSON as AnyObject)
                    }
                }
        }
    }
    
    func getDirections(originLatitude:Double,originLongitude:Double,destinationLatitude:Double,destinationLongitude:Double) {
        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json?&origin=\(originLatitude),\(originLongitude)&destination=\(destinationLatitude),\(destinationLongitude)&mode=driving&language=en&key=\(googleDirectionApiKey)")
            .responseJSON { response in
                if let JSON = response.result.value {
                    self.getDirectionServiceDelegate?.getDirectionsResult(result: JSON as AnyObject)
                }
                else{
                    self.getDirectionServiceDelegate?.getDirectionsError()
                }
        }
    }
    

    
    func login(_ parameters:[String : String]) {
        print(parameters)
        Alamofire.request(baseUrl+"login.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if response.result.isFailure{
                    self.loginServiceDelegate?.loginError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.loginServiceDelegate?.loginResult(JSON as AnyObject)
                    }
                }
        }
    }
    
    func signUp(_ parameters:[String : String]) {
        print(parameters)
        print(baseUrl+"registration.php")
        Alamofire.request(baseUrl+"registration.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if response.result.isFailure{
                    print(response.result.value ?? "")
                    self.signupServiceDelegate?.signUpError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.signupServiceDelegate?.signUpResult(JSON as AnyObject)
                    }
                }
        }
        
    }
    
    func forgotPassword(_ parameters:[String : String]) {
        print(parameters)
        Alamofire.request(baseUrl+"userForgotPass.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if response.result.isFailure{
                    self.forgotPasswordServiceDelegate?.forgotPasswordError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.forgotPasswordServiceDelegate?.forgotPasswordResult(JSON as AnyObject)
                    }
                }
        }
    }
    
    func getRestaurantsList(_ parameters:[String : Any]) {
        print(parameters)
        Alamofire.request(baseUrl+"getRestuarantList.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if response.result.isFailure{
                    self.getRestaurantsListServiceDelegate?.getRestaurantsListError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.getRestaurantsListServiceDelegate?.getRestaurantsListResult(JSON as AnyObject)
                    }
                }
        }
    }
    
    func getFavouriteRestaurantsList(userID:String,language:String, latitude:Double, longitude:Double, offset:Int) {
        print(baseUrl+"getFavouriteRestuarantList.php/?userID=\(userID)&language=\(language)&lattitude=\(latitude)&longitude=\(longitude)")
        Alamofire.request(baseUrl+"getFavouriteRestuarantList.php/?userID=\(userID)&language=\(language)&lattitude=\(latitude)&longitude=\(longitude)")
            .responseJSON { response in
                if response.result.isFailure{
                    self.getFavouriteRestaurantsListServiceDelegate?.getFavouriteRestaurantsListError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.getFavouriteRestaurantsListServiceDelegate?.getFavouriteRestaurantsListResult(JSON as AnyObject)
                    }
                }
        }
    }
    
    func getRestuarantDetail(userID:String,language:String,restID:String, latitude:Double, longitude:Double) {
        print(baseUrl+"getRestuarantDetail.php/?userID=\(userID)&restID=\(restID)&language=\(language)&lattitude=\(latitude)&longitude=\(longitude)")
        Alamofire.request(baseUrl+"getRestuarantDetail.php/?userID=\(userID)&restID=\(restID)&language=\(language)&lattitude=\(latitude)&longitude=\(longitude)")
            .responseJSON { response in
                if response.result.isFailure{
                    self.getRestaurantDetailServiceDelegate?.getRestaurantDetailError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.getRestaurantDetailServiceDelegate?.getRestaurantDetailResult(JSON as AnyObject)
                    }
                }
        }
    }
    
    func markLike(userID:String,restID:String) {
        print(baseUrl+"markLike.php/?userID=\(userID)&restID=\(restID)")
        Alamofire.request(baseUrl+"markLike.php/?userID=\(userID)&restID=\(restID)")
            .responseJSON { response in
                if response.result.isFailure{
                    self.markLikeServiceDelegate?.markLikeError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.markLikeServiceDelegate?.markLikeResult(JSON as AnyObject)
                    }
                }
        }
    }
    
    func markFavourite(userID:String,restID:String) {
        print(baseUrl+"markFavourite.php/?userID=\(userID)&restID=\(restID)")
        Alamofire.request(baseUrl+"markFavourite.php/?userID=\(userID)&restID=\(restID)")
            .responseJSON { response in
                if response.result.isFailure{
                    self.markFavouriteServiceDelegate?.markFavouriteError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.markFavouriteServiceDelegate?.markFavouriteResult(JSON as AnyObject)
                    }
                }
        }
    }
    
    func registerFirebaseToken(_ parameters:[String : Any]) {
        print(parameters)
        Alamofire.request(baseUrl+"registerToken.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.result.isFailure{
                self.registerFirebaseTokenServiceDelegate?.registerFirebaseTokenError()
            }
            else{
                if let JSON = response.result.value {
                    print(JSON)
                    self.registerFirebaseTokenServiceDelegate?.registerFirebaseTokenResult(JSON as AnyObject)
                }
            }
        }
    }
    
    func unregisterFirebaseToken(_ userId:String) {
        print(baseUrl+"unRegisterToken.php/?userId=\(userId)")
        Alamofire.request(baseUrl+"unRegisterToken.php/?userId=\(userId)")
            .responseJSON { response in
                if response.result.isFailure{
                    self.unRegisterFirebaseTokenServiceDelegate?.unRegisterFirebaseTokenError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.unRegisterFirebaseTokenServiceDelegate?.unRegisterFirebaseTokenResult(JSON as AnyObject)
                    }
                }
        }
    }
    
    func getJungleBoxImages() {
        print(baseUrl+"banner.php")
        Alamofire.request(baseUrl+"banner.php")
            .responseJSON { response in
                if response.result.isFailure{
                    self.getJungleBoxBannerServiceDelegate?.getJungleBoxBannerError()
                }
                else{
                    if let JSON = response.result.value {
                        print(JSON)
                        self.getJungleBoxBannerServiceDelegate?.getJungleBoxBannerResult(result: JSON as AnyObject)
                    }
                }
        }
    }
    
}
