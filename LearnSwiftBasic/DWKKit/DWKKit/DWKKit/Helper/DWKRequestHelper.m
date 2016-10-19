//
//  DWKRequestHelper.m
//  DWKKit
//
//  Created by pisen on 16/10/14.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import "DWKRequestHelper.h"
#import "AFNetworking.h"

@implementation DWKRequestHelper

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}
- (id)init {
    self = [super init];
    if (self) {
        self.requestQueue = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)cancelRequestById:(NSString *)requestId {
    NSURLSessionTask *task = self.requestQueue[requestId];
    if (NSURLSessionTaskStateRunning == task.state) {
        [task cancel];
    }
    [self.requestQueue removeObjectForKey:requestId];
}
- (void)cancelAllRequests {
    for (NSString *requestId in self.requestQueue) {
        NSURLSessionTask *task = self.requestQueue[requestId];
        if (NSURLSessionTaskStateRunning == task.state) {
            [task cancel];
        }
    }
    [self.requestQueue removeAllObjects];
}

- (NSString *)resolveDWKErrorType:(NSString *)errorType andError:(NSError *)error{
    NSMutableString * errMsg = [NSMutableString stringWithString:@"\r>>>>>>>>>>>>>>>>>>>>ErrorType[0]>>>>>>>>>>>>>>>>>>>>\r"];//错误标记开始
    NSString * messageTitle = @"提示";
    NSString * messageDetail = errorType;
    if (OBJECT_IS_EMPTY(messageDetail)) {
        messageDetail = error.userInfo[NSLocalizedDescriptionKey];
    }
    if (OBJECT_IS_EMPTY(messageDetail)) {
        messageDetail = @"未知错误";
    }
    
    [errMsg appendFormat:@"messageTitle:%@\r  messageDetail:%@\r", messageTitle, messageDetail];//显示解析后的错误提示
    if (error) {
        [errMsg appendFormat:@"  errorCode:%ld\r  errorMessage:%@\r", (long)error.code, error];//显示error的错误内容
    }
    [errMsg appendString:@"<<<<<<<<<<<<<<<<<<<<ErrorType[0]<<<<<<<<<<<<<<<<<<<<\r\n"];//错误标记结束
    NSLog(@"error message=%@", errMsg);
    return messageDetail;
}

/**
 * 常用请求参数
 */
- (NSString *)requestWithApiName:(NSString *)apiName
                          params:(NSDictionary *)params
                       dataModel:(Class)dataModel
                            type:(DWKRequestType)type
                         success:(DWKRequestSuccess)success
                         failure:(DWKRequestFailure)failure{

    return [self requestFromUrl:kPathAppBaseUrl WithApiName:apiName params:params dataModel:dataModel type:type success:success failure:failure];
}
- (NSString *)requestFromUrl:(NSString *)url
                 WithApiName:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                        type:(DWKRequestType)type
                     success:(DWKRequestSuccess)success
                     failure:(DWKRequestFailure)failure{
    return [self requestFromUrl:url WithApiName:apiName params:params dataModel:dataModel imageData:nil type:type success:success failure:failure];
}

/**
 *  处理DWKBaseModel和DWKDataModel映射、登陆过期
 */
- (NSString *)requestFromUrl:(NSString *)url
                 WithApiName:(NSString *)apiName
                      params:(NSDictionary *)params
                   dataModel:(Class)dataModel
                   imageData:(NSData *)imageData
                        type:(DWKRequestType)type
                     success:(DWKRequestSuccess)success
                     failure:(DWKRequestFailure)failure{
    

    return [self requestFromUrl:url WithApiName:apiName params:params customModel:[DWKBaseModel class] imageData:imageData type:type success:^(id responseObject) {
        
        DWKBaseModel * baseModel = responseObject;
        if (baseModel && [baseModel isKindOfClass:[DWKBaseModel class]]) {
            if ([baseModel checkRequestIsSuccess]) {
                NSObject * dataObj = baseModel.data;
                if (dataObj && dataModel && [[dataModel class] respondsToSelector:@selector(objectWithKeyValues:)]) {
                    dataObj = [dataModel objectWithKeyValues: dataObj];
                    if (dataObj) {
                        if (success) {
                            success(dataObj);
                        }
                    }else{
                        if (failure) {
                            failure(DWKConfigDataInstance.networkErrorDataMappingFailed, nil);
                        }
                    }
                }else{
                    if (success) {
                        success(dataObj);
                    }
                }
            }else{
                [baseModel postNotificationWhenLoginExpired];
                if (failure) {
                    NSInteger state = baseModel.state;
                    NSString * message = TRIM_STRING(baseModel.message);
                    failure(@"",CREATE_NSERROR_WITH_Code(state, message));// 服务器内部错误(需要进一步解析dataModel.state 和 message)
                }
            
            }
        }else{
            if (failure) {
                failure(DWKConfigDataInstance.networkErrorDataMappingFailed, nil);

            }
        }
        
    } failure:^(NSString *DWKErrorType, NSError *error) {
        
    }];
}
/**
 *处理自定义模型的映射，将映射好的自定义模型往上层抛
 *
 */
- (NSString *)requestFromUrl:(NSString *)url
                 WithApiName:(NSString *)apiName
                      params:(NSDictionary *)params
                 customModel:(Class)customModel
                   imageData:(NSData *)imageData
                        type:(DWKRequestType)type
                     success:(DWKRequestSuccess)success
                     failure:(DWKRequestFailure)failure{

return [self requestFromUrl:url WithApiName:apiName params:params httpHeaderParams:nil imageData:imageData type:type success:^(id responseObject) {
    NSObject *model = responseObject;
    if (customModel && [[customModel class] respondsToSelector:@selector(objectWithKeyValues:)]) {
        model = [customModel objectWithKeyValues:responseObject];
        if (model) {//将成功映射后的data模型往上层抛
            if (success) {
                success(model);
            }
        }
        else {
            if (failure) {
                failure(DWKConfigDataInstance.networkErrorDataMappingFailed, nil);
            }
        }
    }
    else {
        if (success) {
            success(model);
        }
    }
} failure:failure];
}

/**
 *通用的GET、POST和上传图片（返回最原始的未经过任何映射的JSON字符串）
 *
 */
- (NSString *)requestFromUrl:(NSString *)url
                 WithApiName:(NSString *)apiName
                      params:(NSDictionary *)params
            httpHeaderParams:(NSDictionary *)httpHeaderParams
                   imageData:(NSData *)imageData
                        type:(DWKRequestType)type
                     success:(DWKRequestSuccess)success
                     failure:(DWKRequestFailure)failure{
    //0. url组装、判断网络状态、判断url合法性
    if ( ! DWKDataInstance.isReachable) {
        if (failure) {
            failure(DWKConfigDataInstance.networkErrorDisconnected, nil);
        }
        return @"";
    }
    url = [self _formatRequestUrl:url withApi:apiName];
    if ( ! [NSString isWebUrl:url]) {
        if (failure) {
            failure(DWKConfigDataInstance.networkErrorURLInvalid, nil);
        }
        return @"";
    }
    NSString *requestId = [self _createRequestIdByUrl:url withApi:apiName params:params type:type];
    // 自动处理重复请求
    
    if (self.requestQueue[requestId]) {
        if (DWKConfigDataInstance.isAutoCancelTheSameRequesting) {
            [self cancelRequestById:requestId];
        }
        else {
            NSLog(@"The same requstId[%@] is still running!\rurl:%@\rapi:%@\rparams:%@\rtype:%ld",
                  requestId, url, apiName, params, type);
            if (failure) {
                failure(DWKConfigDataInstance.networkErrorRequesting, nil);
            }
            return @"";
        }
    }
    NSDictionary *formatedParams = [self _formatRequestParams:params withApi:apiName andUrl:url];//格式化所有请求的参数
    
    //1. 组装manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", @"audio/wav", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = DWKConfigDataInstance.defaultRequestTimeOut;
    if (DWKConfigDataInstance.isUseHeaderSignature) {
        [manager.requestSerializer setValue:[self _signatureParams:formatedParams] forHTTPHeaderField:kParamSignature];
    }
    if (DWKConfigDataInstance.isUseHttpHeaderToken) {
        [manager.requestSerializer setValue:[self _httpToken] forHTTPHeaderField:kParamHttpToken];
    }
    if (OBJECT_ISNOT_EMPTY(httpHeaderParams)) {
        for (NSString *key in [httpHeaderParams allKeys]) {
            NSString *value = httpHeaderParams[key];
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    
    //2. 配置网络请求参数
    NSMutableURLRequest *mutableRequest = nil;
    NSError *serializationError = nil;
    NSString *requestUrlLog = @"";
    if (DWKRequestTypeGET == type) {
        requestUrlLog = [NSString stringWithFormat:@"getting data from \rurl=%@?%@", url, [self _queryRequestParams:formatedParams]];
        mutableRequest = [manager.requestSerializer requestWithMethod:@"GET"
                                                            URLString:url
                                                           parameters:formatedParams
                                                                error:&serializationError];
    }
    else if (DWKRequestTypePOST == type) {
        requestUrlLog = [NSString stringWithFormat:@"posting data to \rurl=%@", url];
        mutableRequest = [manager.requestSerializer requestWithMethod:@"POST"
                                                            URLString:url
                                                           parameters:formatedParams
                                                                error:&serializationError];
    }
    else if (DWKRequestTypeUploadFile == type) {
        requestUrlLog = [NSString stringWithFormat:@"uploading data to \rurl=%@", url];
        mutableRequest = [manager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                         URLString:url
                                                                        parameters:formatedParams
                                                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                             [formData appendPartWithFileData:imageData name:@"file" fileName:@"fileName" mimeType:@"application/octet-stream"];
                                                         }
                                                                             error:&serializationError];
    }
    else if (DWKRequestTypePostBodyData == type) {
        requestUrlLog = [NSString stringWithFormat:@"posting bodydata to \rurl=%@", url];
        NSString *bodyParam = [NSString jsonStringWithObject:formatedParams];
        bodyParam = [self _encryptPostBodyParam:bodyParam];
        mutableRequest = [manager.requestSerializer requestWithMethod:@"POST"
                                                            URLString:url
                                                           parameters:nil
                                                                error:&serializationError];
        mutableRequest.HTTPBody = [bodyParam dataUsingEncoding:manager.requestSerializer.stringEncoding];
    }
    NSLog(@"%@\rparams=\r%@", requestUrlLog, formatedParams);
    
    //3. 创建网络请求出错
    if (serializationError || ! mutableRequest) {
        if (failure) {
            failure(DWKConfigDataInstance.networkErrorRequesFailed, serializationError);
        }
        return @"";
    }
    
    //4. 开始网络请求并返回requestId
    @weakiy(self)
    NSURLSessionTask *task = [manager dataTaskWithRequest:mutableRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [weak_self.requestQueue removeObjectForKey:requestId];//移除网络请求
        if (error) {
            NSInteger statusCode = error.code;
            if (200 == statusCode) {// 服务器无法连接
                if (failure) {
                    failure(DWKConfigDataInstance.networkErrorServerFailed, error);
                }
            }
            else if (-1001 == statusCode) {// 网络连接超时
                if (failure) {
                    failure(DWKConfigDataInstance.networkErrorTimeout, error);
                }
            }
            else if (-1009 == statusCode || -1004 == statusCode) {// 网络处于断开状态
                if (failure) {
                    failure(DWKConfigDataInstance.networkErrorDisconnected, error);
                }
            }
            else if (-999 == statusCode) {// 网络连接取消
                if (failure) {
                    failure(DWKConfigDataInstance.networkErrorCancel, error);
                }
            }
            else {// 其它网络错误
                if (failure) {
                    failure(DWKConfigDataInstance.networkErrorConnectionFailed, error);
                }
            }
        }
        else {
            NSString *responseString = @"";
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            }
            else if ([responseObject isKindOfClass:[NSDictionary class]] ||
                     [responseObject isKindOfClass:[NSArray class]]) {
                responseString = [NSString jsonStringWithObject:responseObject];
            }
            if (OBJECT_ISNOT_EMPTY(responseString) && ( ! [responseString isContains:@"{"])) {
                responseString = [weak_self _decryptResponseString:responseString];
            }
            if (IS_LOG_AVAILABLE) {
                NSString *formatedJsonString = [DWKFormatManager formatPrintJsonStringOnConsole:responseString];
                formatedJsonString = OBJECT_IS_EMPTY(formatedJsonString) ? responseString : formatedJsonString;
                formatedJsonString = [NSString replaceString:formatedJsonString byRegex:@"\\\\/" to:@"/"];
                NSLog(@"%@\rparams=\r%@\rresponseString=\r%@", requestUrlLog, formatedParams, formatedJsonString);
            }
            if ([responseString length] > 0) {
                if (success) {
                    success(responseString);
                }
            }
            else {
                if (failure) {
                    failure(DWKConfigDataInstance.networkErrorReturnEmptyData, nil);
                }
            }
        }
    }];
    [task resume];
    self.requestQueue[requestId] = task;//加入网络请求队列
    return requestId;
}


#pragma mark - private methods
// 格式化请求的url地址
- (NSString *)_formatRequestUrl:(NSString *)url withApi:(NSString *)apiName {
    NSString *tempApiName = [@"/" stringByAppendingPathComponent:apiName];//组装完整的url地址
    return [url stringByAppendingString:tempApiName];
}
// 格式化请求参数
- (NSDictionary *)_formatRequestParams:(NSDictionary *)params
                               withApi:(NSString *)apiName
                                andUrl:(NSString *)url {
    NSMutableDictionary *newDictParam = [NSMutableDictionary dictionary];
    for (NSString *key in params.allKeys) {
        NSObject *value = params[key];
        NSString *newKey = TRIM_STRING(key);
        NSString *newValue = [NSString stringWithFormat:@"%@", OBJECT_IS_EMPTY(value) ? @"" : value];
        newDictParam[newKey] = TRIM_STRING(newValue);
    }
    return newDictParam;
}
// 计算请求参数的签名
- (NSString *)_signatureParams:(NSDictionary *)params {
    NSArray *keys = [[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //0. 按照字典顺序拼接url字符串
    NSMutableString *joinedString = [NSMutableString string];
    for (NSString *key in keys) {
        if ([kParamSignature isEqualToString:key]) {//不对signature进行加密(如果有的话)
            continue;
        }
        [joinedString appendFormat:@"%@%@", TRIM_STRING(key), TRIM_STRING(params[key])];
    }
    
    //1. 对参数进行md5加密
    NSString *newString = [NSString stringWithFormat:@"%@%@", joinedString, TRIM_STRING(self.signatureSecretKey)];
    NSString *signature = [[NSString MD5Encrypt:newString] lowercaseString];
    return signature;
}
// 将请求参数拼接成url字符串
- (NSString *)_queryRequestParams:(NSDictionary *)params {
    return AFQueryStringFromParameters(params);
}
// 计算httpToken参数值
// 采用这种方式：NSString *httpToken = [NSString jsonStringWithObject:param];
// 无法写入http header, why???
- (NSString *)_httpToken {
    NSMutableString *tokenString = [NSMutableString stringWithString:@"{"];
    [tokenString appendFormat:@"\"%@\":\"%@\",", kParamFrom, @"ios"];
    [tokenString appendFormat:@"\"%@\":\"%@\",", kParamAppId, DWKConfigDataInstance.appBundleIdentifier];
    [tokenString appendFormat:@"\"%@\":\"%@\",", kParamAppVersion, DWKConfigDataInstance.appVersion];
    [tokenString appendFormat:@"\"%@\":\"%@\",", kParamAppChannel, DWKConfigDataInstance.appChannel];
    [tokenString appendFormat:@"\"%@\":\"%f\",", kParamLongitude, DWKDataInstance.currentLontitude];
    [tokenString appendFormat:@"\"%@\":\"%f\",", kParamLatitude, DWKDataInstance.currentLatitude];
    [tokenString appendFormat:@"\"%@\":\"%@\",", kParamUdid, DWKDataInstance.udid];
    [tokenString appendFormat:@"\"%@\":\"%@\"}", kParamDeviceToken, DWKDataInstance.deviceToken];
    if (OBJECT_ISNOT_EMPTY(self.httpTokenSecretKey)) {
        NSString *tempString = [NSString DESEncrypt:tokenString byKey:self.httpTokenSecretKey];
        NSLog(@"httpToken string=\r%@", tempString);
        return tempString;
    }
    else {
        return tokenString;
    }
}
// 计算post body的参数值
- (NSString *)_encryptPostBodyParam:(NSString *)bodyParam {
    return bodyParam;
}
// 解密返回值
- (NSString *)_decryptResponseString:(NSString *)responseString {
    return responseString;
}
// 计算请求任务的唯一编号
- (NSString *)_createRequestIdByUrl:(NSString *)url
                            withApi:(NSString *)apiName
                             params:(NSDictionary *)params
                               type:(DWKRequestType)requestType {
    NSString *paramsStr = [NSString jsonStringWithObject:params];
    NSString *tempStr = [NSString stringWithFormat:@"%@_%@_%@_%ld", url, apiName, paramsStr, requestType];
    return [tempStr MD5EncryptString];
}




@end
