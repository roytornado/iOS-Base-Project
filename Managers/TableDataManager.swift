import UIKit

class TableCellHolder: NSObject {
  var obj: Any?
  var cellClass: AnyClass?
  var cellClassName: String {
    var name: String = "\(cellClass!)"
    if name.contains(".") {
      name = name.components(separatedBy: ".").last!
    }
    return name
  }
  var isCellSelected = false
}

class TableSectionHolder: NSObject {
  var allCells = [TableCellHolder]()
  var sectionHeaderView : UIView?
  var sectionFooterView : UIView?
  var sectionHeaderHeight : CGFloat = 0
  var sectionFooterHeight : CGFloat = 0
  var isCellsHidden = false
}

class RSTableViewCell: UITableViewCell {
  weak var manager: TableDataManager?
  var indexPath: IndexPath!
  var selectable = true
  
  class func height(_ cellHolder: TableCellHolder, width: CGFloat) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .default
    backgroundColor = UIColor.clear
    contentView.backgroundColor = UIColor.clear
    backgroundView = UIView()
    backgroundView?.backgroundColor = UIColor.clear
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor.clear
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    if selectable { contentView.alpha = highlighted ? 0.6 : 1.0 }
  }
  
  func setContent(_ cellHolder: TableCellHolder, width: CGFloat) {
    
  }
}

class TableDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
  
  weak var tableView: RSTableView!
  var logEnabled = false
  // MARK: Data
  var allSections = [TableSectionHolder]()
  // MARK: Network
  var isLoading = false
  var isLoadedAll = false
  var isPaginationSupported = true
  var isPullToRefreshSupported = true {
    didSet {
      tableView.setPullToRefresh(enabled: isPullToRefreshSupported)
    }
  }
  var currentPage = 1
  // MARK: Callbacks
  var loadDataAtPage: ((Int) -> Void)?
  var willReloadTriggedByUser: (() -> Void)?
  var didScrollBlock: ((CGPoint) -> Void)?
  var didSelectBlock: ((TableCellHolder, IndexPath) -> Void)?
  var didCellButtonPressedBlock: ((TableCellHolder, IndexPath, String, [String: Any]) -> Void)?
  
  // MARK: Init
  init(tableView: RSTableView) {
    super.init()
    self.tableView = tableView
    setup()
  }
  
  private func setup() {
    isPullToRefreshSupported = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadingBlock = { [weak self] in
      self?.willReloadTriggedByUser?()
      self?.reload()
    }
  }
  
  private func setupLoadMore() {
    tableView.loadMoreBlock = { [weak self] in
      self?.loadMore()
    }
  }
  
  // MARK: Data Handling
  func removeAll() {
    allSections.removeAll()
  }
  
  @discardableResult func addSection() -> TableSectionHolder{
    let section = TableSectionHolder()
    allSections.append(section)
    return section
  }
  
  @discardableResult func addCell(_ obj: Any, cellClass: AnyClass, section: TableSectionHolder? = nil, atFirst: Bool = false) -> TableCellHolder {
    var targetSection = section
    if (targetSection == nil) {
      targetSection = allSections.last
    }
    if (targetSection == nil) {
      targetSection = addSection()
    }
    let cell = TableCellHolder()
    cell.obj = obj
    cell.cellClass = cellClass
    if atFirst {
      targetSection?.allCells.insert(cell, at: 0)
    } else {
      targetSection?.allCells.append(cell)
    }
    return cell
  }
  
  func getCellHolder(_ index: IndexPath) -> TableCellHolder {
    let section = allSections[(index as NSIndexPath).section]
    let cell = section.allCells[(index as NSIndexPath).row]
    return cell
  }
  
  func getIndexPath(targetCell: TableCellHolder) -> IndexPath? {
    for sectionIndex in 0..<allSections.count {
      let section = allSections[sectionIndex]
      for cellIndex in 0..<section.allCells.count {
        let cell = section.allCells[cellIndex]
        if cell === targetCell {
          return IndexPath(row: cellIndex, section: sectionIndex)
        }
      }
    }
    return nil
  }
  
  func removeCellHolder(target: TableCellHolder) {
    for section in allSections {
      section.allCells = section.allCells.filter({ (cellHolder) -> Bool in
        return cellHolder != target
      })
    }
  }
  
  // MARK: Delegate / Datasources
  func isFirstCell(forIndexPath indexPath: IndexPath) -> Bool {
    if indexPath.section == 0 && indexPath.row == 0{
      return true
    }
    return false
  }
  
  func isLastCell(forIndexPath indexPath: IndexPath) -> Bool {
    if indexPath.section == allSections.count - 1 && indexPath.row == allSections[indexPath.section].allCells.count - 1 {
      return true
    }
    return false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    didScrollBlock?(scrollView.contentOffset)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return allSections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let section = allSections[section]
    return section.isCellsHidden ? 0 : section.allCells.count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let section = allSections[section]
    return section.sectionHeaderView == nil ? CGFloat.leastNormalMagnitude : section.sectionHeaderHeight
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    let section = allSections[section]
    return section.sectionFooterView == nil ? CGFloat.leastNormalMagnitude : section.sectionFooterHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return allSections[section].sectionHeaderView
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return allSections[section].sectionFooterView
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = allSections[(indexPath as NSIndexPath).section]
    let cellHolder = section.allCells[(indexPath as NSIndexPath).row]
    let targetCellClass = cellHolder.cellClass as! RSTableViewCell.Type
    let height = targetCellClass.height(cellHolder, width: tableView.width)
    return height
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = allSections[(indexPath as NSIndexPath).section]
    let cellHolder = section.allCells[(indexPath as NSIndexPath).row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellHolder.cellClassName) as! RSTableViewCell
    cell.setContent(cellHolder, width: tableView.width)
    cell.manager = self
    cell.indexPath = indexPath
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    didSelectBlock?(getCellHolder(indexPath), indexPath)
  }
  
  func actionCalled(cell: RSTableViewCell, tag: String = "", extraInfo: [String: Any] = [String: Any]()) {
    let cellHolder = getCellHolder(cell.indexPath)
    didCellButtonPressedBlock?(cellHolder, cell.indexPath, tag, extraInfo)
  }
  
  // MARK: Data Loading Handling
  func reload() {
    if isLoading { return }
    log(message: "Reload")
    isLoading = true
    removeAll()
    tableView.reloadData()
    tableView.showLoadingForFirstPage()
    isLoadedAll = false
    currentPage = 1
    loadDataAtPage?(currentPage)
  }
  
  func loadMore() {
    if !isPaginationSupported { return }
    if isLoadedAll { return }
    if isLoading { return }
    isLoading = true
    log(message: "Load More")
    currentPage += 1
    tableView.showLoadingForOthersPage()
    loadDataAtPage?(currentPage)
  }
  
  func finishLoading(isLoadedAll: Bool) {
    tableView.hideLoading()
    self.isLoadedAll = isLoadedAll
    tableView.reloadData()
    isLoading = false
    setupLoadMore()
  }
  
  // MARK: Logging
  func log(message: String) {
    if logEnabled { print("[TableDataManager] \(message)") }
  }
  
}

