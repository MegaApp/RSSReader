//
//  MainModels.swift
//  RSSReader
//
//  Created by Izzat on 11/16/18.
//  Copyright (c) 2018 Izzat. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift
import FeedKit

enum Main {
    // MARK: Use cases
    
    enum Feed {
        struct Request {
            let url: URL
        }
        struct Response {
            let event: Event<RSSFeed>?
            let url: String?
        }
        struct ViewModel {
            let rssFeed: RSSFeed?
            let error: String?
            let url: String?
        }
    }
}
