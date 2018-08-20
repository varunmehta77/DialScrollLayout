//
//  ImageCollectionCell.swift
//  DialScrollLayout
//
//  Created by Apple on 20/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {

    static let identifier = "cell"

    let imgView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
    }
}

extension ImageCollectionCell {

    ///setup image view
    fileprivate func setupImageView() {
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.lightGray
        imgView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            imgView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            imgView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            imgView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
            ])
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.bounds.height/2
    }
}
