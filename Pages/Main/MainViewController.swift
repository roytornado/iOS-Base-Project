import UIKit

class MainViewController: BaseViewController {
  
  @IBOutlet weak var tableView: RSTableView!
  var tableDataManager: TableDataManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNibCell(PhotoTableViewCell.self)
    tableDataManager = TableDataManager(tableView: tableView)
    tableDataManager.willReloadTriggedByUser = { [weak self] in
      DataRepository.shared.clearPhotoCaches()
    }
    tableDataManager.loadDataAtPage = { [weak self] page in
      self?.loadData(fromCache: false)
    }
    tableDataManager.reload()
  }
  
  func loadData(fromCache: Bool) {
    DataRepository.shared.loadPhotos() { results, error in
      if let error = error {
        self.showAlert(text: error.formattedError)
        self.tableDataManager.finishLoading(isLoadedAll: true)
      } else {
        self.bindData(results: results)
      }
    }
  }
  
  func bindData(results: [PhotoData]) {
    log("bindData: Photo count -> \(results.count)")
    for data in results {
      tableDataManager.addCell(data, cellClass: PhotoTableViewCell.self)
    }
    tableDataManager.finishLoading(isLoadedAll: true)
  }

}
