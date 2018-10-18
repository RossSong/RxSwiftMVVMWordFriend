//
//  QuizReactorTests.swift
//  RxSwiftWordFriendTests
//
//  Created by Ross on 2018. 9. 20..
//  Copyright © 2018년 RossSong. All rights reserved.
//

import Quick
import RxSwift
import RxCocoa
import Nimble
@testable import RxSwiftWordFriend

class QuizReactorTests: QuickSpec {
    override func spec() {
        describe("QuizView") {
            
            var reactor: QuizReactor?
            var disposeBag: DisposeBag?
            var mockDataManager: MockDataManager?
            var mockRandomGenerator: MockRandomGenerator?

            beforeEach {
                mockDataManager = MockDataManager()
                Service.shared.container.register(DataManager.self) { _ in mockDataManager! }

                mockRandomGenerator = MockRandomGenerator()
                Service.shared.container.register(RandomGeneratorProtocol.self) { _ in mockRandomGenerator! }
                
                disposeBag = DisposeBag()
                reactor = QuizReactor()
            }
            
            func loadData() {
                let voca = Vocabulary()
                voca.word = "aaa"
                voca.meaning = "bbb"
                
                let voca2 = Vocabulary()
                voca2.word = "ccc"
                voca2.meaning = "ddd"
                
                mockDataManager?.addWord(voca)
                mockDataManager?.addWord(voca2)
                reactor?.action.onNext(.load)
            }
            
            context("View did load") {
                it("should load words from database") {
                    let voca = Vocabulary()
                    mockDataManager?.addWord(voca)
                    
                    reactor?.state.asObservable().subscribe(onNext: { value in
                        
                    }).disposed(by: disposeBag!)
                    reactor?.action.onNext(.load)
                }
                
                it("should show one word randomly from loaded words") {
                    let result = BehaviorRelay<QuizReactor.State>(value: QuizReactor.State())
                    reactor?.state.bind(to: result).disposed(by: disposeBag!)
                    loadData()
                    //expect..
                }
                
                context("User select one from two meanings") {
                    beforeEach {
                        loadData()
                    }
                    
                    context("the selected one is correct") {
                        it("should show popup for congratulation") {
                            mockRandomGenerator?.isIndexUsing = false
                            mockRandomGenerator?.randomIndex = 1
                            mockRandomGenerator?.randomIndex2 = 0
                            let result = BehaviorRelay<QuizReactor.State>(value: QuizReactor.State())
                            reactor?.state.bind(to: result).disposed(by: disposeBag!)
                            reactor?.action.onNext(.peek)
                            reactor?.action.onNext(.selectAnswer(index: 0))
                            expect(result.value.shouldShowPopupForCongratulation).to(beTrue())
                            expect(result.value.shouldShowPopupForWrong).to(beFalse())
                        }
                    }
                    
                    context("the selected one is wrong") {
                        it("should show popup for wrong answer") {
                            mockRandomGenerator?.isIndexUsing = false
                            mockRandomGenerator?.randomIndex = 0
                            mockRandomGenerator?.randomIndex2 = 1
                            let result = BehaviorRelay<QuizReactor.State>(value: QuizReactor.State())
                            reactor?.state.bind(to: result).disposed(by: disposeBag!)
                            reactor?.action.onNext(.peek)
                            reactor?.action.onNext(.selectAnswer(index: 0))
                            expect(result.value.shouldShowPopupForCongratulation).to(beFalse())
                            expect(result.value.shouldShowPopupForWrong).to(beTrue())
                        }
                    }
                }
                
                context("popup is gone") {
                    beforeEach {
                        loadData()
                    }
                    
                    it("should load another word from loaded words") {
                        mockRandomGenerator?.randomIndex = 1
                        mockRandomGenerator?.randomIndex2 = 0
                        let result = BehaviorRelay<QuizReactor.State>(value: QuizReactor.State())
                        reactor?.state.bind(to: result).disposed(by: disposeBag!)
                        reactor?.action.onNext(.confirmPopup)
                        expect(result.value.shouldShowPopupForCongratulation).to(beFalse())
                        expect(result.value.shouldShowPopupForWrong).to(beFalse())
                    }
                }
            }
        }
    }
}

