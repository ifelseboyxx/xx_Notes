//
//  xxDebugViewController.m
//  CoreDataDemo
//
//  Created by lx13417 on 2017/5/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "XXDebugViewController.h"
#import "XXDebugBaseModule.h"
#import "XXDebugBaseAction.h"
#import "UIViewController+PresentInWindow.h"

@interface XXDebugViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvDebug;
@property (weak, nonatomic) IBOutlet UIView *debugBGView;
@property (weak, nonatomic) IBOutlet UIView *bgShadowView;

@property (strong, nonatomic) NSArray <XXDebugBaseModule *> *modules;

@end

@implementation XXDebugViewController

#pragma mark - Init

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XXDebugViewController alloc] initWithNibName:NSStringFromClass(XXDebugViewController.class) bundle:nil];
    });
    return instance;
}

- (NSArray<XXDebugBaseModule *> *)modules {
    if (!_modules) {
        NSMutableArray *mulArr = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DebugModules" ofType:@"plist"];
        NSArray *module = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSString *className in module) {
            Class classModule = NSClassFromString(className);
            [mulArr addObject:[classModule new]];
        }
        _modules = [mulArr copy];
    }
    return _modules;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClick)];
    [self.debugBGView addGestureRecognizer:tap];
    
    self.tvDebug.layer.cornerRadius = 10.0f;
    self.tvDebug.clipsToBounds = YES;
    
    self.bgShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgShadowView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgShadowView.layer.shadowRadius = 5.f;
    self.bgShadowView.layer.shadowOpacity = 0.8f;
    self.bgShadowView.layer.cornerRadius = 10.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tvDebug reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"xxDebugTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    XXDebugBaseModule *module = self.modules[indexPath.row];
    cell.textLabel.text = module.xx_debugTitle;
    cell.detailTextLabel.text = module.xx_debugSubTitle;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXDebugBaseModule *module = self.modules[indexPath.row];
    XXDebugBaseAction *action = [module xx_debugAction];
    [action xx_debugCellDidClickFromViewController:self];
}

#pragma mark - Action

- (void)bgClick {
    [self xx_dismissWithAnimation:YES];
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}
@end
