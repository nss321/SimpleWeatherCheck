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

class WeatherViewController: BaseViewController {
    
    let locationManager = CLLocationManager()
     
    private let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.text = "날씨 정보를 불러오는 중..."
        return label
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private var point = MKPointAnnotation()
    
    private var currentLocation = CLLocationCoordinate2D(latitude: 37.6545021055909, longitude: 127.049672533607)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        checkDeviceLocationService()
    }
    
    // MARK: - UI Setup
    override func configHierarchy() {
        [mapView, weatherInfoLabel, currentLocationButton, refreshButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configLayout() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        weatherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    override func configView() {
        
    }
    
    override func configNavigation() {
        navigationItem.title = "날씨 췍 ↗"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func configDelegate() {
        locationManager.delegate = self
    }
    
    private func setupActions() {
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
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
            configRegionAndAnntation(center: currentLocation)
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
    
    private func configRegionAndAnntation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        point.do {
            $0.coordinate = region.center
            $0.title = "현재 위치"
        }
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(point)
    }
    
    private func fetchWeather(location: CLLocationCoordinate2D) {
        print(#function, location, currentLocation)
        NetworkManager.shared.getWeather(api: .current(lat: location.latitude, lon: location.longitude), type: CurrentWeather.self) { response in
            switch response {
            case .success(let success):
                dump(success)
                print("🔵 success", #function)
                self.weatherInfoLabel.text = """
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
                self.weatherInfoLabel.text = "현재 날씨를 불러오는데 실패했습니다."
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
            configRegionAndAnntation(center: location.coordinate)
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
