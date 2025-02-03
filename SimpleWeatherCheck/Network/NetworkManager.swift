//
//  NetworkManager.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/3/25.
//

import CoreLocation

import Alamofire

enum WeatherRequest {
    case current(lat: CLLocationDegrees, lon: CLLocationDegrees)
    
    var endpoint: URL {
        switch self {
        case .current(let lat, let lon):
            if let url = URL(string: Urls.currentWeather(lat: lat, lon: lon)) {
                return url
            } else {
                print("🔴 failed to unwrapping endpoint url at:", #function)
                return URL.init(string: "")!
            }
        }
    }
    
    var method: HTTPMethod {
        .get
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func getWeather<T: Decodable>(api: WeatherRequest,
                       type: T.Type,
                       completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(api.endpoint, method: api.method)
//            .responseString { response in
//            dump(response)
//        }
            .responseDecodable(of: T.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
