//
//  PosetFeedViewModel.swift
//  SocialMeadiaFeed
//
//  Created by Igor Solodyankin on 06.08.2025.
//

import Foundation

final class PostFeedViewModel {
    
    private let postService = PostService()
    
    private var posts: [Post] = [] {
        didSet { onPostsUpdated?() }
    }
    
    var onPostsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
        
    func fetchPosts() {
        postService.fetchPost { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    func numberOfPosts() -> Int {
        posts.count
    }
    
    func post(at index: Int) -> Post {
        posts[index]
    }
}
