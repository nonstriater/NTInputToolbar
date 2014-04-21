//
//  FSCommentListViewController.m
//  FuShuo
//
//  Created by nonstriater on 14-4-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "FSCommentListViewController.h"
#import "NTInputToolBar.h"

@interface FSCommentListViewController ()<NTInputToolBarDelegate>{

    NTInputToolBar *inputToolBar;
}

@end

@implementation FSCommentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.dataItems = @[@1,@2,@3,@3,@3,@3,@3];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - tableview delegate/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataItems count];
    
    //return ([self.dataItems count]%2 == 0)?[self.dataItems count]/2:[self.dataItems count]/2+1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    //    }
    //    UIView *cell1 = [self mkContentCell];
    //    [cell1 setFrame:CGRectMake(15, 5, cell1.frame.size.width,cell1.frame.size.height )];
    //    [cell addSubview:cell1];
    //
    //    if ([self.dataItems count] > (indexPath.row*2+1)) {
    //        UIView *cell2 = [self mkContentCell];
    //        [cell2 setFrame:CGRectMake(15+10+140, 5, 140, 187)] ;
    //        [cell addSubview:cell2];
    //    }
    
    UITableViewCell *cell=nil;

    cell=[self.tableView dequeueReusableCellWithIdentifier:@"com.nonstriater.commentlist"];
    
    
    //FSCommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"comment"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



@end
