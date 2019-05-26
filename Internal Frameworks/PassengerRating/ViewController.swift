//
//  PassengerRatingViewController.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 20/05/2019.
//  Copyright © 2019 mytaxi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    private let rootView: View
    private let inputs: Driver<ViewModel>

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(rootView: View, inputs: Driver<ViewModel>) {
        self.inputs = inputs
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setUpBindings() {
        inputs
            .drive(rootView.rx.inputs)
            .disposed(by: disposeBag)
    }
}
