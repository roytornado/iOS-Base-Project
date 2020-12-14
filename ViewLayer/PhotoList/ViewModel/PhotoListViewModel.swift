import Foundation
import RxSwift
import Cleanse

protocol PhotoListViewModelInterface {
  // MARK: Data
  var photoPages: PublishSubject<PaginatedViewData<PhotoData>> { get }
  var isLoading: PublishSubject<Bool> { get }
  // MARK: Events
  func search(keyword: String)
  func clearPhotoCaches()
}

final class PhotoListViewModel: PhotoListViewModelInterface {
  var photoPages: PublishSubject<PaginatedViewData<PhotoData>> = PublishSubject<PaginatedViewData<PhotoData>>()
  var isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
  var query: PublishSubject<String> = PublishSubject<String>()
  private let disposeBag = DisposeBag()
  let dataRepository: DataRepository
  
  init(injectedDataRepository: Cleanse.Provider<DataRepository>) {
    dataRepository = injectedDataRepository.get()
    query.flatMapLatest { text -> Single<[PhotoData]> in
      self.isLoading.onNext(true)
      return self.executeQuery(keyword: text)
    }
    .subscribe(onNext: { [weak self] results in
      guard let self = self else { return }
      self.isLoading.onNext(false)
      self.photoPages.onNext(PaginatedViewData<PhotoData>(results, pageNum: 0, hasMore: false))
    }, onError: { [weak self] error in
      guard let self = self else { return }
      self.isLoading.onNext(false)
      self.photoPages.onError(error)
    })
    .disposed(by: disposeBag)

  }
  
  func search(keyword: String) {
    query.onNext(keyword)
  }
  
  func clearPhotoCaches() {
    dataRepository.clearPhotoCaches()
  }
  
  func executeQuery(keyword: String) -> Single<[PhotoData]> {
    return Single<[PhotoData]>.create { single in
      self.dataRepository.loadPhotos() { results, error in
        if let error = error {
          single(.failure(error))
        } else {
          single(.success(results))
        }
      }
      return Disposables.create()
    }
  }
}
