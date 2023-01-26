//
//  InterfaceController.swift
//  AntiSleep WatchKit Extension
//
//  Created by suhseungju on 2023/01/21.
//

import WatchKit
import Foundation
import HealthKit

import UIKit
import CoreLocation

class InterfaceController: WKInterfaceController {
    var sleepCount : Int = 0

    @IBOutlet weak var driveBtn: WKInterfaceButton!
    @IBOutlet weak var stopDrivingBtn: WKInterfaceButton!
    @IBOutlet weak var finishDriveBtn: WKInterfaceButton!
    
    @IBOutlet weak var countTextLabel: WKInterfaceLabel!
    let delegate = WKExtension.shared().delegate as! ExtensionDelegate
    
    
    var locationManager = CLLocationManager()
    private var showing = false
    
    
    
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        locationManager.delegate = self
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func dBtnTapped() {
        self.pushController(withName: "drive", context: nil)
    }
    @IBAction func sdBtnTapped() {
        //driveBtn.setTitle("Driving")
        self.pushController(withName: "finishDrive", context: nil)
    }
    @IBAction func fdTapped() {
        //driveBtn.setTitle("Driving")
        self.pushController(withName: "startDrive", context: nil)
    }
    
    func setLabel() {
        self.countTextLabel.setText("졸음 운전 횟수 : \(sleepCount)")
    }
    
    var healthStore: HKHealthStore?
    
    
}

extension InterfaceController:CLLocationManagerDelegate {
    
    
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
        let action1 = WKAlertAction.init(title: "확인", style:.default) {
            print("cancel action")
            //async { await self.reloadData() }
        }
        
        self.presentAlert(withTitle: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle:.actionSheet, actions: [action1])
    }
    
    
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            if let coordinate = locations.last?.coordinate {
                WeatherAPIService.weatherAPIService.getData(coordinate)
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

/*extension InterfaceController:HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        //
    }
    
    func workdoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
        }
    }
}*/

