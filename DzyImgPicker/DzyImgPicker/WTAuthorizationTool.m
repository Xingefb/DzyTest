//
//  WTAuthorizationTool.m
//  WTAuthorizationTool
//
//  Created by wentianen on 16/7/28.
//  Copyright © 2016年. All rights reserved.
//

#import "WTAuthorizationTool.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation WTAuthorizationTool

#pragma mark - 相册
+ (void)requestImagePickerAuthorization:(void(^)(WTAuthorizationStatus status))callback {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusNotDetermined) { // 未授权
            if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
                [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
            } else {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                    } else if (status == PHAuthorizationStatusDenied) {
                        [self executeCallback:callback status:WTAuthorizationStatusDenied];
                    } else if (status == PHAuthorizationStatusRestricted) {
                        [self executeCallback:callback status:WTAuthorizationStatusRestricted];
                    }
                }];
            }
            
        } else if (authStatus == ALAuthorizationStatusAuthorized) {
            [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
        } else if (authStatus == ALAuthorizationStatusDenied) {
            [self executeCallback:callback status:WTAuthorizationStatusDenied];
        } else if (authStatus == ALAuthorizationStatusRestricted) {
            [self executeCallback:callback status:WTAuthorizationStatusRestricted];
        }
    } else {
        [self executeCallback:callback status:WTAuthorizationStatusNotSupport];
    }
}

#pragma mark - 相机
+ (void)requestCameraAuthorization:(void (^)(WTAuthorizationStatus))callback {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                } else {
                    [self executeCallback:callback status:WTAuthorizationStatusDenied];
                }
            }];
        } else if (authStatus == AVAuthorizationStatusAuthorized) {
            [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
        } else if (authStatus == AVAuthorizationStatusDenied) {
            [self executeCallback:callback status:WTAuthorizationStatusDenied];
        } else if (authStatus == AVAuthorizationStatusRestricted) {
            [self executeCallback:callback status:WTAuthorizationStatusRestricted];
        }
    } else {
        [self executeCallback:callback status:WTAuthorizationStatusNotSupport];
    }
}

#pragma mark - 通讯录
+ (void)requestAddressBookAuthorization:(void (^)(WTAuthorizationStatus))callback {
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusNotDetermined) {
        __block ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        if (addressBook == NULL) {
            [self executeCallback:callback status:WTAuthorizationStatusNotSupport];
            return;
        }
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
            } else {
                [self executeCallback:callback status:WTAuthorizationStatusDenied];
            }
            if (addressBook) {
                CFRelease(addressBook);
                addressBook = NULL;
            }
        });
        return;
    } else if (authStatus == kABAuthorizationStatusAuthorized) {
        [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
    } else if (authStatus == kABAuthorizationStatusDenied) {
        [self executeCallback:callback status:WTAuthorizationStatusDenied];
    } else if (authStatus == kABAuthorizationStatusRestricted) {
        [self executeCallback:callback status:WTAuthorizationStatusRestricted];
    }
}

#pragma mark - callback
+ (void)executeCallback:(void (^)(WTAuthorizationStatus))callback status:(WTAuthorizationStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback) {
                callback(status);
        }
    });
}

@end
