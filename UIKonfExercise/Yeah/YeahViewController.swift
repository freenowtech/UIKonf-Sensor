//
//  YeahViewController.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 21/05/2019.
//  Copyright © 2019 Intelligent's App. All rights reserved.
//

import UIKit
import SnapKit

class YeahViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Yeah! 👍"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 60, weight: .semibold)
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.0, green: 84.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
        view.addSubview(titleLabel)
        setUpConstraints()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewController)))
    }

    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
