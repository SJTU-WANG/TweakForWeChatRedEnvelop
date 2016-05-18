
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos
/*
#error iOSOpenDev post-project creation from template requirements (remove these lines after completed) -- \
	Link to libsubstrate.dylib: \
	(1) go to TARGETS > Build Phases > Link Binary With Libraries and add /opt/iOSOpenDev/lib/libsubstrate.dylib \
	(2) remove these lines from *.xm files (not *.mm files as they're automatically generated from *.xm files)

%hook ClassName

+ (id)sharedInstance
{
	%log;

	return %orig;
}

- (void)messageWithNoReturnAndOneArgument:(id)originalArgument
{
	%log;

	%orig(originalArgument);
	
	// or, for exmaple, you could use a custom value instead of the original argument: %orig(customValue);
}

- (id)messageWithReturnAndNoArguments
{
	%log;

	id originalReturnOfMessage = %orig;
	
	// for example, you could modify the original return value before returning it: [SomeOtherClass doSomethingToThisObject:originalReturnOfMessage];

	return originalReturnOfMessage;
}

%end
*/



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "HeaderForWeChatRedEnvelop.h"


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
开关(自)：	1	1	1	1	0	0	0	0
开关(单)：	1	1	0	0	1	1	0	0
开关(群)：	1	0	1	0	1	0	1	0
-----------------------------------------
自单：		1	1	0	0	0	0	0	0
自群：		1	0	1	0	0	0	0	0
他单：		1	1	0	0	1	1	0	0
他群：		1	0	1	0	1	0	1	0
*/

#define STR_FILE_CONFIG @"/var/mobile/Media/iTunes_Control/iTunes/ConfigForWeChatRedEnvelop.plist"
#define STR_KEY_SWITCH_MAIN         @"MainSwitch"       //总开关
#define STR_KEY_SWITCH_MINE         @"MineSwitch"       //'己方'发出的红包
#define STR_KEY_SWITCH_SINGLE       @"SingleSwitch"     //单人（非群）红包
#define STR_KEY_SWITCH_CHAT         @"ChatSwitch"       //群红包
#define STR_KEY_DELAY_SEC           @"DelaySeconds"     //延时时长
#define STR_KEY_PREVENTREVOKEMSG    @"PreventRevokeMsg" //禁止撤回消息


static id readConfig(NSString* strKey)
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:STR_FILE_CONFIG];

    return [dict objectForKey:strKey];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
MMServiceCenter* g_MMServiceCenter = nil;
WCRedEnvelopesLogicMgr* g_WCRedEnvelopesLogicMgr = nil;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CSyncBaseEvent
- (void)NotifyFromPrtl:(unsigned long)arg1 MessageInfo:(id)arg2
{
    //NSLog(@"[### CSyncBaseEvent-NotifyFromPrtl ###] arg1=%lu, arg2=%@", arg1, arg2);

#if 0
    id idValue = readConfig(STR_KEY_SWITCH_MAIN);
    NSLog(@"[### %@=%d[class=%@]", STR_KEY_SWITCH_MAIN, [idValue boolValue], [idValue class]);
    idValue = readConfig(STR_KEY_DELAY_SEC);
    NSLog(@"[### %@=%.2f[class=%@]", STR_KEY_DELAY_SEC, [idValue floatValue], [idValue class]);
#endif

    //判断是否为红包消息
    if ([readConfig(STR_KEY_SWITCH_MAIN) boolValue] && 45 == arg1)
    {
        //判断类型是否为NSDictionary
        if (YES == [arg2 isKindOfClass:[NSDictionary class]])
        {
            id idTemp = [arg2 objectForKey:@"18"];
            if ([NSStringFromClass([idTemp class]) isEqualToString:@"CMessageWrap"])
            {
                CMessageWrap* msgWrap = idTemp;

#if 0
                NSLog(@"111111111111111111111111111111111111111111111111");
                NSLog(@"m_uiEmojiStatFlag:%lu", [msgWrap m_uiEmojiStatFlag]);
                NSLog(@"m_uiSendTime:%lu", [msgWrap m_uiSendTime]);

                NSLog(@"m_nsRealChatUsr:%@", [msgWrap m_nsRealChatUsr]);
                NSLog(@"m_nsMsgSource:%@", [msgWrap m_nsMsgSource]);
                NSLog(@"m_nsPushContent:%@", [msgWrap m_nsPushContent]);
                NSLog(@"m_uiCreateTime:%lu", [msgWrap m_uiCreateTime]);
                NSLog(@"m_uiImgStatus:%lu", [msgWrap m_uiImgStatus]);
                NSLog(@"m_uiStatus:%lu", [msgWrap m_uiStatus]);
                NSLog(@"m_nsContent:%@", [msgWrap m_nsContent]);
                NSLog(@"m_uiMessageType:%lu", [msgWrap m_uiMessageType]);
                NSLog(@"m_nsToUsr:%@", [msgWrap m_nsToUsr]);
                NSLog(@"m_nsFromUsr:%@", [msgWrap m_nsFromUsr]);
                NSLog(@"m_n64MesSvrID:%lld", [msgWrap m_n64MesSvrID]);
                NSLog(@"m_uiMesLocalID:%lu", [msgWrap m_uiMesLocalID]);
                NSLog(@"222222222222222222222222222222222222222222222222");
                NSLog(@"isSentOK:%d", [msgWrap isSentOK]);
                NSLog(@"IsAtMe:%d", [msgWrap IsAtMe]);
                NSLog(@"keyDescription:%@", [msgWrap keyDescription]);
                NSLog(@"IsNeedChatExt:%d", [msgWrap IsNeedChatExt]);
                NSLog(@"GetDisplayContent:%@", [msgWrap GetDisplayContent]);
                NSLog(@"GetMsgClientMsgID:%@", [msgWrap GetMsgClientMsgID]);
                //- (BOOL)IsSameMsgWithFullCheck:(id)arg1;
                //- (BOOL)IsSameMsg:(id)arg1;
                NSLog(@"IsSendBySendMsg:%d", [msgWrap IsSendBySendMsg]);
                NSLog(@"IsAppMessage:%d", [msgWrap IsAppMessage]);
                NSLog(@"IsShortMovieMsg:%d", [msgWrap IsShortMovieMsg]);
                NSLog(@"IsVideoMsg:%d", [msgWrap IsVideoMsg]);
                NSLog(@"IsImgMsg:%d", [msgWrap IsImgMsg]);
                NSLog(@"IsChatRoomMessage:%d", [msgWrap IsChatRoomMessage]);
                NSLog(@"IsMassSendMessage:%d", [msgWrap IsMassSendMessage]);
                NSLog(@"IsBottleMessage:%d", [msgWrap IsBottleMessage]);
                NSLog(@"IsQQMessage:%d", [msgWrap IsQQMessage]);
                NSLog(@"IsSxMessage:%d", [msgWrap IsSxMessage]);
                NSLog(@"GetChatName:%@", [msgWrap GetChatName]);
                NSLog(@"333333333333333333333333333333333333333333333333");
#endif

                if ([msgWrap IsAppMessage])
                {
                    if (49 == [msgWrap m_uiMessageType])
                    {
                        if (NSNotFound != [[msgWrap m_nsContent] rangeOfString:@"![CDATA[微信转账]]"].location)
                        {
                            //NSLog(@"### App消息-转账 ###");
                        }
                        else if (NSNotFound != [[msgWrap m_nsContent] rangeOfString:@"![CDATA[微信红包]]"].location)
                        {
                            //NSLog(@"### App消息-红包 ###");

                            NSLog(@"~~~~~ 天噜啦！快来抢红包啊！！！ ~~~~~");

                            //<nativeurl><![CDATA[wxpay://c2cbizmessagehandler/hongbao/receivehongbao?msgtype=囧&channelid=囧&sendid=囧&sendusername=囧&ver=囧&sign=囧]]></nativeurl>
                            //截取 "wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" 和 "]]></nativeurl>" 之间的内容
                            NSString* strTemp = [msgWrap m_nsContent];
                            NSRange rangeHead = [strTemp rangeOfString:@"<nativeurl><![CDATA["];
                            if (NSNotFound != rangeHead.location)
                            {
                                NSRange rangeTail = [strTemp rangeOfString:@"]]></nativeurl>"];
                                NSRange rangeBody = NSMakeRange(rangeHead.location+rangeHead.length, rangeTail.location-(rangeHead.location+rangeHead.length));

                                NSString* strNativeUrl = [strTemp substringWithRange:rangeBody];
                                //NSLog(@"strNativeUrl[len=%d]=%@", [strNativeUrl length], strNativeUrl);

                                NSRange rangeHead = [strTemp rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?"];
                                if (NSNotFound != rangeHead.location)
                                {
                                    NSRange rangeTail = [strTemp rangeOfString:@"]]></nativeurl>"];
                                    NSRange rangeBody = NSMakeRange(rangeHead.location+rangeHead.length, rangeTail.location-(rangeHead.location+rangeHead.length));

                                    NSString* strTrip = [strTemp substringWithRange:rangeBody];
                                    //NSLog(@"strTrip[len=%d]=%@", [strTrip length], strTrip);

                                    if (nil == g_MMServiceCenter)
                                    {
                                        g_MMServiceCenter = [objc_getClass("MMServiceCenter") defaultCenter]; //getclass method-1: objc_getClass
                                        //NSLog(@"g_MMServiceCenter=%@", g_MMServiceCenter);
                                    }

                                    if (g_MMServiceCenter)
                                    {
                                        //NSLog(@"g_MMServiceCenter=%@", g_MMServiceCenter);
                                        if (nil == g_WCRedEnvelopesLogicMgr)
                                        {
                                            //if ([g_MMServiceCenter respondsToSelector:@selector(getService:)])
                                            //{
                                                g_WCRedEnvelopesLogicMgr = [g_MMServiceCenter getService:NSClassFromString(@"WCRedEnvelopesLogicMgr")]; //getclass method-2: NSClassFromString
                                                //NSLog(@"g_WCRedEnvelopesLogicMgr=%@", g_WCRedEnvelopesLogicMgr);
                                            //}
                                        }

                                        if (g_WCRedEnvelopesLogicMgr)
                                        {
                                            //NSLog(@"g_WCRedEnvelopesLogicMgr=%@", g_WCRedEnvelopesLogicMgr);

                                            CContactMgr* contactMgr = [g_MMServiceCenter performSelector:@selector(getService:) withObject:[objc_getClass("CContactMgr") class]];
                                            CContact* contact = [contactMgr getSelfContact];

                                            BOOL bMsgFromMe = [[msgWrap m_nsFromUsr] isEqualToString:[contact m_nsUsrName]]; //是否为'己方'发出的消息
                                            BOOL bOpenRedEnvelopes = NO; //是否打开红包

                                            if (NO == [msgWrap IsChatRoomMessage]) //非群红包
                                            {
                                                //'己方'给'对方'单发的红包（即非群红包）
                                                if (bMsgFromMe)
                                                {
                                                    if ([readConfig(STR_KEY_SWITCH_SINGLE) boolValue] && [readConfig(STR_KEY_SWITCH_MINE) boolValue])
                                                    {
                                                        bOpenRedEnvelopes = YES;
                                                    }
                                                    else
                                                    {
                                                        NSLog(@"Single RedEnvelop from me, ignore it");
                                                    }
                                                }
                                                //'对方'给'己方'单发的红包
                                                else
                                                {
                                                    if ([readConfig(STR_KEY_SWITCH_SINGLE) boolValue])
                                                    {
                                                        bOpenRedEnvelopes = YES;
                                                    }
                                                    else
                                                    {
                                                        NSLog(@"Single RedEnvelop to me, ignore it");
                                                    }
                                                }
                                            }
                                            else //群红包
                                            {
                                                //'己方'发出的群红包
                                                if (bMsgFromMe)
                                                {
                                                    if ([readConfig(STR_KEY_SWITCH_CHAT) boolValue] && [readConfig(STR_KEY_SWITCH_MINE) boolValue])
                                                    {
                                                        bOpenRedEnvelopes = YES;
                                                    }
                                                    else
                                                    {
                                                        NSLog(@"Chat RedEnvelop from me, ignore it");
                                                    }
                                                }
                                                //'对方'发出的群红包
                                                else
                                                {
                                                    if ([readConfig(STR_KEY_SWITCH_CHAT) boolValue])
                                                    {
                                                        bOpenRedEnvelopes = YES;
                                                    }
                                                    else
                                                    {
                                                        NSLog(@"Chat RedEnvelop to me, ignore it");
                                                    }
                                                }
                                            }

                                            //打开红包
                                            if (bOpenRedEnvelopes)
                                            {
                                                NSDictionary* dictNativeUrl = [%c(WCBizUtil) performSelector:@selector(dictionaryWithDecodedComponets:separator:) withObject:strTrip withObject:@"&"];
#if 0
                                                NSLog(@"dictNativeUrl=%@", dictNativeUrl);

                                                NSLog(@"[contact m_nsHeadImgUrl]:%@", [contact m_nsHeadImgUrl]);
                                                NSLog(@"[contact m_nsUsrName]:%@", [contact m_nsUsrName]);
                                                NSLog(@"[contact m_nsNickName]:%@", [contact m_nsNickName]);
                                                NSLog(@"[contact getContactDisplayUsrName]:%@", [contact getContactDisplayUsrName]);
                                                NSLog(@"[contact getContactDisplayName]:%@", [contact getContactDisplayName]);
#endif
                                                NSMutableDictionary* dictParam = [NSMutableDictionary dictionary];
                                                [dictParam setObject:[dictNativeUrl objectForKey:@"channelid"] forKey:@"channelId"];            //channelId
                                                [dictParam setObject:[contact m_nsHeadImgUrl] forKey:@"headImg"];                               //headImg
                                                [dictParam setObject:[dictNativeUrl objectForKey:@"msgtype"] forKey:@"msgType"];                //msgType
                                                [dictParam setObject:strNativeUrl forKey:@"nativeUrl"];                                         //nativeUrl
                                                [dictParam setObject:[contact getContactDisplayName] forKey:@"nickName"];                       //nickName
                                                [dictParam setObject:[dictNativeUrl objectForKey:@"sendid"] forKey:@"sendId"];                  //sendId
                                                [dictParam setObject:[msgWrap m_nsFromUsr] forKey:@"sessionUserName"];                          //sessionUserName
                                                //NSLog(@"dictParam=%@", dictParam);

                                                //N秒后开抢
                                                double delayInSeconds = [readConfig(STR_KEY_DELAY_SEC) floatValue];
                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                                               {
                                                                   //NSLog(@"抢！抢！抢！");
                                                                   [g_WCRedEnvelopesLogicMgr OpenRedEnvelopesRequest:dictParam];
                                                               });
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    %orig;
}
%end



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//消息撤回相关


#pragma mark - 业务流程日志
/*
微信号缩略规则，目前发现2种
第1种：'前2位' + '*' + '后2位' + '~' + '长度'，如：'abcdefg'，显示为'ab*fg~7'
第2种：'前3位' + '*' + '后3位' + '~' + '长度'，如：'wxi1234567890123m32'，显示为'wxi*m32~19'
*/

/*
--'对方'撤回-'己方'不打开对话框
May 18 18:13:47 5c-840-0001 WeChat[11296] <Warning>: ### CMessageMgr-onRevokeMsg, arg1={m_uiMesLocalID=0, m_ui64MesSvrID=19位ID, m_nsFromUsr=ab*fg~7, m_nsToUsr=wxi*m32~19, m_uiStatus=3, type=10002, msgSource=""}  ###
May 18 18:13:47 5c-840-0001 WeChat[11296] <Warning>: ### CMessageMgr-DelMsg MsgList DelAll, arg1=对方微信号, arg2=(
                                                                                                              "{m_uiMesLocalID=31, m_ui64MesSvrID=19位ID, m_nsFromUsr=ab*fg~7, m_nsToUsr=wxi*m32~19, m_uiStatus=3, type=1, msgSource=\"(null)\"} "
                                                                                                              ), arg3=0 ###

--'对方'撤回-'己方'打开对话框
May 18 18:14:28 5c-840-0001 WeChat[11296] <Warning>: ### CMessageMgr-onRevokeMsg, arg1={m_uiMesLocalID=0, m_ui64MesSvrID=19位ID, m_nsFromUsr=ab*fg~7, m_nsToUsr=wxi*m32~19, m_uiStatus=3, type=10002, msgSource=""}  ###
May 18 18:14:28 5c-840-0001 WeChat[11296] <Warning>: ### BaseMsgContentViewController-OnMsgRevoked, arg1=对方微信号, arg2=19位ID, arg3="对方昵称" 撤回了一条消息 ###
May 18 18:14:28 5c-840-0001 WeChat[11296] <Warning>: ### CMessageMgr-DelMsg MsgList DelAll, arg1=对方微信号, arg2=(
                                                                                                              "{m_uiMesLocalID=33, m_ui64MesSvrID=19位ID, m_nsFromUsr=ab*fg~7, m_nsToUsr=wxi*m32~19, m_uiStatus=4, type=1, msgSource=\"(null)\"} "
                                                                                                              ), arg3=0 ###
May 18 18:14:28 5c-840-0001 WeChat[11296] <Warning>: ### BaseMsgContentLogicController-OnDelMsg MsgWrap, arg1=对方微信号, arg2={m_uiMesLocalID=33, m_ui64MesSvrID=19位ID, m_nsFromUsr=ab*fg~7, m_nsToUsr=wxi*m32~19, m_uiStatus=4, type=1, msgSource="(null)"}  ###
May 18 18:14:28 5c-840-0001 WeChat[11296] <Warning>: ### BaseMsgContentLogicController-OnDelMsg DelAll, arg1=对方微信号, arg2=0 ###
*/


/*
--'己方'撤回
May 18 18:37:16 5c-840-0001 WeChat[11343] <Warning>: ### CMessageMgr-onRevokeMsgCgiReturn, arg1=<ProtobufCGIWrap: 0x193dd5d0> ###
May 18 18:37:16 5c-840-0001 WeChat[11343] <Warning>: ### BaseMsgContentViewController-OnRevokeMsg, arg1=对方微信号, arg2={m_uiMesLocalID=39, m_ui64MesSvrID=19位ID, m_nsFromUsr=wxi*m32~19, m_nsToUsr=ab*fg~7, m_uiStatus=2, type=1, msgSource="(null)"} , arg3=0, arg4=已撤回, arg5= ###
May 18 18:37:16 5c-840-0001 WeChat[11343] <Warning>: ### CMessageMgr-DelMsg MsgList DelAll, arg1=对方微信号, arg2=(
                                                                                                              "{m_uiMesLocalID=39, m_ui64MesSvrID=19位ID, m_nsFromUsr=wxi*m32~19, m_nsToUsr=ab*fg~7, m_uiStatus=2, type=1, msgSource=\"(null)\"} "
                                                                                                              ), arg3=0 ###
May 18 18:37:17 5c-840-0001 WeChat[11343] <Warning>: ### BaseMsgContentLogicController-OnDelMsg MsgWrap, arg1=对方微信号, arg2={m_uiMesLocalID=39, m_ui64MesSvrID=19位ID, m_nsFromUsr=wxi*m32~19, m_nsToUsr=ab*fg~7, m_uiStatus=2, type=1, msgSource="(null)"}  ###
May 18 18:37:17 5c-840-0001 WeChat[11343] <Warning>: ### BaseMsgContentLogicController-OnDelMsg DelAll, arg1=对方微信号, arg2=0 ###
*/


#pragma mark - CMessageDB
%hook CMessageDB

- (void)DelMsg:(id)arg1 MsgList:(id)arg2 DelAll:(BOOL)arg3
{
    //NSLog(@"### CMessageDB-DelMsg MsgList DelAll, arg1=%@, arg2=%@, arg3=%d ###", arg1, arg2, arg3);

    if ([readConfig(STR_KEY_PREVENTREVOKEMSG) boolValue])
    {
        return;
    }

    %orig;
}

%end

/*
#pragma mark - CMessageMgr
%hook CMessageMgr

//'对方'撤回触发
- (void)onRevokeMsg:(id)arg1
{
    NSLog(@"### CMessageMgr-onRevokeMsg, arg1=%@ ###", arg1);
    
    %orig;
}

//'己方'撤回触发
- (void)onRevokeMsgCgiReturn:(id)arg1
{
    NSLog(@"### CMessageMgr-onRevokeMsgCgiReturn, arg1=%@ ###", arg1);
    
    %orig;
}

//任意一方撤销触发
- (void)DelMsg:(id)arg1 MsgList:(id)arg2 DelAll:(BOOL)arg3
{
    NSLog(@"### CMessageMgr-DelMsg MsgList DelAll, arg1=%@, arg2=%@, arg3=%d ###", arg1, arg2, arg3);
    
    %orig;
}

%end
*/


/*
#pragma mark - BaseMessageNodeView
//本机菜单显示"撤回"按钮
%hook BaseMessageNodeView
- (BOOL)canShowRevokeMenu
{
    NSLog(@"### BaseMessageNodeView-canShowRevokeMenu ###");

    BOOL bRet = %orig;

    if ([readConfig(STR_KEY_PREVENTREVOKEMSG) boolValue])
    {
        return YES;
    }

    return bRet;
}
%end
*/


/*
#pragma mark - BaseMsgContentViewController
%hook BaseMsgContentViewController

//判断消息是否可以撤回
- (BOOL)isMsgCanRevoke:(id)arg1
{
    NSLog(@"### BaseMsgContentViewController-isMsgCanRevoke ###");

	BOOL bRet = %orig(arg1);

    if ([readConfig(STR_KEY_PREVENTREVOKEMSG) boolValue])
    {
        return YES;
    }

    return bRet;
}

//打开对话框时，'己方'撤回触发
- (void)OnRevokeMsg:(id)arg1 MsgWrap:(id)arg2 ResultCode:(unsigned long)arg3 ResultMsg:(id)arg4 EducationMsg:(id)arg5
{
    NSLog(@"### BaseMsgContentViewController-OnRevokeMsg, arg1=%@, arg2=%@, arg3=%lu, arg4=%@, arg5=%@ ###", arg1, arg2, arg3, arg4, arg5);

    %orig;
}

//打开对话框时，'对方'撤回触发
- (void)OnMsgRevoked:(id)arg1 n64MsgId:(long long)arg2 SysMsg:(id)arg3
{
    NSLog(@"### BaseMsgContentViewController-OnMsgRevoked, arg1=%@, arg2=%lld, arg3=%@ ###", arg1, arg2, arg3);

    %orig;
}

%end
*/


/*
#pragma mark - BaseMsgContentLogicController
%hook BaseMsgContentLogicController

//打开对话框时，任意一方撤销触发
- (void)OnDelMsg:(id)arg1 MsgWrap:(id)arg2
{
    NSLog(@"### BaseMsgContentLogicController-OnDelMsg MsgWrap, arg1=%@, arg2=%@ ###", arg1, arg2);

    %orig;//不执行的话，当前对话框的内容不会被删除并且能收到系统撤销信息，但是关闭对话框再次打开时，撤销内容消失
}
- (void)OnDelMsg:(id)arg1 DelAll:(BOOL)arg2
{
    NSLog(@"### BaseMsgContentLogicController-OnDelMsg DelAll, arg1=%@, arg2=%d ###", arg1, arg2);

    %orig;//作用不明
}

%end
*/


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
#pragma mark - WCContentItemViewTemplateRedEnvelopesV4
//红包照片去掉毛玻璃
%hook WCContentItemViewTemplateRedEnvelopesV4
- (void)initViewsWithWCDataItem:(id)arg1
{
	%orig;

	UIView* view;
	object_getInstanceVariable(self, "_blurView", (void **)&view);
	if (view)
	{
		[view setHidden:YES];
	}
}
%end
*/
