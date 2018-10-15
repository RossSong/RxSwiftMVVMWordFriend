//
//  ListViewModelTests.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 28..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import XCTest
@testable import RxSwiftWordFriend

class ListViewModelTests: XCTestCase {
    
    var listViewModel : ListViewModel?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.listViewModel = ListViewModel(dbManager:MockDataManager())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.listViewModel = nil
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
    
    func testInit() {
        XCTAssert(nil != self.listViewModel)
        XCTAssert(nil != self.listViewModel?.wordList)
    }
    
    func testDeleteWord() {
        let voca = Vocabulary()
        voca.word = "TEST1"
        voca.meaning = "TEST1_Meaning"
        
        let voca2 = Vocabulary()
        voca2.word = "TEST2"
        voca2.meaning = "TEST2_Meaning"
        
        guard let viewModel = self.listViewModel, let manager = viewModel.dataManager else { return XCTFail() }
        manager.addWord(voca)
        manager.addWord(voca2)
        
        guard let list = manager.readWordList() else { return XCTFail() }
        XCTAssert(2 == list.count)
        
        viewModel.deleteWord(index: 0)
        guard let listRet = viewModel.wordList else { return XCTFail() }
        XCTAssert(1 == listRet.value.count)
        
        let vocaRet = listRet.value[0]
        XCTAssert("TEST2" == vocaRet.word && "TEST2_Meaning" == vocaRet.meaning)
    }
    
    func testButtonEditPressed() {
        listViewModel?.isTableViewEditing.accept(false)
        listViewModel?.action.onNext(.buttonEditTapped)
        XCTAssert(true == listViewModel?.isTableViewEditing.value)
        XCTAssert("Edit" == listViewModel?.titleOfButtonEdit.value)
        
        listViewModel?.action.onNext(.buttonEditTapped)
        XCTAssert(false == listViewModel?.isTableViewEditing.value)
        XCTAssert("Done" == listViewModel?.titleOfButtonEdit.value)
    }
}
