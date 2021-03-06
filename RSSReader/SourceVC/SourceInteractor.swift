//
//  ResourceInteractor.swift
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
import RxSwift

protocol SourceBusinessLogic {
    func addRssResource(request: Source.RssSource.Request)
    func deleteRssResource(request: Source.RssSource.Request)
    func getAllResources()
}

protocol SourceDataStore {
    var mainDelegate: MainBusinessLogic? { get set }
}

class SourceInteractor: SourceBusinessLogic, SourceDataStore {
    
    private let disposeBag = DisposeBag()
    var mainDelegate: MainBusinessLogic?
    var presenter: SourcePresentationLogic?
    var apiWorker: SourceAPIWorker?
    var coreDataWorker: SourceCoreDataWorker?
    
    func getAllResources() {
        coreDataWorker = SourceCoreDataWorker()
        coreDataWorker?.getAllRSSChannels()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] channels in
                let response = Source.RssSources.Response(rssChannels: channels)
                self?.presenter?.presentRssResources(response: response)
            }, onError: {[weak self] error in
                let response = Source.Errors.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteRssResource(request: Source.RssSource.Request) {
        coreDataWorker = SourceCoreDataWorker()
        coreDataWorker?.deleteData(url: request.urlString)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] url in
                let mainRequest = Main.Feed.Request(url: URL(string: url)!)
                self?.mainDelegate?.deleteFeeds(request: mainRequest)
            }, onError: {[weak self] error in
                let response = Source.Errors.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            })
            .disposed(by: disposeBag)
    }
    
    func addRssResource(request: Source.RssSource.Request) {
        apiWorker = SourceAPIWorker()
        coreDataWorker = SourceCoreDataWorker()
        guard let url = URL(string: request.urlString) else {
            let response = Source.Errors.Response(message: "Не правельный адрес")
            presenter?.presentError(response: response)
            return
        }
        apiWorker?.chackRssResource(url: url)
            .observeOn(MainScheduler.instance)
            .flatMap({response  -> Observable<Source.RssSource.Response> in
                let request = Source.RssSource.Request(urlString: response.url, title: response.title, logoUrlString: response.logoUrl)
                return self.coreDataWorker!.addChannel(channel: request)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] response in
                self?.presenter?.presentRssResource(response: response)
                let mainRequest = Main.Feed.Request(url: URL(string: response.url)!)
                self?.mainDelegate?.getFeeds(request: mainRequest)
            }, onError: {[weak self] error in
                let response = Source.Errors.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            })
            .disposed(by: disposeBag)
    }
}
