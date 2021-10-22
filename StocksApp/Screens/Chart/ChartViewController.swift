//
//  ChartViewController.swift
//  StocksApp
//
//  Created by Kristina Shlyapkina on 05.09.2021.
//

import UIKit
import SwiftChart

protocol ChartDisplayLogic: AnyObject {
    func displayChart(serieData: [Double], labels: [Double], labelsAsString: [String])
    func displayAlert(title: String, description: String?)
}

final class ChartViewController: UIViewController {

    // MARK: - External vars
    private(set) var router: (ChartRoutingLogic & ChartDataPassing)?

    // MARK: - Outlets
    @IBOutlet private weak var stockChart: Chart!
    @IBOutlet private weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var label: UILabel!

    // MARK: Internal vars
    private var interactor: ChartBusinessLogic?
    private var labelLeadingMarginInitialConstant: CGFloat = 0

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = ChartInteractor()
        let presenter = ChartPresenter()
        let router = ChartRouter()
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

        initializeChart()

        interactor?.requestData()

        loadingActivityIndicatorView.hidesWhenStopped = true
    }

    func initializeChart() {
        stockChart.delegate = self

        // Configure chart layout

        stockChart.lineWidth = 0.5
        stockChart.labelFont = UIFont.systemFont(ofSize: 8)
        stockChart.xLabelsTextAlignment = .center
        stockChart.yLabelsOnRightSide = true
    }
}

// MARK: - Chart Display Logic
extension ChartViewController: ChartDisplayLogic {
    func displayChart(serieData: [Double], labels: [Double], labelsAsString: [String]) {
        let series = ChartSeries(serieData)
        series.area = true

        // Configure chart layout
        stockChart.xLabels = labels
        stockChart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }

        stockChart.add(series)
    }

    func displayAlert(title: String, description: String?) {
        loadingActivityIndicatorView.stopAnimating()
        router?.routeToAlert(title: title, message: description)
    }
}

extension ChartViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {

        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {

            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            label.text = numberFormatter.string(from: NSNumber(value: value))

            var constant = labelLeadingMarginInitialConstant + left - (label.frame.width / 2)

            if constant < labelLeadingMarginInitialConstant {
                constant = labelLeadingMarginInitialConstant
            }

            let rightMargin = chart.frame.width - label.frame.width
            if constant > rightMargin {
                constant = rightMargin
            }

            labelLeadingMarginConstraint.constant = constant
        }
    }

    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }

    func didEndTouchingChart(_ chart: Chart) {
    }
}
