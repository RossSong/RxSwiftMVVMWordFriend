//
//  DaumDictionaryService.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 24..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import Alamofire

class DaumDictionaryService : NSObject, XMLParserDelegate, DictionaryService {
    var delegate: SearchViewModelDelegate?
    
    func setTargetViewModel(_ viewModel:SearchViewModelDelegate) {
        self.delegate = viewModel
    }
    
    func getMeaningFromServer(_ word:String) {
        let stringSearch = "http://dic.daum.net/search.do"
        let parameterDict = ["q": word]
        
        //print(stringSearch)
        Alamofire.request(stringSearch, method:.get, parameters:parameterDict).responseData { response in
            debugPrint(response)
            
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                
                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    let dataHtml:NSData? = data as NSData
                    let parser = TFHpple(htmlData: dataHtml as Data!)
                    
                    let stringQuery = "//div[@class='cleanword_type kuek_type']/ul[@class='list_search']/li"
                    let array = parser?.search(withXPathQuery: stringQuery)
                    
                    let meaning = self.getMeaning(array as! [TFHppleElement])
                    
                    let voca = Vocabulary()
                    voca.word = word
                    voca.meaning = meaning
                    self.delegate?.updateModel(voca)
                }
            }
        }
    }
    
    func getMeaning(_ array:[TFHppleElement]) -> String {
        var stringTitle = ""
        for element in array {
            print(element)
            
            if 2 > element.children.count {
                continue;
            }
            
            let child = element.children[1] as! TFHppleElement
            for elementContent in child.children as! [TFHppleElement] {
                for elementWord in elementContent.children as! [TFHppleElement] {
                    stringTitle += elementWord.content
                }
            }
            
            stringTitle += "\n"
            print(stringTitle)
        }
        
        return stringTitle
    }
}
