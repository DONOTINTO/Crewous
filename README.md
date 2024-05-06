# Crewous

**📘 앱 소개 및 기능**

출시 기간 : 2024.04.10 ~ 2024.05.05

- 농구 크루를 생성 또는 가입하여 크루 단위의 정보를 습득
- **Configuration** : 최소버전 16.0 / 세로모드 / 아이폰용 / 라이트 모드

**📘 핵심 기능**

- **크루 생성 |** 사진 및 크루 정보들을 바탕으로 나의 크루를 생성
- **크루 가입 |** 포트원을 통해 크루 가입 시 금액을 지불하고 가입 가능
- **크루 검색 |** 등록된 크루들의 이름을 통해 검색 가능
- **크루 댓글 |** 내 크루, 상대 크루 상관없이 댓글을 달고 삭제 가능

 ****

**📘 기술 스택**

**프레임워크**

- **UIKit(Code Base)**

**라이브러리**

- **Snapkit(codebase UI)**
- **Alamofire**
- **KingFisher**
- **RxSwift**
- **RxDataSource**

**디자인 패턴**

- **MVVM**

**버전 관리**

- **Git / Github / Github Desktop**

**📘 Crewous를 진행하며 배운 점들**

1. Alamofire의 다양한 활용법과 네트워크 통신의 이해

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

1. embedded View

embedded view를 통해 한 화면에서 여러 view를 embedded하여 사용했다.

각 view의 재사용성을 높일 수 있다는 점이 가장 좋았지만 그만큼 viewModel을 통해 데이터를 전달하는 과정이 쉽지만은 않았다.

비교적 구조가 간단했던 결제 쪽에서 DIP를 준수한 DI를 적용해봤다.

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled.png)

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%201.png)

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%202.png)

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%203.png)

1. PageVC와 CollectionView

PageVC에서 스와이프로 페이지가 변경되면 설정한 Delegate를 통해 CollectionView로 페이지 변경을 알림

CollectionView에서 셀의 클릭은 pageVC의 setViewControllers 메소드를 통해 pageVC를 변경해주었다.

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%204.png)

기능이 동일한 함수지만 가독성을 위해 구분해두었다

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%205.png)

![Untitled](Crewous%202df56d1d73b54cb685405b6d98230c3d/Untitled%206.png)

사실 postData, userData, afterPagingEvent 세가지 시퀀스가 섞여있는 구조라 상당히 마음에 안들지만 시간 내 안전하게 리팩토링할 자신이 솔직히 없었다

1. API 통신 실패

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