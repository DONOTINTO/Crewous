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
                AF.request(urlRequest, interceptor: APIInterceptor()).responseDecodable(of: T.self) { response in
                    print("통신❗️")
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
    
    static func uploadImage<T: Decodable>(router: Router, dataModel: T.Type, image: Data) -> Single<Result<T, APIError>> {
        
        let url = URL(string: router.baseURL + router.path)!
        
        let header: HTTPHeaders = [
            HTTPHeader.Key.authorization.rawValue: UDManager.accessToken,
            HTTPHeader.Key.contentType.rawValue: HTTPHeader.Value.data.rawValue,
            HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue
        ]
        
        return Single<Result<T, APIError>>.create { single in
            AF.upload(multipartFormData: { multiPartFormData in
                
                if let parameters = router.parameters {
                    for (key, value) in parameters {
                        
                        multiPartFormData.append(
                            value as! Data,
                            withName: key,
                            fileName: "goods99j.jpeg",
                            mimeType: "image/jpeg"
                        )
                    }
                }
                
            }, to: url, method: router.method ,headers: header)
            .responseDecodable(of: dataModel.self) { response in
                
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
            return Disposables.create()
        }
    }
}
