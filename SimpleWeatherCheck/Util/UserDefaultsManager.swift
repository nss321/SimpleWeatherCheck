//
//  UserDefaultsManager.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/5/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    private let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case storedPhotos

    }
    
    var storedPhotos: StoredPhoto {
        get {
            if let list = getStoredData(kind: .storedPhotos, type: StoredPhoto.self) {
                return list
            } else {
                return StoredPhoto(images: [])
            }
        }
        
        set {
            setData(kind: .storedPhotos, type: StoredPhoto.self, data: newValue)
        }
    }
    
    func getStoredData<T: Decodable>(kind: Key, type: T.Type) -> T? {
        if let storedData = userDefaults.object(forKey: kind.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let storedObject = try? decoder.decode(T.self, from: storedData) {
                return storedObject
            } else {
                print(#function, "failed to decode")
                return nil
            }
        } else {
            print(#function, "failed to unwrapping object from userdefaults")
            return nil
        }
    }
    
    func setData<T: Codable>(kind: Key, type: T.Type, data: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaults.set(encoded, forKey: kind.rawValue)
        } else {
            print(#function, "failed to save nickname to UserDefaults ")
        }
    }
    
    func resetData() {
        userDefaults.removeObject(forKey: Key.storedPhotos.rawValue)
    }
}
