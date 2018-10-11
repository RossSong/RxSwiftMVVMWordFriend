//
//  ListViewModel.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 24..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import RxCocoa
import RxSwift

enum ActionOfListView {
    case buttonEditTapped
    case deleteItem(index: Int)
}

class ListViewModel {
    let disposeBag = DisposeBag()
    
    var dataManager : DataManager?
    var wordList : BehaviorRelay<[Vocabulary]>?
    var action = PublishSubject<ActionOfListView>()
    var isTableViewEditing = BehaviorRelay<Bool>(value: false)
    var titleOfButtonEdit = BehaviorRelay<String>(value: "Done")
    
    func setupData() {
        guard let list = dataManager?.readWordList() else { return }
        self.wordList = BehaviorRelay<[Vocabulary]>(value: list)
    }
    
    func bind() {
        action.asObservable().subscribe(onNext: { [weak self] value in
            self?.handleAction(value)
        }).disposed(by: disposeBag)
    }
    
    func setupDataManager(_ dbManager: DataManager) {
        self.dataManager = dbManager
    }
    
    init?(dbManager: DataManager) {
        setupDataManager(dbManager)
        bind()
        setupData()
    }
    
    func deleteWord(index:Int) {
        guard let manager = self.dataManager else { return }
        guard let list = manager.deleteWord(index:index) else { return }
        self.wordList?.accept(list)
    }
    
    func setupTitleOfButtonEdit() {
        if isTableViewEditing.value {
            titleOfButtonEdit.accept("Edit")
        }
        else {
            titleOfButtonEdit.accept("Done")
        }
    }
    
    func handleButtonEditTapped() {
        isTableViewEditing.accept(!isTableViewEditing.value)
        setupTitleOfButtonEdit()
    }
    
    func handleAction(_ action: ActionOfListView) {
        switch action {
        case .buttonEditTapped:
            handleButtonEditTapped()
        case .deleteItem(let index):
            deleteWord(index: index)
        }
    }
    
}

