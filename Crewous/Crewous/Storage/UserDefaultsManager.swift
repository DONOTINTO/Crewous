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
    private static let isJoinedCrewStr = "joinedCrew"
    private static let accessTokenStr = "accessToken"
    private static let refreshTokenStr = "refreshToken"
    
    static var isLogin: Bool {
        get {
            return ud.bool(forKey: isLoginStr)
        } set {
            ud.set(newValue, forKey: isLoginStr)
        }
    }
    
    static var isJoinedCrew: Bool {
        get {
            return ud.bool(forKey: isJoinedCrewStr)
        } set {
            ud.set(newValue, forKey: isJoinedCrewStr)
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
