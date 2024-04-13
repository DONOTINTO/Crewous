//
//  SignUpQuery.swift
//  Crewous
//
//  Created by 이중엽 on 4/12/24.
//

import Foundation

struct SignUpQuery: Encodable {
    let email: String
    let password: String
    let nick: String // 닉네임 / 키 / 몸무게 / 포지션 저장
}
