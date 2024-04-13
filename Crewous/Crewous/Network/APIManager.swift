//
//  APIManager.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

struct APIManager {
    
    static func callAPI<T: Decodable>(router: Router, dataModel: T.Type) -> Single<Result<T, APIError>> {
        
        return Single<Result<T, APIError>>.create { single in
            do {
                // router -> URLRequest
                let urlRequest = try router.asURLRequest()
                
                // AF -> API 통신
                AF.request(urlRequest).responseDecodable(of: T.self) { response in
                    
                    guard let responseData = response.response else { return }
                    let statusCode = responseData.statusCode
                    
                    switch response.result {
                    
                    // 모든 통신 결과는 Single의 success로 반환
                    case .success(let success):
                        
                        print("success")
                        
                        // Signle<Result<success, fail>, fail>
                        // -> Result<success, fail>
                        // -> success
                        single(.success(.success(success)))
                        
                    case .failure(_):
                        
                        print("failure - \(statusCode)")
                        
                        // Custom API Error로 Error 코드 구분
                        guard let error = APIError(rawValue: statusCode) else {
                            print("정의되지 않은 error code 입니다")
                            return
                        }
                        
                        // Signle<Result<success, fail>, fail>
                        // -> Result<success, fail>
                        // -> fail
                        single(.success(.failure(error)))
                    }
                }
            } catch {
                single(.success(.failure(APIError.incorrectURL)))
            }
            
            return Disposables.create()
        }
    }
}
