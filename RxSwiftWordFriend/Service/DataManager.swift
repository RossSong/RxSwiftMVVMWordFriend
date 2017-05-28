//
//  DataManager.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 25..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation

protocol DataManager {
    func addWord(_ voca:Vocabulary)
    func readWordList () -> Array<Vocabulary>?
    func deleteWord(index:Int) -> Array<Vocabulary>?
}
