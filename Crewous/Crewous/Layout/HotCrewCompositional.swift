//
//  HotCrewCompositional.swift
//  Crewous
//
//  Created by 이중엽 on 4/29/24.
//

import Foundation
import UIKit

enum HotCrewCompositional {
    
    case hotCrew
    
    static func create() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { section, environment in
            
            return createHotCrew()
        }
    }
    
    private static func createHotCrew() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [createHeaderView()]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
    
    private static func createHeaderView() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: itemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return header
    }
}
