//
//  RandomGenerator.swift
//  RxSwiftWordFriend
//
//  Created by Ross on 2018. 10. 15..
//  Copyright © 2018년 RossSong. All rights reserved.
//

import Foundation

protocol RandomGeneratorProtocol {
    func getRandomIndex(max: Int) -> Int
}

class RandomGenerator: RandomGeneratorProtocol {
    func getRandomIndex(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}
