//
//  HomeViewController.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 21/05/2019.
//  Copyright © 2019 mytaxi. All rights reserved.
//

import UIKit
import MapKit
import PassengerRating
import SharedKit

class HomeViewController: UIViewController {

    private let mapView: MKMapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKonf 2019"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rate", style: .plain, target: self, action: #selector(presentPassengerRatingViewController))
        view.addSubview(mapView)
        setUpConstraints()
    }

    private func setUpConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    @objc private func presentPassengerRatingViewController() {
        let passengerRatincCoordinator = PassengerRating.Coordinator(makeDestinationViewController: YeahViewController.init)
        let passengerRatingViewController = passengerRatincCoordinator.makeViewController(passenger: Passenger(imageURL: "TODO", name: "Pauline"))
        present(passengerRatingViewController, animated: true, completion: nil)
    }

}
