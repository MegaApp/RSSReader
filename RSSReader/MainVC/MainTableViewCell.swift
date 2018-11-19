//
//  MainTableViewCell.swift
//  RSSReader
//
//  Created by Izzat on 11/19/18.
//  Copyright © 2018 Izzat. All rights reserved.
//

import UIKit
import FeedKit
import Kingfisher

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func update(item: RSSFeedItem?) {
        titleLabel.text = item?.title
        descriptionLabel.text = item?.description
        if let urlString = item?.enclosure?.attributes?.url,
            let url = URL(string: urlString) {
            let imageResource = ImageResource(downloadURL: url)
            let processor = ResizingImageProcessor(referenceSize: photo.frame.size, mode: .aspectFill)
            photo.kf.setImage(with: imageResource, placeholder: Image(named: "picture"), options: [.processor(processor)])
        } else {
            photo.image = Image(named: "picture")
        }
    }
}
