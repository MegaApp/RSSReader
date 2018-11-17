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
        return Observable.create {observer in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let managedContext = appDelegate.persistentContainer.viewContext
                let userEntity = NSEntityDescription.entity(forEntityName: "RSSChannel", in: managedContext)!
                
                let rssChannel = NSManagedObject(entity: userEntity, insertInto: managedContext)
                rssChannel.setValue(channel.urlString, forKeyPath: "url")
                rssChannel.setValue(channel.name, forKey: "name")
                rssChannel.setValue(channel.logoUrlString, forKey: "logo_url")
                do {
                    try managedContext.save()
                    let response = Resource.RssResource.Response(url: channel.urlString, title: channel.name, logoUrl: URL(string: channel.logoUrlString ?? ""), error: nil)
                    observer.onNext(response)
                    observer.onCompleted()
                } catch let error as NSError {
                    observer.onError(error)
                    observer.onCompleted()
                }
            } else {
                
            }
            return Disposables.create()
        }
    }
    
    func getAllRSSChannels() -> Observable<[RSSChannel]> {
        return Observable.create {observer in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let managedContext = appDelegate.persistentContainer.viewContext
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
                
            }
            return Disposables.create()
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func deleteData(url: String) -> Observable<String> {
        return Observable.create {observer in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let managedContext = appDelegate.persistentContainer.viewContext
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
                        observer.onError(error)
                        observer.onCompleted()
                    }
                } catch let error as NSError {
                    observer.onError(error)
                    observer.onCompleted()
                }
            } else {
                
            }
            return Disposables.create()
        }
    }
    
}
