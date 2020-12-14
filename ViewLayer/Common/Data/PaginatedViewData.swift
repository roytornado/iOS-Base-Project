import Foundation

class PaginatedViewData<T> {
  let list: [T]
  let pageNum: Int
  let hasMore: Bool
  init(_ list: [T], pageNum: Int, hasMore: Bool) {
    self.list = list
    self.pageNum = pageNum
    self.hasMore = hasMore
  }
  
  static func nothing() -> PaginatedViewData<T> {
    return PaginatedViewData<T>([], pageNum: 0, hasMore: false)
  }
}
