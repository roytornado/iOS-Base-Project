import Foundation
import Cleanse

struct CoreAppModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.include(module: PhotoListViewModel.Module.self)
    binder.include(module: NavigationManager.Module.self)
    binder.bindPropertyInjectionOf(PhotoListViewController.self).to(injector: PhotoListViewController.injectProperties)
  }
}

extension NavigationManager {
  struct Module: Cleanse.Module {
    static func configure(binder: Binder<Singleton>) {
      binder.bind(NavigationManager.self).sharedInScope().to(factory: NavigationManager.init)
    }
  }
}

extension PhotoListViewModel {
  struct Module: Cleanse.Module {
    static func configure(binder: Binder<Singleton>) {
      binder.bind(PhotoListViewModelInterface.self).to(factory: PhotoListViewModel.init)
    }
  }

}
