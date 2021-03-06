//
//  FeaturedViewController.m
//  CKReader
//
//  Created by Tony Borner on 4/17/13.
//  Copyright (c) 2013 CkStudio. All rights reserved.
//

#import "FeaturedViewController.h"

#import "Constants.h"
#import "Downloader.h"
#import "BookAlbum.h"

@interface FeaturedViewController ()

{
    BOOL isLoading;
}

// 列表视图
@property (nonatomic, retain) UITableView *tableView;

// 图书专辑对象列表
@property (nonatomic, retain) NSArray *albums;

// 下载工具对象
@property (nonatomic, retain) Downloader *downloader;
// 图片加载队列
@property (nonatomic, retain) NSOperationQueue *operationQueue;
// 占位图
@property (nonatomic, retain) UIImage *loadingImage;

// 下拉刷新文字标签
@property (nonatomic, retain) UILabel *refreshLabel;

// 刷新列表
-(void)refresh;

// 加载图片的invocation方法（将gcd应拆成两部分的方法合并为一个调用）
-(void)operationForLoadingThumbnailImageForBookAlbum:(BookAlbum *)album;

// 加载图片
-(void)loadThumbnailImageForBookAlbum:(BookAlbum *)album;

// 刷新列表中的图片
-(void)refreshThumbnailImageForBookAlbum:(BookAlbum *)album;

// 刷新列表中的图片（主线程部分）
-(void)refreshThumbnailImageForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation FeaturedViewController

@synthesize tableView = _tableView;
@synthesize downloader = _downloader;
@synthesize albums = _albums;
@synthesize operationQueue = _operationQueue;
@synthesize loadingImage = _loadingImage;
@synthesize refreshLabel = _refreshLabel;

-(void)dealloc
{
    // 清理所有属性对象及其代理
    [_tableView release];
    [_downloader setDelegate:nil];
    [_downloader release];
    [_albums release];
    [_operationQueue release];
    [_loadingImage release];
    [_refreshLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 设置当前界面的背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置当前界面的标题
    self.navigationItem.title = @"电影频道";
    
    // 刷新按钮
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.leftBarButtonItem = refreshButton;
    [refreshButton release];
    
    // 返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"电影" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
    
    // 创建分类切换控件
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"北美排行", @"评分最高", nil]];
    segmentControl.frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
    segmentControl.segmentedControlStyle = UISegmentedControlNoSegment;
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(toggleSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    [segmentControl release];

    // 创建table view
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 50.0, CKINTERFACEWIDTH, CKINTERFACEHEIGHT-50.0) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
    
    // 读取占位图
    self.loadingImage = [UIImage imageNamed:@"loading_image.png"];
    
    // 创建refreshLabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, -70.0, 320.0, 70.0)];
    label.font = [UIFont systemFontOfSize:20.0];
    label.text = @"继续下拉刷新列表";
    label.textAlignment = NSTextAlignmentCenter;
    self.refreshLabel = label;
    [self.tableView addSubview:label];
    [label release];
    
    // refreshLabel的文字变化需要根据此变量判断是否已经在加载了
    isLoading = NO;
    
    // 开始网络请求
    [self refresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 解决UIViewController子类管理UITableView时，返回当前界面不清除选中单元格的问题
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource protocol methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albums count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 标识符
    static NSString *identifier = @"BookAlbumCell";
    
    // 重用或创建
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    
    // 获得当前图书专辑对象
    BookAlbum *album = [self.albums objectAtIndex:indexPath.row];
    
    // 设置cell的属性
    cell.textLabel.text = [NSString stringWithFormat:@"%@. %@", album.bookAlbumID, album.bookAlbumName];
    cell.detailTextLabel.text = album.bookAlbumDescription;
    cell.detailTextLabel.numberOfLines = 3;
    if (album.bookAlbumThumbnail) {
        cell.imageView.image = album.bookAlbumThumbnail;
    }
    else
    {
        // 占位图
        cell.imageView.image = self.loadingImage;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate protocol methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - DownloaderDelegate protocol methods

-(void)downloaderDidFinish:(Downloader *)downloader
{
    // 停止加载状态图标
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 不管解析结果如何，都先清除结果对象数组
    self.albums = nil;
    
    // 下拉刷新功能：关闭isLoading实例变量
    isLoading = NO;
    // 下拉刷新功能：将refreshLabel文字重置
    self.refreshLabel.text = @"继续下拉刷新列表";
    // 下拉刷新功能：将contentInSet移回原位置
    SEL theSelector = NSSelectorFromString(@"setContentInset:");
    NSInvocation *anInvocation = [NSInvocation
                                  invocationWithMethodSignature:
                                  [UITableView instanceMethodSignatureForSelector:theSelector]];
    
    [anInvocation setSelector:theSelector];
    [anInvocation setTarget:self.tableView];
    
    UIEdgeInsets param1 = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [anInvocation setArgument:&param1 atIndex:2];
    
    [anInvocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
    
    // 开始解析返回数据
    NSObject *document = [NSJSONSerialization JSONObjectWithData:downloader.responseData options:0 error:NULL];
    
    if (document)
    {
        // 获得代表图书专辑信息的结点数组
        NSArray *nodes = [document valueForKeyPath:@"subjects"];
        
        // 用来保存图书专辑信息的可变数组
        NSMutableArray *albums = [NSMutableArray array];
        
        // 加载图片用的请求队列
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        self.operationQueue = queue;
        [queue release];
        
        for (NSDictionary *node in nodes)
        {
            // 创建图书专辑信息对象，并为其设置属性
            BookAlbum *album = [[BookAlbum alloc] init];
            
            // 专辑编号
            album.bookAlbumID = [node objectForKey:@"rank"];
            // 专辑名称
            album.bookAlbumName = [node valueForKeyPath:@"subject.title"];
            // 专辑描述
            album.bookAlbumDescription = [node valueForKeyPath:@"subject.original_title"];
            // 专辑中图书数目
            album.bookAlbumBookCount = [[node objectForKey:@"box"] integerValue];
            // 专辑缩略图地址
            album.bookAlbumThumbnailURLString = [node valueForKeyPath:@"subject.images.small"];
            // 专辑标题图地址
            album.bookAlbumBannerURLString = [node valueForKeyPath:@"subject.images.medium"];
            
            //NSLog(@"《%@》", album.albumName);
            
            // 使用NSOperationQueue加载图片
            
            // 创建NSInvocation对象
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(operationForLoadingThumbnailImageForBookAlbum:)]];
            invocation.target = self;
            invocation.selector = @selector(operationForLoadingThumbnailImageForBookAlbum:);
            // 0号和1号参数为系统预留，我们的参数从2号开始
            [invocation setArgument:&album atIndex:2];
            
            // 封装成NSOperation，再添加到NSOperationQueue中去
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
            [self.operationQueue addOperation:operation];
            [operation release];
            
            // 加入图书专辑对象列表
            [albums addObject:album];
            [album release];
            
        }
        
        // 对结果根据当天放映次数进行排序，并赋给真正的图书专辑对象数组
//        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"showCount" ascending:NO];
//        self.albums = [albums sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        self.albums = albums;
    }
    
    // 刷新列表
    [self.tableView reloadData];
}

-(void)downloaderFailed:(Downloader *)downloader
{
    // 停止加载状态图标
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 网络请求失败，清除结果对象数组
    self.albums = nil;
    
    // 下拉刷新功能：关闭isLoading实例变量
    isLoading = NO;
    // 下拉刷新功能：将refreshLabel文字重置
    self.refreshLabel.text = @"继续下拉刷新列表";
    // 下拉刷新功能：将contentInSet移回原位置
    SEL theSelector = NSSelectorFromString(@"setContentInset:");
    NSInvocation *anInvocation = [NSInvocation
                                  invocationWithMethodSignature:
                                  [UITableView instanceMethodSignatureForSelector:theSelector]];
    
    [anInvocation setSelector:theSelector];
    [anInvocation setTarget:self.tableView];
    
    UIEdgeInsets param1 = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [anInvocation setArgument:&param1 atIndex:2];
    
    [anInvocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
    
    // 刷新列表
    [self.tableView reloadData];
}

#pragma mark - UIScrollView delegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%.1f, %.1f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    
    // 判断是否已经在加载了，如果已经在加载就步修改文字
    if (!isLoading)
    {
        // 判断scrollView.contentOffset.y是否足够小
        if (scrollView.contentOffset.y < -70.0)
        {
            self.refreshLabel.text = @"松开刷新列表";
        }
        else
        {
            self.refreshLabel.text = @"继续下拉刷新列表";
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"%.1f, %.1f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    
    // 判断scrollView.contentOffset.y是否足够小
    if (decelerate && scrollView.contentOffset.y < -70.0)
    {
        self.refreshLabel.text = @"正在刷新列表...";
        isLoading = YES;
        scrollView.contentInset = UIEdgeInsetsMake(70.0f, 0.0f, 0.0f, 0.0f);
        [self refresh];
    }
}

#pragma mark - other methods

-(void)refresh
{
    // 以防万一，清除当前下载工具对象（如果有的话）的delegate属性
    [self.downloader setDelegate:nil];
    
    // 创建网络请求对象
    NSString *urlString = [NSString stringWithFormat:@"%@%@?appkey=%@", kDoubanAPIv2URLString, @"/movie/us_box", kCKBlackBeanSauceAppKey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // 创建新的下载工具对象，并开始网络请求
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.downloader = [Downloader downloaderWithRequest:request delegate:self];
}

// 加载图片的invocation方法（将gcd应拆成两部分的方法合并为一个调用）
-(void)operationForLoadingThumbnailImageForBookAlbum:(BookAlbum *)album
{
    // 加载图片
    [self loadThumbnailImageForBookAlbum:album];
    // 刷新列表中的图片
    [self refreshThumbnailImageForBookAlbum:album];
}

// 加载图片
-(void)loadThumbnailImageForBookAlbum:(BookAlbum *)album
{
    if (!album.bookAlbumThumbnail)
    {
        // 获得请求地址
        NSString *urlString = CKINTERFACEISRETINA ? album.bookAlbumBannerURLString : album.bookAlbumThumbnailURLString;
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        
        // 缩放成70x100大小（非retina）或140x200（retina）
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat preferredWidth = CKINTERFACEISRETINA ? 140.0 : 70.0;
        CGFloat preferredHeight = CKINTERFACEISRETINA ? 200.0 : 100.0;
        //NSLog(@"%f, %f", width, height);
        CGFloat posX = 0.0;
        CGFloat posY = 0.0;
        
//        if ((width/preferredWidth) > (height/preferredHeight))
//        {
//            height = height*preferredWidth/width;
//            width = preferredWidth;
//            posY = (preferredHeight - height)/2;  // 上下居中
//        }
//        else if (width/preferredWidth < height/preferredHeight)
//        {
//            width = width*preferredHeight/height;
//            height = preferredHeight;
//            posX = preferredWidth - width;    // 靠右
//        }
//        else
//        {
//            width = preferredWidth;
//            height = preferredHeight;
//        }
        // 白边不好看，干脆裁了算了
        height = height * preferredWidth/width;
        width = preferredWidth;
        
        // draw cg image
        //NSLog(@"%f, %f, %f, %f", posX, posY, width, height);
        CGSize size = CGSizeMake(preferredWidth, preferredHeight);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(posX,posY,width,height)];
        
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        album.bookAlbumThumbnail = newImage;
    }
}

// 刷新列表中的图片
-(void)refreshThumbnailImageForBookAlbum:(BookAlbum *)album
{
    if (album.bookAlbumThumbnail)
    {
        // 获得当前正在显示的单元格列表
        NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visibleIndexPaths)
        {
            // 获得这个单元格对应的图书专辑对象
            BookAlbum *visibleBookAlbum = [self.albums objectAtIndex:indexPath.row];
            
            // 判断是否是需要刷新的单元格
            if (visibleBookAlbum == album)
            {
                // 判断是否还在当前队列上，如果已经不是了就别反复刷了
                if ([NSOperationQueue currentQueue] == self.operationQueue)
                {
                    [self performSelectorOnMainThread:@selector(refreshThumbnailImageForIndexPath:) withObject:indexPath waitUntilDone:NO];
                }
            }
        }
    }
}

// 刷新列表中的图片（主线程部分）
-(void)refreshThumbnailImageForIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
