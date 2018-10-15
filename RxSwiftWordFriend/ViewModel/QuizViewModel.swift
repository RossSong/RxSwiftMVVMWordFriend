//
//  QuizViewModel.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 24..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

enum QuizViewAction {
    case viewDidLoad
}

protocol QuizViewModelProtocol {
    var action: PublishSubject<QuizViewAction> { get }
    var targetWord: String { get }
}

class QuizeViewModel: QuizViewModelProtocol {
    let disposeBag = DisposeBag()
    
    var dataManager: DataManager?
    var randomGenerator: RandomGeneratorProtocol?
    
    var action = PublishSubject<QuizViewAction>()
    var words: [Vocabulary] = []
    var targetIndex = 0
    var targetWord: String {
        get {
            let index = (randomGenerator?.getRandomIndex(max: words.count) ?? -1)
            guard index >= 0 else { return "" }
            return words[index].word
        }
    }
    
    func handleViewDidLoad() {
        words = dataManager?.readWordList() ?? []
    }
    
    func handleAction(_ value: QuizViewAction) {
        switch value {
        case .viewDidLoad:
            handleViewDidLoad()
        }
    }
    
    func bind() {
        self.action.asObservable().subscribe(onNext: { [weak self] value in
            self?.handleAction(value)
        }).disposed(by: disposeBag)
    }
    
    func setupDependencies() {
        dataManager = Service.shared.container.resolve(DataManager.self)
        randomGenerator = Service.shared.container.resolve(RandomGeneratorProtocol.self)
    }
    
    init() {
        setupDependencies()
        bind()
    }
}
