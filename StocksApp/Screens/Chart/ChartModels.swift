//
//  ChartModels.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import Foundation

struct ChartModels {

}

extension ChartModels {
    struct ChartModel: Codable {
        let close, high, low, welcomeOpen: Double?
        let symbol: String?
        let volume: Int?
        let id: String?
        let key: String?
        let subkey, date: String?
        let updated: Int?
        let changeOverTime, marketChangeOverTime, uOpen, uClose: Double?
        let uHigh, uLow: Double?
        let uVolume: Int?
        let fOpen, fClose, fHigh, fLow: Double?
        let fVolume: Int?
        let label: String?
        let change, changePercent: Double?

        enum CodingKeys: String, CodingKey {
            case close, high, low
            case welcomeOpen
            case symbol, volume, id, key, subkey, date, updated, changeOverTime, marketChangeOverTime, uOpen, uClose, uHigh, uLow, uVolume, fOpen, fClose, fHigh, fLow, fVolume, label, change, changePercent
        }
    }
}
