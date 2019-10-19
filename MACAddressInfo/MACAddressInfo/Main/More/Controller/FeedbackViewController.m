//
//  FeedbackViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/24.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "FeedbackViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <MessageUI/MessageUI.h>
#import "Common.h"
#import <Lottie/Lottie.h>
#import "ImageCollectionCell.h"

@interface FeedbackViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate> {
    LOTAnimationView *_checkboxSelect; // 用来记录当前选中的勾选框
}

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerViewBottom;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel1;
@property (nonatomic, weak) IBOutlet LOTAnimationView *checkbox1;
@property (nonatomic, weak) IBOutlet LOTAnimationView *checkbox2;
@property (nonatomic, weak) IBOutlet LOTAnimationView *checkbox3;
@property (nonatomic, weak) IBOutlet LOTAnimationView *checkbox4;
@property (nonatomic, weak) IBOutlet UILabel *topicLabel1;
@property (nonatomic, weak) IBOutlet UILabel *topicLabel2;
@property (nonatomic, weak) IBOutlet UILabel *topicLabel3;
@property (nonatomic, weak) IBOutlet UILabel *topicLabel4;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel2;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel3;
@property (nonatomic, weak) IBOutlet UICollectionView *imagesCollectionView;
@property (nonatomic, strong) UIImagePickerController *albumImagePicker; // 相册选择器
@property (nonatomic, strong) UIImagePickerController *cameraImagePicker; // 拍照选择器

@property (nonatomic, copy) NSString *logFilePath;
@property (nonatomic, strong) NSArray *checkboxs;
@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) NSMutableArray <UIImage *>*images;

@end

@implementation FeedbackViewController

- (void)dealloc {
    [BTSNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUI];

    if (!IS_NULL_STRING(self.macAddress)) {
        // 选中当前的勾选框
        [self.checkbox1 playFromProgress:0.2 toProgress:0.6 withCompletion:nil];
        // 记录当前选中的勾选框
        _checkboxSelect = self.checkbox1;

        self.textView.text = [NSString stringWithFormat:@"%@ %@", BTSLocalizedString(@"Can't find network card address:", nil), self.macAddress];
        self.placeholderLabel.hidden = YES;
    }
}


#pragma mark - UI

- (void)loadUI {
    self.title = BTSLocalizedString(@"Feedback", nil);
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    self.containerViewBottom.constant = 120;
    
    // 问题点
    self.titleLabel1.text = BTSLocalizedString(@"Please select a topic (required)", nil);
    self.topicLabel1.text = self.topics[0];
    self.topicLabel2.text = self.topics[1];
    self.topicLabel3.text = self.topics[2];
    self.topicLabel4.text = self.topics[3];
    // 问题描述
    self.titleLabel2.text = BTSLocalizedString(@"Issue and comment", nil);
    self.textView.tintColor = THEME_COLOR;
    self.placeholderLabel.text = BTSLocalizedString(@"Please describe the issue in at least ten words", nil);
    // 问题截图
    self.titleLabel3.text = BTSLocalizedString(@"Please provide related image(s)", nil);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.imagesCollectionView.collectionViewLayout = flowLayout;
    // 注册cell
    [self.imagesCollectionView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ImageCollectionCellID];
}


#pragma mark - Data

- (void)loadData {
//    [self redirectNSlogToDocumentFolder];
    
    _checkboxSelect = nil;
    
    [BTSNotificationCenter addObserver:self selector:@selector(textViewTextDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [BTSNotificationCenter addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [BTSNotificationCenter addObserver:self selector:@selector(textViewTextDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    
    self.topics = @[BTSLocalizedString(@"FeedbackTopic1", nil),
                    BTSLocalizedString(@"FeedbackTopic2", nil),
                    BTSLocalizedString(@"FeedbackTopic3", nil),
                    BTSLocalizedString(@"FeedbackTopic4", nil)
                    ];
    self.checkboxs = @[self.checkbox1, self.checkbox2, self.checkbox3, self.checkbox4];
    for (LOTAnimationView *checkbox in self.checkboxs) {
        checkbox.contentMode = UIViewContentModeScaleToFill;
        checkbox.userInteractionEnabled = NO;
        [checkbox setAnimationNamed:@"animation_square_checkbox"];
    }
    
    [self.images addObject:[UIImage imageNamed:@"image_add"]];
}

// MARK: 用户方法,将NSLog的输出信息写入到xxx.log文件中
// 将NSLog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder {
    NSString *logFileName = @"feedback.log";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    self.logFilePath = [documentDirectory stringByAppendingPathComponent:logFileName];
    
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:self.logFilePath error:nil];
    
    // 将log输入到文件
    freopen([self.logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([self.logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    // 读取xxx.log文件内容到字符串中
//    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
//    NSData *logFileData = [NSData dataWithContentsOfFile:self.logFilePath];
//    NSString *logFileContent = [[NSString alloc] initWithData:logFileData encoding:encode];
}

- (void)sendEmailWithRecipients:(NSArray *)Recipients subject:(NSString *)subject {
    // 问题点
    NSString *topic = self.topics.lastObject;
    for (int i = 0; i < self.checkboxs.count; i++) {
        LOTAnimationView *checkbox = self.checkboxs[i];
        if (_checkboxSelect == checkbox) {
            topic = self.topics[i];
            break;
        }
    }
    // 日志
    NSString *feedbackLog = [NSString stringWithFormat:@"设备信息: %@ | %@ | %@", UIDevice.deviceModelName, UIDevice.deviceSystemVersion, UIDevice.deviceName];
    feedbackLog = [feedbackLog stringByAppendingString:[NSString stringWithFormat:@"\nApp信息: %@ | %@", NSBundle.appVersion, NSBundle.appBuildVersion]];
    feedbackLog = [feedbackLog stringByAppendingString:[NSString stringWithFormat:@"\nWiFi信息: %@ | %@", [WiFiManagerInstance wifiName], [WiFiManagerInstance wifiMacAddress]]];
    feedbackLog = [feedbackLog stringByAppendingString:[NSString stringWithFormat:@"\n问题点: %@", topic]];
    NSData *feedbackLogData = [feedbackLog dataUsingEncoding:NSUTF8StringEncoding];
    
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    [mailVC setMailComposeDelegate:self];
    [mailVC setSubject:subject]; // 邮件主题
    [mailVC setToRecipients:Recipients]; // 收件人
//    [mailvc setCcRecipients:@[@"邮箱号码"]]; // 设置抄送人
//    [mailvc setBccRecipients:@[@"邮箱号码"]]; // 设置密抄送
    [mailVC setMessageBody:[self messageForUserReport] isHTML:NO]; // 邮件的正文内容
    [mailVC addAttachmentData:feedbackLogData mimeType:@"txt" fileName:@"feedback.log"];
    // 问题的相关图片
    for (int i = 0; i < self.images.count - 1; i++) {
        UIImage *image = self.images[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [mailVC addAttachmentData:imageData mimeType:@"jpeg" fileName:[NSString stringWithFormat:@"feedback_%d.jpeg", i]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:mailVC animated:YES completion:nil];
    });
}

/** 获取用户反馈的邮件内容 */
- (NSString *)messageForUserReport {
    NSString *content = self.textView.text;
    NSString *message = [NSString stringWithFormat:@"%@ %@\n", BTSLocalizedString(@"Issue or comment:", nil), content];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n", BTSLocalizedString(@"Device model:", nil), UIDevice.deviceModelName]];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n", BTSLocalizedString(@"System version:", nil), UIDevice.deviceSystemVersion]];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"%@ %@(%@)\n", BTSLocalizedString(@"App version:", nil), NSBundle.appVersion, NSBundle.appBuildVersion]];
    return message;
}


#pragma mark - Events

- (IBAction)clickCheckbox:(UITapGestureRecognizer *)gestureRecognizer {
    UIView *view = gestureRecognizer.view;
    
    NSUInteger index = view.tag - 10;
    if (index >= self.checkboxs.count) {
        return;
    }
    // 弹出键盘
    if (!_checkboxSelect) {
        [self.textView becomeFirstResponder];
        [self.scrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    LOTAnimationView *checkbox = self.checkboxs[index];
    if (checkbox == _checkboxSelect) { // 已被选中
        return;
    }
    
    // 1. 取消选中之前的勾选框
    if (_checkboxSelect) {
        [_checkboxSelect setAnimationProgress:0.2];
    }
    // 2. 选中当前的勾选框
    [checkbox playFromProgress:0.2 toProgress:0.6 withCompletion:nil];
    // 3. 记录当前选中的勾选框
    _checkboxSelect = checkbox;
    
    self.rightBarButton.enabled = YES;
}

/** 相册选取 */
- (void)showAlbumPickerTo:(UIViewController *)viewController {
    // 1. 相册权限的处理
    // 判断权限
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
            case PHAuthorizationStatusNotDetermined: { // 若用户未决定,则去请求权限
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 再次判断权限
                        switch (status) {
                                case PHAuthorizationStatusDenied: { // 用户拒绝时,则弹窗提示
                                    
                                }
                                break;
                                
                                case PHAuthorizationStatusRestricted: { // 若受限制,则弹窗提示
                                    
                                }
                                break;
                                
                                case PHAuthorizationStatusAuthorized: { // 用户授权允许
                                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                        [viewController presentViewController:self.albumImagePicker animated:YES completion:nil];
                                    } else {
                                        
                                    }
                                }
                                break;
                                
                            default:
                                break;
                        }
                    });
                }];
            }
            break;
            
            case PHAuthorizationStatusDenied: { // 若用户拒绝,则弹窗提示
                
            }
            break;
            
            case PHAuthorizationStatusRestricted: { // 若受限制,则弹窗提示
                
            }
            break;
            
            case PHAuthorizationStatusAuthorized: { // 用户授权允许
                // 2. 权限允许后,再去跳转页面
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    [viewController presentViewController:self.albumImagePicker animated:YES completion:nil];
                } else {
                    
                }
            }
            break;
            
        default:
            break;
    }
}

/** 拍照选取 */
- (void)showCameraPickerTo:(UIViewController *)viewController {
    // 相机权限的处理
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    // 判断权限
    switch (authStatus) {
            case AVAuthorizationStatusNotDetermined: { // 若用户未决定,则去请求权限
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 再次判断权限
                        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                        switch (status) {
                                case AVAuthorizationStatusDenied: { // 若用户拒绝,则弹窗提示
                                    
                                }
                                break;
                                
                                case AVAuthorizationStatusRestricted: { // 若受限制,则弹窗提示
                                    
                                }
                                break;
                                
                                case AVAuthorizationStatusAuthorized: { // 用户授权允许
                                    // 2. 权限允许后,再去跳转页面
                                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                        [viewController presentViewController:self.cameraImagePicker animated:YES completion:nil];
                                    } else {
                                        
                                    }
                                }
                                break;
                                
                            default:
                                break;
                        }
                    });
                }];
            }
            break;
            
            case AVAuthorizationStatusDenied: { // 若用户拒绝,则弹窗提示
                
            }
            break;
            
            case AVAuthorizationStatusRestricted: { // 若受限制,则弹窗提示
                
            }
            break;
            
            case AVAuthorizationStatusAuthorized: { // 用户授权允许
                // 2. 权限允许后,再去跳转页面
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [viewController presentViewController:self.cameraImagePicker animated:YES completion:nil];
                } else {
                    
                }
            }
            break;
            
        default:
            break;
    }
}

/** 提交反馈 */
- (void)feedbackSend {
    [self.view endEditing:YES];

    // 未选择问题点
    if (!_checkboxSelect) {
        [UIAlertController showAlertWithTitle:nil message:BTSLocalizedString(@"Please select a topic", nil) firstTitle:BTSLocalizedString(@"I got it", nil) firstHandler:nil toController:self];
        return;
    }
    // 未输入描述
    NSString *issueContent = self.textView.text;
    if (issueContent.length < 10) {
        [UIAlertController showAlertWithTitle:nil message:BTSLocalizedString(@"Please describe the issue in at least ten words", nil) firstTitle:BTSLocalizedString(@"I got it", nil) firstHandler:nil toController:self];
        return;
    }
    
    // 发送一封邮件
    if (![MFMailComposeViewController canSendMail]) {
        [UIAlertController showAlertWithTitle:nil message:BTSLocalizedString(@"Please go to \"Settings -> Passwords & Accounts\", then add an account", nil) firstTitle:BTSLocalizedString(@"I got it", nil) firstHandler:nil toController:self];
        return;
    }
    NSString *emailAddress = @"wzqsyk@126.com";
    [self sendEmailWithRecipients:@[emailAddress] subject:BTSLocalizedString(@"User feedback", nil)];
}


#pragma mark - UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.images.count;
    if (count > 4) {
        count = 4;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionCellID forIndexPath:indexPath];
    BTS_WEAK_SELF;
    UIImage *image = self.images[indexPath.row];
    cell.imageView.image = image;
    // 最后一个为添加Cell
    if (indexPath.row == self.images.count - 1) {
        cell.isAddCell = YES;
    } else {
        cell.isAddCell = NO;
    }
    cell.deleteImageBlock = ^{
        [weakSelf.images removeObjectAtIndex:indexPath.row];
        [weakSelf.imagesCollectionView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 最后一个为添加Cell
    if (indexPath.row == self.images.count - 1) {
        BTS_WEAK_SELF;
        [UIAlertController showActionSheetWithTitle:nil message:nil firstTitle:BTSLocalizedString(@"Album", nil) firstHandler:^(UIAlertAction *action) {
            [weakSelf showAlbumPickerTo:weakSelf];
        } secondTitle:BTSLocalizedString(@"Camera", nil) secondHandler:^(UIAlertAction *action) {
            [weakSelf showCameraPickerTo:weakSelf];
        } cancelHandler:nil toController:weakSelf];
    }
}

// MARK: UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 分为几列
    NSUInteger column = 4;
    CGFloat itemW = (BTSWIDTH - ((column + 1) * IMAGE_CELL_MARGIN_HOR)) / (column * 1.0);
    CGFloat itemH = itemW / IMAGE_CELL_RATIO;
    return CGSizeMake(itemW, itemH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(IMAGE_CELL_MARGIN_VER, IMAGE_CELL_MARGIN_HOR, IMAGE_CELL_MARGIN_VER, IMAGE_CELL_MARGIN_HOR);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    // Cell在竖直方向上的最小间隔
    return IMAGE_CELL_MARGIN_VER;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    // Cell在水平方向上的最小间隔
    return IMAGE_CELL_MARGIN_HOR;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    BTS_WEAK_SELF;
    [picker dismissViewControllerAnimated:YES completion:^{
        // 处理图片数据,UIImagePickerControllerEditedImage编辑后的，UIImagePickerControllerOriginalImage原图
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [weakSelf.images insertObject:image atIndex:weakSelf.images.count - 1];
        [weakSelf.imagesCollectionView reloadData];
    }];
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    BTS_WEAK_SELF;
    switch (result) {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
        {
            NSLog(@"Mail sent...");
            [UIAlertController showAlertWithTitle:nil message:BTSLocalizedString(@"Feedback send success", nil) firstTitle:BTSLocalizedString(@"I got it", nil) firstHandler:^(UIAlertAction *action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } toController:self];
        }
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
}


#pragma mark - Notification

- (void)textViewTextDidBeginEditing:(NSNotification *)notification {
    
}

- (void)textViewTextDidChange:(NSNotification *)notification {
    UITextView *textView = notification.object;
    NSString *text = textView.text;
    
    if (text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
    
    text = [text trimAllWhitespace];
    if (IS_NULL_STRING(text)) {
        return;
    }
}

- (void)textViewTextDidEndEditing:(NSNotification *)notification {
    
}


#pragma mark - Getters

- (UIImagePickerController *)albumImagePicker {
    if (!_albumImagePicker) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _albumImagePicker = [[UIImagePickerController alloc] init];
            _albumImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            _albumImagePicker.allowsEditing = YES;
            _albumImagePicker.delegate = self;
            _albumImagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        }
    }
    return _albumImagePicker;
}

- (UIImagePickerController *)cameraImagePicker {
    if (!_cameraImagePicker) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _cameraImagePicker = [[UIImagePickerController alloc] init];
            _cameraImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            _cameraImagePicker.allowsEditing = YES;
            _cameraImagePicker.delegate = self;
            _cameraImagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        }
    }
    return _cameraImagePicker;
}

- (NSMutableArray<UIImage *> *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (UIBarButtonItem *)rightBarButton {
    if (!_rightBarButton) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithTitle:BTSLocalizedString(@"Send", nil) style:UIBarButtonItemStylePlain target:self action:@selector(feedbackSend)];
        _rightBarButton.tintColor = THEME_COLOR;
    }
    return _rightBarButton;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
