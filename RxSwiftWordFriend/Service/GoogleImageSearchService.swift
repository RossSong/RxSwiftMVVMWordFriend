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
    
    func handleForDownloadImage(_ response: Alamofire.DataResponse<Image>) {
        guard let image = response.result.value else { return }
        print("image downloaded: \(image)")
        self.delegate?.setupImage(image, index:self.imageIndex)
        self.imageIndex = self.imageIndex + 1
    }
    
    func downloadAndSetupImage (_ stringThumbnailURL:String, height:Int?) {
        Alamofire.request(stringThumbnailURL).responseImage { [weak self] response in
            self?.handleForDownloadImage(response)
        }
    }
    
    func setupResultImage(_ jsonDict:Dictionary<String, Any>) {
        guard let dictPagemap = jsonDict["pagemap"] as? Dictionary<String, Any> else { return }
        guard let dictThumbnail = dictPagemap["cse_image"] as? [Dictionary<String, Any>] else { return }
        guard dictThumbnail.count > 0 else { return }
        guard let stringThumbnailURL = dictThumbnail[0]["src"] as? String else { return }
        guard stringThumbnailURL.hasPrefix("https://") else { return }
        let height = dictThumbnail[0]["height"] as? Int
        self.downloadAndSetupImage(stringThumbnailURL, height:height)
    }
    
    func doSetupImage(_ jsonDict: Dictionary<String, String>?) {
        guard let jsonDict = jsonDict, nil != jsonDict["title"] else { return }
        self.setupResultImage(jsonDict)
    }
    
    func showImageSearchResult(_ items:[Dictionary<String, Any>]) {
        _ = items.map{ doSetupImage($0 as? Dictionary<String, String>) }
    }
    
    func getParameterDict(_ word:String) -> Dictionary<String, Any> {
        return [
            "key": googleAPIKeyString,
            "cx": googleAPIEngineIDString,
            "searchtype": "image",
            "fields" : "items",
            "start": "1",
            "q": word
        ]
    }
    
    func handleForResultOfImageSearch(_ response: Alamofire.DataResponse<Any>) {
        guard let json = response.result.value as? Dictionary<String, Any> else { return }
        print("JSON: \(json)")
        guard let items = json["items"] as? [Dictionary<String, Any>] else { return }
        debugPrint(items)
        self.showImageSearchResult(items)
    }
    
    func getImagesFromServer(_ word:String) {
        self.imageIndex = 0
        let parameterDict = getParameterDict(word)
        
        Alamofire.request(stringGoogleApi, method:.get, parameters:parameterDict).responseJSON { [weak self] response in
            self?.handleForResultOfImageSearch(response)
        }
    }

}
