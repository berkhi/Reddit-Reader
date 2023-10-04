//
//  Models.swift
//  Reddit Reader
//
//  Created by BerkH on 4.10.2023.
//

import Foundation

struct RedditPost: Codable {
    struct Data: Codable {
        struct Child: Codable {
            struct PostData: Codable {
                let title: String?
                let selftext: String?
                let thumbnail: String?
            }
            
            let data: PostData
        }
        
        let children: [Child]
    }
    
    let data: Data
}
