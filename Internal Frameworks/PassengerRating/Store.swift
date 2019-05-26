//
//  PassengerRatingStore.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 20/05/2019.
//  Copyright © 2019 mytaxi. All rights reserved.
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
        title = stateModel.title
        text = stateModel.text
        filledStarColor = stateModel.filledStarColor
        showExplanationAndSubmit = stateModel.showExplanationAndSubmit
        explanationPlaceholder = stateModel.explanationPlaceholder
        submitButtonEnabled = stateModel.submitButtonEnabled
        submitButtonTitle = stateModel.submitButtonTitle
        starRatingEnabled = stateModel.starRatingEnabled
    }
}

private extension StateModel {

    var title: ViewModel.Title {
        switch rating {
        case 1:
            return .veryBad
        case 2:
            return .bad
        case 3:
            return .ok
        case 4:
            return .good
        case 5:
            return .great
        default:
            return .empty
        }
    }

    var text: ViewModel.Text {
        switch rating {
        case 1, 2, 3:
            return .requestExplanation
        default:
            return .empty
        }
    }

    var filledStarColor: ViewModel.StarColor {
        switch rating {
        case 1...2:
            return .red
        case 3...4:
            return .yellow
        case 5:
            return .green
        default:
            return .yellow
        }
    }

    var showExplanationAndSubmit: Bool {
        return state != .initial
    }

    var explanationPlaceholder: ViewModel.ExplanationPlaceholder {
        return rating > 3 ? .optional : .compulsory
    }

    var submitButtonEnabled: Bool {
        return state == .editing
            && (rating > 3 || isExplanationFilled)
    }

    var starRatingEnabled: Bool {
        return state == .initial || state == .editing
    }

    private var isExplanationFilled: Bool {
        guard let explanation = explanation else { return false }
        return !explanation.isEmpty
    }

    var submitButtonTitle: ViewModel.SubmitButtonTitle {
        return state == .submitting ? .submitting : .submit
    }

}
