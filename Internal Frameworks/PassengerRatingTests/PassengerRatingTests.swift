//
//  PassengerRatingTests.swift
//  PassengerRatingTests
//
//  Created by Lluís Gómez on 22/05/2019.
//  Copyright © 2019 Intelligent Apps GmbH. All rights reserved.
//

import XCTest
import SensorTest
import RxTest
@testable import PassengerRating
@testable import SharedKit

class PassengerRatingTests: XCTestCase, SensorTestCase {

    var scheduler: TestScheduler!

    private let passenger = Passenger(imageURL: "", name: "Pauline")

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
    }

    func testCommentBecomesOptionalWhenRatingAboveThree() {
        //create the inputs
        let possibleRatings: [String: Float] = ["1": 1.0, "2": 2.0, "3": 3.0, "4": 4.0, "5": 5.0]
        let ratingEvent = hotSignal((timeline: "--1--2--3--4--5", values: possibleRatings))
        
        // make the output
        let storeOutputs = Store.makeOutputs(with: passenger,
                                             inputs: View.Outputs(ratingControl: ratingEvent))
        
        // assert the sequence is correct
        assert(storeOutputs.map { $0.viewModel.submitButtonEnabled },
               isEqualToTimeline: "👎-👎--👎--👎--👍--👍",
               withValues: ["👎": false, "👍": true])
            .withScheduler(scheduler)
    }

}
