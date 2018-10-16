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
    var dataManager: DataManager?
    var randomGenerator: RandomGeneratorProtocol?
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
        case closePopupAndPeekAWord
    }
    
    struct State {
        var words: [Vocabulary] = []
        var indexAnswer: Int?
        var word: String = ""
        var options = ["", ""]
        var shouldShowPopupForCongratulation = false
        var shouldShowPopupForWrong = false
        var shouldClosePopup = false
    }
    
    func setupDependencies() {
        dataManager = Service.shared.container.resolve(DataManager.self)
        randomGenerator = Service.shared.container.resolve(RandomGeneratorProtocol.self)
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
            return Observable.just(Mutation.closePopupAndPeekAWord)
        }
    }
    
    func handleLoadWords(_ state: State) -> State {
        var state = state
        state.words = dataManager?.readWordList() ?? []
        return state
    }
    
    func handlePeekAWord(_ state: State) -> State {
        var state = state
        state.indexAnswer = randomGenerator?.getRandomIndex(max: 2) ?? -1
        return state
    }
    
    func handleEvaluateAnswer(_ state: State, index: Int) -> State {
        var state = state
        guard -1 != state.indexAnswer else { return state }
        state.shouldShowPopupForCongratulation = ( index == state.indexAnswer )
        state.shouldShowPopupForWrong = ( index != state.indexAnswer )
        return state
    }
    
    func handleClosePopupAndPeekAWord(_ state: State) -> State {
        var state = state
        state.indexAnswer = randomGenerator?.getRandomIndex(max: 2) ?? -1
        state.shouldShowPopupForCongratulation = false
        state.shouldShowPopupForWrong = false
        state.shouldClosePopup = true
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
        case .closePopupAndPeekAWord:
            return handleClosePopupAndPeekAWord(state)
        }
    }

}
