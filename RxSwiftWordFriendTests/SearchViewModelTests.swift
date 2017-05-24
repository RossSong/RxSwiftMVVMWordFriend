//
//  SearchViewModelTests.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 25..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import XCTest
@testable import RxSwiftWordFriend

class MockDictionaryService : DictionaryService {
    var delegate : SearchViewModelDelegate?
    
    func setTargetViewModel(_ viewModel:SearchViewModelDelegate) {
        self.delegate = viewModel
    }
    
    func getMeaningFromServer(_ word:String) {
        let model = WordSearchResult()
        
        if "TEST" == word {
            model.meaning = "ABC"
        }
        
        self.delegate?.updateModel(model)
    }
}

class MockImageSearchService : ImageSearchService {
    var delegate : SearchViewModelDelegate?
    
    func setTargetViewModel(_ viewModel:SearchViewModelDelegate) {
        self.delegate = viewModel
    }
    
    func getImagesFromServer(_ word:String) {
        
    }
}

class SearchViewModelTests: XCTestCase {
    var searchViewModel : SearchViewModel?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.searchViewModel = SearchViewModel(dicService: MockDictionaryService(), imageService: MockImageSearchService())
        
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
        self.searchViewModel?.searchWord.value = "TEST"
        self.searchViewModel?.doSearchWord()
        XCTAssert("ABC" == self.searchViewModel?.meaning.value)
    }
    
}
