//
//  SearchViewModel.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 24..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
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
    
    var searchWord: BehaviorRelay<String>
    var imageFirst: BehaviorRelay<(image: UIImage, height: CGFloat)>
    var imageSecond: BehaviorRelay<(image: UIImage, height: CGFloat)>
    var imageThird: BehaviorRelay<(image: UIImage, height: CGFloat)>
    var meaning: BehaviorRelay<String>
    
    var images = [BehaviorRelay<(image: UIImage, height: CGFloat)>]()
    let buttonListPressed = PublishSubject<Void>()
    let buttonQuizPressed = PublishSubject<Void>()
    let shouldGoToQuizViewController = PublishSubject<Void>()
    let shouldGoToListViewController = PublishSubject<Void>()
    
    init?(dicService: DictionaryService, imageService: ImageSearchService, dbManager: DataManager, widthOfImageView: CGFloat) {
        self.widthOfImageView = widthOfImageView
        self.searchWord = BehaviorRelay<String>(value: "")
        self.imageFirst = BehaviorRelay<(image: UIImage, height: CGFloat)>(value: (image: UIImage(), height: 0.0))
        self.imageSecond = BehaviorRelay<(image: UIImage, height: CGFloat)>(value: (image: UIImage(), height: 0.0))
        self.imageThird = BehaviorRelay<(image: UIImage, height: CGFloat)>(value: (image: UIImage(), height: 0.0))
        self.meaning = BehaviorRelay<String>(value: "")
        self.dictionaryService = dicService
        self.imageSearchService = imageService
        self.dataManager = dbManager
        self.imageSearchService.setTargetViewModel(self)
        
        self.images = [self.imageFirst, self.imageSecond, self.imageThird]
        
        setupEventsHandler()
    }
    
    func setupButtonListPressedEventsHandler() {
        self.buttonListPressed.bind(to:shouldGoToListViewController).disposed(by: disposeBag)
    }
    
    func setupButtonQuizPressedEventsHandler() {
        self.buttonQuizPressed.bind(to: shouldGoToQuizViewController).disposed(by: disposeBag)
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
        self.meaning.accept(model.meaning)
        self.dataManager.addWord(model)
    }
    
    func setupImage(_ image:UIImage, index:Int) {
        guard  self.images.count > index else { return }
        let height = getHeight(image: image)
        self.images[index].accept((image: image, height: height))
    }
    
    func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let wordList = self.dataManager.readWordList() else { return false }
        guard 0 == wordList.count && "gotoQuiz" == identifier else { return true }
        return false
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
