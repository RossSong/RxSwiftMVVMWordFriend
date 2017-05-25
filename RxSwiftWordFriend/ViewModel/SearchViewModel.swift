//
//  SearchViewModel.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 24..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Alamofire

protocol SearchViewModelDelegate {
    func updateModel(_ model:Vocabulary)
    func setupImage(_ image:UIImage, index:Int)
}

class SearchViewModel : SearchViewModelDelegate {
    
    var dictionaryService : DictionaryService
    var imageSearchService : ImageSearchService
    var dataManager : DataManager
    
    var searchWord: Variable<String>
    var imageFirst: Variable<UIImage>
    var imageSecond: Variable<UIImage>
    var imageThird: Variable<UIImage>
    var meaning: Variable<String>
    
    var images = [Variable<UIImage>]()
    
    init?(dicService: DictionaryService, imageService: ImageSearchService, dbManager: DataManager) {
        self.searchWord = Variable<String>("")
        self.imageFirst = Variable<UIImage>(UIImage())
        self.imageSecond = Variable<UIImage>(UIImage())
        self.imageThird = Variable<UIImage>(UIImage())
        self.meaning = Variable<String>("")
        self.dictionaryService = dicService
        self.imageSearchService = imageService
        self.dataManager = dbManager
        self.dictionaryService.setTargetViewModel(self)
        self.imageSearchService.setTargetViewModel(self)
        
        self.images = [self.imageFirst, self.imageSecond, self.imageThird]
    }
    
    func showList() {
        debugPrint("TODO: show ListViewController!")
    }
    
    func showQuiz() {
        debugPrint("TODO: show QuizViewController!")
    }
    
    func doSearchWord() {
        print("doSearchWord: \(self.searchWord.value)")
        self.dictionaryService.getMeaningFromServer(self.searchWord.value)
        self.imageSearchService.getImagesFromServer(self.searchWord.value)
    }
    
    func updateModel(_ model:Vocabulary) {
        self.meaning.value = model.meaning
        self.dataManager.addWord(model)
    }
    
    func setupImage(_ image:UIImage, index:Int) {
        guard  self.images.count > index else { return }
        self.images[index].value = image
    }
}
