@interface CCUIControlCenterViewController : UIViewController
- (void)_addContentViewController:(UIViewController*)arg1;
- (void)_loadPages;
- (id)_selectedViewController;
- (id)_selectedContentViewController;
- (void)setRevealPercentage:(int)arg1;
@property (nonatomic, assign) CGFloat correctMaxHeight;
@end

@interface CCUIControlCenterPageContainerViewController : UIViewController
- (id)contentViewController;
@end;

CGFloat ccHeight = 200;

// Create CC page
%subclass TestPageViewController : CCUIControlCenterPageContainerViewController
- (void)viewDidLoad {
  //UIView *view = [self view];
}
%end

%hook CCUIControlCenterViewController

%property (nonatomic, assign) CGFloat correctMaxHeight;

// Load CC page
- (void)_loadPages {
  %orig;

  UIViewController *pageView = [[%c(TestPageViewController) alloc] init];

  [self _addContentViewController:pageView];
  [pageView release];
}

// Change height of CC page
// (delete the two functions if you don't want to change cc page height)
-(CGFloat)_scrollviewContentMaxHeight {
  self.correctMaxHeight = %orig;
  id content =  [self _selectedContentViewController];
  BOOL rightPage = [[content class] isEqual:NSClassFromString(@"TestPageViewController")];
  if (rightPage) {
    return ccHeight;
  }
  return %orig;
}

- (CGRect)_frameForChildViewController:(CCUIControlCenterPageContainerViewController *)viewController {
  CGRect origFrame = %orig;
    
  if([[[viewController contentViewController] class] isEqual:NSClassFromString(@"TestPageViewController")]) {
    if (viewController != [self _selectedViewController]) {
      return CGRectMake(origFrame.origin.x, self.correctMaxHeight - ccHeight, origFrame.size.width, ccHeight);
    } else {
      return CGRectMake(origFrame.origin.x, 0, origFrame.size.width, ccHeight);
    }
  } else {
    if ([self _selectedContentViewController]) {
      if([[[self _selectedContentViewController] class] isEqual:NSClassFromString(@"TestPageViewController")]) {
        CGFloat pushDown = (ccHeight - self.correctMaxHeight);
        return CGRectMake(origFrame.origin.x, pushDown, origFrame.size.width, self.correctMaxHeight);
      }
    }
  }
  return %orig;
}
%end
