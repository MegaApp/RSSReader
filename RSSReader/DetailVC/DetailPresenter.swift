//
//  DetailPresenter.swift
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

protocol DetailPresentationLogic {
    func presentItem(response: Detail.Item.Response)
}

class DetailPresenter: DetailPresentationLogic {
    weak var viewController: DetailDisplayLogic?
    
    func presentItem(response: Detail.Item.Response) {
        guard let item = response.item else {
            let viewModel = Detail.Item.ViewModel(item: nil, error: "Ой! Что то пошло не так")
            viewController?.displayError(viewModel: viewModel)
            return
        }
        let viewModel = Detail.Item.ViewModel(item: item, error: nil)
        viewController?.displayItem(viewModel: viewModel)
    }
}