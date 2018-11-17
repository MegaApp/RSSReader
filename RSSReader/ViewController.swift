//
//  ViewController.swift
//  RSSReader
//
//  Created by Izzat on 11/15/18.
//  Copyright © 2018 Izzat. All rights reserved.
//

import UIKit
import FeedKit
import RxSwift

class ViewController: UITableViewController {

    fileprivate var disposeBag = DisposeBag()
    let feedURL = URL(string: "http://khovar.tj/rus/feed/")!
    let feedURL1 = URL(string: "https://www.vb.kg/?rss")!
    let feedURL2 = URL(string: "https://www.ozodi.org/api/zmkove$pit")!
    var feed = [RSSFeed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urls = [feedURL, feedURL1, feedURL2]
        
        let subject = PublishSubject<URL>()
        let mappedObservable = subject.flatMap({self.getRSSFeed(url: $0)})
            
        mappedObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                self.feed.append(result)
                let sec = self.tableView.numberOfSections
                self.tableView.insertSections([sec], with: .bottom)
            }, onError: { error in
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        for u in urls {
            subject.onNext(u)
        }
    }
    
    func getRSSFeed(url: URL) -> Observable<RSSFeed> {
        return Observable.create{ observer in
            let parser = FeedParser(URL: url)
            parser.parseAsync {(result) in
                guard let rssFeed = result.rssFeed else {
                    observer.onError(result.error!)
                    observer.on(.completed)
                    return
                }
                observer.onNext(rssFeed)
                observer.on(.completed)
            }
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return feed.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed[section].items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return feed[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = feed[indexPath.section].items?[indexPath.item].title
        cell.detailTextLabel?.text = feed[indexPath.section].items?[indexPath.item].description
        return cell
    }
}
