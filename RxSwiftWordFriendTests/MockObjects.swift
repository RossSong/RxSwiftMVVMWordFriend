//
//  MockObjects.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 28..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
@testable import RxSwiftWordFriend

class MockDataManager : DataManager {
    var ret = Array<Vocabulary>()
    
    func addWord(_ voca:Vocabulary) {
        ret.append(voca)
    }
    
    func readWordList () -> Array<Vocabulary>? {
        return ret
    }
    
    func deleteWord(index:Int) -> Array<Vocabulary>? {
        guard index < ret.count else { return ret }
        ret.remove(at: index)
        return ret
    }
}

class MockDictionaryService : DictionaryService {
    var delegate : SearchViewModelDelegate?
    var dataManager : DataManager?
    
    required init? (_ dbManager: DataManager) {
        self.dataManager = dbManager
    }
    
    func setTargetViewModel(_ viewModel:SearchViewModelDelegate) {
        self.delegate = viewModel
    }
    
    func getMeaningFromServer(_ word:String) {
        let model = Vocabulary()
        
        if "TEST" == word {
            model.word = "TEST"
            model.meaning = "ABC"
        }
        
        self.delegate?.updateModel(model)
    }
}
