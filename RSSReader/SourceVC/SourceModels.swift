//
//  ResourceModels.swift
//  RSSReader
//
//  Created by Izzat on 11/17/18.
//  Copyright (c) 2018 Izzat. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Source {
    enum RssSource {
        struct Request {
            let urlString: String
            let title: String
            let logoUrlString: String?
        }
        struct Response {
            let url: String
            let title: String
            let logoUrl: String?
        }
        struct ViewModel {
            let title: String
            let logoUrl: String?
            let urlString: String
        }
    }
    
    enum RssSources {
        struct Response {
            let rssChannels: [RSSChannel]
        }
        
        struct ViewModel {
            let rssChannels: [Source.RssSource.ViewModel]
        }
    }
    
    enum Errors {
        struct Response {
            let message: String
        }
        
        struct ViewModel {
            let message: String
        }
    }
}
