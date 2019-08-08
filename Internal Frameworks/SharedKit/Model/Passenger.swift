//
//  Passenger.swift
//  UIKonfExercise
//
//  Created by Lluís Gómez on 21/05/2019.
//  Copyright © 2019 Intelligent's App. All rights reserved.
//

import Foundation

public struct Passenger: Equatable, Hashable {
    public let imageURL: String
    public let name: String

    public init(imageURL: String, name: String) {
        self.imageURL = imageURL
        self.name = name
    }
}
