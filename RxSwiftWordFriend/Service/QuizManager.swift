//
//  QuizManager.swift
//  RxSwiftWordFriend
//
//  Created by Ross on 2018. 10. 18..
//  Copyright © 2018년 RossSong. All rights reserved.
//

import Foundation

protocol QuizManagerProtocol {
    func load()
    func peek() -> (word: String, options: [String])
    func check(_ value: String) -> Bool
}

class QuizManager: QuizManagerProtocol {
    var dataManager: DataManager?
    var randomGenerator: RandomGeneratorProtocol?
    var words: [Vocabulary] = []
    var indexAnswer: Int?
    
    init() {
        randomGenerator = Service.shared.container.resolve(RandomGeneratorProtocol.self)
        dataManager = Service.shared.container.resolve(DataManager.self)
    }
    
    func load() {
        words = dataManager?.readWordList() ?? []
    }
    
    func peek() -> (word: String, options: [String]) {
        guard let randomGenerator = randomGenerator else { return ("", ["", ""])}
        let index = randomGenerator.getRandomIndex(max: words.count)
        let index2 = randomGenerator.getRandomIndex(max: words.count)
        guard index > -1 else { return ("", ["", ""])}
        guard index2 > -1 else { return ("", ["", ""])}
        
        indexAnswer = index
        
        var array: [String] = []
        if 0 < randomGenerator.getRandomIndex(max: 2) {
            array.append(words[index].meaning)
            array.append(words[index2].meaning)
        }
        else {
            array.append(words[index2].meaning)
            array.append(words[index].meaning)
        }
        
        return (words[index].word, array)
    }
    
    func check(_ value: String) -> Bool {
        guard let indexAnswer = indexAnswer,
            value == words[indexAnswer].meaning else { return false }
        return true
    }
}
