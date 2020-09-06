import Foundation
import UIKit

class TableViewController: UITableViewController, PageChildViewController {
    var scrollView: UIScrollView {
        return tableView
    }

//    let items: [[Int]] = Array(0...9).map { i in Array(0...9).map { i*10+$0 } }
    let items: [[Int]] = [
        [1],
        [2,3,4,5,6],
        [7,8,9],
        [1],
        [2,3,4,5,6],
        [2,3,4,5,6],
    ]
    private var isViewDidAppear: Bool = false

    let index: Int
    override var description: String {
        return "\(index)"
    }

    var ob: NSKeyValueObservation?

    init(index: Int) {
        self.index = index
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 128
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /// 初回の描画時のみ、`contentOffset` を親PageViewController のスクロール位置に合わせてセットする
        /// ※注: `viewWillAppear` で `contentOffset` をセットしても、_QueuingScrollView が初期値にリセットしてしまうので、`viewDidLayoutSubviews` で行うこと
        /// 次回以降は `PageViewController.scrollViewDidScroll(viewController:scrollView:)` でセットしている
        if !isViewDidAppear {
            scrollView.contentOffset = .init(x: 0, y: parentPageViewController?.scrollY ?? 0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewDidAppear = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.configure(items: self.items[indexPath.row])
        return cell
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isViewDidAppear else { return }
        /// 親に伝える
        parentPageViewController?.scrollViewDidScroll(viewController: self, scrollView: scrollView)
    }
}

class TableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var items: [Int] = []
    let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: createLayout())

    static func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ale.addFilledSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(items: [Int]) {
        self.items = items
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.configure(item: items[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 248, height: 128)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

class CollectionViewCell: UICollectionViewCell {
    let title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        ale.addCenteredSubview(title)
        backgroundColor = .systemGray2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: Int) {
        title.text = String(item)
    }
}
