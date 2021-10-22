//
//  PickerStocksPresenter.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import Foundation
import UIKit

protocol PickerStocksPresentationLogic: AnyObject {
    func presentPicker(data: [PickerStocksModels.SymbolsModel])
    func presentStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double, imageURL: URL?)
    func presentNetworkError()
    func presentInformationError()
}

final class PickerStocksPresenter {
    // MARK: External vars
    weak var viewController: PickerStocksDisplayLogic?
}

// MARK: - PickerStocks Presentation Logic
extension PickerStocksPresenter: PickerStocksPresentationLogic {
    func presentStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double, imageURL: URL?) {
        var changeColor: UIColor

        if priceChange > 0 {
            changeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else if priceChange < 0 {
            changeColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            changeColor = .black
        }

        viewController?.displayStockInfo(companyName: companyName, symbol: symbol,
                                         price: price, priceChange: priceChange,
                                         changeColor: changeColor, imageURL: imageURL)
    }

    func presentPicker(data: [PickerStocksModels.SymbolsModel]) {
        viewController?.displayPicker(viewModel: data)
    }

    func presentNetworkError() {
        viewController?.displayAlert(title: "Sorry", description: "Network Error")
    }

    func presentInformationError() {
        viewController?.displayAlert(title: "Sorry", description: "Can't find information about company")
    }
}
