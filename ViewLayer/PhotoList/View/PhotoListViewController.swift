import UIKit
import Cleanse
import RxCocoa
import RxSwift

class PhotoListViewController: BaseViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var tableView: RSTableView!
  var tableDataManager: TableDataManager!
  var viewModel: PhotoListViewModelInterface!
  
  func injectProperties(injectedViewModel: Provider<PhotoListViewModelInterface>) {
    viewModel = injectedViewModel.get()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNibCell(PhotoTableViewCell.self)
    tableDataManager = TableDataManager(tableView: tableView)
    tableDataManager.willReloadTriggedByUser = {
      DataRepository.shared.clearPhotoCaches()
    }
    searchTextField.rx.text.orEmpty.debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        self.tableDataManager.finishLoading(isLoadedAll: true)
        self.tableDataManager.reload()
        self.viewModel.search(keyword: text)
      }).disposed(by: disposeBag)
    
    viewModel.photoPages
      .asDriver(onErrorJustReturn: PaginatedViewData<PhotoData>.nothing())
      .drive(onNext: { [weak self] page in
        guard let self = self else { return }
        self.bindData(page: page)
      }).disposed(by: disposeBag)
  }
  
  func loadData(fromCache: Bool) {
    guard let keyword = searchTextField.text else { return }
    viewModel.search(keyword: keyword)
  }
  
  func bindData(page: PaginatedViewData<PhotoData>) {
    log("bindData: Photo count -> \(page.list.count)")
    for data in page.list {
      tableDataManager.addCell(data, cellClass: PhotoTableViewCell.self)
    }
    tableDataManager.finishLoading(isLoadedAll: !page.hasMore)
  }
  
  @IBAction func add() {
    showBlockLoading()
    DataRepository.shared.addPhoto(title: "test", body: "body", userId: 12) { [weak self] _ in
      self?.hideBlockLoading()
    }
  }

}
