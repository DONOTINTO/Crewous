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
                    
                    switch response.result {
                    
                    // 모든 통신 결과는 Single의 success로 반환
                    // 의도적으로 single이 disposed되는 것을 방지
                    //Result<Success, Failure>
                    case .success(let success):
                        // Signle<Result<success, fail>, fail>
                        // -> Result<success, fail>
                        // -> success
                        single(.success(.success(success)))
                        
                    case .failure(_):
                        // Signle<Result<success, fail>, fail>
                        // -> Result<success, fail>
                        // -> fail
                        let errorCode = responseData.statusCode
                        // Custom API Error로 Error 코드 구분
                        guard let error = APIError(rawValue: errorCode) else { return }
                        
                        single(.success(.failure(error)))
                    }
                }
            } catch {
                // URL 문제
                single(.success(.failure(APIError.unknownError)))
            }
            
            return Disposables.create()
        }
    }
}
