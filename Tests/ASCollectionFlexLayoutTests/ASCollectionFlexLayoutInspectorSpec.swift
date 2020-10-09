#if os(iOS) || os(tvOS)
import AsyncDisplayKit
import Nimble
import Quick

@testable import ASCollectionFlexLayout

final class ASCollectionFlexLayoutInspectorSpec: QuickSpec {
  override func spec() {
    describe("scrollableDirections") {
      it("returns empty when the layout inspector doesn't have a layout delegate") {
        let layoutInspector = ASCollectionFlexLayoutInspector(layout: nil)
        expect(layoutInspector.scrollableDirections()).to(beEmpty())
      }

      it("returns layout delegate's scrollable directions") {
        let layout = ASCollectionFlexLayout(scrollableDirections: [.left])
        let layoutInspector = ASCollectionFlexLayoutInspector(layout: layout)
        expect(layoutInspector.scrollableDirections()) == [.left]
      }
    }
  }
}
#endif
