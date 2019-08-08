//
//  PassengerRatingStore.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 20/05/2019.
//  Copyright © 2019 Intelligent's App. All rights reserved.
//

import Foundation
import RxCocoa
import Sensor
import SharedKit

// In this file we do the wiring and mapping

enum Store {

    struct Outputs: Equatable {
        let viewModel: ViewModel
        let navigation: Coordinator.Navigation
        
        init(viewModel: ViewModel, navigation: Coordinator.Navigation = .idle){
            self.viewModel = viewModel
            self.navigation = navigation
        }
    }

    static func makeOutputs(with passenger: Passenger, inputs: View.Outputs) -> Driver<Outputs>  {
        let inputEvents: Signal<Event>  = Signal.merge(
            inputs.ratingControl.map { .ratingChanged($0) },
            inputs.explanationField.map { .explanationChanged($0) },
            inputs.submitButton.map { .submitButtonTapped },
            inputs.skipButton.map { .skipButtonTapped }
        )

        let context = Context(submitRating: UseCase.defaultSubmitRating)

        return StateModel.outputStates(initialState: StateModel.initial(with: passenger),
                                       inputEvents: inputEvents,
                                       context: context)
            .map(Store.Outputs.init(stateModel:))
            .distinctUntilChanged()
    }

}

private extension Store.Outputs {

    init(stateModel: StateModel) {
        viewModel = ViewModel(stateModel: stateModel)
        navigation = Coordinator.Navigation(stateModel: stateModel)
    }
}

private extension Coordinator.Navigation {

    init(stateModel: StateModel) {
        switch stateModel.state {
        case .submitted:
            self = .presentSuccessfulRating
        case .skipped:
            self = .dismiss
        default:
            self = .idle
        }
    }
}

private extension ViewModel {
    init(stateModel: StateModel) {
        passengerImageURL = stateModel.passenger.imageURL
        passengerName = stateModel.passenger.name
        rating = stateModel.ratingTitle
        feedback = stateModel.feedbackTitle
        filledStarColor = stateModel.filledStarColor
        showExplanationAndSubmit = stateModel.showExplanationAndSubmit
        explanationPlaceholder = stateModel.explanationPlaceholder
        submitButtonEnabled = stateModel.submitButtonEnabled
        submitButtonTitle = stateModel.submitButtonTitle
        starRatingEnabled = stateModel.starRatingEnabled
    }
}

//TODO: Map the StateModel to ViewModel so it matches the following acceptance criteria

/*
    - "Title" label should depend on the rating value: 1 - Title.veryBad, 2: Title.bad, 3: Title.ok, 4: Title.good, 5: Title.great (HINT: You have an enum with all the values)
    - "Text" label should depend on the rating value: Less than 4: Text.requestExplanation (HINT: You have an enum with all the values)
    - The color of the stars should depend on the rating value:
        - From 1 to 2: Red
        - From 3 to 4: Yellow
        - 5: Green
        (HINT: You have an enum with all the values)
    - Explanation placeholder should be optional when rating more than 3 stars.
    - Explanation and submit button are hidden until the users taps in any star
    - Submit button is enabled when rating is more than 3 stars or comment is not empty.
    - Submit button should say "Submitting" while doing the network request.
*/
private extension StateModel {
 
    var ratingTitle: ViewModel.RatingTitle {
        return .empty
    }

    var feedbackTitle: ViewModel.FeedbackTitle {
        return .empty
    }

    var filledStarColor: ViewModel.StarColor {
        return .yellow
    }

    var showExplanationAndSubmit: Bool {
        return false
    }

    var explanationPlaceholder: ViewModel.ExplanationPlaceholder {
        return .optional
    }

    var submitButtonEnabled: Bool {
        return false
    }

    var starRatingEnabled: Bool {
        return true
    }

    var submitButtonTitle: ViewModel.SubmitButtonTitle {
        return .submit
    }

}
