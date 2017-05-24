//
//  ImageSearchService.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 25..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation

protocol ImageSearchService {
    func setTargetViewModel(_ viewModel:SearchViewModelDelegate)
    func getImagesFromServer(_ word:String)
}
