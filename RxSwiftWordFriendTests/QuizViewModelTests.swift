//
//  QuizViewModelTests.swift
//  RxSwiftWordFriendTests
//
//  Created by Ross on 2018. 9. 20..
//  Copyright © 2018년 RossSong. All rights reserved.
//

import Quick
import Nimble
@testable import RxSwiftWordFriend

class QuizViewModelTests: QuickSpec {
    override func spec() {
        describe("QuizView") {
            
            var viewModel: QuizViewModelProtocol?
            var mockDataManager: MockDataManager?
            var mockRandomGenerator: MockRandomGenerator?
            
            beforeEach {
                mockDataManager = MockDataManager()
                Service.shared.container.register(DataManager.self) { _ in mockDataManager! }
                
                mockRandomGenerator = MockRandomGenerator()
                Service.shared.container.register(RandomGeneratorProtocol.self) { _ in mockRandomGenerator! }
                viewModel = QuizeViewModel()
            }
            
            context("View did load") {
                it("should load words from database") {
                    let voca = Vocabulary()
                    mockDataManager?.addWord(voca)
                    viewModel?.action.onNext(.viewDidLoad)
                    //expect(viewModel?.words.count).toNot(equal(0))
                }
                
                it("should show one word randomly from loaded words") {
                    let voca = Vocabulary()
                    voca.word = "aaa"
                    voca.meaning = "bbb"
                    
                    let voca2 = Vocabulary()
                    voca2.word = "ccc"
                    voca2.meaning = "ddd"
                    
                    mockDataManager?.addWord(voca)
                    mockDataManager?.addWord(voca2)
                    
                    viewModel?.action.onNext(.viewDidLoad)
                    mockRandomGenerator?.randomIndex = 0
                    expect(viewModel?.targetWord).to(equal("aaa"))
                    mockRandomGenerator?.randomIndex = 1
                    expect(viewModel?.targetWord).to(equal("ccc"))
                }
            }
            
            context("User select one from two meanings") {
                context("the selected one is correct") {
                    it("should show popup for congratulation") {
                        
                    }
                }
                
                context("the selected one is wrong") {
                    it("should show popup for wrong answer") {
                        
                    }
                }
            }
            
            context("popup is gone") {
                it("should load another word from loaded words") {
                    
                }
            }
        }
    }
}
