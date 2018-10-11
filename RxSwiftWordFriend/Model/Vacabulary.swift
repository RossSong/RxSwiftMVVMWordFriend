//
//  Vacabulary.swift
//  WordFriend
//
//  Created by RossSong on 2017. 4. 26..
//  Copyright © 2017년 Ross Song. All rights reserved.
//

import Foundation
import RealmSwift

class Vocabulary : Object {
    @objc dynamic var word:String = ""
    @objc dynamic var meaning:String = ""
    @objc dynamic var imageURL:String = ""
}
