//
//  AboutViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "AboutViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AboutViewController () <UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UILabel *introLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *introLabelHeight;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) AVSpeechSynthesisVoice *voice;
@property (nonatomic, strong) AVSpeechUtterance *utterance;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    BOOL stop = [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    if (stop) {
        NSLog(@"取消说话成功");
    } else {
        NSLog(@"取消说话失败");
    }
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"About", nil);
    self.versionLabel.text = [NSString stringWithFormat:BTSLocalizedString(@"Version %@", nil), [NSBundle appVersion]];
    self.introLabel.text = BTSLocalizedString(@"App introduce", nil);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellIdentifier"];
    
    CGSize introSize = [self.introLabel.text boundingRectWithSize:CGSizeMake(BTSWIDTH - 30, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;
    self.introLabelHeight.constant = introSize.height + 20;
}


#pragma mark - Data

- (void)loadData {
//    self.titles = @[BTSLocalizedString(@"Features", nil),
//                    BTSLocalizedString(@"Rate", nil)];
}


#pragma mark - Events

- (IBAction)startReadIntroduceContent {
    if (self.synthesizer.isSpeaking) {
        NSLog(@"正在说话中...");
    } else {
        [self.synthesizer speakUtterance:self.utterance];
    }
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - AVSpeechSynthesizerDelegate

// 开始说话了
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"开始说话了");
}

// 说完了
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"说完了");
    
    // 如果想循环播放，可以在该方法里再调用：
    //    [synthesizer speakUtterance:utterance];
}

// 已经暂停说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"已经暂停说话");
}

// 继续说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"继续说话");
}

// 已经取消说话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"已经取消说话");
}

// 将要说某段话
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    NSLog(@"将要说: \"%@\"", [utterance.speechString substringWithRange:characterRange]);
}


#pragma mark - Getters

// TTS: 文本转语音技术(Text To Speech), iOS7之后才有该功能,需要AVFoundation库
- (AVSpeechSynthesizer *)synthesizer {
    if (!_synthesizer) {
        // 1. AVSpeechSynthesizer：这个类表示语音合成器, 就像一个会说话的人, 可以”说话”, 可以”暂停”说话, 可以”继续”说话, 可以判断他当前是否正在说话.
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
        // AVSpeechBoundary: 这个枚举表示 在暂停或者停止说话的时候,停下的方式
        // AVSpeechBoundaryImmediate:立即停  AVSpeechBoundaryWord:说完一个整词再停
//        BOOL stop = [synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
//        BOOL pause = [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
//        BOOL continuee = [self.synthesizer continueSpeaking];
    }
    return _synthesizer;
}

- (AVSpeechSynthesisVoice *)voice {
    if (!_voice) {
        NSString *voiceLanguage = @"en-US";
        NSString *appLanguageCode = [BTSUtil appCurrentLanguageCode];
        if ([appLanguageCode isEqualToString:@"zh"]) {
            voiceLanguage = @"zh-CN";
        }
        // 2. AVSpeechSynthesisVoice：这个类表示说话的声音
        // 根据制定的语言, 获得一个声音
        _voice = [AVSpeechSynthesisVoice voiceWithLanguage:voiceLanguage];
        
        // 获得当前设备支持的声音
//        NSArray *speechVoices = [AVSpeechSynthesisVoice speechVoices];
//        NSLog(@"speechVoices = %@", speechVoices);
        /**
         (
         "[AVSpeechSynthesisVoice 0x60000000d580] Language: ar-SA, Name: Maged, Quality: Default [com.apple.ttsbundle.Maged-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d6c0] Language: cs-CZ, Name: Zuzana, Quality: Default [com.apple.ttsbundle.Zuzana-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d620] Language: da-DK, Name: Sara, Quality: Default [com.apple.ttsbundle.Sara-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d4b0] Language: de-DE, Name: Anna, Quality: Default [com.apple.ttsbundle.Anna-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d5b0] Language: el-GR, Name: Melina, Quality: Default [com.apple.ttsbundle.Melina-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d530] Language: en-AU, Name: Karen, Quality: Default [com.apple.ttsbundle.Karen-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d4e0] Language: en-GB, Name: Daniel, Quality: Default [com.apple.ttsbundle.Daniel-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d5d0] Language: en-IE, Name: Moira, Quality: Default [com.apple.ttsbundle.Moira-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d610] Language: en-US, Name: Samantha, Quality: Default [com.apple.ttsbundle.Samantha-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d650] Language: en-ZA, Name: Tessa, Quality: Default [com.apple.ttsbundle.Tessa-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d5e0] Language: es-ES, Name: Monica, Quality: Default [com.apple.ttsbundle.Monica-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d600] Language: es-MX, Name: Paulina, Quality: Default [com.apple.ttsbundle.Paulina-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d630] Language: fi-FI, Name: Satu, Quality: Default [com.apple.ttsbundle.Satu-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d0c0] Language: fr-CA, Name: Amelie, Quality: Default [com.apple.ttsbundle.Amelie-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d660] Language: fr-FR, Name: Thomas, Quality: Default [com.apple.ttsbundle.Thomas-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d4c0] Language: he-IL, Name: Carmit, Quality: Default [com.apple.ttsbundle.Carmit-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d560] Language: hi-IN, Name: Lekha, Quality: Default [com.apple.ttsbundle.Lekha-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d590] Language: hu-HU, Name: Mariska, Quality: Default [com.apple.ttsbundle.Mariska-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d4d0] Language: id-ID, Name: Damayanti, Quality: Default [com.apple.ttsbundle.Damayanti-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d460] Language: it-IT, Name: Alice, Quality: Default [com.apple.ttsbundle.Alice-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d540] Language: ja-JP, Name: Kyoko, Quality: Default [com.apple.ttsbundle.Kyoko-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d6a0] Language: ko-KR, Name: Yuna, Quality: Default [com.apple.ttsbundle.Yuna-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d4f0] Language: nl-BE, Name: Ellen, Quality: Default [com.apple.ttsbundle.Ellen-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d680] Language: nl-NL, Name: Xander, Quality: Default [com.apple.ttsbundle.Xander-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d5f0] Language: no-NO, Name: Nora, Quality: Default [com.apple.ttsbundle.Nora-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d6b0] Language: pl-PL, Name: Zosia, Quality: Default [com.apple.ttsbundle.Zosia-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d570] Language: pt-BR, Name: Luciana, Quality: Default [com.apple.ttsbundle.Luciana-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d510] Language: pt-PT, Name: Joana, Quality: Default [com.apple.ttsbundle.Joana-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d500] Language: ro-RO, Name: Ioana, Quality: Default [com.apple.ttsbundle.Ioana-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d5c0] Language: ru-RU, Name: Milena, Quality: Default [com.apple.ttsbundle.Milena-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d550] Language: sk-SK, Name: Laura, Quality: Default [com.apple.ttsbundle.Laura-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d440] Language: sv-SE, Name: Alva, Quality: Default [com.apple.ttsbundle.Alva-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d520] Language: th-TH, Name: Kanya, Quality: Default [com.apple.ttsbundle.Kanya-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d690] Language: tr-TR, Name: Yelda, Quality: Default [com.apple.ttsbundle.Yelda-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d670] Language: zh-CN, Name: Ting-Ting, Quality: Default [com.apple.ttsbundle.Ting-Ting-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d640] Language: zh-HK, Name: Sin-Ji, Quality: Default [com.apple.ttsbundle.Sin-Ji-compact]",
         "[AVSpeechSynthesisVoice 0x60000000d5a0] Language: zh-TW, Name: Mei-Jia, Quality: Default [com.apple.ttsbundle.Mei-Jia-compact]"
         )
         */
        
        // 获得当前voice的语言字符串, 比如”zh-HK”
//        NSString *language = [_voice language];
//        NSLog(@"voice language = %@", language);

//        // 获得当前设备所使用系统语言的语言字符串, 比如”en-US”
//        NSString *languageCode = [AVSpeechSynthesisVoice currentLanguageCode];
//        NSLog(@"languageCode = %@", languageCode);
    }
    return _voice;
}

- (AVSpeechUtterance *)utterance {
    if (!_utterance) {
        // 3. AVSpeechUtterance：这个类表示一段要说的话
        NSString *speechStr = self.introLabel.text;
        _utterance = [AVSpeechUtterance speechUtteranceWithString:speechStr];
        _utterance.voice = self.voice; // 使用的声音
        
//        _utterance.rate = AVSpeechUtteranceDefaultSpeechRate; // 读的速度 [0 - 1] Default = 0.5
//        _utterance.pitchMultiplier = 1.0; // 音高, 值越大越像女生的音调  [0.5 - 2] Default = 1
//        _utterance.volume = 1.0; // 音量 [0 - 1] Default = 1
//        _utterance.preUtteranceDelay = 2; // 读一段话之前的停顿时间
//        _utterance.postUtteranceDelay = 5; // 读完一段后的停顿时间
        
        // 声音1
        _utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
        _utterance.pitchMultiplier = 0.8;
    }
    return _utterance;
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
