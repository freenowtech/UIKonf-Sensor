//
//  StateMachine.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 22/05/2019.
//  Copyright © 2019 mytaxi. All rights reserved.
//

import Foundation
import Sensor
import RxCocoa
import SharedKit

// In this file we have all the state logic

enum Event: Equatable {
    case ratingChanged(Float)
    case explanationChanged(String?)
    case submitButtonTapped
    case skipButtonTapped
    case submitSucceeded
    case submitFailed
}

struct Context {
    let submitRating: UseCase.SubmitRating
}

enum Effect: TriggerableEffect {
    case submitRating(rating: Float, explanation: String?)

    func trigger(context: Context) -> Signal<Event> {
        switch self {
        case .submitRating(let rating, let explanation):
            return context
                .submitRating(rating, explanation)
                .map { .submitSucceeded }
                .asSignal(onErrorJustReturn: .submitFailed)
        }
    }
}

enum State: Hashable {
    //TODO: Add all needed states
    case initial, submitted, skipped
}

struct StateModel: ReducibleStateWithEffects {
    let state: State
    let passenger: Passenger
    let rating: Float
    let explanation: String?

    func reduce(event: Event) -> (state: StateModel, effects: Set<Effect>) {
        switch (state, event) {
        //TODO: Add more state transitions
        default:
            return (self, [])
        }
    }
    
    static func initial(with passenger: Passenger) -> StateModel {
        return StateModel(state: .initial, passenger: passenger, rating: 0.0, explanation: nil)
    }

}

// Convenience builder methods
private extension StateModel {

    func stateModel(state: State) -> StateModel {
        return StateModel(state: state, passenger: passenger, rating: rating, explanation: explanation)
    }

    func stateModel(passenger: Passenger) -> StateModel {
        return StateModel(state: state, passenger: passenger, rating: rating, explanation: explanation)
    }

    func stateModel(rating: Float) -> StateModel {
        return StateModel(state: state, passenger: passenger, rating: rating, explanation: explanation)
    }

    func stateModel(explanation: String?) -> StateModel {
        return StateModel(state: state, passenger: passenger, rating: rating, explanation: explanation)
    }

}
