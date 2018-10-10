//
//  DictionaryService.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 25..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import RxSwift

protocol DictionaryService {
    func getMeaningFromServer(_ word:String) -> Observable<Vocabulary>
}
