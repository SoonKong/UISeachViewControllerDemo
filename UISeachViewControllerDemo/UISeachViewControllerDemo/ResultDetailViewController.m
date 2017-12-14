//
//  ResultDetailViewController.m
//  UISeachViewControllerDemo
//
//  Created by soonkong on 2017/12/14.
//  Copyright © 2017年 SK. All rights reserved.
//

#import "ResultDetailViewController.h"

@interface ResultDetailViewController ()

@property (nonatomic, copy) NSString *resultText;

@end

@implementation ResultDetailViewController

- (instancetype)initWithText:(NSString *)text
{
    if (self = [super init]) {
        self.resultText = text;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor brownColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, screenSize.width, 30)];
    textLbl.backgroundColor = [UIColor clearColor];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.textColor = [UIColor blackColor];
    textLbl.font = [UIFont systemFontOfSize:20];
    textLbl.text = _resultText;
    [self.view addSubview:textLbl];
    
    CGFloat originX = (screenSize.width - 80) * 0.5;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.frame = CGRectMake(originX, 150, 80, 40);
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(popBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)popBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
