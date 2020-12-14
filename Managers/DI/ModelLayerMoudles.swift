import Foundation
import Cleanse

struct ModelLayerMoudle: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.include(module: DataRepository.Module.self)
  }
}

extension DataRepository {
  struct Module: Cleanse.Module {
    static func configure(binder: Binder<Singleton>) {
      binder.bind(DataRepository.self).sharedInScope().to(factory: DataRepository.init)
    }
  }
}
