//
//  AuthService.swift
//  Finiite
//
//  Created by Dmytro on 2/22/21.
//  Copyright © 2021 Dmytro. All rights reserved.
//

import Foundation

protocol AuthServiceType {
    func saveGoogleToken(token: String)
    func saveAmazonToken(token: String)
    func saveInfoUser(email: String,name: String)

    var isLogged: Bool { get }
    var isSubscription: Bool { get set }
    var numberOfTakePhoto: Int { get set }

}

final class AuthService: AuthServiceType {
    var isSubscription: Bool = false
    var numberOfTakePhoto: Int = 0
    public static var `default` = AuthService()
    
    var userDefault: UserDefaults
    
    private let googleTokenKey = "googleTokenKey"
    private let amazonTokenKey = "amazonTokenKey"
    private let firstLoginKey = "firstLoginKey"
    private let emailKey = "emailKey"
    private let nameKey = "nameKey"

    init(userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
    }
    
    func saveInfoUser(email: String,name: String) {
        userDefault.set(email, forKey: emailKey)
        userDefault.set(name, forKey: nameKey)
        let appService = AppService()
        appService.saveUserInfo(userName: name, userEmail: email) { json in
            
        }
    }

    func saveGoogleToken(token: String) {
        userDefault.set(token, forKey: googleTokenKey)
    }
    
    func saveAmazonToken(token: String) {
        userDefault.set(token, forKey: amazonTokenKey)
    }
    
    func getCurrentTokenEmail() -> String {
        let email = userDefault.string(forKey: emailKey) ?? ""
        let token = userDefault.string(forKey: googleTokenKey) ?? userDefault.string(forKey: amazonTokenKey) ?? ""
        if !email.isEmpty {
            return email
        } else if token.isEmpty {
            return ""
        } else {
            return "\(token)@gmail.com"
        }
    }
    
    private func getGoogleToken() -> String {
        return userDefault.string(forKey: googleTokenKey) ?? ""
    }
    
    private func getAmazonToken() -> String {
        return userDefault.string(forKey: amazonTokenKey) ?? ""
    }
    
    var isLogged: Bool {
        return !getGoogleToken().isEmpty || !getAmazonToken().isEmpty
    }
    
    func setFirstLogin(value: Bool) {
        userDefault.setValue(value, forKey: firstLoginKey)
    }
    
    func isFirstLogin() -> Bool {
        return  userDefault.bool(forKey: firstLoginKey)
    }
}
