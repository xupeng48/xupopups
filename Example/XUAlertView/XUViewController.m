//
//  XUViewController.m
//  XUAlertView
//
//  Created by xupeng on 01/24/2019.
//  Copyright (c) 2019 xupeng. All rights reserved.
//

#import "XUViewController.h"
#import <XUAlertView/XUAlertView.h>
#import <XUAlertView/UIColor+XUAlert.h>

@interface XUViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XUViewController

- (void)viewDidLoad {
    self.dataArray = [@[
                        @{
                            @"view" : @"icon && config message",
                            @"button" : @"Recommend+HalfWidth && NotRecommend+HalfWidth"
                            },
                        @{
                            @"view" : @"headerView && customView",
                            @"button" : @"Recommend+Full"
                            },
                        @{
                            @"view" : @"headerView",
                            @"button" : @"Recommend+HalfWidth && NotRecommend+HalfWidth"
                            },
                        @{
                            @"view" : @"config mseeage && custom",
                            @"button" : @"Recommend+HalfWidth && NotRecommend+HalfWidth"
                            },
                        @{
                            @"view" : @"config mseeage",
                            @"button" : @"Recommend+HalfWidth && custom"
                            },
                        @{
                            @"view" : @"custom",
                            @"button" : @"Recommend+Full"
                            },
                        @{
                            @"view" : @"suger",
                            @"button" : @"Recommend+Full"
                            },
                        @{
                            @"view" : @"suger",
                            @"button" : @"NotRecommend+HalfWidth+NotRecommend+HalfWidth"
                            },
                        ] copy];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = dic[@"view"];
    cell.detailTextLabel.text = dic[@"button"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *alertString = [NSString stringWithFormat:@"showAlert%ld", (long)indexPath.row + 1];
    SEL selector = NSSelectorFromString(alertString);
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selector);
}


// MARK: - alert

- (void)showAlert1 {
    XUAlertAction *confirmAction = [XUAlertAction actionHalfWidthWithTitle:@"前往查看" style:XUAlertActionStyleRecommend];
    XUAlertAction *cancelAction = [XUAlertAction actionHalfWidthWithTitle:@"取消" style:XUAlertActionStyleNotRecommend];
    XUAlertView *alert = [XUAlertView alertWithIconImage:[UIImage imageNamed:@"alertSucceedYellow"]
                                             headerImage:nil
                                                   title:@"兑换成功"
                                                 message:@"您已成功领取专辑《矮大紧指北》\n可在“我的-已购项目”中查看哦"
                                              customView:nil];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [alert display];
}

- (void)showAlert2 {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 116)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notificationAlertHot"]];
    image1.frame = CGRectMake(20, 6.5, 32, 32);
    image1.layer.cornerRadius = 16.0f;
    image1.layer.masksToBounds = YES;
    [view addSubview:image1];
    UILabel *lable1 = [UILabel new];
    lable1.text = @"热门推荐提醒";
    lable1.font = [UIFont systemFontOfSize:16.0f];
    lable1.textColor = [UIColor XUAlertColorWithString:@"#333333"];
    lable1.frame = CGRectMake(68, 0, 200, 22);
    [view addSubview:lable1];
    UILabel *lable2 = [UILabel new];
    lable2.text = @"重要新闻、热门内容即时推送";
    lable2.font = [UIFont systemFontOfSize:13.0f];
    lable2.textColor = [UIColor XUAlertColorWithString:@"#999999"];
    lable2.frame = CGRectMake(68, 27, 200, 18);
    [view addSubview:lable2];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notificationAlertFavourite"]];
    image2.frame = CGRectMake(20, 6.5 + 45 + 26, 32, 32);
    image2.layer.cornerRadius = 16.0f;
    image2.layer.masksToBounds = YES;
    [view addSubview:image2];
    UILabel *lable3 = [UILabel new];
    lable3.text = @"收藏更新提醒";
    lable3.font = [UIFont systemFontOfSize:16.0f];
    lable3.textColor = [UIColor XUAlertColorWithString:@"#333333"];
    lable3.frame = CGRectMake(68, 45 + 26, 200, 22);
    [view addSubview:lable3];
    UILabel *lable4 = [UILabel new];
    lable4.text = @"收藏专辑有更新即时通知";
    lable4.font = [UIFont systemFontOfSize:13.0f];
    lable4.textColor = [UIColor XUAlertColorWithString:@"#999999"];
    lable4.frame = CGRectMake(68, 45 + 26 + 27, 200, 18);
    [view addSubview:lable4];
    
    XUAlertAction *confirmAction = [XUAlertAction actionFullWithTitle:@"去设置开启" style:XUAlertActionStyleRecommend];
    XUAlertView *alert = [XUAlertView alertWithIconImage:nil
                                             headerImage:[UIImage imageNamed:@"notificationAlertBackgorund"]
                                                   title:nil
                                                 message:nil
                                              customView:view];
    [alert addCloseButtonWithAction:nil];
    [alert addAction:confirmAction];
    [alert display];
}

- (void)showAlert3 {
    XUAlertAction *confirmAction = [XUAlertAction actionHalfWidthWithTitle:@"允许" style:XUAlertActionStyleRecommend onClick:^{
        NSLog(@"confirm");
    }];
    XUAlertAction *cancelAction = [XUAlertAction actionHalfWidthWithTitle:@"不允许" style:XUAlertActionStyleNotRecommend];
    XUAlertView *alert = [XUAlertView alertWithIconImage:nil
                                             headerImage:[UIImage imageNamed:@"notificationAlertBackgorund"]
                                                   title:@"流量提醒"
                                                 message:@"当前无WiFi，是否允许流量收听？"
                                              customView:nil];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [alert display];
}

- (void)showAlert4 {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 40.0)];
    
    UIImageView *userIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, 0.0, 40, 40.0)];
    userIconImageView.image = [UIImage imageNamed:@"notificationAlertFavourite"];
    userIconImageView.layer.cornerRadius = 20.0f;
    userIconImageView.layer.masksToBounds = YES;
    [customView addSubview:userIconImageView];
    
    UILabel *loginTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, 0, 280.0 - 72.0, 16.0)];
    loginTypeLabel.textColor = [UIColor XUAlertColorWithString:@"#333333"];
    loginTypeLabel.font = [UIFont systemFontOfSize:14.0f];
    NSMutableAttributedString *loginTypeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"登录方式：%@", @"微信"]];
    [loginTypeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor XUAlertColorWithString:@"#999999"]
                            range:NSMakeRange(0, 5)];
    loginTypeLabel.attributedText = loginTypeString;
    [customView addSubview:loginTypeLabel];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, 24.0, 280.0 - 72.0, 16.0)];
    userNameLabel.textColor = [UIColor XUAlertColorWithString:@"#333333"];
    userNameLabel.font = [UIFont systemFontOfSize:14.0f];
    NSMutableAttributedString *userNameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"账号名称：%@", @"weChat"]];
    [userNameString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor XUAlertColorWithString:@"#999999"]
                           range:NSMakeRange(0, 5)];
    userNameLabel.attributedText = userNameString;
    [customView addSubview:userNameLabel];
    
    XUAlertAction *confirmAction = [XUAlertAction actionHalfWidthWithTitle:@"确定" style:XUAlertActionStyleRecommend];
    XUAlertAction *cancelAction = [XUAlertAction actionHalfWidthWithTitle:@"取消" style:XUAlertActionStyleNotRecommend];
    XUAlertView *alert = [XUAlertView alertWithIconImage:nil
                                             headerImage:nil
                                                   title:@"还原蜻蜓"
                                                 message:@"还原蜻蜓后您的登录状态和使用记录等都将清空，但下载文件不会消失。\n如您通过本账号购买过内容，请还原后用该账号重新登录畅听已购内容。"
                                              customView:customView];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    
    NSMutableAttributedString * p1 = [[NSMutableAttributedString alloc] initWithString:@"还原蜻蜓后您的登录状态和使用记录等都将清空，但下载文件不会消失。\n如您通过本账号购买过内容，请还原后用该账号重新登录畅听已购内容。"];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing = 8.0f;
    [p1 addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, p1.length)];
    [alert addExtraConfig:^(UILabel *titleLabel, UILabel *messageLabel) {
        [messageLabel setAttributedText:p1];
    }];
    [alert display];
}

- (void)showAlert5 {
    XUAlertAction *confirmAction = [XUAlertAction actionFullWithTitle:@"先去登录" style:XUAlertActionStyleRecommend];
    XUAlertAction *cancelAction = [XUAlertAction actionCustomWithTitle:@"仅在本设备购买" config:^(UIButton *configButton) {
        [configButton setFrame:CGRectMake(0, 0, 0, 18)];
        configButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }];
    XUAlertView *alert = [XUAlertView alertWithIconImage:nil
                                             headerImage:nil
                                                   title:@"您尚未登录"
                                                 message:@"未登录状态下购买会有以下限制：\n1. 充值的蜻蜓币或金豆豆不能够转移到已存在的蜻蜓账号\n2.会员开通后仅限本设备使用，不能跨平台享受会员权益\n3.APP卸载后充值的虚拟货币、已购内容、会员权益有丢失风险\n4.充值后不能享用优惠券"
                                              customView:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [alert addCloseButtonWithAction:nil];
    [alert addExtraConfig:^(UILabel *titleLabel, UILabel *messageLabel) {
        messageLabel.textAlignment = NSTextAlignmentLeft;
    }];
    [alert display];
}

- (void)showAlert6 {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 164.0)];
    CGFloat y = 8.0;
    UIImageView *userIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((280.0 - 96.0) / 2, y, 96.0, 96.0)];
    userIconImageView.image = [UIImage imageNamed:@"play_page_special_program_placeholder"];
    userIconImageView.layer.cornerRadius = 4.0f;
    userIconImageView.layer.masksToBounds = YES;
    [customView addSubview:userIconImageView];
    y += 96 + 12;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 280.0, 24.0)];
    label1.textColor = [UIColor XUAlertColorWithString:@"#666666"];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14.0f];
    label1.text = @"猜你喜欢此专辑，快加入收藏";
    [customView addSubview:label1];
    y += 24;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 280.0, 24.0)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor XUAlertColorWithString:@"#FD5353"];
    label2.font = [UIFont systemFontOfSize:14.0f];
    label2.text = @"第一时间获取更新提醒哦~";
    [customView addSubview:label2];
    
    XUAlertAction *confirmAction = [XUAlertAction actionFullWithTitle:@"收 藏" style:XUAlertActionStyleRecommend];
    XUAlertView *alert = [XUAlertView alertWithIconImage:nil
                                             headerImage:nil
                                                   title:nil
                                                 message:nil
                                              customView:customView];
    [alert addCloseButtonWithAction:nil];
    [alert addAction:confirmAction];
    [alert display];
}

- (void)showAlert7 {
    //    [XUAlertView showAlertWithTitle:@"欢迎使用蜻蜓FM" message:nil confirmTitle:@"确 定"];
    [XUAlertView showAlertWithTitle:@"欢迎使用蜻蜓FM" message:nil showClose:YES closeClick:nil confirmTitle:@"确 定" confirmStyle:XUAlertActionStyleRecommend confirmClick:^{
        NSLog(@"true1");
    }];
}

- (void)showAlert8 {
    [XUAlertView showAlertWithTitle:@"流量提醒" message:@"当前无WiFi，是否允许流量收听？" cancelTitle:@"取消" cancelClick:^{
        NSLog(@"cancel");
    } confirmTitle:@"确定" confirmClick:^{
        NSLog(@"confirm");
    }];
    UIAlertView *_alertView = [[UIAlertView alloc]
                               initWithTitle:nil message:[NSString stringWithFormat:@"确定删除《晓说》及其中所有节目吗？"]
                               delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alertView show];
}

@end
