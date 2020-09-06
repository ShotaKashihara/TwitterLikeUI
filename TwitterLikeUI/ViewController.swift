import UIKit

class ViewController: UIViewController {
    struct Parameter {
        let defaultHeaderHeight: CGFloat
        let minimumHeaderHeight: CGFloat
        var shrinkOffset: CGFloat { defaultHeaderHeight - minimumHeaderHeight }
    }
    private let parameter: Parameter
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    private var pageViewController: PageViewController!

    init(_ parameter: Parameter = .init(defaultHeaderHeight: 200, minimumHeaderHeight: 44)) {
        self.parameter = parameter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        let pages: [PageChildViewController] = [
            TableViewController(index: 0),
            TableViewController(index: 1),
            TableViewController(index: 2),
        ]
        pageViewController = .init(
            pages: pages,
            parameter: parameter,
            didScrollHandler: { [weak self] offset in
                guard let self = self else { return }
                let diff = offset.clamp(to: 0...self.parameter.shrinkOffset)
                self.headerTopConstraint.constant = -diff
            }
        )
        addChild(pageViewController)
        contentView.ale.addFilledSubview(pageViewController.view)
        /// ヘッダの高さを変更
        headerHeightConstraint.constant = parameter.defaultHeaderHeight
        /// 各ページの `contentInset` をヘッダにあわせる
        pageViewController.contentInsetをヘッダの高さに合わせる(parameter.defaultHeaderHeight)
    }
}
