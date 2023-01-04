import InstantSearch
import InstantSearchSwiftUI

class AlgoliaController {
  
  let searcher: HitsSearcher

  let searchBoxInteractor: SearchBoxInteractor
  let searchBoxController: SearchBoxObservableController

  let hitsInteractor: HitsInteractor<Hit<AlgoliaShow>>
  let hitsController: HitsObservableController<Hit<AlgoliaShow>>
  
  init() {
    self.searcher = HitsSearcher(appID: "EXF4DPVMDL",
                                 apiKey: "10e81ef592f852d7c25580f7ec0ca771",
                                 indexName: "shows")
    self.searchBoxInteractor = .init()
    self.searchBoxController = .init()
    self.hitsInteractor = .init()
    self.hitsController = .init()
    setupConnections()
  }
  
  func setupConnections() {
    searchBoxInteractor.connectSearcher(searcher)
    searchBoxInteractor.connectController(searchBoxController)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsController)
  }
      
}
