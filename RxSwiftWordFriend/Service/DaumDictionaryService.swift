//
//  DaumDictionaryService.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 24..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class DaumDictionaryService : NSObject, XMLParserDelegate, DictionaryService {
    
    func getElementsFrom(_ data: Data) -> [TFHppleElement]? {
        guard let parser = TFHpple(htmlData: data) else { return nil }
        let stringQuery = "//div[@class='cleanword_type kuek_type']/ul[@class='list_search']/li"
        return parser.search(withXPathQuery: stringQuery) as? [TFHppleElement]
    }
    
    func createVocabulary(word: String, meaning: String) -> Vocabulary {
        let voca = Vocabulary()
        voca.word = word
        voca.meaning = meaning
        return voca
    }
    
    func getVocaFromData(_ data: Data, word: String) -> Vocabulary? {
        guard let elements = getElementsFrom(data) else { return nil }
        return createVocabulary(word: word, meaning: self.getMeaning(elements))
    }
    
    func handleSuccessForRequestSearch(_ observer: AnyObserver<Vocabulary>, word:String, data: Data?) {
        guard let data = data,
            //let utf8Text = String(data: data, encoding: .utf8),
            let voca = getVocaFromData(data, word: word) else { return }
        //debugPrint(utf8Text)
        observer.onNext(voca)
        observer.onCompleted()
    }
    
    func handleForRequestSearch(_ observer: AnyObserver<Vocabulary>, word:String, response: DataResponse<Data>) {
        switch response.result {
        case .success(let value):
            self.handleSuccessForRequestSearch(observer, word: word, data: value)
        case .failure(let error):
            observer.onError(error)
        }
    }
    
    func getMeaningFromServer(_ word:String) -> Observable<Vocabulary> {
        return Observable.create { observer -> Disposable in
            let stringSearch = "http://dic.daum.net/search.do"
            let parameterDict = ["q": word]
            
            Alamofire.request(stringSearch, method:.get, parameters:parameterDict).responseData { [weak self] response in
                self?.handleForRequestSearch(observer, word: word, response: response)
            }
            
            return Disposables.create()
        }
    }
    
    func getStringFrom(elementContent: TFHppleElement) -> String {
        guard let elementContentChildren = elementContent.children as? [TFHppleElement] else { return "" }
        return elementContentChildren.map { $0.content ?? "" }.joined()
    }
    
    func getStringFrom(element: TFHppleElement) -> String {
        print(element)
        guard 1 < element.children.count,
            let child = element.children[1] as? TFHppleElement,
            let elementContentes = child.children as? [TFHppleElement] else { return "" }
        
        return elementContentes.map{ getStringFrom(elementContent: $0) }.joined()
    }
    
    func getMeaning(_ array:[TFHppleElement]) -> String {
       return array.map { getStringFrom(element: $0) }.joined(separator: "\n")
    }
}
