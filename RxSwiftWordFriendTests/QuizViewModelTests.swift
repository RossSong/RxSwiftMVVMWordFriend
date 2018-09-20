//
//  QuizViewModelTests.swift
//  RxSwiftWordFriendTests
//
//  Created by Ross on 2018. 9. 20..
//  Copyright © 2018년 RossSong. All rights reserved.
//

import Quick
import Nimble

class QuizViewModelTests: QuickSpec {
    override func spec() {
        describe("QuizView") {
            context("View did load") {
                it("should load words from database") {
                    
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
