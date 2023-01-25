//
//  Weather.swift
//  WeatherTest
//
//  Created by yeseo on 2023/01/24.
//

import Foundation
import Alamofire
import AlamofireImage
import CoreLocation

//class Weather{
//    func getData(_ location:CLLocation) {
//        print("oooooooo")
//            let headers: HTTPHeaders=[
//                //"appid": "51518b2be4cd74362f31ee3f4be6b8ad"
//                "units" : "metric"
//            ]//,https://api.openweathermap.org/data/2.5/weather?lat=37.65&lon=127.33&appid=51518b2be4cd74362f31ee3f4be6b8ad&lang=kr&units=metri
//        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=51518b2be4cd74362f31ee3f4be6b8ad&lang=kr&units=metric", headers: headers).responseJSON{response in
//    
//                //데이터 저장
//                switch response.result {
//                case .success(let data) :
//                    //print(data)
//                    do{
//                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//                        let decoder = JSONDecoder()
//                        self.currentData = try decoder.decode(CurrentWeaterData.self, from: jsonData)
//    
//                        self.settings(self.currentData.weather[0], self.currentData.main)
//    
//                    } catch {
//                        debugPrint(error)
//                    }
//                case .failure(let data): print("fail")
//                default: return
//                }
//    
//            }
//
//    }
//    
//    func settings(_ WData:WeatherData, _ TData:TempData) {
//        //아이콘 설정
//        if let url = URL(string: "https://openweathermap.org/img/wn/\(WData.icon)@2x.png"){
//            weatherIcon.af.setImage(withURL: url)
//        }
//        //날씨 설정
//        weather.text = WData.description
//        //온도 설정
//        temp.text = String(TData.temp)
//    }
//}
