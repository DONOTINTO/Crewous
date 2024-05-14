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

### ✏️ Alamofire의 다양한 활용법과 네트워크 통신의 이해

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

### ✏️ 유지보수를 고려한 에러 핸들링 적용하기

이전 DoT 프로젝트에서는 AF의 Result에 AFError대신 커스텀 에러를 사용할 수 있다는 점을 알게 됐다.
Crewous에서는 이를 적용하여 커스텀 Error를 만들었는데, 적용 방식은 다음과 같았다.

1. `ViewModel`에서 `API 호출`
2. `Status Code`를 통해 `커스텀 Error 생성`
3. `Result`를 통해 커스텀 Error를 다시 `ViewModel로 전달`
4. ViewModel은 이를 `Output으로 VC에 전달`

구조가 이렇다보니, 각 VC마다 Error에 대한 처리가 필요했는데 넘어오는 Status Code에 따른 처리가 비슷한 반면 VC마다 코드를 처리하다 보니 코드가 반복되는 부분은 BaseVC에서 메소드를 생성하여 이를 상속받은 VC에서 해당 메소드만을 호출하면 되도록 했다.

<img src = "https://github.com/DONOTINTO/Crewous/assets/123792519/6caab862-b79b-45f2-aa97-3eb042bbf406">

1. BaseVC errorHandler에서 이에 대한 모든 처리를 담당한다.

1) 공통 오류에 대해선 강제종료

2) 엑세스 토큰 오류의 경우 로그인 화면으로 변경

3) 그 외 타입들에 대하여 Alert를 띄우는 등 상황에 맞추어 처리하였다.

## 트러블슈팅

### ✏️ PageVC와 CollectionView를 통한 Tab 기능 구현

#### ❗️ 문제상황

탭을 담당하는 CollectionView의 셀을 클릭했을 때 크루 정보 탭은 정상 동작했지만, 멤버 탭은 화면 전환은 이루어져도 화면이 그려지지 않았다.

#### ❗️ 원인파악

PageVC를 생성할 때 PageVC ViewModel에 크루 정보가 담긴 `PostData`와 멤버 정보가 담긴 `userData`를 넘겨주고 PageVC에서 다시 InfoVC와 MemberVC에 각각 PostData와 UserData를 넘겨준다.

다만 PageVC는 초기 생성될 때 노출되는 첫 화면에 대해서만 실제 VC가 ViewDidLoad가 되고 있었기 때문에, 해당 시점에 MemberVC에 UserData를 넘겨줘도 아직 시퀀스를 구독하기 이전이기 때문에 시퀀스가 무시됐던 것이었다.

<img src = "https://github.com/DONOTINTO/Crewous/assets/123792519/ec29c25c-2988-42c1-89e7-9aaebfba4bf5">

#### ! 해결방법

셀을 클릭해서 다음 화면으로 넘어가서 실제 MemberVC가 ViewDidLoad 된 후 값을 넘겨줬다.

1. 셀을 클릭하면 선택한 셀의 row를 저장한다.

<img src = "https://github.com/DONOTINTO/Crewous/assets/123792519/47f87855-0991-4b56-9ca4-cfe3833d638a">

2. ViewModel에서는 (왼쪽 스와이프 / 오른쪽 스와이프)를 판별하여 저장하고 selected row 값을 저장한다.

<img src = "https://github.com/DONOTINTO/Crewous/assets/123792519/1bda1421-687e-407a-ab5b-7d3000a25a28">

3. 저장한 selected row값 역시 전달한다.

<img src = "https://github.com/DONOTINTO/Crewous/assets/123792519/4f8024ca-8a64-4586-8596-c6ab936aa521">

4. 넘겨받은 seleted row를 통해 선택된 page를 확인하고 해당하는 viewModel에 다시 한번 데이터를 전달한다. 이 후 seleted row 데이터가 전달받을때마다 동작해야하기 때문에 zip대신 combinelastest를 사용했다.

<img src = "https://github.com/DONOTINTO/Crewous/assets/123792519/9920e77c-c521-4f16-ac68-ea11e919f67b">