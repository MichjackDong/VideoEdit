//
//  ViewController.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "ViewController.h"
#import "PlayViewController.h"
#import "HDVideoHanderTool.h"

#define Screen_width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)HDVideoHanderTool *videoHanderTool;

//
@property (nonatomic , copy) NSString *videoPath;

@property (nonatomic , copy) NSString *testOnePath;

@property (nonatomic , copy) NSString *testTwoPath;

@property (nonatomic , copy) NSString *testThreePath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataSource addObjectsFromArray:@[@"裁剪视频",@"压缩视频",@"视频添加水印",@"旋转视频",@"修改视频音乐",@"合并视频",@"视频混音",@"视频变速",@"组合效果"]];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"原视频" style:UIBarButtonItemStyleDone target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.videoHanderTool = [[HDVideoHanderTool alloc] init];
    
    _videoPath = [[NSBundle mainBundle] pathForResource:@"nature.mp4" ofType:nil];
    _testOnePath = [[NSBundle mainBundle] pathForResource:@"test1.mp4" ofType:nil];
    _testTwoPath = [[NSBundle mainBundle] pathForResource:@"test2.mp4" ofType:nil];
    _testThreePath = [[NSBundle mainBundle] pathForResource:@"test3.mp4" ofType:nil];
    
}
- (NSString *)videoFilePath{
    
    return [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%f.mp4", [[NSDate date] timeIntervalSinceReferenceDate]]];
}

- (void)selectLeftAction:(UIBarButtonItem*)item {
    PlayViewController *playVC = [[PlayViewController alloc] init];
    [playVC loadWithFilePath:_videoPath];
    [self.navigationController pushViewController:playVC animated:YES];
    
}
- (void)goPlayVideoWithPath:(NSString *)filePath {
    PlayViewController *playVC = [[PlayViewController alloc] init];
    [playVC loadWithFilePath:filePath];
    [self.navigationController pushViewController:playVC animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
#pragma mark-once 几组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


#pragma mark-once 行内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            [self rangeVideo];
        }
            break;
        case 1:{
            [self compressionVideo];
        }
            break;
        case 2:{
            [self addWaterMarkWithVideo];
        }
            break;
        case 3:{
            [self rotateVideo];
        }
            break;
        case 4:{
            [self replaceMusic];
        }
            break;
        case 5:{
            [self mixVideo];
        }
            break;
        case 6:{
            [self mixSound];
        }
            break;
        case 7:{
            [self speedUpVideo];
        }
            break;
        case 8:{
            [self combinationVideo];
        }
            break;
        default:
            break;
    }
}

#pragma mark - f处理视频方法

//裁剪视频
- (void)rangeVideo {
    [self.videoHanderTool clean];
    NSString *filePath = [self videoFilePath];
    [self.videoHanderTool loadVideoWithPath:_videoPath];
    //CMTimeMake(a,b)    a当前第几帧, b每秒钟多少帧.当前播放时间a/b
   // CMTimeMakeWithSeconds(a,b)    a当前时间,b每秒钟多少帧.
    [_videoHanderTool rangeVideoByTimeRange:CMTimeRangeMake(CMTimeMake(2000, 500), CMTimeMake(2000, 500))];
    WS(ws);
    [_videoHanderTool asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [ws goPlayVideoWithPath:filePath];
        }
    }];
    
}
//压缩视频
- (void)compressionVideo {
     [self.videoHanderTool clean];
     NSString *filePath = [self videoFilePath];
     WS(ws);
     [_videoHanderTool loadVideoWithPath:_videoPath];
     _videoHanderTool.ratio = HDVideoExportRatio640x480;
     _videoHanderTool.videoQuality = 1; // 有两种方法可以压缩
     [_videoHanderTool asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
         if (!error) {
             [ws goPlayVideoWithPath:filePath];
         }
         ws.videoHanderTool.ratio = HDVideoExportRatio640x480;
         ws.videoHanderTool.videoQuality = 0;
     }];
}
//添加水印
- (void)addWaterMarkWithVideo {
    [_videoHanderTool clean];
    NSString *filePath = [self videoFilePath];
    WS(ws);
    [_videoHanderTool loadVideoWithPath:_videoPath];
    
    [_videoHanderTool appendWaterMark:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpg"]]  relativeRect:CGRectMake(0.6, 0.2, 0.3, 0)];
    [_videoHanderTool asyncFinishEditByFilePath:filePath progress:^(float progress) {
        NSLog(@"progress -- %f",progress);
    } complete:^(NSError *error) {
        if (!error) {
            [ws goPlayVideoWithPath:filePath];
        }
    }];
}
//旋转视频
- (void)rotateVideo {
    [_videoHanderTool clean];
    NSString *filePath = [self videoFilePath];
    WS(ws);
    [_videoHanderTool loadVideoWithPath:_videoPath];
    [_videoHanderTool rotateVideoByDegress:180];
    [_videoHanderTool asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [ws goPlayVideoWithPath:filePath];
        }
    }];
    
}

//更换背景音乐
- (void)replaceMusic {
    [_videoHanderTool clean];
    
    NSString *filePath = [self videoFilePath];
    WS(ws);
    [_videoHanderTool loadVideoWithPath:_videoPath];
    [_videoHanderTool replaceSoundBySoundPath:_testThreePath];
    
    [_videoHanderTool asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [ws goPlayVideoWithPath:filePath];
        }
    }];
    
}
//视频片段混合
- (void)mixVideo {
    [_videoHanderTool clean];
    NSString *filePath = [self videoFilePath];
    
    WS(ws);
    [_videoHanderTool loadVideoWithPath:_testThreePath];
    [_videoHanderTool loadVideoWithPath:_testTwoPath];
    
    [_videoHanderTool asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [ws goPlayVideoWithPath:filePath];
        }
    }];
    
}

//视频混音
- (void)mixSound {
    
     [_videoHanderTool clean];
    NSString *filePath = [self videoFilePath];
    
    WS(ws);
    [_videoHanderTool loadVideoWithPath:_videoPath];
    [_videoHanderTool dubbedSoundBySoundPath:_testThreePath];
    
    [_videoHanderTool asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [ws goPlayVideoWithPath:filePath];
        }
    }];
    
}

//视频加速
- (void)speedUpVideo {
   [_videoHanderTool clean];
    NSString *filePath = [self videoFilePath];
    
    WS(ws);
    [_videoHanderTool loadVideoWithPath:_videoPath];
    [_videoHanderTool gearBoxWithScale:3];
    
    [_videoHanderTool asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [ws goPlayVideoWithPath:filePath];
        }
    }];
    
}

- (void)combinationVideo {
    [_videoHanderTool clean];
    NSString *filePath = [self videoFilePath];
    __weak typeof(self) wself = self;
    // 放入原视频，换成1号的音，再把3号视频放入混音,剪其中8秒
    // 拼1号视频，给1号水印,剪其中8秒
    // 拼2号视频，给2号变速
    // 拼3号视频，旋转180,剪其中8秒
    // 把最后的视频再做一个变速
    [_videoHanderTool loadVideoWithPath:_videoPath];
    [_videoHanderTool replaceSoundBySoundPath:_testOnePath];
    [_videoHanderTool dubbedSoundBySoundPath:_testThreePath];
    [_videoHanderTool rangeVideoByTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(3600, 600))];
    
    [_videoHanderTool loadVideoWithPath:_testOnePath];
    [_videoHanderTool appendWaterMark:[UIImage imageNamed:@"waterMark"] relativeRect:CGRectMake(0.7, 0.2, 0.2, 0)];
    [_videoHanderTool rangeVideoByTimeRange:CMTimeRangeMake(CMTimeMake(3600, 600), CMTimeMake(3600, 600))];
    
    [_videoHanderTool loadVideoWithPath:_testTwoPath];
    [_videoHanderTool gearBoxWithScale:2];
    
    [_videoHanderTool loadVideoWithPath:_testThreePath];
    [_videoHanderTool rotateVideoByDegress:180];
    [_videoHanderTool rangeVideoByTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(3600, 600))];
    
    [_videoHanderTool commit];
    [_videoHanderTool gearBoxWithScale:2];
    
    [_videoHanderTool asyncFinishEditByFilePath:filePath progress:^(float progress) {
        NSLog(@"progress --- %f",progress);
    }  complete:^(NSError * error) {
        if (!error) {
            [wself goPlayVideoWithPath:filePath];
        }
    }];

}
@end
