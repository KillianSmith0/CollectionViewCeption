//
//  ConferenceCollectionViewCell.swift
//  Modern Collection Views
//
//  Created by Killian Smith  on 11/01/2022.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

final class ConferenceCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ConferenceCollectionViewCell"

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, ConferenceNewsController.NewsFeedItem>!
    var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConferenceCollectionViewCell {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    func configureDataSource() {
        let newsController = ConferenceNewsController()
        let cellRegistration = UICollectionView.CellRegistration
        <ConferenceNewsFeedCell, ConferenceNewsController.NewsFeedItem> { (cell, indexPath, newsItem) in
            // Populate the cell with our item description.
            cell.titleLabel.text = newsItem.title
            cell.bodyLabel.text = newsItem.body

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            cell.dateLabel.text = dateFormatter.string(from: newsItem.date)
            cell.showsSeparator = indexPath.item != newsController.items.count - 1
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, item) in
            // Return the cell.
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        // load our data
        let newsItems = newsController.items
        var snapshot = NSDiffableDataSourceSnapshot<Section, ConferenceNewsController.NewsFeedItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newsItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func createLayout() -> UICollectionViewLayout {
        let estimatedHeight = CGFloat(100)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .horizontal
        return layout
    }
}

