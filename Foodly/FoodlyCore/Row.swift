import UIKit

struct Row {
    let title: String
    let subtitle: String?
    let image: UIImage
    let handler: () -> Void
    
    init(title: String, subtitle: String? = nil, image: UIImage, handler: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.handler = handler
    }
}
