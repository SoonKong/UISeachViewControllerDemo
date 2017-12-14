# UISearchControllerDemo
UISearchController的示例

重点解决，搜索点击结果进入详情页，详情页设置没有导航时无效的问题及其他各种坑。





#### 创建SearchController

```objective-c
_searchViewCtrl = [[UISearchController alloc] initWithSearchResultsController:nil];
_searchViewCtrl.searchResultsUpdater = self;
_searchViewCtrl.delegate = self;

//包着搜索框外层的颜色
_searchViewCtrl.searchBar.barTintColor = [UIColor orangeColor];
_searchViewCtrl.searchBar.placeholder= @"请输入关键字搜索";

//搜索时，背景变暗色
_searchViewCtrl.dimsBackgroundDuringPresentation = NO;

self.definesPresentationContext = YES;
```



#### searchBar放到UITabelView的header

```objective-c
//位置
_searchViewCtrl.searchBar.frame = CGRectMake(_searchViewCtrl.searchBar.frame.origin.x, _searchViewCtrl.searchBar.frame.origin.y, _searchViewCtrl.searchBar.frame.size.width, 44.0);

// 添加 searchbar 到 headerview
self.tableView.tableHeaderView = _searchViewCtrl.searchBar;
```


#### 点击进入搜索结果详情页

```objective-c
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchViewCtrl.active) {
        //收起键盘
        [_searchViewCtrl.searchBar resignFirstResponder];
        
        if (indexPath.row < self.searchResultArr.count) {
            NSString *text = self.searchResultArr[indexPath.row];
            ResultDetailViewController *resultCtrl = [[ResultDetailViewController alloc] initWithText:text];
            [self.navigationController pushViewController:resultCtrl animated:YES];
        }
    }
    else {
        if (indexPath.row < self.dataArr.count) {
            NSString *text = self.dataArr[indexPath.row];
            ResultDetailViewController *resultCtrl = [[ResultDetailViewController alloc] initWithText:text];
            [self.navigationController pushViewController:resultCtrl animated:YES];
        }
    }
}
```





### 那么，问题来了：

------

##### 1、如果搜索结果详情页是需要隐藏导航条的；而这样进来的话，导航栏是显示的

解决办法：

* 在进入搜索结果详情页前，将 hidesNavigationBarDuringPresentation 设置为NO

```objective-c
//这里必须要设置为NO，否则导航不隐藏
_searchViewCtrl.hidesNavigationBarDuringPresentation = NO;
```



* 而搜索结果详情页（ResultDetailViewController），设置导航栏隐藏

```objective-c

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
```



* 而首页（HomeViewController），设置导航显示

```objective-c
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
```



##### 2、以为这样就解决了？不，返回的时候，取消搜索后，搜索框不见了；整个界面都不好了

* 解决办法：  原本 hidesNavigationBarDuringPresentation 设置为NO后，回到首页搜索时，没有设置回来，所以在首页（HomeViewController），viewWillAppear里，设置回YES

```objective-c
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    //不设置，从搜索结果详情页，返回首页时，搜索框没了
    _searchViewCtrl.hidesNavigationBarDuringPresentation = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
```



##### 3、以为这样就解决了？不，这还不完美。从搜索结果详情页返回的时候，可以非常清晰的看到，动画pop回来时，顶部多出一个导航



为了清晰展示，我开启NavigationController的右划返回手势

```objective-c
//右划返回
self.navigationController.interactivePopGestureRecognizer.delegate = self;
```



为啥会出现这样的问题？这是由于从搜索结果详情返回时，这是停留在搜索中，UISearchController还处于Active状态，搜索框还处于导航栏那，不需要   [self.navigationController setNavigationBarHidden:NO animated:animated];   只有搜索状态处于active时，才需要。



* 解决办法：首页（HomeViewController），viewWillAppear里判断一下搜索是否激活状态

```objective-c
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //不设置，从搜索结果详情页，返回首页时，搜索框没了
    _searchViewCtrl.hidesNavigationBarDuringPresentation = YES;
    
    if (!_searchViewCtrl.active) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}
```





### 自从，相对完美的搜索及搜索结果就完成了！