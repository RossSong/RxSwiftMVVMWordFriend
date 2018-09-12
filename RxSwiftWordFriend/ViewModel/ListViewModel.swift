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
import RxSwift

enum ActionOfListView {
    case buttonEditTapped
    case deleteItem(index: Int)
}

class ListViewModel {
    let disposeBag = DisposeBag()
    
    var dataManager : DataManager?
    var wordList : Variable<[Vocabulary]>?
    var action = PublishSubject<ActionOfListView>()
    var isTableViewEditing = Variable<Bool>(false)
    var titleOfButtonEdit = Variable<String>("Done")
    
    func setupData() {
        guard let list = dataManager?.readWordList() else { return }
        self.wordList = Variable<[Vocabulary]>(list)
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
        self.wordList?.value = list
    }
    
    func setupTitleOfButtonEdit() {
        if isTableViewEditing.value {
            titleOfButtonEdit.value = "Edit"
        }
        else {
            titleOfButtonEdit.value = "Done"
        }
    }
    
    func handleButtonEditTapped() {
        isTableViewEditing.value = !isTableViewEditing.value
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

