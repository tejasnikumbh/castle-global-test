//
//  CGNetworkingManager.swift
//  iOS Test
//
//  Created by Tejas  Nikumbh on 25/11/16.
//  Copyright © 2016 Castle. All rights reserved.
//

import Foundation
import Alamofire

typealias CGWikiEntryFetchCall = ([CGWikiEntry]) -> ()

final class CGNetworkingManager: Singleton {
    
    static let sharedInstance = CGNetworkingManager()
    // Ensures that instances of this aren't created
    fileprivate init() {}
    
    func loadResults(queryString: String, completion: CGWikiEntryFetchCall? = nil) {
        let requestURL =
            "\(CGConstants.URL.wikiResultsAPIBase)"
        let params = ["format": "json", "action":"query", "generator":"search","gsrnamespace":"0","gsrsearch":queryString,"gsrlimit":"10","prop":"pageimages|extracts","pilimit":"max","exintro":"1","explaintext":"1","exsentences":"1","exlimit":"max"]
        
        Alamofire.request(requestURL, parameters: params).responseJSON{ response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            guard let JSON = response.result.value else {
                guard let completion = completion else { return }
                completion([])
                return
            }
            guard let result = (JSON as! [String: AnyObject])["query"]?["pages"] else {
                guard let completion = completion else { return }
                completion([])
                return
            }
            guard let pages = result as? [String: AnyObject] else {
                guard let completion = completion else { return }
                completion([])
                return
            }
            
            var entries: [CGWikiEntry] = []
            for (_, value) in pages {
                let page = value as! [String: AnyObject]
                guard let title = page["title"] as? String ,
                    let subTitle = page["extract"] as? String else {
                    guard let completion = completion else { return }
                    completion([])
                    return
                }
                
                if let url = page["thumbnail"] as? [String: AnyObject] {
                    if let urlString = url["source"] as? String {
                        let entry = CGWikiEntry(title: title, summary: subTitle, thumbnailImageURL: urlString)
                        entries.append(entry)
                        continue
                    }
                }
                
                let entry = CGWikiEntry(title: title, summary: subTitle)
                entries.append(entry)
            }
            guard let completion = completion else { return }
            completion(entries)
        }
    }
}
