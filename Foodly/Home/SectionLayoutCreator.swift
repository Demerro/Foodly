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
        
        return createLayoutSection(group: group, scrollBehavior: .continuous)
    }
    
    func createRestaurantsSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.2)),
            subitems: [item]
        )
        
        return createLayoutSection(group: group, scrollBehavior: .continuous)
    }
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollBehavior
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 20
        
        return section
    }
}
