# ASCollectionFlexLayout

ASCollectionFlexLayout is a custom collection layout that allows to use Texture layout specs in ASCollectionNode.

![screenshot](https://user-images.githubusercontent.com/931655/95620861-c3776800-0aab-11eb-81cd-7dd67a71ce4d.png)

## Usage

### Creating a layout

```swift
let layout = ASCollectionFlexLayout()
layout.layoutProvider = self

let collectionNode = ASCollectionNode(collectionViewLayout: layout)
```

If you don't specify the `layoutProvider`, it will use a `ASStackLayout` as default.

### Implementing ASCollectionFlexLayoutProvider protocol

There are two kind of layout specs in ASCollectionFlexLayout:

1. A layout for sections
2. A Layout for items in a section

You can optionally provide each layout specs by implementing `ASCollectionFlexLayoutProvider` protocol.

```swift
protocol ASCollectionFlexLayoutProvider {
  /// A layout spec for sections. The default layout spec is a stretched stack layout with no spacing.
  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, sectionElements: [ASLayoutElement]) -> ASLayoutSpec?

  /// A layout spec for items in a section. The default layout spec is a flex-wrapping stack with no spacing.
  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec?
}
```

For example:

```swift
extension MyViewController: ASCollectionFlexLayoutProvider {
  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, sectionElements: [ASLayoutElement]) -> ASLayoutSpec? {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 20,
      justifyContent: .start,
      alignItems: .start,
      children: sectionElements
    )
  }

  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec? {
    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 10,
      justifyContent: .start,
      alignItems: .start,
      flexWrap: .wrap,
      alignContent: .start,
      lineSpacing: 10,
      children: itemElements
    )
  }
}
```

### Using the default layout

You can modify the default layout to apply layout without implementing `ASCollectionFlexLayoutProvider` protocol.

```swift
let layout = ASCollectionFlexLayout()
layout.defaultSectionLayout.alignItems = .center
layout.defaultItemLayout.direction = .vertical
layout.defaultItemLayout.alignItems = .stretch
```

Also you can directly refer to the default layout in the `ASCollectionFlexLayoutProvider` protocol implementation.

```swift
func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec? {
  let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
  return ASInsetLayoutSpec(insets: insets, child: layout.defaultItemLayout)
}
```

## License

ASCollectionFlexLayout is under MIT license. See the [LICENSE](LICENSE) for more info.
