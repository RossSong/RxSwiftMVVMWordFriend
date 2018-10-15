//
//  QuizReactor.swift
//  RxSwiftWordFriend
//
//  Created by Ross on 2018. 10. 15..
//  Copyright © 2018년 RossSong. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

class QuizReactor: Reactor {
    var initialState = State()
    
    enum Action {
        case load
        case peek
        case selectAnswer(index: Int)
    }
    
    enum Mutation {
        case loadWords
        case peekAWord
        case evaluateAnswer(index: Int)
    }
    
    struct State {
        var word: String = ""
        var options = ["", ""]
        var indexAnswer = -1
        var isCorrect = false
    }
    
    func mutate(action: QuizReactor.Action) -> Observable<QuizReactor.Mutation> {
        switch action {
        case .load:
            return Observable.just(Mutation.loadWords)
        case .peek:
            return Observable.just(Mutation.peekAWord)
        case .selectAnswer(let index):
            return Observable.just(Mutation.evaluateAnswer(index: index))
        }
    }
    
    func reduce(state: QuizReactor.State, mutation: QuizReactor.Mutation) -> QuizReactor.State {
        var state = state
        
        switch mutation {
        case .loadWords:
            return state
        case .peekAWord:
            return state
        case .evaluateAnswer(let index):
            state.isCorrect = ( index == state.indexAnswer )
            return state
        }
    }

}
