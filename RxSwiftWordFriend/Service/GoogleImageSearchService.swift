//
//  GoogleImageSearchService.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 25..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class GoogleImageSearchService : ImageSearchService {
    var delegate: SearchViewModelDelegate?
    var imageIndex : Int = 0
    
    let stringGoogleApi = "https://www.googleapis.com/customsearch/v1"
    let googleAPIKeyString = ""// MARK: Google API Key required!
    let googleAPIEngineIDString = ""// MARK: Google API Engin ID required!
    
    func setTargetViewModel(_ viewModel:SearchViewModelDelegate) {
        self.delegate = viewModel
    }
    
    func downloadAndSetupImage (_ stringThumbnailURL:String, height:Int?) {
        Alamofire.request(stringThumbnailURL).responseImage { response in
            debugPrint(response)
            
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.delegate?.setupImage(image, index:self.imageIndex)
                self.imageIndex = self.imageIndex + 1
            }
        }
    }
    
    func setupResultImage(_ jsonDict:Dictionary<String, Any>) {
        if let dictPagemap = jsonDict["pagemap"] as? Dictionary<String, Any> {
            if let dictThumbnail = dictPagemap["cse_image"] as? [Dictionary<String, Any>] {
                if let stringThumbnailURL = dictThumbnail[0]["src"] as? String {
                    print(stringThumbnailURL)
                    
                    let height = dictThumbnail[0]["height"] as? Int
                    if stringThumbnailURL.hasPrefix("https://") {
                        self.downloadAndSetupImage(stringThumbnailURL, height:height)
                    }
                }
            }
        }
    }
    
    func showImageSearchResult(_ items:[Dictionary<String, Any>]) {
        for jsonDict in items {
            let stringTitle = jsonDict["title"] as! String
            print(stringTitle)
            
            self.setupResultImage(jsonDict)
        }
    }
    
    func getImagesFromServer(_ word:String) {
        self.imageIndex = 0
        let parameterDict = [
            "key": googleAPIKeyString,
            "cx": googleAPIEngineIDString,
            "searchtype": "image",
            "fields" : "items",
            "start": "1",
            "q": word
        ]
        
        Alamofire.request(stringGoogleApi, method:.get, parameters:parameterDict).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value as? Dictionary<String, Any> {
                print("JSON: \(json)")
                
                if let items = json["items"] as? [Dictionary<String, Any>] {
                    debugPrint(items)
                    self.showImageSearchResult(items)
                }
            }
        }
    }

}
