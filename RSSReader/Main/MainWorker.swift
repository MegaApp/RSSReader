//
//  MainWorker.swift
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

class MainWorker {
    func getFeeds(url: URL) -> Observable<RSSFeed> {
        return Observable.create{ observer in
            let parser = FeedParser(URL: url)
            parser.parseAsync {(result) in
                guard let rssFeed = result.rssFeed else {
                    observer.onError(result.error!)
                    observer.on(.completed)
                    return
                }
                rssFeed.link = url.absoluteString
                observer.onNext(rssFeed)
                observer.on(.completed)
            }
            return Disposables.create()
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
