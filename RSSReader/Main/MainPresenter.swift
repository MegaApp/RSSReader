//
//  MainPresenter.swift
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

protocol MainPresentationLogic {
    func presentFeeds(response: Main.Feed.Response)
    func presentError(response: Main.Error.Response)
    func deleteFeeds(response: Main.Feed.Delete)
}

class MainPresenter: MainPresentationLogic {
    
    weak var viewController: MainDisplayLogic?
    
    func presentFeeds(response: Main.Feed.Response) {
        let viewModel = Main.Feed.ViewModel(rssFeed: response.feed)
        viewController?.displayFeeds(viewModel: viewModel)
    }
    
    func presentError(response: Main.Error.Response) {
        let viewModel = Main.Error.ViewModel(message: response.message)
        viewController?.displayError(viewModel: viewModel)
    }
    
    func deleteFeeds(response: Main.Feed.Delete) {
        let viewModel = Main.Feed.Delete(url: response.url)
        viewController?.deleteFeeds(viewModel: viewModel)
    }
}
