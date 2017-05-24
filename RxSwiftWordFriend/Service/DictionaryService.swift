//
//  DictionaryService.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 25..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation

protocol DictionaryService {
    func setTargetViewModel(_ viewModel:SearchViewModelDelegate)
    func getMeaningFromServer(_ word:String)
}
