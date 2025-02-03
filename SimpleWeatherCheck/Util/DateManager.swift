//
//  DateManager.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/3/25.
//

import Foundation

class DateManager {
    static let shared = DateManager()
    private init() { }
    private let formatter = DateFormatter()
    func utcToFormattedDate(unixTime: Double, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        formatter.dateFormat = "yyyy년 M월 d일 a h시 m분"
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return formatter.string(from: date)
    }
}
