//
//  Service.swift
//  RxSwiftWordFriend
//
//  Created by Ross on 2018. 10. 1..
//  Copyright © 2018년 RossSong. All rights reserved.
//

import Foundation
import Swinject
import RxSwift

struct Service {
    static let shared = Service()
    let container = Container()
    
    private init() {
        register()
    }
    
    func register() {
        container.register(DataManager.self) { _ in RealmDataManager.shared }
        container.register(QuizManagerProtocol.self) { _ in QuizManager()}
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
    
    func resolve<Service>(_ serviceType: Service.Type, suiteName: String) -> Service? {
        return container.resolve(serviceType, name: suiteName)
    }
}



