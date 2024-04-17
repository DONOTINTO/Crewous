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
    let refreshAccessToken = PublishRelay<Void>()
    let completionHandler = PublishRelay<() -> Void>()
    
    override func loadView() {
        
        self.view = LayoutView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configure()
        makeBackBarButton()
        configureNavigation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.layoutView.endEditing(true)
    }
    
    func bind() {
        
        let refreshObservable = refreshAccessToken.flatMap {
            return (APIManager.callAPI(router: Router.refresh, dataModel: RefreshDataModel.self))
        }
        
        Observable.zip(refreshObservable, completionHandler)
            .bind(with: self) { owner, data in
                
                let (result, completion) = data
                
                switch result {
                case .success(let refreshData):
                    
                    print("#### Refresh API Success ####")
                    UDManager.accessToken = refreshData.accessToken
                    completion()
                    
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
    
    func errorHandler(_ apiError: APIError, calltype: APIError.CallType, completionHandler: @escaping (() -> Void) = { }) {
        
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
                refreshAccessToken.accept(())
                self.completionHandler.accept(completionHandler)
                
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
            
            // MARK: Fetch My Crew ( Like2를 누른 Post 정보 가져오기)
        case .fetchMyCrew:
            
            switch apiError {
            case .code400, .code401, .code403:
                // 유효하지 않은 엑세스 토큰 -> 로그인 화면으로 이동
                makeAlert(msg: "Error Code: \(apiError.rawValue)") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToSignIn()
                }
            case .code419:
                // 엑세스 토큰 재발급
                refreshAccessToken.accept(())
                self.completionHandler.accept(completionHandler)
                
            default:
                return
            }
            
            // MARK: Upload Image
        case .uploadImage:
            
            switch apiError {
            case .code400, .code401, .code403:
                
                // 유효하지 않은 엑세스 토큰 -> 로그인 화면으로 이동
                makeAlert(msg: "Error Code: \(apiError.rawValue)") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToSignIn()
                }
                
            case .code419:
                
                // 엑세스 토큰 재발급
                refreshAccessToken.accept(())
                self.completionHandler.accept(completionHandler)
                
            default:
                return
            }
            
            // MARK: Make Crew
        case .makeCrew:
            
            switch apiError {
            case .code401, .code403:
                
                // 유효하지 않은 엑세스 토큰 -> 로그인 화면으로 이동
                makeAlert(msg: "Error Code: \(apiError.rawValue)") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToSignIn()
                }
                
            case .code410:
                
                makeAlert(msg: "크루 생성 실패하여 재시도합니다", buttonTitle: "Retry") { _ in
                    completionHandler()
                }
                
            case .code419:
                // 엑세스 토큰 재발급
                refreshAccessToken.accept(())
                self.completionHandler.accept(completionHandler)
                
            default:
                return
            }
            
            // MARK: 크루 가입(Post Like-2)
        case .like2:
            
            switch apiError {
            case .code400, .code401, .code403, .code410:
                
                makeAlert(msg: "크루 생성 실패하여 재시도합니다", buttonTitle: "Retry") { _ in
                    completionHandler()
                }
            case .code419:
                // 엑세스 토큰 재발급
                refreshAccessToken.accept(())
                self.completionHandler.accept(completionHandler)
            default:
                return
            }
            
        case .withDraw:
            
            switch apiError {
            case .code401, .code403:
                
                // 유효하지 않은 엑세스 토큰 -> 로그인 화면으로 이동
                makeAlert(msg: "Error Code: \(apiError.rawValue)") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToSignIn()
                }
            case .code419:
                
                // 엑세스 토큰 재발급
                refreshAccessToken.accept(())
                self.completionHandler.accept(completionHandler)
                
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
    
    func makeAlert(msg: String, buttonTitle: String, handler: @escaping ((UIAlertAction) -> Void) = { _ in }) {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        let cancleAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAlertAction)
        alert.addAction(cancleAlertAction)
        
        present(alert, animated: true)
    }
    
    func changeRootViewToSignIn() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        let rootVC = SignInViewController()
        let naviVC = UINavigationController(rootViewController: rootVC)
        
        UDManager.isLogin = false
        UDManager.isJoinedCrew = false
        UDManager.accessToken = ""
        UDManager.refreshToken = ""
        
        sceneDelegate.window?.rootViewController = naviVC
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    func changeRootViewToStats() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        let tabVC = sceneDelegate.makeTabVC()
        
        sceneDelegate.window?.rootViewController = tabVC
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
