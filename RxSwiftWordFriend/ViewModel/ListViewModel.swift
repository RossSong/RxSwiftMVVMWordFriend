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

class ListViewModel {
    var wordList : Variable<[Vocabulary]>?
    var dataManager : DataManager?
    
    init?(dbManager: DataManager) {
        self.dataManager = dbManager
        if let list = dbManager.readWordList() {
            self.wordList = Variable<[Vocabulary]>(list)
        }
    }
    
    func deleteWord(index:Int) {
        guard let manager = self.dataManager else { return }
        guard let list = manager.deleteWord(index:index) else { return }
        self.wordList?.value = list
    }
}

