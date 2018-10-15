//
//  MockObjects.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 28..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

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
    
    func getMeaningFromServer(_ word:String) -> Observable<Vocabulary> {
        return Observable.create { observer -> Disposable in
            let model = Vocabulary()
            
            if "TEST" == word {
                model.word = "TEST"
                model.meaning = "ABC"
            }
            
            observer.onNext(model)
            return Disposables.create()
        }
    }
}

class MockRandomGenerator: RandomGeneratorProtocol {
    var randomIndex = -1
    
    func getRandomIndex(max: Int) -> Int {
        return randomIndex
    }
}

