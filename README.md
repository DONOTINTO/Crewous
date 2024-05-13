# Crewous

<p align="center">
	<img src = "https://github.com/DONOTINTO/ToughCookie/assets/123792519/481f88bb-6b60-4b15-8100-5ccf4a0d1782" align="center" width="24%">
	<img src = "https://github.com/DONOTINTO/ToughCookie/assets/123792519/0b722abc-cc39-4236-acf5-c1dba64374f6" align="center" width="24%">
	<img src = "https://github.com/DONOTINTO/ToughCookie/assets/123792519/cd856b89-7ddd-4560-8379-a2c25251aaf3" align="center" width="24%">
	<img src="https://github.com/DONOTINTO/ToughCookie/assets/123792519/59543360-ca27-40e1-9bf7-ba03ac52e877" align="center" width="24%">
</p> <br>

## 앱 소개 및 기능

> 출시 기간 : 2024.04.10 ~ 2024.05.05   
> 최소버전 16.0 / 세로모드 / 아이폰 전용

 Crewous는 농구 크루를 편하게 하기 위해 기획된 앱입니다. 앱에 가입하게 되면 내가 원하는 크루를 검색 또는 추천 받을 수 있습니다.
원하는 크루가 없다면 직접 크루를 생성할 수 있습니다. 크루에는 크루 가입 비용이 존재하며, 크루에 가입 시 결제가 진행됩니다.
결제가 성공적으로 진행된다면 해당 크루에 가입할 수 있습니다.
생성된 크루의 정보창에 들어가게 된다면, 크루 정보 및 멤버를 확인할 수 있으며 크루별로 댓글을 달 수 있습니다.

## 핵심 기능
### 크루 생성
> 사진 및 크루 정보들을 바탕으로 나의 크루를 생성

### 크루 가입
> 포트원을 통해 크루 가입 시 금액을 지불하고 가입 가능

### 크루 검색
> 등록된 크루들의 이름을 통해 검색 가능

### 크루 댓글
> 내 크루, 상대 크루 상관없이 댓글을 달고 삭제 가능

## 기술 스택

`UIKit(CodeBase)` <br>
`Alamofire` / `YPImagePicker` / `PHPicker`/ `KingFisher` / `SnapKit` <br>
`RxSwift` / `RxDataSource` <br>
`Portone` <br>
`UICollectionCompositional Layout` <br> 
`MVVM` / `Input Output` / `Router` <br>
`Git` / `Github` / `Figma` <br>

- 이전 프로젝트에서 고려했던 `Router 패턴`과 `Generic`을 실질적으로 사용해보며 `Alamofire`를 활용하고, `Interceptor`를 통해 서버 통신에 필요한 `JWT 토큰`이 만료되었는지 체크하는 코드를 통해 대응 요소를 줄였음

- `RxSwift`와 `Input Ouput 패턴` 통해 Action과 비즈니스 로직을 분리하고, `ViewModelProtocol`를 통해 일관된 ViewmModel를 구성하고 유지보수성을 고려

- `BaseVC`와 `ErrorHandler` 메소드를 통해 모든 VC에서 동일한 메소드를 통해 에러를 관리하여 코드 재사용성을 높이고 가독성을 높임

## 회고

#### ✏️ Alamofire의 다양한 활용법과 네트워크 통신의 이해

기존에는 request를 통해 간단한 네트워크 통신을 구현한 정도였다면,

이번 프로젝트를 통해 다음 3가지를 이해했다.

1) interceptor를 통한 통신의 사전 검증

- RequestInterceptor 프로토콜에는 adapt와 retry로 구성되어 request시 adapt를 통해 access token을 변경
- retry를 통해 access token이 만료된 경우 새로운 acces token을 재발급 후 request
- retry를 통해 request시 다시 adapt가 호출되면서 자연스럽게 재발급된 access token으로 변경

2) upload(multipartFormData)

- 이미지 네트워킹시 이미지가 아닌 Data로 변환하여 송수신할 수 있다

3) query와 body의 차이

query는 URL 뒤에 key=value 형태로 비교적 간단한 내용들이 전달되며 속도가 빠르지만, url에 노출되는만큼 중요한 정보는 넣지 않았다

body는 json이나 xml형태로 데이터의 양이 크거나 복잡할 때 사용하며, 암호화를 통해 query보다 안전하게 데이터를 전송할 수 있음, 다만 속도가 느릴 수 있다

암호화까지는 진행하지 않았지만, 기존에 이러한 차이점을 모르고 사용하다 여러 케이스들을 접하면서 차이점을 공부할 수 있었다

#### ✏️ PageVC와 CollectionView를 통한 Tab 기능 구현

PageVC에서 스와이프로 페이지가 변경되면 설정한 Delegate를 통해 CollectionView로 페이지 변경을 알리고,

<img src = "https://github.com/DONOTINTO/Document/assets/123792519/44c5e9f0-9101-439e-8df5-e00013ac2e75">

<img src = "https://github.com/DONOTINTO/Document/assets/123792519/078f3a2c-d565-4797-a23d-e4fe37fc7bd0">

CollectionView에서 셀의 클릭은 pageVC의 setViewControllers 메소드를 통해 pageVC를 변경해주었다.

<img src = "https://github.com/DONOTINTO/Document/assets/123792519/013c3ae6-cf80-4999-ac29-e0506da37d26">

이 부분을 직접 구현하면서 아직 데이터 전달에서 많은 아쉬움이 남았다.

값을 넘길 때 ViewModel에 PublishRelay로 값을 그대로 넘겨줬는데, 뷰 모델을 생성해서 VC 생성 시 해당 ViewModel로 넘겨주는 방식도 고려해보았으면 좋았을 것 같다.


---
---
# 수정중!!!


#### ✏️ API 통신 실패

VC는 BaseVC라는 커스텀 VC를 상속받아 생성한다

이를 이용해서 BaseVC에 api error에 대한 처리를 위한 errorHandler 메소드를 만들어두고 모든 VC에서 해당 메소드만 호출하면 되도록 설계했다.

1. 통신에 실패하면 status code를 통해 API Error 인스턴스를 생성하여 반환한다.

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%207.png)

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%208.png)

1. API 통신에 실패하면 해당 VM에서 Output으로 apiError를 던져준다.

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%209.png)

1. VC는 전달받은 apiError와 API 호출타입을 파라미터로 BaseVC에 작성된 errorHandler 메소드를 호출한다.

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%2010.png)

1. BaseVC errorHandler에서 이에 대한 모든 처리를 담당한다.

1) 공통 오류에 대해선 강제종료

2) 엑세스 토큰 오류의 경우 로그인 화면으로 변경

3) 그 외 타입들에 대하여 Alert를 띄우는 등 상황에 맞추어 처리하였다.

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%2011.png)