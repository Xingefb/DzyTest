//
//  DzyImgPicker.h
//  CustomImagePicker
//
//  Created by XG on 16/8/3.
//  Copyright © 2016年 com.lhs. All rights reserved.
//

#import <UIKit/UIKit.h>
/* 
 0 ***** 这里值得说一下的是  LGPhoto和MLPhotoBrowser  给我们提供了很好的方案 但是我在工程中使用发现 和Masonry 一起使用的话会冲突,这里的解决思路是讲 因为 他们分别定义的  UIView 类别 并且名字一样  不管是手动还是 pod  都会出现问题 所以 我退而求其次 修改 LGPhoto 的 #import "UIView+Layout.h"  类别里的名称即可 所以 这个库需要手动导入   (也就是说如果你没自己定义了这个类别也需要注意 如果出现问题可能就是这里出现了冲突)
 1 使用时候会提示 注意警告的地方 便于你修改   只测试了 适配xcode 6.4 7.3 其他版本未安装大家自行测试 
 2 本人喜欢钻研 有现成的就不用重复造轮子 所以提供给大家学习 
 3 个人简书    : 践行丶见远  http://url.cn/29W6WLM
 4 个人github : https://github.com/Xingefb 
 5 最后喜欢的别忘了 评论 转发 点赞 666 
 6 喜欢看书  听歌   旅游  ... 有兴趣相投的可以加我 qq 390676123
 
 */

@protocol  DzyImgDelegate <NSObject>
//代理方式返回数组
- (void)getImages:(NSArray *)imgData;

@end

@interface DzyImgPicker : UIView

//初始化添加父类view进去
- (instancetype)initWithFrame:(CGRect)frame andParentV:(UIViewController *)parentV andMaxNum:(NSInteger )maxNum;
//处理block 返回的图片
@property (nonatomic ) void (^DzyImgs)(NSArray *data);
//从选择器返回的时候需要刷新界面 所以在每次界面将要显示的时候刷新用
@property ( nonatomic) UICollectionView *collectionView;

@property (nonatomic ) id<DzyImgDelegate> dzyImgDelegate;

@end
