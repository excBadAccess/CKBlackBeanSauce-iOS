//
//  CategoryViewController.m
//  CKReader
//
//  Created by Tony Borner on 4/17/13.
//  Copyright (c) 2013 CkStudio. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 界面标题
    self.navigationItem.title = @"分类";
    
    // 界面背景色
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
