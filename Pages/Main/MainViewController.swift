import UIKit

class MainViewController: BaseViewController {
  
  @IBOutlet weak var tableView: RSTableView!
  var tableDataManager: TableDataManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNibCell(ItineraryTableViewCell.self)
    tableDataManager = TableDataManager(tableView: tableView)
    tableDataManager.loadDataAtPage = { [weak self] page in
      self?.loadData(fromCache: false)
    }
    tableDataManager.reload()
  }
  
  func loadData(fromCache: Bool) {
    DataRepository.shared.loadItineraries() { results, error in
      if let error = error {
        self.showAlert(text: error.formattedError)
        self.tableDataManager.finishLoading(isLoadedAll: true)
      } else {
        self.bindData(results: results)
      }
    }
  }
  
  func bindData(results: [ItineraryData]) {
    log("bindData: ItineraryData count -> \(results.count)")
    for data in results {
      tableDataManager.addCell(data, cellClass: ItineraryTableViewCell.self)
    }
    tableDataManager.finishLoading(isLoadedAll: true)
  }
}
