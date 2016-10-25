//
//  QianjituanViewController.m
//  Qianjituan
//
//  Created by ios-mac on 15/9/16.
//  Copyright (c) 2015年 ios-mac. All rights reserved.
//

#import "QianjituanViewController.h"

#import <CommonCrypto/CommonDigest.h>

#import "MQChatViewManager.h"

#import <MeiQiaSDK/MQManager.h>
#define HEIGHT self.view.bounds.size.height
#define WIDTH self.view.bounds.size.width
//
@implementation KeyMap


@end



//
@implementation QianjituanViewController

@synthesize mBackBtnContainerView;

@synthesize mCityContainerView;

@synthesize mCityLabel;

@synthesize mCityBtn;

@synthesize mBackgroundView;

@synthesize mTitleCoontainerView;

@synthesize mTitleLabel;

@synthesize mMenuContainerView;

@synthesize mShareContainerView;

@synthesize mMainWebView;

//
@synthesize mNoNetworkContainerView;

@synthesize mNoNetworkImageView;

@synthesize mNoNetworkLabel;

@synthesize mNoNetworkRefreshButton;

//
@synthesize mLoadingViewContainer;

@synthesize mLoadingImageView;

//
@synthesize mCityNotifyContainerView;

@synthesize mCityNotifyVisibleContainerView;

@synthesize mCityNotifyBtn;

NSString* KHomeUrlFormat = @"http://m.qjt1000.com/index.html?city=%@&source=app";

NSString* KHomeUrl = NULL;

NSString* KHomeUrlBase = @"http://m.qjt1000.com/index.html";

NSString* KLoadingText = @"载入中...";

NSString* KSourceFlagFormat = @"city=%@&source=app";
 
NSString* KSourceFlag = @"city=510100&source=app";

NSString* KCustomerServiceUrl = @"http://eco-api.meiqia.com/";

// 1.1 美洽客服
//NSString* KIntoCustomerUrl = @"#MQPanelVisible";

//1.2 修改后


NSString* KIntoCustomerUrl = @"cmd=meiqia";
//
NSString* KIntoCustomerUrlMerchant = @"cmd=meiqia_zs";





NSString* KUserCenterUrl = @"http://m.qjt1000.com/personalCenter.do";

NSString* KDeletePicUrl = @"_newSaleDelpic";

NSString* KPayUrl = @"o2o.yeepay.com";

NSString* KShareSplitKey = @"[;]";

NSString* KCitySplitKey = @"[_]";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initComponenets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @brief 初始化组件
 *
 */
- (void) initComponenets
{
    [[UIApplication sharedApplication]setStatusBarHidden: NO
                                           withAnimation: UIStatusBarAnimationSlide];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent
                                                animated: YES];
    
    self.navigationController.navigationBarHidden = YES;  
    //
    mBackBtnContainerView.hidden = YES;
    
    //
    mLocatedCityName = @"成都";
    
    //
    mMenuContainerView.hidden = YES;
    
    //
    mShareContainerView.hidden = YES;
    
    //专注批发，正品评价  
    _homeLabel.hidden = YES;
    
    [_homeLabel  sizeToFit];
    
    //
    CGRect screenFrame = [ UIScreen mainScreen ].bounds;
    
    if(screenFrame.size.width == 320 &&
       screenFrame.size.height == 480)
    {
        mMainWebView.frame =
        CGRectMake(
                   0,
                   mMainWebView.frame.origin.y,
                   mMainWebView.frame.size.width,
                   mMainWebView.frame.size.height - 87);
        
    }
    
    //
    mMainWebView.delegate = self;
    
    //
    mNoNetworkContainerView.hidden = YES;
    
    mNoNetworkRefreshButton.layer.masksToBounds = YES;
    
    mNoNetworkRefreshButton.layer.cornerRadius = 20;
    
    mNoNetworkRefreshButton.layer.borderWidth = 1.0;
    
    mNoNetworkRefreshButton.layer.borderColor =
    [[UIColor colorWithRed: 90.0f / 255.0f
                     green: 168.0f / 255.0f
                      blue: 248.0f / 255.0f
                     alpha: 1.0f] CGColor];
    
    //
    mCityNotifyContainerView.hidden = YES;
    
    mCityNotifyVisibleContainerView.layer.masksToBounds = YES;
    
    mCityNotifyVisibleContainerView.layer.cornerRadius = 16;
    
    mCityNotifyVisibleContainerView.layer.borderWidth = 1.0;
    
    mCityNotifyVisibleContainerView.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //city data initialize
    NSUserDefaults* cityDataDifaults = [NSUserDefaults standardUserDefaults];
    
    NSString* cityRawStr = [cityDataDifaults objectForKey: @"CityRawString"];
    
    NSData* cityRawData = nil;
    
    if(cityRawStr != nil)
    {
        cityRawData = [cityRawStr dataUsingEncoding: NSUTF8StringEncoding];
    }
    
    NSError* error;
    
    NSArray* cityArray = nil;
    
    if(cityRawData != nil)
    {
        cityArray =
        [NSJSONSerialization JSONObjectWithData: cityRawData
                                        options: NSJSONReadingMutableLeaves
                                          error: &error];
    }
    
    if(cityArray != nil)
    {
        if(mCityDataArray == nil)
        {
            mCityDataArray = [[NSMutableArray alloc] init];
        }
        else
        {
            [mCityDataArray removeAllObjects];
        }
        
        for(int i = 0; i < cityArray.count; i++)
        {
            NSDictionary* cityDict = [cityArray objectAtIndex: i];
            
            NSString* cityName = [cityDict objectForKey: @"venderName"];
            
            NSString* cityID = [cityDict objectForKey: @"areaCode"];
            
            CityData* cityData = [[CityData alloc] init];
            
            cityData->cityName = cityName;
            
            cityData->cityID = cityID;
            
            [mCityDataArray addObject: cityData];
        }
    }
    
    //
    mLoadingViewContainer.hidden = YES;
  
    
    NSArray* gifArray = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"1"],
                         [UIImage imageNamed:@"2"],
                         [UIImage imageNamed:@"3"],
                         [UIImage imageNamed:@"4"],
                         [UIImage imageNamed:@"5"],
                         [UIImage imageNamed:@"6"],
                         [UIImage imageNamed:@"7"],
                         [UIImage imageNamed:@"8"],
                         [UIImage imageNamed:@"9"],
                         [UIImage imageNamed:@"10"],
                         [UIImage imageNamed:@"11"],
                         [UIImage imageNamed:@"12"],
                         [UIImage imageNamed:@"13"],
                         [UIImage imageNamed:@"14"],
                         [UIImage imageNamed:@"15"],
                         nil];
    
    mLoadingImageView.animationImages = gifArray;
    
    mLoadingImageView.animationDuration = 2;
    
    mLoadingImageView.animationRepeatCount = 0;
        
   // CGSize size  = _loadLoadingIV.frame.size;
    _loadLoadingIV.frame=CGRectMake(0, 0, WIDTH/3.2, WIDTH/3.2);
    _loadLoadingIV.alpha = 0.2;
    CGPoint centerPoint=CGPointMake(self.view.center.x, self.view.center.y-50);
    _loadLoadingIV.center=centerPoint;
    mLoadingImageView.center=centerPoint;

    //init special page handle list
    [self initSpecialHandleList];
    
    //init user database
    mUserDataDBManager = [UserDataDBManager getInstance];
    
    mCurrentUserData = [mUserDataDBManager readLastOnlineUserData];
    
    mLocService = [[BMKLocationService alloc]init];
    
    mLocService.delegate = self;
    
    mGeocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    mGeocodesearch.delegate = self;
    
    [mLocService startUserLocationService];
    
    //init web browser
    mMainWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    mMainWebView.scrollView.showsHorizontalScrollIndicator = NO;
    
    mMainWebView.scrollView.bounces = NO;
    // 2.0 增加需求需要title 透明的话需要加的代理
    mMainWebView.scrollView.delegate = self;
    
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    NSURLRequest* request = nil;
    
    if(appDelegate.mCurrentLoadingUrl != nil)
    {
        request = [self getRequestFromStr: appDelegate.mCurrentLoadingUrl];
    }
    else
    {
        KHomeUrl = [NSString stringWithFormat: KHomeUrlFormat, @"510100"];
        
        request = [self getRequestFromStr: KHomeUrl];
    }
    if(request != nil)
    {
        [mMainWebView loadRequest: request];
    }
    
}
/**
 *  @brief 一些特殊处理 数组中加的模型 前人写的
 *
 */
- (void)initSpecialHandleList
{
    mIgnoreBackMapList = [[NSMutableArray alloc] init];
    
    KeyMap* keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/ware/searchWareList.do";
    
    keyMap->value = @"http://m.qjt1000.com/ware/CommodityCmCat.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/ware/CommodityCmCat.do";
    
    keyMap->value = @"http://m.qjt1000.com/index.html";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/order/order/toSubmitOrderSuccess.do";
    
    keyMap->value = @"http://m.qjt1000.com/order/myOrder/myOrder.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/order/order/cashierPay.do";
    
    keyMap->value = @"http://m.qjt1000.com/order/myOrder/myOrder.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/order/myOrder/orderDetail.do";
    
    keyMap->value = @"http://m.qjt1000.com/order/myOrder/myOrder.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"https://ok.yeepay.com/zhangguitong/query/pay/success";
    
    keyMap->value = @"http://m.qjt1000.com/order/myOrder/myOrder.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    mHideBackMapList = [[NSMutableArray alloc] init];
    
    [mHideBackMapList addObject: @"/news/saleNews/saleNewsList.do"];
    
    [mHideBackMapList addObject: @"/news/issue/issueList.do"];
    
    [mHideBackMapList addObject: @"/personalCenter.do"];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/order/myOrder/myOrder.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/order/myOrder/toWaitPayOrder.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/order/myOrder/toWaitDeliveryOrder.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/order/myOrder/toRecipientOrder.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/order/myOrder/toEndOrder.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/user/mycoupon/toCouponNotUse.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/user/mycoupon/toCouponUse.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/user/mycoupon/toCouponExpired.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/user/address/addressList.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
    keyMap = [[KeyMap alloc] init];
    
    keyMap->key = @"/user/personlData/personlDetail.do";
    
    keyMap->value = @"http://m.qjt1000.com/personalCenter.do";
    
    [mIgnoreBackMapList addObject: keyMap];
    
    //
//    keyMap = [[KeyMap alloc] init];
//    
//    keyMap->key = @"/order/order/orderConfirm.do";
//    
//    keyMap->value = @"http://m.qjt1000.com/order/userCart/userCartList.do";
//    
//    [mIgnoreBackMapList addObject: keyMap];
}

//////////////////////////////////////////////////
- (KeyMap*) getBackIgnoreData: (NSString*)url
{
    if(url == nil ||
       mIgnoreBackMapList == nil ||
       url.length <= 0 ||
       mIgnoreBackMapList.count <= 0)
    {
        return nil;
    }
    
    for(int i = 0; i < mIgnoreBackMapList.count; i++)
    {
        KeyMap* keyMap = [mIgnoreBackMapList objectAtIndex: i];
        
        if(keyMap->key == nil ||
           keyMap->key.length <= 0)
        {
            continue;
        }
        
        //
        NSRange matchRange = [url rangeOfString: keyMap->key];
        
        if(matchRange.length <= 0)
        {
            continue;
        }
        
        return keyMap;
    }
    
    return nil;
}
/**
 *  @brief 请求数据时需要隐藏放回按钮
 *
 */
- (BOOL) isNeedBackBtnHide: (NSString*)url
{
   
    if(url == nil ||
       mHideBackMapList == nil ||
       url.length <= 0 ||
       mHideBackMapList.count <= 0)
    {
        return NO;
    }
    
    for(int i = 0; i < mHideBackMapList.count; i++)
    {
        NSString* keyUrl = [mHideBackMapList objectAtIndex: i];
        
        if(keyUrl== nil ||
           keyUrl.length <= 0)
        {
            continue;
        }
        
        //
        NSRange matchRange = [url rangeOfString: keyUrl];
        
        if(matchRange.length <= 0)
        {
            continue;
        }
        
        return YES;
    }
    
    return NO;
}
/**
 *  @brief 更新用户位置
 *
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(userLocation == nil ||
       userLocation.location == nil)
    {
        return;
    }
    
    BMKReverseGeoCodeOption* geocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    geocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
    BOOL flag = [mGeocodesearch reverseGeoCode:geocodeSearchOption];
    
    if(!flag)
    {
        NSLog(@"reverse fail");
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error
{
    if(result == nil ||
       result.addressDetail == nil ||
       result.addressDetail.city == nil)
    {
        return;
    }
    
    mLocatedCityName = result.addressDetail.city;
    
    mCityLabel.text = result.addressDetail.city;
    
    if(![mLocatedCityName hasPrefix: @"成都"] &&
       ![mLocatedCityName hasPrefix: @"北京"] &&
       ![mLocatedCityName hasPrefix: @"上海"] &&
       ![mLocatedCityName hasPrefix: @"广州"] &&
       ![mLocatedCityName hasPrefix: @"深圳"] &&
       ![mLocatedCityName hasPrefix: @"南京"])
    {
        mCityNotifyContainerView.hidden = NO;
        
        mCityLabel.text = @"成都";
    }
    else
    {
        NSString* cityCode = @"510100";
        
        if([mLocatedCityName hasPrefix: @"成都"])
        {
            [mLocService stopUserLocationService];
            
            return;
        }
        else if([mLocatedCityName hasPrefix: @"北京"])
        {
            cityCode = @"110100";
        }
        else if([mLocatedCityName hasPrefix: @"上海"])
        {
            cityCode = @"310100";
        }
        else if([mLocatedCityName hasPrefix: @"广州"])
        {
            cityCode = @"440100";
        }
        else if([mLocatedCityName hasPrefix: @"深圳"])
        {
            cityCode = @"440300";
        }
        else if([mLocatedCityName hasPrefix: @"南京"])
        {
            cityCode = @"320100";
        }
        
        KHomeUrl = [NSString stringWithFormat: KHomeUrlFormat, cityCode];
        
        NSURLRequest* request = [self getRequestFromStr: KHomeUrl];
        
        if(request != nil)
        {
            [mMainWebView loadRequest: request];
        }
    }
    
    [mLocService stopUserLocationService];
}
///////////////////////////////////////////////////////////////////

- (NSURLRequest*) getRequestFromStr:(NSString*)urlStr
{
    if(urlStr == nil ||
       urlStr.length <= 0)
    {
        return nil;
    }
    
    NSURL* url = [NSURL URLWithString: urlStr];
    
    NSURLRequest* urlRequest =
    [NSURLRequest requestWithURL: url
                     cachePolicy: NSURLCacheStorageAllowed
                 timeoutInterval: 10];
    
    return urlRequest;
}

- (NSString*) getMD5WithData: (NSString*)source
{
    
    if(source == nil)
    {
        return nil;
    }
    
    const char* sourceStr = [source UTF8String];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(sourceStr, strlen(sourceStr), digist);
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity: CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [outPutStr appendFormat: @"%02x",digist[i]];
    }
    
    return [outPutStr lowercaseString];
    
}

-(BOOL) isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch([reach currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    
    if(!isExistenceNetwork)
    {
        return NO;
    }
    
    return isExistenceNetwork;
}

- (void) showCustomAlertView: (NSString*)showStr
{
    CGSize size =
    [showStr sizeWithFont: [UIFont systemFontOfSize:15.0]
        constrainedToSize: CGSizeMake(MAXFLOAT, 0.0)
            lineBreakMode: NSLineBreakByWordWrapping];
    
    UIView* alertView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, size.width + 20, 50)];
    
    alertView.backgroundColor = [UIColor grayColor];
    
    alertView.center = CGPointMake(ScreenWidth/2, ScreenHeight - 175/2);
    
    alertView.backgroundColor =
    [UIColor colorWithRed: 0
                    green: 0
                     blue: 0
                    alpha: 64];
    
    alertView.layer.cornerRadius = 4.0;
    
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, 50)];
    
    customLabel.text = showStr;
    
    customLabel.textAlignment = NSTextAlignmentCenter;
    
    customLabel.font = [UIFont systemFontOfSize:15];
    
    customLabel.textColor = [UIColor whiteColor];
    
    [alertView addSubview:customLabel];
    
    [[UIApplication sharedApplication].keyWindow addSubview: alertView];
    
    [self performSelector: @selector(hideAlertView: )
               withObject: alertView
               afterDelay: 2.0];
}

- (void) hideAlertView: (UIView*)selfView
{
    if(![selfView isKindOfClass: [UIView class]])
    {
        return;
    }
    
    [selfView removeFromSuperview];
}

-(void) onCitySelected: (NSString*)cityName
                  code: (NSString*)cityCode
{
    if(cityName == nil ||
       cityCode == nil)
    {
        return;
    }
    
    if(mSelectedCityName != nil &&
       [mSelectedCityName compare: cityName] == NSOrderedSame)
    {
        return;
    }
    
    mSelectedCityName = cityName;
    
    mSelectedCityCode = cityCode;
    
    KSourceFlag = [NSString stringWithFormat: KSourceFlagFormat, cityCode];
    
    mCityLabel.text = cityName;
    
    //
    KHomeUrl = [NSString stringWithFormat: KHomeUrlFormat, mSelectedCityCode];
    
    NSURLRequest* request = [self getRequestFromStr: KHomeUrl];
    
    if(request != nil)
    {
        [mMainWebView loadRequest: request];
    }
}

#pragma mark OnLoginSuccessDelegate  

/**
 *  @brief 登录界面返回到qjtViewController的代理（点击返回  成功自动返回  失败返回）
 *
 */
-(void) onLoginSucceeded: (NSString*)account
                password: (NSString*)password
{
    // 处理点击登录不注册登录直接返回导致的bug  个人中心  订单  地址管理 个人信息  优惠券
    if ([mCurrentLoadingUrl containsString:@"personalCenter"]||
        [mCurrentLoadingUrl containsString:@"myOrder"]||
        [mCurrentLoadingUrl containsString:@"addressList"] ||
        [mCurrentLoadingUrl containsString:@"personlDetail"] ||
        [mCurrentLoadingUrl containsString:@"toCouponNotUse"]) {
        
        [self resetTitle];
        
        self.mBackBtnContainerView.hidden = YES;
        // 返回时重新显示 设置按钮
        self.mMenuContainerView.hidden = NO;
        
    }else{
        
        [self resetTitle];
        
        self.mBackBtnContainerView.hidden = NO;
        // 返回时不显示 设置按钮
        self.mMenuContainerView.hidden = YES;
    }
    
    
    if(account == nil ||
       account.length <= 0)
    {
        NSString* userInfoStr =
        [NSString stringWithFormat: @"loginCallback('%@', '%@', '%@')", @"", @"", @""];
        
        [mMainWebView stringByEvaluatingJavaScriptFromString: userInfoStr];
        
        return;
    }
    
    NSMutableString* sign = [[NSMutableString alloc] initWithString: @"login_"];
    
    [sign appendString: account];
    
    [sign appendString: @"_qianjituan"];
    
    NSString* md5Sign = [self getMD5WithData: sign];
    
    //
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    NSString* loginAttachedData = appDelegate.mLoginAttachedData;
    
    if(loginAttachedData == nil)
    {
        loginAttachedData = @"";
    }
    
    NSString* userInfoStr =
    [NSString stringWithFormat: @"loginCallback('%@', '%@', '%@')",
                                account,
                                md5Sign,
                                loginAttachedData];
    
    [mMainWebView stringByEvaluatingJavaScriptFromString: userInfoStr];
}

-(void) startDelayDismissNoticeTimer
{
    if(mDelayDismissNoticeTimer != nil)
    {
        [mDelayDismissNoticeTimer invalidate];
        
        mDelayDismissNoticeTimer = nil;
    }
    
    //
    mDelayDismissNoticeTimer =
    [NSTimer scheduledTimerWithTimeInterval: 5
                                     target: self
                                   selector: @selector(onTimerTick)
                                   userInfo: nil
                                    repeats: NO];
    
    [[NSRunLoop currentRunLoop] addTimer: mDelayDismissNoticeTimer
                                 forMode: NSDefaultRunLoopMode];
}

- (void) onTimerTick
{
    //stop loading animation
    if(!mLoadingViewContainer.isHidden)
    {
        [mLoadingImageView stopAnimating];
        
        mLoadingViewContainer.hidden = YES;
    }
    
    if(mDelayDismissNoticeTimer != nil)
    {
        [mDelayDismissNoticeTimer invalidate];
        
        mDelayDismissNoticeTimer = nil;
    }
}

#pragma mark app background and foreground event start

- (void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
}

- (void) viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [mLocService stopUserLocationService];
}

#pragma mark app background and foreground event end

-(void)touchesBegan: (NSSet*)touches
          withEvent: (UIEvent*)event
{
}
/**
 *  @brief 城市按钮点击
 *
 */
- (IBAction) onCityBtnClick: (id)sender
{
    //go to city select view
    CitySelectViewController* viewController = [[CitySelectViewController alloc] init];
    
    viewController.mOnCitySelectedDelegate = self;
    
    [viewController setCityData: mCityDataArray];
    
    viewController.mCurrentCity = mLocatedCityName;
    
    //
    UINavigationController* naviC = self.navigationController;
    
    [naviC pushViewController: viewController
                     animated: YES];
}
/**
 *  @brief 返回按钮点击
 *
 */
- (IBAction) onBackBtnClick:(id)sender
{
    // 解决返回键导致加载失败
    if([mMainWebView canGoBack]){
        
        goBackLeadingtoFail = YES;
    }else{
        
        goBackLeadingtoFail = NO;
    }
    
    if(mCurrentMatchKeyMap != nil)
    {
        NSURLRequest* request = [self getRequestFromStr: mCurrentMatchKeyMap->value];
        
        if(request != nil)
        {
            [mMainWebView loadRequest: request];
        }
        
        mCurrentMatchKeyMap = nil;
        
        return;
    }
    

    
    if([mMainWebView canGoBack])
    {
        [mMainWebView goBack];
        
        // [self resetTitle];
    }
    
    if([mMainWebView canGoBack])
    {
        mCityContainerView.hidden = YES;
        
        mBackBtnContainerView.hidden = NO;
    }
    else
    {
        mCityContainerView.hidden = NO;
        
        mBackBtnContainerView.hidden = YES;
    }
}
/**
 *  @brief 设置按钮点击
 *
 */
- (IBAction) onMenuBtnClick:(id)sender
{
    //go to login view
    SettingViewController* viewController = [[SettingViewController alloc] init];
    
    //
    UINavigationController* naviC = self.navigationController;
    
    [naviC pushViewController: viewController
                     animated: YES];
}
/**
 *  @brief 分享
 *
 */
- (IBAction) onShareBtnClick:(id)sender
{

    if(mCurrentShareContent == nil ||
       mCurrentShareContent.length <= 0)
    {
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSArray* imageArray = nil;
  
   if(mCurrentShareImageUrl != nil)
   {
       imageArray = @[mCurrentShareImageUrl];
   }

    [shareParams SSDKSetupShareParamsByText: mCurrentShareContent
                                      images: imageArray
                                        url: [NSURL URLWithString:mCurrentShareUrl]
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
         
         if (platformType == SSDKPlatformSubTypeWechatTimeline) {
             
             [shareParams SSDKSetupShareParamsByText: mCurrentShareContent
                                              images: imageArray
                                                 url: [NSURL URLWithString:mCurrentShareUrl]
                                               title: mCurrentShareContent
                                                type: SSDKContentTypeAuto];
         }
         
         if (platformType == SSDKPlatformSubTypeWechatFav) {
             
             [shareParams SSDKSetupShareParamsByText: mCurrentShareContent
                                              images: imageArray
                                                 url: [NSURL URLWithString:mCurrentShareUrl]
                                               title: mCurrentShareContent
                                                type: SSDKContentTypeAuto];
             
         }
         // 新浪微博得拼一个链接
         if (platformType == SSDKPlatformTypeSinaWeibo) {
             
             NSString * wbShareContent = [mCurrentShareContent stringByAppendingString:mCurrentShareUrl];
             
             [shareParams SSDKSetupShareParamsByText: wbShareContent
                                              images: imageArray
                                                 url: [NSURL URLWithString:mCurrentShareUrl]
                                               title: @"千机团"
                                                type: SSDKContentTypeAuto];
         }
        
         switch (state)
         {
                
                 
             case SSDKResponseStateSuccess:
             {
                 mUserDataDBManager = [UserDataDBManager getInstance];
                 
                 UserData* currentOnlineUserData = [mUserDataDBManager readLastOnlineUserData];
                 
                 //
                 if(currentOnlineUserData != nil &&
                    currentOnlineUserData->isOnline)
                 {
                     NSMutableString* sign = [[NSMutableString alloc] initWithString: @"account_"];
                     
                     [sign appendString: currentOnlineUserData->account];
                     
                     [sign appendString: @"_qianjituan"];
                     
                     NSString* md5Sign = [self getMD5WithData: sign];
                     
                     NSString* shareResultStr =
                     [NSString stringWithFormat: @"shareCallback('%@', '%@')",
                      currentOnlineUserData->account,
                      md5Sign];
                     
                     [mMainWebView stringByEvaluatingJavaScriptFromString: shareResultStr];
                     
                 }
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView* alert =
                 [[UIAlertView alloc]initWithTitle: [error description]
                                           message: nil
                                          delegate: nil
                                 cancelButtonTitle: @"关闭"
                                 otherButtonTitles: nil];
                 
                 [alert show];
                 
                 break;
             }
             default:
                 break;
         }
     }];
}


- (IBAction) onCityNotifyBtnClick:(id)sender
{
    mCityNotifyContainerView.hidden = YES;
}

- (IBAction) onRefreshBtnClick:(id)sender
{
    mNoNetworkContainerView.hidden = YES;
    
    [mTitleLabel setText: KLoadingText];
    
    [mMainWebView stopLoading];
    
    if(mCurrentLoadingUrl != nil)
    {
        NSURLRequest* request = [self getRequestFromStr: mCurrentLoadingUrl];
        
        if(request != nil)
        {
            [mMainWebView loadRequest: request];
        }
    }
}

#pragma mark web.ScrollView Delegate start

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if ([mCurrentLoadingUrl containsString:KHomeUrlBase]) {
//        
//         NSLog(@"%f",mMainWebView.scrollView.contentOffset.y);
//        if (mMainWebView.scrollView.contentOffset.y > 64) {
//            mTitleCoontainerView.alpha = 0;
//        }else{
//            mTitleCoontainerView.alpha = 1.0;
//        }
//    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

#pragma mark web.ScrollView Delegate end


#pragma mark UIWebView delegate start


- (void)alertView: (UIAlertView*)alertView
clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if(buttonIndex == 1 &&
       mCurrentLoadingUrl != nil)
    {
        NSURLRequest* request = [self getRequestFromStr: mCurrentLoadingUrl];
        
        if(request != nil)
        {
            [mMainWebView loadRequest: request];
        }
    }
}

- (BOOL)webView: (UIWebView*)webView
shouldStartLoadWithRequest: (NSURLRequest*)request
 navigationType: (UIWebViewNavigationType)navigationType
{
    
    if(request == nil ||
       request.URL == nil)
    {
        mIsCurrentUrlIgnored = NO;
        
        return YES;
    } 
    
    //
    NSURL* url = [request URL];
    
    NSString* urlStr = [url absoluteString];
  
    
// 调用 客服原生 SDK
    
    

//    if([urlStr containsString:KIntoCustomerUrl]){
//        
//        self.navigationController.navigationBarHidden = NO;
//        
//        if ([urlStr containsString:@"news/issue"]) {
//            
//            MQChatViewManager * chatViewManager = [[MQChatViewManager alloc]init];
//            
//            [chatViewManager setScheduledGroupId:MEIQIA_GROUP_ID_MERCHANTS];
//          
//            [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.41 blue:0 alpha:1]];
//            
//            [chatViewManager pushMQChatViewControllerInViewController:self];
//            
//        }else{
//            
//            MQChatViewManager * chatViewManager = [[MQChatViewManager alloc]init];
//            
//            [chatViewManager setScheduledGroupId:MEIQIA_GROUP_ID_SERVICE];
//         
//            [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.41 blue:0 alpha:1]];
//            
//            [chatViewManager pushMQChatViewControllerInViewController:self];
//        }
//        
//    }else{
//        self.navigationController.navigationBarHidden = YES;
//    }

#warning 测试用
    // 屏蔽侧滑返回 否则导致bug
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if ([urlStr hasSuffix:KIntoCustomerUrl]) {
        // 将这个处理丢到meiqia的代码中了
//        self.navigationController.navigationBarHidden = NO;

        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        
        [chatViewManager setScheduledGroupId:@"47fb6302d6c02f154ecf0a251bde2e86"];
        
        [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.41 blue:0 alpha:1]];
        
        [chatViewManager pushMQChatViewControllerInViewController:self];

    }else if([urlStr hasSuffix:KIntoCustomerUrlMerchant]){
        
        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        
        [chatViewManager setScheduledGroupId:@"5473545a407577e84df81a712d1bbe10"];
        
        [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.41 blue:0 alpha:1]];
        
        [chatViewManager pushMQChatViewControllerInViewController:self];
        
//        self.navigationController.navigationBarHidden = NO;

    }else{
        self.navigationController.navigationBarHidden = YES;
    }
    

//    if([urlStr containsString:KIntoCustomerUrl]){
//        
//        self.navigationController.navigationBarHidden = NO;
//        
//        if ([urlStr containsString:@"news/issue"]) {
//            
//            MQChatViewManager * chatViewManager = [[MQChatViewManager alloc]init];
//            
 //          [chatViewManager setScheduledGroupId:MEIQIA_GROUP_ID_MERCHANTS];
//          
//            [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.41 blue:0 alpha:1]];
//            
//            [chatViewManager pushMQChatViewControllerInViewController:self];
//            
//        }else{
//            
//            MQChatViewManager * chatViewManager = [[MQChatViewManager alloc]init];
//            
 //           [chatViewManager setScheduledGroupId:MEIQIA_GROUP_ID_SERVICE];
//         
//            [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.41 blue:0 alpha:1]];
//            
//            [chatViewManager pushMQChatViewControllerInViewController:self];
//        }
//        
//    }else{
//        self.navigationController.navigationBarHidden = YES;
//    }


#pragma mark-原生
    // 屏蔽侧滑返回 否则导致bug
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    


    if ([urlStr hasSuffix:KIntoCustomerUrl]) {
        // 将这个处理丢到meiqia的代码中了
//        self.navigationController.navigationBarHidden = NO;

        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        
        [chatViewManager setScheduledGroupId:MEIQIA_GROUP_ID_SERVICE];
        
        [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.41 blue:0 alpha:1]];
        
        [chatViewManager pushMQChatViewControllerInViewController:self];
        
        return NO;

    }else if([urlStr hasSuffix:KIntoCustomerUrlMerchant]){
        
        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        
        [chatViewManager setScheduledGroupId:MEIQIA_GROUP_ID_MERCHANTS];
        
        [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.41 blue:0 alpha:1]];
        
        [chatViewManager pushMQChatViewControllerInViewController:self];
        
//        self.navigationController.navigationBarHidden = NO;

        return NO;
    }else{
        
    self.navigationController.navigationBarHidden = YES;
    }

 
    
    if(![urlStr hasPrefix: KCustomerServiceUrl])
    {
        mCurrentLoadingUrl = urlStr;
    }
    

    NSLog(@"url string: %@", urlStr);
    
    NSRange deletePic = [urlStr rangeOfString: KDeletePicUrl];
    
    if(deletePic.length > 0)
    {
        mIsCurrentUrlIgnored = YES;
        
        return YES;
    }
    
    if(![urlStr hasPrefix: @"http://"])
    {
        mIsCurrentUrlIgnored = NO;
        
        return YES;
    }
    
    if([urlStr hasPrefix: KUserCenterUrl])
    {
        mMenuContainerView.hidden = NO;
    }
    else
    {
        mMenuContainerView.hidden = YES;
    }
    
    // 是否在首页
    bool isGoToMainPage = NO;
    
    if([mCurrentLoadingUrl hasPrefix: KHomeUrlBase])
    {
        isGoToMainPage = YES;
    }
    
    if(isGoToMainPage)
    {
        mCityContainerView.hidden = NO;
        
        mBackBtnContainerView.hidden = YES;
        
        mBackgroundView.backgroundColor =
        [UIColor colorWithRed: 255.0f / 255.0f
                         green: 102.0f / 255.0f
                          blue: 0.0f / 255.0f
                        alpha: 1.0f];
        
        mTitleCoontainerView.backgroundColor =
        [UIColor colorWithRed: 255.0f / 255.0f
                        green: 102.0f / 255.0f
                         blue: 0.0f / 255.0f
                        alpha: 1.0f];
        
        mCityLabel.textColor = [UIColor whiteColor];
        
        mTitleLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        mCityContainerView.hidden = YES;
        
        mBackBtnContainerView.hidden = NO;
        
        mBackgroundView.backgroundColor = [UIColor darkGrayColor];
        
        mTitleCoontainerView.backgroundColor = [UIColor whiteColor];
        
        mCityLabel.textColor = [UIColor darkGrayColor];
        
        mTitleLabel.textColor = [UIColor darkGrayColor];
    }
    
    if(![self isConnectionAvailable])
    {
        
        mNoNetworkContainerView.hidden = NO;
        
        return NO;
    }
    else
    {
        mNoNetworkContainerView.hidden = YES;
    }

    //
    NSRange loginRange = [urlStr rangeOfString: @"cmd=login"];
    
    NSRange updateRange = [urlStr rangeOfString: @"cmd=updatepwd"];
    
    NSRange exitRange = [urlStr rangeOfString: @"cmd=exit"];
    
    if(loginRange.length > 0)
    {
        
        
        if (self.isBack) {
            self.isBack=NO;
            
            //
        }else{
        mUserDataDBManager = [UserDataDBManager getInstance];
        
        UserData* currentOnlineUserData = [mUserDataDBManager readLastOnlineUserData];
        
        //
        NSArray* dataArray = [urlStr componentsSeparatedByString: @"&"];
        
        NSString* attachedData = @"";
        
        if(dataArray != nil &&
           dataArray.count > 0)
        {
            for(int i = 0; i < dataArray.count; i++)
            {
                NSString* data = dataArray[i];
                
                if([data hasPrefix: @"returnPath"])
                {
                    NSArray* subDataArray = [data componentsSeparatedByString: @"="];
                    
                    attachedData = subDataArray[1];
                    
                }
            }
        }
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        //
        if(currentOnlineUserData != nil &&
           currentOnlineUserData->isOnline)
        {
            NSMutableString* sign = [[NSMutableString alloc] initWithString: @"login_"];
            
            [sign appendString: currentOnlineUserData->account];
            
            [sign appendString: @"_qianjituan"];
            
            NSString* md5Sign = [self getMD5WithData: sign];
        
            
            NSString* userInfoStr =
            [NSString stringWithFormat: @"loginCallback('%@', '%@', '%@')",
                                        currentOnlineUserData->account,
                                        md5Sign,
                                        attachedData ];
            
            
            [mMainWebView stringByEvaluatingJavaScriptFromString: userInfoStr];
        }
        else
        {
            

            appDelegate.mLoginAttachedData = attachedData;
            
            //go to login view
            LoginViewController* viewController = [[LoginViewController alloc] init];
            
            //
            viewController.mIsFromMain = YES;
            
            viewController.mOnLoginSuccessDelegate = self;
            
            //
            UINavigationController* naviC = self.navigationController;
            
            [naviC pushViewController: viewController
                             animated: YES];
        }
        
        mIsCurrentUrlIgnored = YES;
    
        return NO;
     }
    }
    else if(updateRange.length > 0)
    {
     
        mUserDataDBManager = [UserDataDBManager getInstance];
        
        //
        NSArray* dataArray = [urlStr componentsSeparatedByString: @"&"];
        
        NSString* account = nil;
        
        NSString* password = nil;
        
        if(dataArray != nil &&
           dataArray.count > 0)
        {
            for(int i = 0; i < dataArray.count; i++)
            {
                NSString* data = dataArray[i];
                
                if([data hasPrefix: @"mobile"])
                {
                    NSArray* subDataArray = [data componentsSeparatedByString: @"="];
                    
                    account = subDataArray[1];
                }
                else if([data hasPrefix: @"password"])
                {
                    
                    NSArray* subDataArray = [data componentsSeparatedByString: @"="];
                    
                    password = subDataArray[1];
                }
            }
        }
        
        if(account != nil &&
           password != nil)
        {
            UserData* actionUserData = [[UserData alloc] init];
            
            actionUserData->account = account;
            
            actionUserData->password = password;
            
            [mUserDataDBManager updateUserDataToDB: actionUserData];
        }
        
        mIsCurrentUrlIgnored = NO;
    }
    else if(exitRange.length > 0)
    {
        mUserDataDBManager = [UserDataDBManager getInstance];
        
        [mUserDataDBManager resetLastOnlineUser];
        
        mCurrentUserData = nil;
        
        //go home page
        NSURLRequest* request = [self getRequestFromStr: KHomeUrl];
        
        if(request != nil)
        {
            [mMainWebView loadRequest: request];
        }
        
        mIsCurrentUrlIgnored = YES;
        
        return NO;
    }
    
    mIsCurrentUrlIgnored = NO;
    
    if(![urlStr hasPrefix: KCustomerServiceUrl])
    {
        
        mCurrentLoadingUrl = urlStr;
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        appDelegate.mCurrentLoadingUrl = mCurrentLoadingUrl;
        
        KeyMap* keyMap = [self getBackIgnoreData: urlStr];
        
        mCurrentMatchKeyMap = keyMap;
        
        if(!isGoToMainPage)
        {
            BOOL  isBackBtnNeedHide = [self isNeedBackBtnHide: urlStr];
            
            if(isBackBtnNeedHide)
            {
                mBackBtnContainerView.hidden = YES;
            }
            else
            {
                mBackBtnContainerView.hidden = NO;
            }
        }
    }
\

    //loading animation
    mLoadingViewContainer.hidden = NO;
  //根据需求透明处理背景颜色为 clearColor
    mLoadingViewContainer.backgroundColor = [UIColor clearColor];
    
    [mLoadingImageView startAnimating];
    
    [self startDelayDismissNoticeTimer];
    
    return YES;
}
/**
 *  @brief 重置title
 *
 */
- (void)resetTitle{

    NSString* titleSource = [mMainWebView stringByEvaluatingJavaScriptFromString: @"document.title"];
    
    NSString* title = @"";
    
    if(titleSource != nil)
    {
        NSRange shareContentRange = [titleSource rangeOfString: KShareSplitKey];
        
        if(shareContentRange.length > 0)
        {
            // 直接分割字符串即可
            NSArray * arr = [titleSource componentsSeparatedByString:KShareSplitKey];

            title = arr[0];
            
            mCurrentShareImageUrl = arr[1];
            
            mCurrentShareContent = arr[2];
            
            mCurrentShareUrl = arr[3];
            
            mShareContainerView.hidden = NO;
            
        }
        else
        {
            
            mCurrentShareContent = nil;
            
            mShareContainerView.hidden = YES;
            
            NSRange cityContentRange = [titleSource rangeOfString: KCitySplitKey];
            
            if(cityContentRange.length > 0)
            {
                title = [titleSource substringToIndex: cityContentRange.location];
            }
            else
            {
                title = titleSource;
            }
            
        }
        
        mTitleLabel.text = title;
    }
}

- (void)webViewDidStartLoad: (UIWebView*)webView
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [mTitleLabel setText: KLoadingText];
    
    if(mDelayDismissNoticeTimer != nil)
    {
        [mDelayDismissNoticeTimer invalidate];
        
        mDelayDismissNoticeTimer = nil;
    }
}

- (void)webViewDidFinishLoad: (UIWebView*)webView
{
    
    if ([mCurrentLoadingUrl containsString:@"/index.html"]) {
        _homeLabel.hidden = NO;
    }else{
        _homeLabel.hidden = YES;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self resetTitle];
    
        //read cityData
    if(mCurrentLoadingUrl != nil && 
       [mCurrentLoadingUrl hasPrefix: KHomeUrlBase])
    {
        
        NSString* cityStr = [mMainWebView stringByEvaluatingJavaScriptFromString: @"getVenderInfo()"];
        
        NSData* cityRawData = nil;
        
        if(cityStr != nil)
        {
            cityRawData = [cityStr dataUsingEncoding: NSUTF8StringEncoding];
        }
        
        NSError* error;
        
        NSArray* cityArray = nil;
        
        if(cityRawData != nil)
        {
            cityArray =
            [NSJSONSerialization JSONObjectWithData: cityRawData
                                            options: NSJSONReadingMutableLeaves
                                              error: &error];
        }
        
        if(cityArray != nil)
        {
            if(mCityDataArray == nil)
            {
                mCityDataArray = [[NSMutableArray alloc] init];
            }
            else
            {
                [mCityDataArray removeAllObjects];
            }
            
            for(int i = 0; i < cityArray.count; i++)
            {
                NSDictionary* cityDict = [cityArray objectAtIndex: i];
                
                NSString* cityName = [cityDict objectForKey: @"venderName"];
                
                NSString* cityID = [cityDict objectForKey: @"areaCode"];
                
                CityData* cityData = [[CityData alloc] init];
                
                cityData->cityName = cityName;
                
                cityData->cityID = cityID;
                
                [mCityDataArray addObject: cityData];
            }
            
            NSUserDefaults* cityDataDifaults = [NSUserDefaults standardUserDefaults];
            
            [cityDataDifaults setObject: cityStr forKey: @"CityRawString"];
        }
    }
    
    //stop loading animation
    [mLoadingImageView stopAnimating];
    
    mLoadingViewContainer.hidden = YES;
    
    if(!mIsCurrentUrlIgnored)
    {
        mNoNetworkContainerView.hidden = YES;
    }
    
    if(mDelayDismissNoticeTimer != nil)
    {
        [mDelayDismissNoticeTimer invalidate];
        
        mDelayDismissNoticeTimer = nil;
    }
    // inject 引入 注册后登录
    if(self.mIsNeedInjectLoginData)
    {
        self.mIsNeedInjectLoginData = NO;
        
        //
        mUserDataDBManager = [UserDataDBManager getInstance];
        
        UserData* currentOnlineUserData = [mUserDataDBManager readLastOnlineUserData];
        
        //
        NSString* attachedData = @"";
        
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        NSLog(@"%@",appDelegate.mCurrentLoadingUrl);
        
        if(appDelegate.mLoginAttachedData != nil)
        {
            attachedData = appDelegate.mLoginAttachedData;
            
        }
        //
        if(currentOnlineUserData != nil &&
           currentOnlineUserData->isOnline)
        {
            NSMutableString* sign = [[NSMutableString alloc] initWithString: @"login_"];
            
            [sign appendString: currentOnlineUserData->account];
            
            [sign appendString: @"_qianjituan"];
            
            NSString* md5Sign = [self getMD5WithData: sign];
            
            NSString* userInfoStr =
            [NSString stringWithFormat: @"loginCallback('%@', '%@', '%@')",
             currentOnlineUserData->account,
             md5Sign,
             attachedData];
            
            [mMainWebView stringByEvaluatingJavaScriptFromString: userInfoStr];
        }
    }
}

- (void)webView: (UIWebView*)webView
didFailLoadWithError: (NSError*)error
{
    if(error == nil ||
       mCurrentLoadingUrl == nil)
    {
        return;
    }
    
    if(mTitleLabel.text != nil &&
       [mTitleLabel.text isEqualToString: KLoadingText])
    {
        mTitleLabel.text = @"";
    }
    
    //stop loading animation
    [mLoadingImageView stopAnimating];
    
    mLoadingViewContainer.hidden = YES;
    
    if(goBackLeadingtoFail){
        
        mIsCurrentUrlIgnored = YES;
    }
    
    if(!mIsCurrentUrlIgnored)
    {
        mNoNetworkContainerView.hidden = NO;
    }
}

#pragma mark UIWebView delegate end

@end
