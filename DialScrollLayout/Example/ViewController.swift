//
//  ExController.swift
//  DialScrollLayout
//
//  Created by Apple on 20/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let cellHeight: CGFloat = 70
    fileprivate static let dialViewWidth: CGFloat = (UIScreen.main.bounds.width * 0.25)
    fileprivate static let dialViewHeight: CGFloat = (UIScreen.main.bounds.width * 0.25 * 3)

    fileprivate var segmentControl = UISegmentedControl()
    fileprivate var collectionView: UICollectionView!
    fileprivate var layout: DialScrollLayout!

    fileprivate var allImages = ["1", "2", "3", "4", "5", "6", "1", "2", "3", "4", "5", "6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        view.backgroundColor = UIColor.white
        setupSegmentControl()
        setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {

    ///calculating radius according to display
    fileprivate func getRadius() -> CGFloat {
        return (ViewController.dialViewWidth/2) +
            (pow(ViewController.dialViewHeight, 2)/(8*ViewController.dialViewWidth));

    }

    @objc fileprivate func segmentControlChanged() {
        layout.isLayoutRightSide = segmentControl.selectedSegmentIndex == 1
        collectionView.reloadData()
    }
}

///Setup views
extension ViewController {
    ///setup segment control
    fileprivate func setupSegmentControl() {
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.insertSegment(withTitle: "Left", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Right", at: 1, animated: true)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(
            self,
            action: #selector(segmentControlChanged),
            for: .valueChanged
        )
        NSLayoutConstraint.activate([
            segmentControl.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            segmentControl.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 40
            )
            ])
    }

    ///setup for collection view
    fileprivate func setupCollectionView() {
        layout = DialScrollLayout.init(
            radius: getRadius() - (cellHeight/2),
            angularSpacing: 30,
            cellSize: CGSize.init(
                width: cellHeight,
                height: cellHeight
            ),
            alignment: .Left,
            itemHeight: cellHeight,
            xOffset: ViewController.dialViewWidth - cellHeight/2
        )
        collectionView = UICollectionView.init(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.topAnchor.constraint(
                equalTo: segmentControl.bottomAnchor,
                constant: 24
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
            ])
        collectionView.register(
            ImageCollectionCell.self,
            forCellWithReuseIdentifier: ImageCollectionCell.identifier
        )
        collectionView.clipsToBounds = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionCell.identifier,
            for: indexPath
            ) as! ImageCollectionCell
        cell.imgView.contentMode = .scaleToFill
        cell.imgView.image = UIImage.init(named: allImages[indexPath.row])

        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
