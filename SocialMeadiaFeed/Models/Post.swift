//
//  Post.swift
//  SocialMeadiaFeed
//
//  Created by Igor Solodyankin on 06.08.2025.
//

import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
