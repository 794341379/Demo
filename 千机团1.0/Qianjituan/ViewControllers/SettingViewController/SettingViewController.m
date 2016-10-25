//
//  SettingViewController.m
//  PisenMarket
//
//  Created by zengbixing on 15/9/23.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "SettingViewController.h"
#import "RegisterProtocolViewController.h"


@implementation SettingViewController

@synthesize mBackBtn;

@synthesize mSettingItemTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mSettingItemTableView.dataSource = self;
    
    mSettingItemTableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) onBackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark Table view start

//
- (CGFloat)tableView: (UITableView *)tableView
heightForHeaderInSection: (NSInteger)section
{
    return 0;
}

//
-(UIView*) tableView: (UITableView*)tableView
viewForFooterInSection: (NSInteger)section
{
    return nil;
}

//
- (NSInteger)numberOfSectionsInTableView: (UITableView*)tableView
{
    if(tableView != mSettingItemTableView)
    {
        return 0;
    }
    
    return 1;
}

//
- (NSInteger)tableView: (UITableView*)tableView
 numberOfRowsInSection: (NSInteger)section
{
    if(tableView != mSettingItemTableView)
    {
        return 0;
    }
    
    if(section == 0)
    {
        return 3;
    }
    
    return 0;
}

- (NSString*)tableView: (UITableView*)tableView
         titleForHeaderInSection: (NSInteger)section
{
    return nil;
}

- (UITableViewCell*)tableView: (UITableView*)tableView
        cellForRowAtIndexPath: (NSIndexPath*)indexPath
{
    if(tableView == nil ||
       indexPath == nil)
    {
        return nil;
    }
    
    NSString* cellIdentifier = @"SettingTableViewCell";
    
    SettingTableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed: @"SettingTableViewCell"
                                              owner: self
                                            options: nil] lastObject];
    }
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [cell.headerImageView setImage: [UIImage imageNamed: @"ico_about.png"]];
            
            [cell.titleLabel setText: @"用户协议"];
            
            cell.midCoverTitleLabel.hidden = YES;
        }
        else if(indexPath.row == 1)
        {
            [cell.headerImageView setImage: [UIImage imageNamed: @"ico_contract.png"]];
            
            [cell.titleLabel setText: @"版本号"];
            
            cell.midCoverTitleLabel.hidden = NO;
            
            
            //
            NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            NSString* app_Version = [infoDictionary objectForKey: @"CFBundleShortVersionString"];
            
            NSString* versionStr = [NSString stringWithFormat: @"V%@", app_Version];
            
            cell.midCoverTitleLabel.text = versionStr;
        }
        else if(indexPath.row == 2)
        {
            [cell.headerImageView setImage: [UIImage imageNamed: @"fx-.png"]];
            
            [cell.titleLabel setText: @"邀请朋友加入"];
            
            cell.midCoverTitleLabel.hidden = YES;
        }
    }
    
    return cell;
}

//
- (void)tableView: (UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath
                             animated: YES];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
//            HelpViewController* helpController = [[HelpViewController alloc] init];
//            
//            UINavigationController* naviC = self.navigationController;
//            
//            [naviC pushViewController: helpController
//                             animated: YES];
            
            RegisterProtocolViewController * regVC = [[RegisterProtocolViewController alloc]initWithNibName:@"RegisterProtocolViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:regVC animated:YES];
            
        }
        else if(indexPath.row == 1)
        {
            AboutViewController* aboutController = [[AboutViewController alloc] init];
            
            UINavigationController* naviC = self.navigationController;
            
            [naviC pushViewController: aboutController
                             animated: YES];
            
        
        }
        else if(indexPath.row == 2)
        {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            
            
            NSArray* imageArray = @[[UIImage imageNamed:@"120-120.png"]];
            
            [shareParams SSDKSetupShareParamsByText:@"千机团手机、3C智能产品批发团购APP，2016最会赚钱的人都下了！"
                                             images: imageArray
                                                url: [NSURL URLWithString: @"http://m.qjt1000.com/downloadApp.do"]
                                              title: @"千机团"
                                               type: SSDKContentTypeAuto];
            
            [ShareSDK showShareActionSheet:nil
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(
                                             SSDKResponseState state,
                                             SSDKPlatformType platformType,
                                             NSDictionary *userData,
                                             SSDKContentEntity *contentEntity,
                                             NSError *error,
                                             BOOL end)
             {
                 if (platformType == SSDKPlatformSubTypeWechatTimeline|| platformType == SSDKPlatformSubTypeWechatFav) {
                     [shareParams SSDKSetupShareParamsByText: @"千机团手机、3C智能产品批发团购APP，2016最会赚钱的人都下了！"
                                                      images: imageArray
                                                         url: [NSURL URLWithString: @"http://m.qjt1000.com/downloadApp.do"]
                                                       title: @"千机团手机、3C智能产品批发团购APP，2016最会赚钱的人都下了！"
                                                        type: SSDKContentTypeAuto];
                 }
                 
                if(platformType == SSDKPlatformTypeSinaWeibo){
                     [shareParams SSDKSetupShareParamsByText: @"千机团手机、3C智能产品批发团购APP，2016最会赚钱的人都下了！http://m.qjt1000.com/downloadApp.do"
                                                      images: imageArray
                                                         url: [NSURL URLWithString: @"http://m.qjt1000.com/downloadApp.do"]
                                                       title: @"千机团"
                                                        type: SSDKContentTypeAuto];
                 }
                 
                 switch (state)
                 {
                     case SSDKResponseStateSuccess:
                     {
//                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                         [alert show];
                         
                        
                     }
                          break;
                     case SSDKResponseStateFail:
                     {
                         UIAlertView* alert =
                         [[UIAlertView alloc]initWithTitle: [error description]
                                                   message: nil
                                                  delegate: nil
                                         cancelButtonTitle: @"关闭"
                                         otherButtonTitles: nil];
                         
                         [alert show];
                         
                         
                     }
                         break;
                     default:
                         break;
                 }
             }];
        }
    }
}

- (void)load: (void(^)())completeHandler
faultHandler: (void(^)(NSError *error))faultHandler
{
    
}

#pragma mark Table view delegate end

@end
