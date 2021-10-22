//
//  ChartInteractor.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import Foundation

protocol ChartBusinessLogic: AnyObject {
    func requestData()
}

protocol ChartDataStoring: AnyObject {
    var symbol: String? { get set }
}

// MARK: - Chart Data Storing
final class ChartInteractor: ChartDataStoring {
    // MARK: - External vars
    var presenter: ChartPresentationLogic?

    // MARK: Chart Data Storing
    var symbol: String?

    // MARK: Internal vars
}

// MARK: - Chart Business Logic
extension ChartInteractor: ChartBusinessLogic {


    func requestData() {
        guard let symbol = symbol else {
            return
        }
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/chart/1y?&token=\(token)")!
        let dataTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard
                error == nil,
                let data = data
            else {
                DispatchQueue.main.async {
                    self.presenter?.presentNetworkError()
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([ChartModels.ChartModel].self, from: data)

                DispatchQueue.main.async {
                    if response.isEmpty {
                        self.presenter?.presentInformationError()
                        return
                    }
                    print(response)
                    self.presenter?.presentChart(data: response)
                }

            } catch {
                DispatchQueue.main.async {
                    self.presenter?.presentInformationError()
                }
            }
        }
        dataTask.resume()
    }
}

