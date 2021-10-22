//
//  ChartRouter.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import UIKit

protocol ChartRoutingLogic: AnyObject {
    func routeToAlert(title: String, message: String?)
}

protocol ChartDataPassing: AnyObject {
    /// Pass data between routers
    var dataStore: ChartDataStoring? { get }
}

// MARK: - Test Data Passing
final class ChartRouter: ChartDataPassing {

    // MARK: External vars
    var dataStore: ChartDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - Chart Routing Logic
extension ChartRouter: ChartRoutingLogic {
    func routeToAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        viewController?.present(alert, animated: true)
    }
}
