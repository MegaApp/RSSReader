//
//  MainRouter.swift
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

@objc protocol MainRoutingLogic {
    func routeToSourceVC(segue: UIStoryboardSegue?)
    func routeToDetailVC(segue: UIStoryboardSegue?)
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    
    // MARK: Routing
    
    func routeToSourceVC(segue: UIStoryboardSegue?) {
      if let segue = segue {
        let destinationVC = segue.destination as! SourceViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataSourceVC(source: dataStore!, destination: &destinationDS)
      } else {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SourceViewController") as! SourceViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataSourceVC(source: dataStore!, destination: &destinationDS)
        navigateToSourceVC(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToDetailVC(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! DetailViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataDetailVC(source: dataStore!, destination: &destinationDS)
        }
    }
    
    // MARK: Navigation
    
    func navigateToSourceVC(source: MainViewController, destination: SourceViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataSourceVC(source: MainDataStore, destination: inout SourceDataStore) {
      destination.mainDelegate = source.mainDelegate
    }
    
    func passDataDetailVC(source: MainDataStore, destination: inout DetailDataStore) {
        destination.item = source.item
    }
}
