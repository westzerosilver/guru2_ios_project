//
//  APIService.swift
//  guru_ios
//
//  Created by yeseo on 2023/01/25.
//

import Foundation
import Alamofire
import AlamofireImage
import CoreLocation

class WeatherAPIService {
    
    static let weatherAPIService = WeatherAPIService()
    var currentData:CurrentWeaterData! //전체 데이터 저장
    
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
                //weatherIcon.af.setImage(withURL: url)
                print(url)
            }
    //        //날씨 설정
    //        weather.text = WData.description
    //        //온도 설정
    //        temp.text = String(TData.temp)
            
            print(WData.description)
            print(TData.temp)
        }
}
