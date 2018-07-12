# 20180712_Day23_kakao_map



## 다음 Map

다음앱 api 검색해서 app하나 만들기

`javascript key` 필요



내어플리케이션 -> test_map -> 설정[일반] -> 플랫폼에 내 서버주소 추가하기



Maps API

> http://apis.map.daum.net/web/sample/basicMap/
>
> Docs에서 이벤트, 메소드들 확인가능 



```erb
<script> 
	var 변수 = document(이건 이 창 자체). id값이 ' '인것을 찾아서 변수에넣음,
        
        var 변수 = {   //var 삭제가능
            center: 위도, 경도 를 줌
            level: 
        }
    
</script>
```

↓ 스크립트안에 내용바꾸기

```erb
<div id="map" style="width:100%;height:350px;"></div>
<div id="clickLatlng"></div>   <!-- 추가-->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=API키 입력"></script>

<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

// 지도를 클릭한 위치에 표출할 마커입니다
var marker = new daum.maps.Marker({ 
    // 지도 중심좌표에 마커를 생성합니다 
    position: map.getCenter() 
}); 
// 지도에 마커를 표시합니다
marker.setMap(map);

// 지도에 클릭 이벤트를 등록합니다
// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
daum.maps.event.addListener(map, 'click', function(mouseEvent) {        
    
    // 클릭한 위도, 경도 정보를 가져옵니다 
    var latlng = mouseEvent.latLng; //mouseEvent 이벤트가 발생하면 latLng 메소드가 발생한다.
    console.lig(latlng);
    
    // 마커 위치를 클릭한 위치로 옮깁니다
    marker.setPosition(latlng);
    
    var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
    message += '경도는 ' + latlng.getLng() + ' 입니다';
    
    var resultDiv = document.getElementById('clickLatlng'); 
    resultDiv.innerHTML = message;
    
});
</script>
```





### model 생성

` $ rails g model post title lat lng`



> `$ install figaro` 해서 `.yml` 파일에 api key 따로 담아놓을 수 있음



*views/home/new.html.erb*

```erb
<h1>Home#new</h1>

<!--정보를 받아서 저장하는 폼 작성 -->
<%= form_for @post, url: {action: "create"} do |f| %>
  title : <%= f.text_field :title %> <br/>
  위치 : <%= f.text_field :lat %>
  <%= f.text_field :lng %>
  <%= f.submit "Create" %>
<% end %>
```

```erb
<body>
<div id="map" style="width:100%;height:350px;"></div>
<p><em>지도를 클릭해주세요!</em></p> 
<div id="clickLatlng"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c8d0ae031119b5383c24351164f52b37"></script>
<script>
var mapContainer = document.getElementById('map') // 지도를 표시할 div 
var mapOption = { 
        center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

// 지도를 클릭한 위치에 표출할 마커입니다
var marker = new daum.maps.Marker({ 
    // 지도 중심좌표에 마커를 생성합니다 
    position: map.getCenter() 
}); 
// 지도에 마커를 표시합니다
marker.setMap(map);

// 지도에 클릭 이벤트를 등록합니다
// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
daum.maps.event.addListener(map, 'click', function(mouseEvent) {        
    
    // 클릭한 위도, 경도 정보를 가져옵니다 
    var latlng = mouseEvent.latLng; //다음에서 만든 메소드 (Docs가서 살펴보기)
    
    // 마커 위치를 클릭한 위치로 옮깁니다
    marker.setPosition(latlng);
    
    console.log(lat);
    console.log(lng);
    
    // 입력창에 클릭한 위치의 위도, 경도 정보 넣기 
    document.getElementById('lat').value = lat;  
    document.getElementById('lng').value = lng;

    
    // var resultDiv = document.getElementById('clickLatlng'); 
    // resultDiv.innerHTML = message;
    
    
});
</script>
```



* Create 완성 (db에  저장)

*app/controllers/home_controllers.rb*

```ruby
class HomeController < ApplicationController
  def index
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to '/home/new'
  end
  
  private  # 컨트롤러안에서만 사용하는 메소드
  def post_params
     params.require(:post).permit(:title, :lat, :lng)
  end
end
```





### 지도에 위치 클릭하면 인포윈도우 생성하기

*views/home/new.html.erb*

```erb
...
<script>
...

// 지도에 클릭 이벤트를 등록합니다
// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
daum.maps.event.addListener(map, 'click', function(mouseEvent) {        
    
    // 클릭한 위도, 경도 정보를 가져옵니다 
    var latlng = mouseEvent.latLng; // latlng: 값들의 덩어리인 객체
    
    // 마커 위치를 클릭한 위치로 옮깁니다
    marker.setPosition(latlng);
    
    var lat = latlng.getLat();
    var lng = latlng.getLng();
    
    console.log(lat);
    console.log(lng);
    
    document.getElementById('lat').value = lat;
    document.getElementById('lng').value = lng;
    
    var iwContent = '<div style="padding:5px;">내가 클릭해쩡!</div>', // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
    iwPosition = new daum.maps.LatLng(lat, lng), //인포윈도우 표시 위치입니다
    iwRemoveable = true; // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다

// 인포윈도우를 생성하고 지도에 표시합니다
    var infowindow = new daum.maps.InfoWindow({
        map: map, // 인포윈도우가 표시될 지도
        position : iwPosition, 
        content : iwContent,
        removable : iwRemoveable
    });

    
    // var resultDiv = document.getElementById('clickLatlng'); 
    // resultDiv.innerHTML = message;
    
});
</script>
```





### 시작시 마커 db에 저장된 위치로 변경하기

*app/controllers/home_controllers.rb*

```ruby
...
  def new
    @p = Post.first    # 추가
    @post = Post.new
  end
...
```



*views/home/new.html.erb*

```erb
<script>
var mapContainer = document.getElementById('map') // 지도를 표시할 div 
var mapOption = { 
        center: new daum.maps.LatLng(<%= @p.lat.to_i %>, <%= @p.lng.to_i %>), // 수정
        level: 3 // 지도의 확대 레벨
    };

var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
...
</script>
```

