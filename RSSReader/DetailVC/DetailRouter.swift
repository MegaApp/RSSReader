//
//  DetailRouter.swift
//  RSSReader
//
//  Created by Izzat on 11/19/18.
//  Copyright (c) 2018 Izzat. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get }
}

class DetailRouter: NSObject, DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?
}