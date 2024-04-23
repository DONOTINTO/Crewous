//
//  APIInterceptor.swift
//  Crewous
//
//  Created by 이중엽 on 4/18/24.
//

import Foundation
import Alamofire

class APIInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        print("-----adapt⚠️--------")
        
        let accessToken = UDManager.accessToken
        
        if accessToken == "" {
            //없으면 그냥 해 무관한 애야
            completion(.success(urlRequest))
            return
        }
        
        // 있으면 얘로 바꿔서 진행해
        var urlRequest = urlRequest
        
        urlRequest.setValue(accessToken, forHTTPHeaderField: HTTPHeader.Key.authorization.rawValue)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print("-----retry⚠️--------")
        // 코드 419번일때만 엑세스토큰 재발급해
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // >>>
        do {
            let urlRequest = try Router.refresh.asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: RefreshDataModel.self) { response in
                
                guard let responseData = response.response else { return }
                let statusCode = responseData.statusCode
                
                switch response.result {
                    
                case .success(let data):
                    print("-----retry 통신 성공⚠️--------")
                    // 나 재발급 성공했어 adapt야 다시 시도해
                    UDManager.accessToken = data.accessToken
                    completion(.retry)
                    
                case .failure(let error):
                    print("-----retry 통신 실패 \(statusCode)⚠️--------")
                    // 나 재발급 실패했어 (418번 리프레시 토큰 만료) -> 너 로그아웃해
                    // 밖에서는 무조건 419로 받음 (그떄는 걸러걸러 419가 나온거기 떄문에, 그냥 로그아웃 처리)
                    completion(.doNotRetryWithError(error))
                }
            }
        } catch {
            completion(.doNotRetryWithError(error))
        }
        
    }
}
