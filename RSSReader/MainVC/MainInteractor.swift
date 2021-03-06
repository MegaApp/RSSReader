//
//  MainInteractor.swift
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

protocol MainBusinessLogic {
    func getFeeds(request: Main.Feed.Request)
    func getFeeds()
    func deleteFeeds(request: Main.Feed.Request)
    func setItemToPass(item: RSSFeedItem)
}

protocol MainDataStore {
    var mainDelegate: MainBusinessLogic? { get set }
    var item: RSSFeedItem? { get set }
}

class MainInteractor: MainBusinessLogic, MainDataStore {
    var item: RSSFeedItem?
    var mainDelegate: MainBusinessLogic?

    private let disposeBag = DisposeBag()
    var presenter: MainPresentationLogic?
    var worker: MainWorker?
    var coreDataWorker: MainCoreDataWorker?
    let subject: PublishSubject<URL>?
    
    init() {
        worker = MainWorker()
        subject = PublishSubject<URL>()
        subject?.flatMap({self.worker!.getFeeds(url: $0)})
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] rssFeed in
                let response = Main.Feed.Response(feed: rssFeed)
                self?.presenter?.presentFeed(response: response)
            }, onError: {[weak self] error in
                let response = Main.Errors.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            })
            .disposed(by: disposeBag)
        setMainData()
    }
    
    func getFeeds(request: Main.Feed.Request) {
        subject?.onNext(request.url)
    }
    
    func getFeeds() {
        coreDataWorker = MainCoreDataWorker()
        coreDataWorker?.getAllRSSChannels()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] channels in
                if channels.count == 0 {
                    self?.presenter?.routeToSourceVC()
                    return
                }
                self?.getFeeds(channels: channels)
            }, onError: { error in
                let response = Main.Errors.Response(message: error.localizedDescription)
                self.presenter?.presentError(response: response)
            })
            .disposed(by: disposeBag)
    }
    
    func getFeeds(channels :[RSSChannel]) {
        Observable.from(channels)
            .filter({$0.url != nil})
            .map({URL(string: $0.url!)!})
            .flatMap({self.worker!.getFeeds(url: $0)})
            .toArray()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self]  feeds in
                let response = Main.Feeds.Response(feeds: feeds)
                self?.presenter?.presentFeeds(response: response)
            }, onError: {[weak self] error in
                let response = Main.Errors.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteFeeds(request: Main.Feed.Request) {
        let response = Main.Feed.Delete(url: request.url.absoluteString)
        presenter?.deleteFeed(response: response)
    }
    
    func setMainData() {
        mainDelegate = self
    }
    
    func setItemToPass(item: RSSFeedItem) {
        self.item = item
    }
}
