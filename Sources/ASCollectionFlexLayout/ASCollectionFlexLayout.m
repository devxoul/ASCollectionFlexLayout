#import "ASCollectionFlexLayout.h"
#import <ASCollectionFlexLayout/ASCollectionFlexLayout-Swift.h>

@implementation _ASCollectionFlexLayout

@class ASCollectionFlexLayout;

- (instancetype)initWithScrollableDirections:(ASScrollDirection)scrollableDirections layoutProvider:(nullable id<ASCollectionFlexLayoutProvider>)layoutProvider {
  ASCollectionFlexLayoutDelegate *layoutDelegate = [[ASCollectionFlexLayoutDelegate alloc] initWithScrollableDirections:scrollableDirections layoutProvider:layoutProvider];
  self = [super initWithLayoutDelegate:layoutDelegate];
  if (self) {
    layoutDelegate.layout = (ASCollectionFlexLayout *)self;
  }
  return self;
}

@end
