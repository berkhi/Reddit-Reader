//
//  Reader.swift
//  Reddit Reader
//
//  Created by BerkH on 4.10.2023.
//

import Foundation

class Reader {
    
    static let shared = Reader()
    var readers: [RedditPost.Data.Child.PostData]?
    
    public init(readers: [RedditPost.Data.Child.PostData]? = nil) {
        fetchData { [weak self] data in
            self?.readers = data
        }
    }
    
    func fetchData(completion: @escaping ([RedditPost.Data.Child.PostData]?) -> Void) {
        var fetchedData: [RedditPost.Data.Child.PostData]?
        
        if let url = URL(string: "https://www.reddit.com/r/swift/top.json?count=20") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Veri alınamadı. Hata: \(error)")
                    completion(nil)
                    return
                }
                
                if let data = data {
                    do {
                        let redditPost = try JSONDecoder().decode(RedditPost.self, from: data)
                        fetchedData = redditPost.data.children.map { $0.data }
                        print("Veri başarıyla alındı.")
                        completion(fetchedData)
                    } catch {
                        print("Veri işleme hatası: \(error)")
                        completion(nil)
                    }
                }
            }
            
            task.resume()
        } else {
            completion(nil)
        }
    }
    
}

