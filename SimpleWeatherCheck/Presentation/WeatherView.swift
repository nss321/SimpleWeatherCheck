//
//  WeatherView.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/4/25.
//

import UIKit

import MapKit
import SnapKit
import Then

final class WeatherView: BaseView {

    let mapView = MKMapView()
    let weatherInfoLabel = UILabel()
    let currentLocationButton = UIButton(type: .system)
    let refreshButton = UIButton(type: .system)
    var point = MKPointAnnotation()
    var currentLocation = CLLocationCoordinate2D(latitude: 37.6545021055909, longitude: 127.049672533607)
    let photoButton = UIButton()
    let backgroundImageView = UIImageView()

    // MARK: - UI Setup
    override func configHierarchy() {
        [backgroundImageView, mapView, weatherInfoLabel, currentLocationButton, refreshButton, photoButton].forEach {
            addSubview($0)
        }
    }
    
    override func configLayout() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        weatherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        photoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(refreshButton)
            $0.height.equalTo(refreshButton)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        mapView.do {
            $0.setRegion(MKCoordinateRegion(
                center: CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude),
                latitudinalMeters: 500,
                longitudinalMeters: 500),
                         animated: true)
        }
        weatherInfoLabel.do {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .label
            $0.text = "날씨 정보를 불러오는 중..."

        }
        currentLocationButton.do {
            $0.setImage(UIImage(systemName: "location.fill"), for: .normal)
            $0.backgroundColor = .systemBackground
            $0.tintColor = .systemBlue
            $0.layer.cornerRadius = 25
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 4

        }
        refreshButton.do {
            $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
            $0.backgroundColor = .systemBackground
            $0.tintColor = .systemBlue
            $0.layer.cornerRadius = 25
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 4
        }
        photoButton.do {
            var config = UIButton.Configuration.filled()
            config.title = "배경 선택"
            config.cornerStyle = .capsule
            $0.configuration = config
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 4
        }
        backgroundImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .systemBackground
            $0.alpha = 0.5
        }
    }
    
    // MARK: - Methods
    func configRegionAndAnntation(center: CLLocationCoordinate2D) {
        print(#function, center)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        point.do {
            $0.coordinate = region.center
            $0.title = "현재 위치"
        }
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(point)
    }
}
