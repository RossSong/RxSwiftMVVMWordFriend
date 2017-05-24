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
    dynamic var word:String = ""
    dynamic var meaning:String = ""
    dynamic var imageURL:String = ""
}
