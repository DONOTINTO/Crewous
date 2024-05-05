//
//  UserDefaultsManager.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation

class UDManager {
    
    private static let ud = UserDefaults.standard
    
    private static let isLoginStr = "isLogin"
    private static let userIDStr = "userID"
    private static let accessTokenStr = "accessToken"
    private static let refreshTokenStr = "refreshToken"
    
    static var isLogin: Bool {
        get {
            return ud.bool(forKey: isLoginStr)
        } set {
            ud.set(newValue, forKey: isLoginStr)
        }
    }
    
    static var userID: String {
        get {
            return ud.string(forKey: userIDStr) ?? ""
        } set {
            ud.set(newValue, forKey: userIDStr)
        }
    }
    
    static var accessToken: String {
        get {
            return ud.string(forKey: accessTokenStr) ?? ""
        } set {
            ud.set(newValue, forKey: accessTokenStr)
        }
    }
    
    static var refreshToken: String {
        get {
            return ud.string(forKey: refreshTokenStr) ?? ""
        } set {
            ud.set(newValue, forKey: refreshTokenStr)
        }
    }
}
