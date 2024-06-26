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
    
    override func loadView() {
        
        self.view = LayoutView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configure()
        makeBackBarButton()
        configureNavigation()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.layoutView.endEditing(true)
    }
    
    func bind() { }
    
    func configure() { }
    
    func configureCollectionView() { }
    
    func configureNavigation() { }
    
    private func makeBackBarButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem?.tintColor = .customBlack
    }
    
    func errorHandler(_ apiError: APIError, calltype: APIError.CallType, completionHandler: @escaping (() -> Void) = { }) {
        
        // 공통 오류 -> 강제 종료
        if apiError.checkCommonError() {
            self.forceQuit(apiError.rawValue)
        }
        
        // 엑세스 토큰 오류 (intercept로 이미 재시도 후 넘어온 오류이기에 재발급 실패로 봐도 무방) -> 로그인 화면으로 변경
        if apiError.checkAccessTokenError() {
            self.changeRootViewToSignIn()
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
            
            // MARK: Fetch Self, Fetch My Crew ( Like2를 누른 Post 정보 가져오기), Upload Image, 회원탈퇴, 특정 포스트 조회, 유저 조회, 모든 포스트 조회
        case .fetchSelf, .fetchMyCrew, .uploadImage, .withDraw, .fetchPost, .fetchUser, .fetchCrew:
            switch apiError {
            case .code400, .code401, .code403:
                // 유효하지 않은 엑세스 토큰 -> 로그인 화면으로 이동
                makeAlert(msg: "Error Code: \(apiError.rawValue)") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToSignIn()
                }
                
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
            default:
                return
            }
            
            // MARK: 결제 검증 실패
        case .paymentValidation:
            switch apiError {
            
            case .code401, .code403:
                
                makeAlert(msg: "Error Code: \(apiError.rawValue)") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToSignIn()
                }
            case .code409:
                
                makeAlert(msg: "검증처리가 완료되었습니다.")
            case .code410:
                
                makeAlert(msg: "게시물을 찾을 수 없습니다.") { [weak self] _ in
                    
                    guard let self else { return }
                    
                    self.changeRootViewToStats()
                }
            default: return
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
    
    func setDetent() {
        
        let fraction = UISheetPresentationController.Detent.custom { _ in 300 }
        self.sheetPresentationController?.detents = [fraction, .medium(), .large()]
        self.sheetPresentationController?.prefersGrabberVisible = true
        self.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = false
    }
}
