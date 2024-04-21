//
//  CrewContentCompositional.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit

enum CrewContentCompositional {
    
    static func create() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            return createContent()
        }
        
        layout.configuration.scrollDirection = .horizontal
        
        return layout
    }
    
    private static func createContent() -> NSCollectionLayoutSection {
        
        let groupInterSpacing: CGFloat = 30
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .absolute(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                               heightDimension: .absolute(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = groupInterSpacing
        section.orthogonalScrollingBehavior = .continuous
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
}
