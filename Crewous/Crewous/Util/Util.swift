//
//  Util.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation

enum Util {
    
    // 정규식
    enum RegularExpression {
        
        static func validateEmail(_ input: String) -> Bool {
            
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            return emailPredicate.evaluate(with: input)
        }
        
        static func validatePassword(_ input: String) -> Bool {
            
            let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}" // 8자리 ~ 20자리 영어+숫자+특수문자
            let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

            return predicate.evaluate(with: input)
        }
    }
    
    // 숫자
    enum Num {
        
        static func isDouble(_ input: String) -> Bool {
            
            if let result = Double(input) {
                return true
            }
            
            return false
        }
    }
}
