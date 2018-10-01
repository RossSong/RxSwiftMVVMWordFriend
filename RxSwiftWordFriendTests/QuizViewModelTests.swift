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
            
            beforeEach {
                viewModel = QuizeViewModel()
                mockDataManager = MockDataManager()
                Service.shared.container.register(DataManager.self) { _ in mockDataManager! }
            }
            
            context("View did load") {
                it("should load words from database") {
                    let voca = Vocabulary()
                    mockDataManager?.addWord(voca)
                    viewModel?.action.onNext(.viewDidLoad)
                    expect(viewModel?.words.count).toNot(equal(0))
                }
                
                it("should show one word randomly from loaded words") {
                    
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
