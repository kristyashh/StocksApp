//
//  PickerStocksModels.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

struct PickerStocksModels {

}

extension PickerStocksModels {
    struct SymbolsModel: Codable {
        let currency: String?
        let description, displaySymbol, figi: String?
        let mic: String?
        let symbol: String?
        let type: String?

        enum CodingKeys: String, CodingKey {
            case currency
            case description
            case displaySymbol, figi, mic, symbol, type
        }
    }
}
