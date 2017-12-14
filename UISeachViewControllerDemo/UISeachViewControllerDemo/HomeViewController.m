//
//  HomeViewController.m
//  UISeachViewControllerDemo
//
//  Created by soonkong on 2017/12/14.
//  Copyright © 2017年 SK. All rights reserved.
//

#import "HomeViewController.h"
#import "ResultDetailViewController.h"

@interface HomeViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *searchResultArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索Demo";
    
    _dataArr = [[NSMutableArray alloc] init];
    _searchResultArr = [[NSMutableArray alloc] init];
    
    //产生100个数字+三个随机字母
    for (NSInteger i =0; i<100; i++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"%ld%@",(long)i,[self shuffledAlphabet]]];
    }
    
    
    _searchViewCtrl = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchViewCtrl.searchResultsUpdater = self;
    _searchViewCtrl.delegate = self;
    //包着搜索框外层的颜色
    _searchViewCtrl.searchBar.barTintColor = [UIColor orangeColor];
    _searchViewCtrl.searchBar.placeholder= @"请输入关键字搜索";
    //搜索时，背景变暗色
    _searchViewCtrl.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    //_searchViewCtrl.obscuresBackgroundDuringPresentation = NO;
    
    //点击搜索的时候,是否隐藏导航栏
    //_searchViewCtrl.hidesNavigationBarDuringPresentation = NO;
    
    
    self.definesPresentationContext = YES;
    
    
    //位置
    _searchViewCtrl.searchBar.frame = CGRectMake(_searchViewCtrl.searchBar.frame.origin.x, _searchViewCtrl.searchBar.frame.origin.y, _searchViewCtrl.searchBar.frame.size.width, 44.0);
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = _searchViewCtrl.searchBar;
    
    
    //右划返回
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //不设置，从搜索结果详情页，返回首页时，搜索框没了
    _searchViewCtrl.hidesNavigationBarDuringPresentation = YES;
    
    if (!_searchViewCtrl.active) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchViewCtrl.active) {
        return self.searchResultArr.count;
    }
    else {
        return self.dataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (self.searchViewCtrl.active) {
        if (indexPath.row < self.searchResultArr.count) {
            cell.textLabel.text = self.searchResultArr[indexPath.row];
        }
        else {
            cell.textLabel.text = nil;
        }
    }
    else{
        if (indexPath.row < self.dataArr.count) {
            cell.textLabel.text = self.dataArr[indexPath.row];
        }
        else {
            cell.textLabel.text = nil;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchViewCtrl.active) {
        //收起键盘
        [_searchViewCtrl.searchBar resignFirstResponder];
        
        if (indexPath.row < self.searchResultArr.count) {
            //这里必须要设置为NO，否则导航不隐藏
            _searchViewCtrl.hidesNavigationBarDuringPresentation = NO;
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchViewCtrl.active) {
        return 0;
    }
    else {
        return 56;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.searchViewCtrl.active) {
        return nil;
    }
    else {
        UIView *headerVw = [[UIView alloc] init];
        headerVw.backgroundColor = [UIColor darkGrayColor];
        return headerVw;
    }
}

#pragma mark - Search
//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"updateSearchResultsForSearchController");
    
    NSString *searchString = [self.searchViewCtrl.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    if (self.searchResultArr != nil) {
        [self.searchResultArr removeAllObjects];
    }
    
    //过滤数据
    [self.searchResultArr addObjectsFromArray:[self.dataArr filteredArrayUsingPredicate:preicate]];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
    
    //    [self.view addSubview:self.searchController.searchBar];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
}

#pragma mark - other
//产生3个随机字母
- (NSString *)shuffledAlphabet {
    
    NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    
    NSString *strTest = [[NSString alloc]init];
    for (int i=0; i<3; i++) {
        int x = arc4random() % 25;
        strTest = [NSString stringWithFormat:@"%@%@",strTest,shuffledAlphabet[x]];
    }
    return strTest;
}

@end
