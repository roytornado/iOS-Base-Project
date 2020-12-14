import Foundation
import Cleanse

struct AppComponent: Cleanse.RootComponent {
  typealias Root = PropertyInjector<AppDelegate>
  
  static func configureRoot(binder bind: ReceiptBinder<PropertyInjector<AppDelegate>>) -> BindingReceipt<PropertyInjector<AppDelegate>> {
    return bind.propertyInjector(configuredWith: { bind in
      bind.to(injector: AppDelegate.injectProperties)
    })
  }

  static func configure(binder: Binder<Singleton>) {
    binder.include(module: CoreAppModule.self)
    binder.include(module: ModelLayerMoudle.self)
  }
}
