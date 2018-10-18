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
    var quizManager: QuizManagerProtocol?
    var initialState = State()
    
    enum Action {
        case load
        case peek
        case selectAnswer(index: Int)
        case confirmPopup
    }
    
    enum Mutation {
        case loadWords
        case peekAWord
        case evaluateAnswer(index: Int)
    }
    
    struct State {
        var word: String = ""
        var options = ["", ""]
        var shouldShowPopupForCongratulation = false
        var shouldShowPopupForWrong = false
    }
    
    func setupDependencies() {
        quizManager = Service.shared.container.resolve(QuizManagerProtocol.self)
    }
    
    init() {
        setupDependencies()
    }
    
    func mutate(action: QuizReactor.Action) -> Observable<QuizReactor.Mutation> {
        switch action {
        case .load:
            return Observable.just(Mutation.loadWords)
        case .peek:
            return Observable.just(Mutation.peekAWord)
        case .selectAnswer(let index):
            return Observable.just(Mutation.evaluateAnswer(index: index))
        case .confirmPopup:
            return Observable.just(Mutation.peekAWord)
        }
    }
    
    func handleLoadWords(_ state: State) -> State {
        let state = state
        quizManager?.load()
        return state
    }
    
    func handlePeekAWord(_ state: State) -> State {
        guard let quizManager = quizManager else { return state }
        var state = state
        let value = quizManager.peek()
        state.word = value.word
        state.options = value.options
        return state
    }
    
    func handleEvaluateAnswer(_ state: State, index: Int) -> State {
        var state = state
        guard let quizManager = quizManager else { return state }
        let value = quizManager.check(state.options[index])
        state.shouldShowPopupForCongratulation = value
        state.shouldShowPopupForWrong = !value
        return state
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loadWords:
            return handleLoadWords(state)
        case .peekAWord:
            return handlePeekAWord(state)
        case .evaluateAnswer(let index):
            return handleEvaluateAnswer(state, index: index)
        }
    }

}
