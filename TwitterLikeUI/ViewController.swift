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
    @IBOutlet weak var minimumHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabStackView: UIStackView!
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
                if offset < 0 {
                    self.headerHeightConstraint.constant = self.parameter.defaultHeaderHeight - offset
                    let indicatorInsets = self.parameter.defaultHeaderHeight - offset
                    self.pageViewController.childScrollViews.forEach { s in
                        s.scrollIndicatorInsets = .init(top: indicatorInsets, left: 0, bottom: 0, right: 0)
                    }
                }
            }
        )
        addChild(pageViewController)
        contentView.ale.addFilledSubview(pageViewController.view)
        /// ヘッダの高さを変更
        headerHeightConstraint.constant = parameter.defaultHeaderHeight
        /// タブ部分の高さを変更
        minimumHeaderHeightConstraint.constant = parameter.minimumHeaderHeight
        /// 各ページの `contentInset` をヘッダにあわせる
        let headerHeight = parameter.defaultHeaderHeight
        pageViewController.childScrollViews.forEach { s in
            s.contentInset = .init(top: headerHeight, left: 0, bottom: 0, right: 0)
            s.scrollIndicatorInsets = .init(top: headerHeight, left: 0, bottom: 0, right: 0)
        }
        /// タブを `pages` の数だけ作る
        pages.forEach { [weak self] page in
            let button = UIButton(type: .custom)
            button.setTitle("Table \(page.index)", for: .normal)
            button.accessibilityIdentifier = String(page.index)
            button.addTarget(self, action: #selector(tapTab(event:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 100).ale.activate()
            self?.tabStackView.addArrangedSubview(button)
        }
        tabStackView.addArrangedSubview(UIView())
    }

    @objc func tapTab(event: UIButton) {
        guard let index = Int(event.accessibilityIdentifier ?? "") else { return }
        pageViewController.scrollPageTo(index: index)
    }
}
