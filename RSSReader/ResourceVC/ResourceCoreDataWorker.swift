//
//  ResourceCoreDataWorker.swift
//  RSSReader
//
//  Created by Izzat on 11/17/18.
//  Copyright © 2018 Izzat. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import UIKit

class ResourceCoreDataWorker {
    func addChannel(channel: Resource.RssResource.Request) -> Observable<Resource.RssResource.Response> {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return Observable.create {observer in
            if let delegate = appDelegate {
                let managedContext = delegate.persistentContainer.viewContext
                let userEntity = NSEntityDescription.entity(forEntityName: "RSSChannel", in: managedContext)!
                
                let rssChannel = NSManagedObject(entity: userEntity, insertInto: managedContext)
                rssChannel.setValue(channel.urlString, forKeyPath: "url")
                rssChannel.setValue(channel.title, forKey: "name")
                rssChannel.setValue(channel.logoUrlString, forKey: "logo_url")
                do {
                    try managedContext.save()
                    let response = Resource.RssResource.Response(url: channel.urlString, title: channel.title, logoUrl: channel.logoUrlString)
                    observer.onNext(response)
                    observer.onCompleted()
                } catch let error as NSError {
                    managedContext.reset()
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
    
    func deleteData(url: String) -> Observable<String> {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return Observable.create {observer in
            if let delegate = appDelegate {
                let managedContext = delegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RSSChannel")
                fetchRequest.predicate = NSPredicate(format: "url = %@", url)
                do {
                    let result = try managedContext.fetch(fetchRequest)
                    let objectToDelete = result[0] as! NSManagedObject
                    managedContext.delete(objectToDelete)
                    do{
                        try managedContext.save()
                        observer.onNext(url)
                        observer.onCompleted()
                    } catch let error as NSError {
                        managedContext.reset()
                        observer.onError(error)
                        observer.onCompleted()
                    }
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
