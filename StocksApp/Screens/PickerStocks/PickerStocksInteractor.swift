//
//  PickerStocksInteractor.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import Foundation

protocol PickerStocksBusinessLogic: AnyObject {
    func requestQuote(for symbol: String)
    func requestSymbols()
}

protocol PickerStocksDataStoring: AnyObject {
}

// MARK: - PickerStocks Data Storing
final class PickerStocksInteractor: PickerStocksDataStoring {

    // MARK: - External vars
    var presenter: PickerStocksPresentationLogic?
}

// MARK: - PickerStocks Business Logic
extension PickerStocksInteractor: PickerStocksBusinessLogic {

    func requestQuote(for symbol: String) {
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?&token=\(token)")!

        let dataTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                print("Network error")
                return
            }

            self.parseQuote(data: data)
        }
        dataTask.resume()
    }

    func requestSymbols() {
        let url = URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=\(tokenForSymbols)")!

        let dataTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    self.presenter?.presentNetworkError()
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([PickerStocksModels.SymbolsModel].self, from: data)

                DispatchQueue.main.async {
                    self.presenter?.presentPicker(data: response)
                }

            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}

private extension PickerStocksInteractor {
    func getLogoURL(for symbol: String) -> URL? {
        return URL(string: "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/\(symbol).png")
    }

    func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)

            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else {
                    DispatchQueue.main.async {
                        self.presenter?.presentInformationError()
                    }
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.presentStockInfo(companyName: companyName,
                                       symbol: companySymbol,
                                       price: price,
                                       priceChange: priceChange,
                                       imageURL: self?.getLogoURL(for: companySymbol))
            }
            print("Company name is '\(companyName)'")
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
}
