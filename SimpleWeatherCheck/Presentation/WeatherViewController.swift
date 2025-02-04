//
//  ViewController.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/3/25.
//

import UIKit
import MapKit
import CoreLocation

import SnapKit
import Then

final class WeatherViewController: BaseViewController {
    
    private let locationManager = CLLocationManager()
    private var selectedPhoto = Observable(UIImage())
    private var currentLocation = CLLocationCoordinate2D(latitude: 37.6545021055909, longitude: 127.049672533607)
    
    let weatherView = WeatherView()
    
    override func loadView() {
        view = weatherView
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        checkDeviceLocationService()
    }
    
    override func configView() {
        selectedPhoto.bind { UIImage in
            
        }
    }
    
    override func configNavigation() {
        navigationItem.title = "날씨 췍 ↗"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func configDelegate() {
        print(#function)
        locationManager.delegate = self
    }
    
    private func setupActions() {
        weatherView.currentLocationButton.addAction(UIAction(handler: { _ in
            self.currentLocationButtonTapped()
        }), for: .touchUpInside)
        weatherView.refreshButton.addAction(UIAction(handler: { _ in
            self.refreshButtonTapped()
        }), for: .touchUpInside)
        weatherView.photoButton.addAction(UIAction(handler: { _ in
            let vc = PhotoSelectViewController()
            vc.completion = {
                print(#function, $0)
                self.weatherView.backgroundImageView.image = $0
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func currentLocationButtonTapped() {
        // 현재 위치 가져오기 구현
        checkDeviceLocationService()
    }
    
    @objc private func refreshButtonTapped() {
        // 날씨 새로고침 구현
        fetchWeather(location: currentLocation)
        print("🔵 weather data is successfully fetced", #function)
    }
    
    private func checkDeviceLocationService() {
        print(#function)
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    self.checkLocationAuthorization(status: authorization)
                }
            } else {
                print("🟡 user's location service is off", #function)
            }
        }
    }
    
    private func checkLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("🟡 location authorization is not determined yet", #function)
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("🟡 location authorization is denied", #function)
            currentLocation = CLLocationCoordinate2D(latitude: 37.6545021055909, longitude: 127.049672533607)
            weatherView.configRegionAndAnntation(center: currentLocation)
            showAlert(title: "사용자 위치 정보 이용", message: "현위치의 날씨를 불러오기 위해서는 위치 권한이 필요해요 ;_;" , btnTitle: "설정으로 이동") { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                } else {
                    print("🔴 failed to move setting. need to check", #function)
                    self.showAlert(title: "설정에 접근할 수 없음", message: "설정 앱을 열 수 없어요. 직접 설정 앱으로 이동하여 앱 > 날씨췍 > 위치에서 '다음번에 묻기 또는 내가 공유할 때' 또는 '앱을 사용하는 동안'을 선택해주세요.") { _ in
                    }
                }
            }
        case .authorizedWhenInUse:
            print("🔵 location authorization is allowed", #function)
            locationManager.startUpdatingLocation()
        default:
            print("🔴 not expected location authorization status", #function)
        }
    }
    
    private func fetchWeather(location: CLLocationCoordinate2D) {
        print(#function, location, currentLocation)
        NetworkManager.shared.getWeather(api: .current(lat: location.latitude, lon: location.longitude), type: CurrentWeather.self) { response in
            switch response {
            case .success(let success):
                dump(success)
                print("🔵 success", #function)
                self.weatherView.weatherInfoLabel.text = """
                                    \(DateManager.shared.utcToFormattedDate(unixTime: success.dt, timezone: success.timezone))
                                    현재 기온: \(success.main.temp)℃
                                    체감 기온: \(success.main.feels_like)℃
                                    습도: \(success.main.humidity)%
                                    풍속: \(success.wind.speed)m/s
                                    """
                
            case .failure(let failure):
                print("🔴 failed to load current weather", #function)
                dump(failure)
                debugPrint(failure)
                self.weatherView.weatherInfoLabel.text = "현재 날씨를 불러오는데 실패했습니다."
            }
        }
    }
}


// MARK: - Location Manager Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations.last?.coordinate)
        if let location = locations.last {
            currentLocation = location.coordinate
            weatherView.configRegionAndAnntation(center: location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // iOS 14+
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        let noti: (CLAuthorizationStatus) -> Void = { status in
            print("🟡 location authorization did changed", #function)
            print(">>> ", status.rawValue)
            print(">>> ", "0: notDetermined, 1: restricted, 2: denied, 3: authorizedAlways, 4: authorizedWhenInUse")
        }
        noti(status)
        checkLocationAuthorization(status: status)
    }
    
    // until iOS 14
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("🟡 location authorization did changed", #function)
        print(">>> ", manager.authorizationStatus.rawValue)
        print(">>> ", "0: notDetermined, 1: restriced, 2: denied, 3: authorizaedAlways, 4: authorizedWhenInUse")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("🔴 failed to load current location", #function)
        print(error)
    }
}
