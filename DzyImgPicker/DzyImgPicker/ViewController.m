//
//  ViewController.m
//  DzyImgPicker
//
//  Created by XG on 16/8/3.
//  Copyright © 2016年 com.Xg_FB. All rights reserved.
//

#import "ViewController.h"

#import "DzyImgPicker.h"

#define DzyWid ([UIScreen mainScreen].bounds.size.width)
#define DzyHei ([UIScreen mainScreen].bounds.size.height)

@interface ViewController () <DzyImgDelegate>
{
    DzyImgPicker *DzyView;
}

@property (nonatomic ) NSArray *data;

@end

@implementation ViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //从相册返回的话需要刷新下界面
//    [DzyView.collectionView reloadData];
    
}
#pragma - DzyImgDelegate
- (void)getImages:(NSArray *)imgData{
    
    //顺道提一嘴  图片上传的   因为一般到这都是为了上传图片所以我顺道给下实现代码  没有导入AF 所以就用注释的形式实现下
    //写一个数组存储 图片转化成2进制后的数据  _imageDataArray
    /*
     _imageDataArray = [NSMutableArray array];//存储二进制
     
     if (imageArray.count>0) {
     for (int i=0; i<imageArray.count; i++) {
     UIImage *image = imageArray[i];
     imageData = UIImagePNGRepresentation(image);
     NSString * newImageName = [NSString stringWithFormat:@"%@%zi%@", @"Send_image_Name", i, @".jpg"];
     NSString  *jpgPath = NSHomeDirectory();
     jpgPath = [jpgPath stringByAppendingPathComponent:@"Documents"];
     jpgPath = [jpgPath stringByAppendingPathComponent:newImageName];
     [_imageDataArray writeToFile:jpgPath atomically:YES];
     NSLog(@"%@",jpgPath);
     [_imageDataArray addObject:imageData];
     }
     
     
     上传的话用的是  AF3.0   的这个函数
     - (NSURLSessionDataTask *)POST:(NSString *)URLString
     parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
     
     //多张图片上传  简历一个  网络请求类  然后我这里写的是 直接用
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
     
     [manager POST:@"" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     // 上传 多张图片
     for(NSInteger i = 0; i < _imageDataArray.count; i++)
     {
     NSData * imageData = [_imageDataArray objectAtIndex: i];
     // 上传的参数名
     NSString * Name = [NSString stringWithFormat:@"%@%zi", @"Send_image_Name", i+1];
     // 上传filename
     NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
     NSLog(@"%@",fileName);
     
     //  ********** 此处需要注意的是需要传输的数据名称是要和后台的名称一样  Name   fileName
     
     [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
     
     }
     } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
     }];
     
     */
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.data = [NSArray new];
    //此处需要注意  自己计算一下  我设置的每个cell 是60*60  间距10 所以 这里一般是设置 全屏宽度  如有特殊需求自行修改
    DzyView = [[DzyImgPicker alloc] initWithFrame:CGRectMake(0, 160, DzyWid, 200) andParentV:self andMaxNum:9];
    DzyView.dzyImgDelegate = self;
    DzyView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:DzyView];
    
    __weak typeof(self)weakSelf = self;
    [DzyView setDzyImgs:^(NSArray *data) {
        NSLog(@"block --- %lu",(unsigned long)data.count);
        weakSelf.data = data;
        
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
