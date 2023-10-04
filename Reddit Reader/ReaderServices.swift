//
//  ReaderServices.swift
//  Reddit Reader
//
//  Created by BerkH on 4.10.2023.
//

import Foundation
import Alamofire
import Shared

public class ReaderServices {
    static func fetchReader(completion: @escaping (Result<RedditPost, Error>) -> Void) {
        let url = "https://www.reddit.com/r/swift/top.json?count=20"
        
        AF.request(url).responseDecodable(of: RedditPost.self) { response in
            switch response.result {
            case .success(let readerResponse):
                completion(.success(readerResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
