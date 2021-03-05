//
//  Api.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/16/21.
//

import Foundation

struct Api {
    struct ApiError {
        var message: String
        var code: String
        
        init(response: [String:Any]) {
            self.message = (response["error_message"] as? String) ?? "Default error"
            self.code = (response["error_code"] as? String) ?? "default_error"
        }
    }
    typealias ApiCompletion = ((_ response: [String: Any]?, _ error: ApiError?) -> Void)
    
//    static var baseUrl = "https://ecs189e-fall2018.appspot.com/api"
    static let defaultError = ApiError(response: [:])
    
//    static func configuration() -> URLSessionConfiguration {
//        
//    }
    
    static func ApiCall(endpoint: String, parameters: [String: Any], completion: @escaping ApiCompletion) {
        
    }
    
    static func addNewAccount() {
        //signup button press
    }
    
    static func removeAccount() {
        //Have an option in the profile to remove the account from the database
    }
    
    static func setFirstName(firstName: String, completion: @escaping ApiCompletion) {
        //set the user's first name in the sign up VC
//        ApiCall(endpoint:"\user", parameters: ["firstName": firstName], completion: completion)
        
    }
    
    static func setLastName(lastName: String, completion: @escaping ApiCompletion) {
        //set the user's last name in the sign up VC
//        ApiCall(endpoint:"\user", parameters: ["lastName": lastName], completion: completion)
    }
    
    static func verifyEmail() {
        //Check that there is an account with the current email
    }
    
    static func verifyPassword() {
        //Check that the password entered is the one for the entered email
    }
    
    static func Categories() {
        //save the data each user selects
    }
    
    static func user() {
        //load user data?
    }
    
    
    //VERIFY EMAIL WITH CODE?
}
