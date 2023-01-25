//
//  ViewController.swift
//  WeatherTest
//
//  Created by yeseo on 2023/01/21.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreLocation

class ViewController: UIViewController {
    
    let key:String = "51518b2be4cd74362f31ee3f4be6b8ad"
    var currentData:CurrentWeaterData! //전체 데이터 저장
    
    //let location:CLLocation! = nil
    var locationManager = CLLocationManager()

    
    @IBOutlet weak var weatherIcon: UIImageView! //아이콘
    @IBOutlet weak var weather: UILabel! // 날씨
    @IBOutlet weak var temp: UILabel! //온도
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
    }
        
    
    func getData(_ location:CLLocationCoordinate2D) {
        
            let headers: HTTPHeaders=[
                //"appid": "51518b2be4cd74362f31ee3f4be6b8ad"
                "units" : "metric"
            ]
        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=51518b2be4cd74362f31ee3f4be6b8ad&lang=kr&units=metric", headers: headers).responseJSON{response in
    
                //데이터 저장
                switch response.result {
                case .success(let data) :
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        self.currentData = try decoder.decode(CurrentWeaterData.self, from: jsonData)
                        self.settings(self.currentData.weather[0], self.currentData.main)
    
                    } catch {
                        debugPrint(error)
                    }
                case .failure(let data): print("fail")
                default: return
                }
    
            }

    }
    
    func settings(_ WData:WeatherData, _ TData:TempData) {
        //아이콘 설정
        if let url = URL(string: "https://openweathermap.org/img/wn/\(WData.icon)@2x.png"){
            weatherIcon.af.setImage(withURL: url)
        }
        //날씨 설정
        weather.text = WData.description
        //온도 설정
        temp.text = String(TData.temp)
    }
    
    
    
    func checkLocationAuth() {
            
        // 3.1
        guard CLLocationManager.locationServicesEnabled() else {
            // 시스템 설정으로 유도하는 커스텀 얼럿
            locationAlert()
            return
        }
            
            
        // 3.2
        let authorizationStatus: CLAuthorizationStatus
            
        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
            
        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        userCurrentLocationAuth(authorizationStatus)
    }
    
    func userCurrentLocationAuth(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            
            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            // 권한 요청
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted:
            // 권한이 없는 상태
            locationAlert()
            
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태: 위치 가져오기
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }
    
    func locationAlert() {
        let locationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            //async { await self?.reloadData() }
        }
        locationServiceAlert.addAction(cancel)
        locationServiceAlert.addAction(goSetting)
        
        present(locationServiceAlert, animated: true)
    }
}

extension ViewController:CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            if let coordinate = locations.last?.coordinate {
                getData(coordinate)
            }
            
            // startUpdatingLocation()을 사용하여 사용자 위치를 가져왔다면
            // 불필요한 업데이트를 방지하기 위해 stopUpdatingLocation을 호출
            locationManager.stopUpdatingLocation()
        }
    
        // 위치 정보를 가져오지 못했을 때 호출
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
        
        // 앱에 대한 권한 설정이 변경되면 호출
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            //위치 서비스가 활성화 상태인지 확인
            checkLocationAuth()
        }
        
        // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            // 위치 서비스가 활성화 상태인지 확인
            checkLocationAuth()
        }
}
