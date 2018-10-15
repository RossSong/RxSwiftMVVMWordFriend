//
//  SearchViewModelTests.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 25..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import XCTest
import RxSwift
@testable import RxSwiftWordFriend

class MockImageSearchService : ImageSearchService {
    var delegate : SearchViewModelDelegate?
    
    func setTargetViewModel(_ viewModel:SearchViewModelDelegate) {
        self.delegate = viewModel
    }
    
    func getImagesFromServer(_ word:String) {
        
    }
}

class SearchViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    var searchViewModel : SearchViewModel?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let dataManager = MockDictionaryService(MockDataManager()) {
            self.searchViewModel = SearchViewModel(dicService: dataManager, imageService: MockImageSearchService(), dbManager: MockDataManager(), widthOfImageView: 100)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDoSearchWord() {
        self.searchViewModel?.searchWord.accept("TEST")
        self.searchViewModel?.doSearchWord()
        XCTAssert("ABC" == self.searchViewModel?.meaning.value)
    }
    
    func testDoSearchWord2() {
        if let viewModel = self.searchViewModel {
            viewModel.searchWord.accept("TEST")
            viewModel.doSearchWord()
            let list = viewModel.dataManager.readWordList()
            XCTAssert(nil != list)
            
            let wordList = list!
            XCTAssert(1 == wordList.count)
            XCTAssert(wordList[0].word == "TEST")
            XCTAssert(wordList[0].meaning == "ABC")
        }
    }
    
    func testButtonListPressed() {
        var value = false
        searchViewModel?.shouldGoToListViewController.asObservable().subscribe(onNext: { _ in
            value = true
        }).disposed(by: disposeBag)
        searchViewModel?.buttonListPressed.onNext(())
        XCTAssert(true == value)
    }
    
    func testButtonQuizPressed() {
        var value = false
        searchViewModel?.shouldGoToQuizViewController.asObservable().subscribe(onNext: { _ in
            value = true
        }).disposed(by: disposeBag)
        searchViewModel?.buttonQuizPressed.onNext(())
        XCTAssert(true == value)
    }
}
