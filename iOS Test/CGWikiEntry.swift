//
//  WikiEntry.swift
//  iOS Test
//
//  Created by Tejas  Nikumbh on 25/11/16.
//  Copyright © 2016 Castle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

typealias CGImageFetchCallCompletion = (_ image: UIImage?) -> ()

class CGWikiEntry {
    
    var title: String? = nil
    var summary: String? = nil
    var thumbnailImageURL: String? = nil
    var thumbnailImage: UIImage? = nil
    
    init(title: String, summary: String, thumbnailImageURL: String? = nil) {
        self.title = title
        self.summary = summary
        self.thumbnailImageURL = thumbnailImageURL
    }
    
    /*
     * Method: convienience init
     *
     * Discussion: Convienience initializer that initializes a JSON Object from response returned
     */
    convenience init?(wikiEntry: [String: AnyObject]) {
        guard let title = wikiEntry["title"] as? String,
            let extract = wikiEntry["extract"] as? String else { return nil }
            let thumbnailImageURL = wikiEntry["thumbnail"]?["source"] as? String
        self.init(title: title, summary: extract, thumbnailImageURL: thumbnailImageURL)
    }
    
    
    /*
     * Method: fetchImage
     *
     * Discussion: Method that fetches an image given a particular URL
     */
    func fetchThumbnailImage(completion: CGImageFetchCallCompletion? = nil) {
        guard let profilePictureURL = self.thumbnailImageURL else { return }
        Alamofire.request(profilePictureURL).responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.thumbnailImage = image
                guard let completion = completion else { return }
                completion(image)
            } else {
                guard let completion = completion else { return }
                completion(nil)
            }
        }
    }
}
