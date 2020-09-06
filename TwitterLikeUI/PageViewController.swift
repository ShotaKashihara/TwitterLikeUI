import Foundation
import UIKit

protocol PageChildViewController: UIViewController {
    var scrollView: UIScrollView { get }
}

extension PageChildViewController {
    var parentPageViewController: PageViewController? {
        guard isViewLoaded else { return nil }
        if let parent = parent as? PageViewController {
            return parent
        }
        // viewの構成に依存している
        return view.superview?.viewController as? PageViewController
    }
}

class PageViewController: UIPageViewController {
    private let parameter: ViewController.Parameter
    private let pages: [PageChildViewController]
    private let didScrollHandler: (CGFloat) -> Void
    private var isViewDidAppear: Bool = false
    var scrollY: CGFloat

    init(pages: [PageChildViewController], parameter: ViewController.Parameter, didScrollHandler: @escaping ((CGFloat) -> Void)) {
        self.pages = pages
        self.parameter = parameter
        self.didScrollHandler = didScrollHandler
        self.scrollY = -parameter.defaultHeaderHeight
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewDidAppear = true
    }

    func contentInsetをヘッダの高さに合わせる(_ headerHeight: CGFloat) {
        pages.forEach { p in
            p.scrollView.contentInset = .init(top: headerHeight, left: 0, bottom: 0, right: 0)
            p.scrollView.scrollIndicatorInsets = .init(top: headerHeight, left: 0, bottom: 0, right: 0)
        }
    }
    /// これは各画面から呼ばれる
    func scrollViewDidScroll(viewController: UIViewController, scrollView: UIScrollView) {
        guard isViewDidAppear else {
            return
        }

        /// 各画面でスクロールした量
        let scrollWithContentInset = scrollView.contentOffset.y + scrollView.contentInset.top
        /// 親のヘッダーを上にズラす
        didScrollHandler(scrollWithContentInset)

        /// 他の画面のscrollViewの contentOffset をリセット
        /// UIPageViewController の場合、まだ描画されていない画面は scrollView を初期化してから
        /// でないと contentOffset を設定できない
        scrollY = min(scrollView.contentOffset.y, -parameter.minimumHeaderHeight)
        for page in pages where page != viewController {
            page.scrollView.contentOffset = CGPoint(x: 0, y: scrollY)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(where: { $0 === viewController }) else { return nil }
        let page = pages[safe: index - 1]
        return page
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(where: { $0 === viewController }) else { return nil }
        return pages[safe: index + 1]
    }
}
