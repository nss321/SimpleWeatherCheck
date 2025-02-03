//
//  Weather.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/3/25.
//

import Foundation

struct CurrentWeather: Decodable {
    let dt: Double
    let timezone: Int
    let main: Main
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double
    let gust: Double?
}

/*
 {
     "coord": {
         "lon": 127.0479,
         "lat": 37.6528
     },
     "weather": [
         {
             "id": 800,
             "main": "Clear",
             "description": "맑음",
             "icon": "01d"
         }
     ],
     "base": "stations",
     "main": {
         "temp": 270.08,
         "feels_like": 263.48,
         "temp_min": 270.08,
         "temp_max": 270.08,
         "pressure": 1020,
         "humidity": 52,
         "sea_level": 1020,
         "grnd_level": 1002
     },
     "visibility": 10000,
     "wind": {
         "speed": 6.61,
         "deg": 300,
         "gust": 11.88
     },
     "clouds": {
         "all": 8
     },
     "dt": 1738570560,
     "sys": {
         "type": 1,
         "id": 8105,
         "country": "KR",
         "sunrise": 1738535650,
         "sunset": 1738573018
     },
     "timezone": 32400,
     "id": 1835847,
     "name": "Seoul",
     "cod": 200
 }
 */
