import Foundation
import UIKit

class HScrollViewController: UIViewController {

    struct Parameter {
        let pages: [UIViewController]
    }

    private let parameter: Parameter

    private var horizonScrollView: UIScrollView!
    private var horizonStackView: UIStackView!

    init(parameter: Parameter) {
        self.parameter = parameter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        horizonScrollView = .init(frame: .zero)
        horizonScrollView.isPagingEnabled = true
        parameter.pages.forEach(addChild(_:))
        horizonStackView = .init(arrangedSubviews: parameter.pages.compactMap(\.view))
        horizonStackView.axis = .horizontal
        horizonStackView.alignment = .fill
        horizonStackView.distribution = .fillEqually
        view.ale.addFilledSubview(horizonScrollView)
        horizonScrollView.ale.addFilledSubview(horizonStackView)
    }
}
