//
//  PassengerRatingView.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 20/05/2019.
//  Copyright © 2019 mytaxi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import SDWebImage
import UITextView_Placeholder
import SharedKit

class View: UIView, CancelChildViewProtocol {

    struct Outputs {
        let ratingControl: Signal <Float>
        let explanationField: Signal<String?>
        let submitButton: Signal<Void>
        let skipButton: Signal<Void>
        
        init(ratingControl: Signal <Float> = .never(),
             explanationField: Signal<String?> = .never(),
             submitButton: Signal<Void> = .never(),
             skipButton: Signal<Void> = .never()){
            self.ratingControl = ratingControl
            self.explanationField = explanationField
            self.submitButton = submitButton
            self.skipButton = skipButton
        }
    }

    lazy var outputs: Outputs = {
        return View.Outputs(
            ratingControl: starRatingView.rx.rating.filter({ $0 > 0 }).asSignal(onErrorJustReturn: 0),
            explanationField: explanationTextView.rx.text.asSignal(onErrorJustReturn: nil),
            submitButton: submitButton.rx.tap.asSignal(),
            skipButton: skipButton.rx.tap.asSignal()
        )
    }()

    struct Constants {
        static let passengerImageWith: CGFloat = 110
        static let explanationHeight: CGFloat = 56
    }

    private(set) var scrollView: UIScrollView! = UIScrollView(frame: .zero)
    private(set) var explanationTextView: UITextView! = {
        let explanationTextView = UITextView(frame: .zero)
        explanationTextView.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium)
        explanationTextView.textColor = UIColor.blueyGrey
        explanationTextView.backgroundColor = UIColor.paleGrey
        explanationTextView.placeholderColor = UIColor.blueyGrey
        explanationTextView.attributedPlaceholder = NSAttributedString(string: "Add a comment (optional)",
                                                                       attributes: [
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                                        NSAttributedString.Key.foregroundColor: UIColor.blueyGrey
            ])
        explanationTextView.textContainerInset = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 16)
        explanationTextView.layer.borderColor = UIColor.paleBlue.cgColor
        explanationTextView.layer.borderWidth = 1.0
        explanationTextView.layer.cornerRadius = 4
        explanationTextView.alpha = 0
        return explanationTextView
    }()
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }()
    private let skipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(red: 60/255, green: 150/255, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.textAlignment = .right
        return button
    }()
    private let questionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor.darkGreyBlue
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    private let passengerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ic_profile_placeholder")
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.passengerImageWith / 2
        return imageView
    }()
    private let starRatingView: StarRatingWidget = {
        let starRatingView = StarRatingWidget()
        return starRatingView
    }()
    private let feedbackTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.darkGreyBlue
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    private let feedbackTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.blueyGrey
        label.textAlignment = .center
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.65
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 60/255, green: 150/255, blue: 1, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.layer.cornerRadius = 8
        button.alpha = 0
        return button
    }()
    private var safeArea: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        setupSubviews()
        setupConstraints()
        addDismissKeyboardHandler()
        registerForKeyboardNotifications()
        backgroundColor = .white
    }

    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [skipButton, passengerImageView, questionLabel, starRatingView,
         feedbackTitleLabel, feedbackTextLabel, explanationTextView, submitButton].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(self.safeArea.bottom).offset(-8)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(self)
        }
        skipButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(26)
            make.trailing.equalToSuperview().offset(-20)
        }
        passengerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.lessThanOrEqualToSuperview().offset(100)
            make.width.height.equalTo(Constants.passengerImageWith)
        }
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(passengerImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        starRatingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionLabel.snp.bottom).offset(30)
        }
        feedbackTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(starRatingView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(73)
            make.height.equalTo(22) // avoid moving layout on small devices
        }
        feedbackTextLabel.snp.makeConstraints { make in
            make.top.equalTo(feedbackTitleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(22) // avoid moving layout on small devices
        }
        explanationTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.greaterThanOrEqualTo(feedbackTextLabel.snp.bottom).offset(22)
            make.height.equalTo(Constants.explanationHeight)
        }
        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(explanationTextView.snp.bottom).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin).offset(-8)
            make.height.equalTo(64)
        }
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWasShown(_ notification: Notification) {
        handleKeyboardShown(notification)
        updateExplanationTextView(with: Constants.explanationHeight * 3)
    }

    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        handleKeyboardHidden(notification)
        updateExplanationTextView(with: Constants.explanationHeight)
    }

    private func updateExplanationTextView(with value: CGFloat) {
        UIView.animate(withDuration: 0.3) { [explanationTextView] in
            if let explanationTextView = explanationTextView {
                explanationTextView.snp.updateConstraints { make in
                    make.height.equalTo(value)
                }
            }
        }
    }

}

extension Reactive where Base: View {
    var inputs: Binder<ViewModel> {
        return Binder(self.base) { view, viewModel in
            view.configure(from: viewModel)
        }
    }
}

private extension View {

    func configure(from model: ViewModel) {
        starRatingView.isUserInteractionEnabled = model.starRatingEnabled
        submitButton.isEnabled = model.submitButtonEnabled
        starRatingView.filledStarImage = UIImage(named: model.filledStarColor.rawValue)
        questionLabel.text = "How was your job with \(model.passengerName)?"
        passengerImageView.sd_setImage(with: URL(string: model.passengerImageURL),
                                       placeholderImage: UIImage(named: "passenger"))
        feedbackTitleLabel.text = model.rating.rawValue
        feedbackTextLabel.text = model.feedback.rawValue
        submitButton.setTitle(model.submitButtonTitle.rawValue, for: .normal)
        submitButton.setTitle(model.submitButtonTitle.rawValue, for: .disabled)
        explanationTextView.placeholder = model.explanationPlaceholder.rawValue

        let shouldShowFields = model.showExplanationAndSubmit && explanationTextView.alpha == 0 && submitButton.alpha == 0
        if shouldShowFields {
            UIView.animate(withDuration: 0.4) { [explanationTextView, submitButton] in
                explanationTextView?.alpha = model.showExplanationAndSubmit ? 1 : 0
                submitButton.alpha = model.submitButtonAlpha
            }
        } else {
            submitButton.alpha = model.submitButtonAlpha
            explanationTextView.alpha = model.showExplanationAndSubmit ? 1 : 0
        }
        updateConstraints()
    }

}

private extension ViewModel {

    var submitButtonAlpha: CGFloat {
        guard showExplanationAndSubmit else { return 0.0 }
        return submitButtonEnabled ? 1.0 : 0.5
    }
}

