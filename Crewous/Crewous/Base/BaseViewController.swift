//
//  BaseViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController<LayoutView: UIView>: UIViewController {
    
    var layoutView: LayoutView {
        
        return view as! LayoutView
    }
    
    let disposeBag = DisposeBag()
    private let refreshAccessToken = PublishRelay<Void>()
    
    override func loadView() {
        
        self.view = LayoutView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configure()
        makeBackBarButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.layoutView.endEditing(true)
    }
    
    func bind() {
        
        refreshAccessToken
            .flatMap {
                
                print("#### Refresh API Call ####")
                return APIManager.callAPI(router: Router.refresh, dataModel: RefreshDataModel.self)
            }.bind(with: self) { owner, result in
                
                switch result {
                case .success(let refreshData):
                    
                    print("#### Refresh API Success ####")
                    UDManager.accessToken = refreshData.accessToken
                    
                case .failure(let apiError):
                    
                    print("#### Refresh API Fail - ErrorCode = \(apiError.rawValue) ####")
                    owner.errorHandler(apiError, calltype: .refresh)
                }
            }.disposed(by: disposeBag)
    }
    
    func configure() { }
    
    func configureCollectionView() { }
    
    func configureNavigation() { }
    
    private func makeBackBarButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    func errorHandler(_ apiError: APIError, calltype: APIError.CallType) {
        
        // 공통 오류 -> 강제 종료
        if apiError.checkCommonError() {
            self.forceQuit(apiError.rawValue)
        }
        
        switch calltype {
        // MARK: Sign IN
        case .signIn:
            
            switch apiError {
            case .code400:
                self.makeAlert(msg: "이메일, 비밀번호를 입력해주세요.")
            case .code401:
                self.makeAlert(msg: "이메일, 비밀번호를 확인해주세요.")
            default:
                return
            }
            
        // MARK: Sign In
        case .signUp:
            
            switch apiError {
            case .code400:
                self.makeAlert(msg: "이메일, 비밀번호를 입력해주세요.")
            case .code409:
                self.makeAlert(msg: "이미 가입한 이메일입니다.")
            default:
                return
            }
        
        // MARK: Fetch Self
        case .fetchSelf:
            
            switch apiError {
            case .code401, .code403:
                // 유효하지 않은 엑세스 토큰 -> 로그인 화면으로 이동
                makeAlert(msg: "Error Code: \(apiError.rawValue)") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToSignIn()
                }
                
            case .code419:
                // 엑세스 토큰 재발급
                // 재발급 불가 -> 로그인 화면으로 이동
                refreshAccessToken.accept(())
                
            default:
                return
            }
        
        // MARK: Refresh
        case .refresh:
            
            switch apiError {
            case .code401, .code403, .code418:
                // 유효하지 않은 엑세스 토큰, 접근권한 없음, 리프레시 토큰 만료 -> 로그인 화면으로 이동
                makeAlert(msg: "Error Code: \(apiError.rawValue)") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToSignIn()
                }
                
            default:
                return
            }
        }
    }
    
    
    func forceQuit(_ errorCode: Int) {
        
        let alert = UIAlertController(title: "Error", message: "Quotes with unexpected error -\(errorCode)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Quit", style: .cancel) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
    func makeAlert(msg: String, handler: @escaping ((UIAlertAction) -> Void) = { _ in }) {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
    func changeRootViewToSignIn() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        let rootVC = SignUpViewController()
        let naviVC = UINavigationController(rootViewController: rootVC)
        
        sceneDelegate.window?.rootViewController = naviVC
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    func changeRootViewToStats() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        let statsVC = StatsViewController()
        let statsNaviVC = UINavigationController(rootViewController: statsVC)
        
        let tabVC = UITabBarController()
        tabVC.setViewControllers([statsNaviVC], animated: true)
        
        sceneDelegate.window?.rootViewController = tabVC
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
