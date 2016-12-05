//
//  SwiftyAnimateTests.swift
//  SwiftyAnimateTests
//
//  Created by Reid Chatham on 12/4/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import XCTest
@testable import SwiftyAnimate

class SwiftyAnimateTests: XCTestCase {
    
    static var allTests : [(String, (SwiftyAnimateTests) -> () throws -> Void)] {
        return [
            ("test_Animate_Performed", test_Animate_Performed),
            ("test_Animate_PerformedWithCompletion", test_Animate_PerformedWithCompletion),
            ("test_EmptyAnimate_Performed", test_EmptyAnimate_Performed),
            ("test_EmptyAnimate_PerformedWithCompletion", test_EmptyAnimate_PerformedWithCompletion),
            ("test_EmptyAnimate_PerformedDoBlock", test_EmptyAnimate_PerformedDoBlock),
            ("test_EmptyAnimate_PerformedWaitBlock", test_EmptyAnimate_PerformedWaitBlock),
            ("test_EmptyAnimate_Finished", test_EmptyAnimate_Finished),
            ("test_EmptyAnimate_PerformedThenAnimation", test_EmptyAnimate_PerformedThenAnimation),
            ("test_EmptyAnimate_PerformedThenAnimationWithCompletion", test_EmptyAnimate_PerformedThenAnimationWithCompletion),
        ]
    }
    
    func test_Animate_Performed() {
        
        var performedAnimation = false
        
        let animation = Animate(duration: 0.5) {
            performedAnimation = true
        }
        
        XCTAssertFalse(performedAnimation)
        
        animation.perform()
        
        XCTAssertTrue(performedAnimation)
    }
    
    func test_Animate_PerformedWithCompletion() {
        
        var performedAnimation = false
        var performedWithCompletion = false
        
        let animation = Animate(duration: 0.5) {
            performedAnimation = true
        }
        
        XCTAssertFalse(performedAnimation)
        XCTAssertFalse(performedWithCompletion)
        
        let expect = expectation(description: "Performed animation with completion")
        
        animation.perform {
            performedWithCompletion = true
            expect.fulfill()
        }
        
        XCTAssertTrue(performedAnimation)
        
        waitForExpectations(timeout: 1.0) { error in
            if error != nil { print(error!.localizedDescription) }
            XCTAssertTrue(performedWithCompletion)
        }
    }
    
    func test_Animate_PerformedThenAnimation() {
        
        var performedAnimation = false
        var performedThenAnimation = false
        
        let animation = Animate(duration: 0.5) {
            performedAnimation = true
        }.then(duration: 0.5) {
            performedThenAnimation = true
        }
        
        XCTAssertFalse(performedAnimation)
        XCTAssertFalse(performedThenAnimation)
        
        let expect = expectation(description: "Performed then animation with completion")
        
        animation.perform {
            expect.fulfill()
        }
        
        XCTAssertTrue(performedAnimation)
        XCTAssertFalse(performedThenAnimation)
        
        waitForExpectations(timeout: 1.0) { error in
            if error != nil { print(error!.localizedDescription) }
            XCTAssertTrue(performedThenAnimation)
        }
    }
    
    func test_EmptyAnimate_Performed() {
        
        let animation = Animate()
        
        let expect = expectation(description: "Performed empty animation with completion")
        
        animation.perform {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { error in
            if error != nil { print(error!.localizedDescription) }
        }
        
    }
    
    func test_EmptyAnimate_PerformedWithCompletion() {
        
        var performedWithCompletion = false
        
        let animation = Animate()
        
        XCTAssertFalse(performedWithCompletion)
        
        animation.perform {
            performedWithCompletion = true
        }
        
        XCTAssertTrue(performedWithCompletion)
    }
    
    func test_EmptyAnimate_PerformedDoBlock() {
        
        var performedDoBlock = false
        
        let animation = Animate().do {
            performedDoBlock = true
        }
        
        XCTAssertFalse(performedDoBlock)
        
        animation.perform()
        
        XCTAssertTrue(performedDoBlock)
    }
    
    func test_EmptyAnimate_PerformedWaitBlock() {
        
        var performedWaitBlock = false
        
        let animation = Animate().wait { resume in
            
            self.resumeBlock = {
                XCTAssertFalse(performedWaitBlock)
                performedWaitBlock = true
                
                resume()
                self.resumeBlock = nil
            }
            
            if #available(iOS 10.0, *) {
                
                Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] timer in
                    self?.resumeBlock?()
                }
            } else {
                Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(SwiftyAnimateTests.resume(_:)), userInfo: nil, repeats: false)
            }
            
        }
        
        XCTAssertFalse(performedWaitBlock)
        
        let expect = expectation(description: "Performed empty animation with completion")
        
        animation.perform {
            XCTAssertTrue(performedWaitBlock)
            expect.fulfill()
        }
        
        XCTAssertFalse(performedWaitBlock)
        
        waitForExpectations(timeout: 6.0) { error in
            if error != nil { print(error!.localizedDescription) }
        }
    }
    
    func test_EmptyAnimate_PerformedWaitBlock_WithTimeout() {
        
        var performedWaitBlock = false
        var performedDoBlock = false
        
        let animation = Animate().wait(timeout: 1.0) { resume in
            
            self.resumeBlock = {
                XCTAssertFalse(performedWaitBlock)
                performedWaitBlock = true
                
                resume()
                self.resumeBlock = nil
            }
            
            if #available(iOS 10.0, *) {
                
                Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] timer in
                    self?.resumeBlock?()
                }
            } else {
                Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(SwiftyAnimateTests.resume(_:)), userInfo: nil, repeats: false)
            }
            
        }.do {
            performedDoBlock = true
        }
        
        XCTAssertFalse(performedWaitBlock)
        XCTAssertFalse(performedDoBlock)
        
        let expect = expectation(description: "Performed empty animation with completion")
        
        animation.perform {
            XCTAssertFalse(performedWaitBlock)
            XCTAssertTrue(performedDoBlock)
            expect.fulfill()
        }
        
        XCTAssertFalse(performedWaitBlock)
        XCTAssertFalse(performedDoBlock)
        
        waitForExpectations(timeout: 2.0) { error in
            if error != nil { print(error!.localizedDescription) }
            
            XCTAssertFalse(performedWaitBlock)
            XCTAssertTrue(performedDoBlock)
        }
    }
    
    func test_EmptyAnimate_Finished() {
        
        var finishedAnimation = false
        
        let animation = Animate()
        
        XCTAssertFalse(finishedAnimation)
        
        animation.finish(duration: 0.5) {
            finishedAnimation = true
        }
        
        XCTAssertTrue(finishedAnimation)
    }
    
    func test_EmptyAnimate_PerformedThenAnimation() {
        
        var performedThenAnimation = false
        
        let animation = Animate().then(duration: 0.5) {
            performedThenAnimation = true
        }
        
        XCTAssertFalse(performedThenAnimation)
        
        animation.perform()
        
        XCTAssertTrue(performedThenAnimation)
    }
    
    func test_EmptyAnimate_PerformedThenAnimationWithCompletion() {
        
        var performedThenAnimation = false
        var performedWithCompletion = false
        
        let animation = Animate().then(duration: 0.5) {
            performedThenAnimation = true
        }
        
        XCTAssertFalse(performedThenAnimation)
        XCTAssertFalse(performedWithCompletion)
        
        
        let expect = expectation(description: "Performed then animation with completion")
        
        animation.perform {
            performedWithCompletion = true
            expect.fulfill()
        }
        
        XCTAssertTrue(performedThenAnimation)
        
        waitForExpectations(timeout: 1.0) { error in
            if error != nil { print(error!.localizedDescription) }
            XCTAssertTrue(performedWithCompletion)
        }
    }
    
    func test_EmptyAnimate_DidDecay() {
        
        var performedDoBlock = false
        
        let animation = Animate().do {
            performedDoBlock = true
        }
        
        XCTAssertFalse(performedDoBlock)
        
        animation.decay()
        
        XCTAssertFalse(performedDoBlock)
        
        animation.perform()
        
        XCTAssertFalse(performedDoBlock)
        
    }
    
    private var resumeBlock: Resume?
    
    internal func resume(_ sender: Timer) {
        resumeBlock?()
    }
}
