//
//  ChartPresenter.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import Foundation

protocol ChartPresentationLogic: AnyObject {
    // Required documentation
    func presentChart(data: [ChartModels.ChartModel])
    func presentNetworkError()
    func presentInformationError()
}

final class ChartPresenter {
    // MARK: External vars
    weak var viewController: ChartDisplayLogic?
}

// MARK: - Chart Presentation Logic
extension ChartPresenter: ChartPresentationLogic {
    func presentChart(data: [ChartModels.ChartModel]) {
        var serieData: [Double] = []
        var labels: [Double] = []
        var labelsAsString: [String] = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"

        for (i, value) in data.enumerated() {

            serieData.append(value.close ?? 0)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: value.date!)!

            let month = Calendar.current.dateComponents([.day, .year, .month], from: date).month!
            let monthAsString: String = dateFormatter.monthSymbols[month - 1]
            if (labels.count == 0 || labelsAsString.last != monthAsString) {
                labels.append(Double(i))
                labelsAsString.append(monthAsString)
            }
        }
        viewController?.displayChart(serieData: serieData,
                                     labels: labels,
                                     labelsAsString: labelsAsString)
    }

    func presentNetworkError() {
        viewController?.displayAlert(title: "Sorry", description: "Network Error")
    }

    func presentInformationError() {
        viewController?.displayAlert(title: "Sorry", description: "Can't find information about company")
    }
}
