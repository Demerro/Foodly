import UIKit

struct Restaurant: Hashable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let location: String
    let type: String
    let color: UIColor
}
