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
    var words: [Vocabulary] { get }
}

class QuizeViewModel: QuizViewModelProtocol {
    let disposeBag = DisposeBag()
    var dataManager: DataManager?
    var action = PublishSubject<QuizViewAction>()
    var words: [Vocabulary] = []
    
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
    }
    
    init() {
        setupDependencies()
        bind()
    }
}
