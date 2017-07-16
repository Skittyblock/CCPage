@interface CCUIControlCenterViewController : UIViewController
- (void)_loadPages;
- (void)_addContentViewController:(UIViewController*)arg1;
@end

%subclass TestPageViewController : CCUIControlCenterPageContainerViewController
- (void)viewDidLoad {
  // Add subviews to [self view]
}
%end

%hook CCUIControlCenterViewController
- (void)_loadPages {
  %orig;

  UIViewController *pageView = [[%c(TestPageViewController) alloc] init];

  [self _addContentViewController:pageView];
  [pageView release];
}
%end
