import UIKit

class SectionLayoutCreator {
    func createNewsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)),
            subitems: [item]
        )
        
        return createLayoutSection(group: group, scrollBehavior: .none)
    }
    
    func createFoodCategoriesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.15)),
            subitems: [item]
        )
        
        return createLayoutSection(group: group, scrollBehavior: .continuous)
    }
    
    func createTrendingFoodSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.3)),
            subitems: [item]
        )
        
        return createLayoutSection(
            group: group,
            scrollBehavior: .continuous,
            contentInsets: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
            boundarySupplementaryItems: [createHeader()]
        )
    }
    
    func createRestaurantsSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.2)),
            subitems: [item]
        )
        
        return createLayoutSection(
            group: group,
            scrollBehavior: .continuous,
            contentInsets: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
            boundarySupplementaryItems: [createHeader()]
        )
    }
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
        contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20),
        boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollBehavior
        section.contentInsets = contentInsets
        section.interGroupSpacing = 20
        section.boundarySupplementaryItems = boundarySupplementaryItems
        
        return section
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
