//
//  RealmDataManager.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 25..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataManager : DataManager {
    static let shared = RealmDataManager()
    let realm: Realm?
    
    init() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func addWord(_ voca:Vocabulary) {
        guard let manager = self.realm else { return }
        do {
            try manager.write {
                manager.add(voca)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func readWordList () -> Array<Vocabulary>? {
        guard let manager = self.realm else { return nil}
        let wordList = Array(manager.objects(Vocabulary.self))
        return wordList
    }
}
