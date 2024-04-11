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
                let urlRequest = try router.asURLRequest()
                
                AF.request(urlRequest).responseDecodable(of: T.self) { response in
                    
                    guard let responseData = response.response else { return }
                    
                    switch response.result {
                        
                    case .success(let success):
                        print("success")
                        single(.success(.success(success)))
                        
                    case .failure(let failure):
                        
                        let errorCode = responseData.statusCode
                        
                        guard let error = APIError(rawValue: errorCode) else { return }
                        
                        single(.success(.failure(error)))
                    }
                }
            } catch {
                single(.success(.failure(APIError.unknown999)))
            }
            
            return Disposables.create()
        }
    }
}
