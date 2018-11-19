//
//  MainCoreDataWorker.swift
//  RSSReader
//
//  Created by Izzat on 11/18/18.
//  Copyright © 2018 Izzat. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import UIKit

class MainCoreDataWorker {
    func getAllRSSChannels() -> Observable<[RSSChannel]> {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return Observable.create {observer in
            if let delegate = appDelegate {
                let managedContext = delegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RSSChannel")
                do {
                    let result = try managedContext.fetch(fetchRequest)
                    observer.onNext(result as! [RSSChannel])
                    observer.onCompleted()
                } catch let error as NSError {
                    observer.onError(error)
                    observer.onCompleted()
                }
            } else {
                let error = NSError.init(domain: "AppDelegate not found", code: 1, userInfo: nil)
                observer.onError(error)
                observer.onCompleted()
            }
            return Disposables.create()
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
    }
}
