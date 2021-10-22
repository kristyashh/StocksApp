//
//  PickerStocksRouter.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import UIKit

protocol PickerStocksRoutingLogic: AnyObject {
    func routeToChart(symbol: String)
    func routeToAlert(title: String, message: String?)
}

protocol PickerStocksDataPassing: AnyObject {
    /// Pass data between routers
    var dataStore: PickerStocksDataStoring? { get }
}

// MARK: - Test Data Passing
final class PickerStocksRouter: PickerStocksDataPassing {

    // MARK: External vars
    var dataStore: PickerStocksDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - PickerStocks Routing Logic
extension PickerStocksRouter: PickerStocksRoutingLogic {
    func routeToChart(symbol: String) {
        let storyboard = UIStoryboard(name: "ChartViewController", bundle: nil)
        guard let chartVC = storyboard.instantiateViewController(withIdentifier: "ChartViewController") as? ChartViewController else { return }

        chartVC.router?.dataStore?.symbol = symbol
        viewController?.present(chartVC, animated: true)
    }

    func routeToAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        viewController?.present(alert, animated: true)
    }
}
