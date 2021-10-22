//
//  PickerStocksViewController.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import UIKit

protocol PickerStocksDisplayLogic: AnyObject {
    func displayPicker(viewModel: [PickerStocksModels.SymbolsModel])
    func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double, changeColor: UIColor, imageURL: URL?)
    func displayAlert(title: String, description: String?)
}

final class PickerStocksViewController: UIViewController {

    // MARK: - External vars
    private(set) var router: (PickerStocksRoutingLogic & PickerStocksDataPassing)?

    // MARK: Internal vars
    private var interactor: PickerStocksBusinessLogic?
    var companies: [PickerStocksModels.SymbolsModel] = []

    // MARK: - Outlets
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var companySymbolLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceChangeLabel: UILabel!
    @IBOutlet private weak var companyPickerView: UIPickerView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var chartInfoButton: UIButton!

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    @IBAction func chartInfoTapped(_ sender: UIButton) {
        guard let symbol = companies[companyPickerView.selectedRow(inComponent: 0)].symbol
        else { return }

        router?.routeToChart(symbol: symbol)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = PickerStocksInteractor()
        let presenter = PickerStocksPresenter()
        let router = PickerStocksRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicatorView.startAnimating()
        companyPickerView.dataSource = self
        companyPickerView.delegate = self

        activityIndicatorView.hidesWhenStopped = true
        companyPickerView.isUserInteractionEnabled = false

        interactor?.requestSymbols()
    }
}

// MARK: - PickerStocks Display Logic
extension PickerStocksViewController: PickerStocksDisplayLogic {
    func displayAlert(title: String, description: String?) {
        activityIndicatorView.stopAnimating()
        router?.routeToAlert(title: title, message: description)
    }

    func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double, changeColor: UIColor, imageURL: URL?) {
        activityIndicatorView.stopAnimating()
        companyNameLabel.text = companyName
        companySymbolLabel.text = symbol
        priceLabel.text = "\(price)"
        priceChangeLabel.text = "\(priceChange)"
        priceChangeLabel.textColor = changeColor
        chartInfoButton.isHidden = false

        if let url = imageURL {
            logoImageView.downloaded(from: url)
        }
    }

    func displayPicker(viewModel: [PickerStocksModels.SymbolsModel]) {
        companies = viewModel
        companyPickerView.reloadAllComponents()
        companyPickerView.isUserInteractionEnabled = true
        if let symbol = viewModel.first?.symbol {
            interactor?.requestQuote(for: symbol)
        }
    }
}

private extension PickerStocksViewController {
    func requestQuoteUpdate() {
        chartInfoButton.isHidden = true
        logoImageView.image = nil
        activityIndicatorView.startAnimating()
        companyNameLabel.text = "–"
        companySymbolLabel.text = "–"
        priceLabel.text = "–"
        priceChangeLabel.text = "–"
        priceChangeLabel.textColor = .black

        guard let selectedSymbol = self.companies[companyPickerView.selectedRow(inComponent: 0)].symbol
        else { return }

        interactor?.requestQuote(for: selectedSymbol)
    }
}

// MARK: - UIPickerViewDataSource

extension PickerStocksViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return companies[row].description
    }
}

// MARK: - UIPickerViewDelegate

extension PickerStocksViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activityIndicatorView.startAnimating()

        requestQuoteUpdate()
    }
}

