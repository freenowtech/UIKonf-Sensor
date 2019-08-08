//
//  PassengerRatingUseCaser.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 20/05/2019.
//  Copyright © 2019 Intelligent's App. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum UseCase {

    typealias SubmitRating = (_ rating: Float, _ explanation: String?) -> Single<Void>
    
    static var defaultSubmitRating: SubmitRating {
        return { rating, explanation in
            return Observable
                .just(())
                .delay(.seconds(1), scheduler: MainScheduler.asyncInstance).asSingle()

        }
    }
}
