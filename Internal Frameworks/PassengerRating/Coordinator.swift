//
//  PassengerRatingCoordinator.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 21/05/2019.
//  Copyright © 2019 mytaxi. All rights reserved.
//

import UIKit
import SharedKit

public final class Coordinator {

    enum Navigation {
        case dismiss
        case presentSuccessfulRating
        case idle
        //TODO:
//        case presentErrorAlert
    }

    private let makeDestinationViewController: ()->(UIViewController)

    public init(makeDestinationViewController: @escaping ()->(UIViewController)) {
        self.makeDestinationViewController = makeDestinationViewController
    }

    public func makeViewController(passenger: Passenger) -> UIViewController {
        let passengerRatingView = View()
        let outputsDriver = Store.makeOutputs(with: passenger, inputs: passengerRatingView.outputs)

        let viewController = ViewController(
            rootView: passengerRatingView,
            inputs: outputsDriver.map { $0.viewModel }
        )

        let navigationController = UINavigationController(rootViewController: viewController)

        outputsDriver
            .map { $0.navigation }
            .debug("navigation", trimOutput: false)
            .drive(onNext: { self.coordinate(navigation: $0, from: viewController) })
            .disposed(by: viewController.disposeBag)

        return navigationController
    }

    private func coordinate(navigation: Navigation, from viewController: UIViewController) {
        print("navigation")
        switch navigation {
        case .dismiss:
            viewController.dismiss(animated: true, completion: nil)
        case .presentSuccessfulRating:
            viewController.navigationController?.pushViewController(makeDestinationViewController(), animated: true)
        case .idle:
            return
        }
    }
}
