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
    var disposeBag = DisposeBag()
    var widthOfImageView: CGFloat = 0
    var dictionaryService : DictionaryService
    var imageSearchService : ImageSearchService
    var dataManager : DataManager
    
    var searchWord: Variable<String>
    var imageFirst: Variable<(image: UIImage, height: CGFloat)>
    var imageSecond: Variable<(image: UIImage, height: CGFloat)>
    var imageThird: Variable<(image: UIImage, height: CGFloat)>
    var meaning: Variable<String>
    
    var images = [Variable<(image: UIImage, height: CGFloat)>]()
    let buttonListPressed = PublishSubject<Void>()
    let buttonQuizPressed = PublishSubject<Void>()
    let shouldGoToQuizViewController = PublishSubject<Void>()
    let shouldGoToListViewController = PublishSubject<Void>()
    
    init?(dicService: DictionaryService, imageService: ImageSearchService, dbManager: DataManager, widthOfImageView: CGFloat) {
        self.widthOfImageView = widthOfImageView
        self.searchWord = Variable<String>("")
        self.imageFirst = Variable<(image: UIImage, height: CGFloat)>(image: UIImage(), height: 0)
        self.imageSecond = Variable<(image: UIImage, height: CGFloat)>(image: UIImage(), height: 0)
        self.imageThird = Variable<(image: UIImage, height: CGFloat)>(image: UIImage(), height: 0)
        self.meaning = Variable<String>("")
        self.dictionaryService = dicService
        self.imageSearchService = imageService
        self.dataManager = dbManager
        self.imageSearchService.setTargetViewModel(self)
        
        self.images = [self.imageFirst, self.imageSecond, self.imageThird]
        
        setupEventsHandler()
    }
    
    func setupButtonListPressedEventsHandler() {
        _ = self.buttonListPressed.subscribe(onNext: { [weak self] _ in
            self?.shouldGoToListViewController.onNext()
        })
    }
    
    func setupButtonQuizPressedEventsHandler() {
        _ = self.buttonQuizPressed.subscribe(onNext: { [weak self] _ in
            self?.shouldGoToQuizViewController.onNext()
        })
    }
    
    func setupEventsHandler() {
        setupButtonListPressedEventsHandler()
        setupButtonQuizPressedEventsHandler()
    }
    
    func showList() {
        debugPrint("TODO: show ListViewController!")
    }
    
    func doSearchWord() {
        print("doSearchWord: \(self.searchWord.value)")
        self.dictionaryService.getMeaningFromServer(self.searchWord.value).asObservable()
            .subscribe(onNext: {[weak self] value in
                self?.updateModel(value)
            }).disposed(by: disposeBag)
        self.imageSearchService.getImagesFromServer(self.searchWord.value)
    }
    
    func updateModel(_ model:Vocabulary) {
        self.meaning.value = model.meaning
        self.dataManager.addWord(model)
    }
    
    func setupImage(_ image:UIImage, index:Int) {
        guard  self.images.count > index else { return }
        let height = getHeight(image: image)
        self.images[index].value = (image: image, height: height)
    }
    
    func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let wordList = self.dataManager.readWordList() else { return false }
        
        if 0 == wordList.count && "gotoQuiz" == identifier {
            return false
        }
        
        return true
    }
    
    func getHeight(image:UIImage?) -> CGFloat {
        guard let newImage = image else { return 0 }
        guard 0 != newImage.size.height else { return 0 }
        guard 0 != newImage.size.width else { return 0 }
        let height = newImage.size.height
        let width = newImage.size.width
        let newHeight = height/width * widthOfImageView
        return CGFloat(newHeight);
    }
}
