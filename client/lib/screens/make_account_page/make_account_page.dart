import 'package:flutter/material.dart';
import 'package:keeping/screens/make_account_page/make_acount_enter_auth_password_page.dart';
import 'package:keeping/screens/make_account_page/utils/make_account_future_methods.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/rounded_modal.dart';

// 계좌 만들기 첫 페이지
class MakeAccountPage extends StatefulWidget {
  MakeAccountPage({super.key});

  @override
  State<MakeAccountPage> createState() => _MakeAccountPageState();
}

class _MakeAccountPageState extends State<MakeAccountPage> {
  bool _agreementResult = false;

  void _setAgreementResult() {
    setState(() {
      _agreementResult = !_agreementResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '계좌 만들기'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('모바일 뱅킹 서비스 이용 약관', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          termsAndConditions(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: _agreementBtn(_setAgreementResult, _agreementResult)
          ),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () {goNext(context, PhoneVerificationPage());},
        isDisabled: !_agreementResult
      ),
    );
  }
}

// 약관 내용 있는 페이지
Widget termsAndConditions() {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: roundedBoxWithShadowStyle(
          shadow: false,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Text(_termsAndConditionsText),
          ),
        ),
      ),
    ),
  );
}

Widget _agreementBtn(setAgreementResult, agreementResult) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _checkIcon(setAgreementResult, agreementResult),
      SizedBox(width: 10,),
      Expanded(child: Text('약관의 내용을 충분히 이해하며 본 상품에 가입함을 확인합니다.', style: TextStyle(fontSize: 17),))
    ]
  );
}

Widget _checkIcon(setAgreementResult, agreementResult) {
  return InkWell(
    onTap: () {
      setAgreementResult();
    },
    child: Container(
      width: 30,
      height: 30,
      decoration: roundedBoxWithShadowStyle(
        border: true,
        borderRadius: 100,
        borderColor: agreementResult ? const Color(0xFF8320E7) : Colors.grey,
        bgColor: agreementResult ? const Color(0xFF8320E7) : Colors.white,
        shadow: false
      ),
      child: Icon(Icons.check, color: agreementResult ? Colors.white : Colors.grey, size: 20,),
    ),
  );
}

// 번호 인증 페이지
class PhoneVerificationPage extends StatefulWidget {
  final _phonAuthFormKey = GlobalKey<FormState>();
  final _verificationFormKey = GlobalKey<FormState>();

  PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  bool _phoneAuthenticationResult = false;
  bool _verificationResult = false;

  String? accessToken;
  String? memberKey;
  // String? phone;

  void _successPhoneAuth() {
    setState(() {
      _phoneAuthenticationResult = true;
    });
  }

  void _failPhoneAuth() {
    setState(() {
      _phoneAuthenticationResult = false;
    });
  }

  void _successVerification() {
    setState(() {
      _verificationResult = true;
    });
  }

  void _failVerification() {
    setState(() {
      _verificationResult = false;
    });
  }

  final _phoneController = TextEditingController();
  final _verificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4NGFiMjY2MS00N2EyLTQ4NmMtOWY3Zi1mOGNkNTkwMGRiMTAiLCJleHAiOjE2OTU3MDM4NzZ9.Pmks2T9tCqjazb4IUgx1GVUCbtOz97DsBBGKrwkGd5c';
    memberKey = '84ab2661-47a2-486c-9f7f-f8cd5900db10';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '계좌 만들기'),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Form(
                          key: widget._phonAuthFormKey,
                          child: renderPhoneNumberFormField(
                            label: '전화번호', 
                            onSaved: (val) async {
                              print('핸드폰번호 입력 => accessToken: $accessToken, memberKey: $memberKey, phone: $val');
                              final response = await phoneCheck(
                                accessToken: accessToken!, 
                                memberKey: memberKey!, 
                                phone: val
                              );
                              if (response != null) {
                                _successPhoneAuth();
                              } else {
                                _failPhoneAuth();
                                roundedModal(context: context, title: '다시 입력해주세요');
                              }
                            }, 
                            validator: (val) {
                              if (val.length < 1) {
                                return '전화번호를 입력해주세요.';
                              }
                              return null;
                            }, 
                            controller: _phoneController
                          )
                        )
                      ),
                      _authenticationBtn(widget._phonAuthFormKey, context, '인증번호 발송'),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Form(
                          key: widget._verificationFormKey,
                          child: renderTextFormField(
                            label: '인증번호', 
                            onSaved: (val) async {
                              final response = await phoneAuth(
                                accessToken: accessToken!, 
                                memberKey: memberKey!, 
                                code: val
                              );
                              if (response != null) {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => MakeAccountEnterAuthPasswordPage()));
                              } else {
                                _failVerification();
                                roundedModal(context: context, title: '인증번호가 틀렸습니다.');
                              }
                            }, 
                            validator: (val) {
                              if (val.length < 1 || val.length > 6) {
                                return '인증번호를 제대로 입력해주세요';
                              }
                              return null;
                            },
                            onChange: (val) {
                              if (val != null && val.length == 6) {
                                _successVerification();
                              } else {
                                _failVerification();
                              }
                            },
                            controller: _verificationController,
                            isNumber: true
                          )
                        )
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '인증하기',
        action: () async {
          if (widget._verificationFormKey.currentState != null && widget._verificationFormKey.currentState!.validate()) {
            widget._verificationFormKey.currentState!.save();
            print('저장완료');
          } else {
            print('저장실패');
            roundedModal(context: context, title: '다시 입력해주세요');
          }
        },
        isDisabled: _phoneAuthenticationResult && _verificationResult ? false : true,
      ),
    );
  }
}

Widget _authenticationBtn(GlobalKey<FormState> formKey, BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 20, left: 10),
    child: ElevatedButton(
      onPressed: () async {
        if (formKey.currentState != null && formKey.currentState!.validate()) {
          formKey.currentState!.save();
          print('저장완료');
        } else {
          print('저장실패');
          roundedModal(context: context, title: '다시 입력해주세요');
        }
      },
      style: _authenticationBtnStyle(),
      child: Text(title),
    )
  );
}

ButtonStyle _authenticationBtnStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: const Color(0xFF8320E7), // 테두리 색상 설정
          width: 2.0, // 테두리 두께 설정
        ),
      )
    ),
    fixedSize: MaterialStateProperty.all<Size>(
      Size(120, 40)
    )
  );
}

// 애니메이션 효과 없이 다음 페이지로 이동하는 함수
void goNext(BuildContext context, Widget path) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2) {
        return path; //변경 필요
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    )
  );
}

const String _termsAndConditionsText = '''
  제1조 목적
  이 약관은 「주식회사 키핑」(이하 "키핑"라 합니다)와 키핑 모바일뱅킹 서비스(이하 "모바일뱅킹 서비스"라 한다)를 이용하는 자(이하 "이용자"라 합니다)간의 서비스이용에 관한 제반 사항을 정함을 목적으로 합니다.

  제2조 용어의 정의
  이 약관에서 사용하는 용어의 의미는 다음 각 호와 같습니다.

  ① ‘모바일뱅킹 서비스’ : 키핑이 배포하는 키핑 스마트폰 모바일앱(이하 "모바일앱"이라 합니다)에서 이용할 수 있는 무선인터넷서비스를 이용한 계좌조회, 자금이체 등의 금융서비스
  ② ‘PIN’ : 모바일뱅킹 가입시 이용자가 직접 지정한 6자리의 숫자가 조합된 개인 인증 비밀번호(Personal Identification Number)
  제3조 모바일뱅킹 서비스의 종류
  ①   키핑이 제공하는 모바일뱅킹 서비스의 종류는 다음과 같습니다.
  1.계좌 개설 및 해지, 거래내역 조회, 이체 서비스
  2.간편이체 서비스 : 자녀에 대한 소액 자금이체 서비스
  3.미션 서비스 : 자녀가 수행한 과제에 따른 이체 서비스
  4.그 외 키핑이 정하는 서비스
  ②  키핑은 모바일뱅킹 서비스가 변경, 추가되는 내용을 모바일앱 또는 인터넷 홈페이지를 통해 알립니다. 다만 서비스가 이용자에게 불리하게 변경 될 경우 그 내용을 사전에 이용자에게 알리고, 약관 변경이 수반되는 경우에는 제 14 조 약관변경 절차를 준용합니다.
  제4조 모바일뱅킹 서비스 신청
  ① 이용자가 스마트폰에 설치한 모바일앱에서 키핑에 회원가입신청을 한 후, 전자금융거래 기본약관과 이 약관의 내용에 동의한 경우 모바일뱅킹 서비스 이용계약이 성립됩니다.
  ② 키핑은 모바일뱅킹 서비스 이용 신청에 다음 각 호의 사유가 있는 경우, 신청에 대해 승낙을 하지 않거나 사후에 모바일뱅킹 서비스 이용계약을 해지할 수 있습니다.
  1.이용자의 본인 확인이 안 되거나 타인의 명의를 이용한 경우
  2.허위 정보의 기재 또는 신청 내용을 정확히 기재하지 않거나 오기 등이 있는 경우
  3.대리인이 개인인 이용자 본인을 대리하여 신청하는 경우
  4.범죄 또는 불법·탈법행위를 목적으로 모바일뱅킹 서비스를 신청하였거나 모바일뱅킹 서비스를 범죄 또는 불법·탈법행위에 이용하는 경우
  ③ 키핑은 위의 사유로 인해 모바일뱅킹 서비스 가입 승인을 유보하거나 가입 후 모바일뱅킹 서비스 이용계약을 해지하는 경우, 부득이한 사유가 없는 한 이용자에게 적절한 방법으로 알리는 것을 원칙으로 합니다.
  제5조 이용 조건
  ① 키핑은 이용자 본인 명의 확인이 완료된 한 대의 스마트폰을 통해 모바일뱅킹 서비스를 이용할 수 있도록 지원하는 것을 원칙으로 합니다.
  ② 이용자가 스마트폰 교체 등 사유로 본인명의 확인이 완료된 스마트폰이 아닌 다른 스마트폰을 통해 모바일뱅킹 서비스를 이용하고자 하는 경우 키핑이 별도로 정하는 기기변경절차를 완료하여야 하며, 기기변경절차가 완료된 후에는 종전 스마트폰으로 모바일뱅킹 서비스를 이용할 수 없습니다.
  제6조 이용시의 본인확인 방법
  ① 키핑은 다음 각 호의 본인확인 방법의 전부 또는 일부가 사전에 키핑에 등록된 자료와 일치할 경우에 이용자 본인으로 인정하고 모바일뱅킹 서비스를 제공합니다.
  1.PIN의 입력
  2.로그인, 비밀번호등 모바일앱 로그인 수단의 입력
  3.휴대폰 본인확인 서비스 등 타 기관 본인확인 서비스의 활용
  4.그 외 이에 준하는 방법
  ② 이용자는 제1항에 따라 등록한 본인인증수단을 키핑이 별도로 정하는 절차에 따라 변경 또는 갱신할 수 있습니다.
  ③ 이용자가 키핑이 별도로 정하는 제1항 제3호의 생체정보를 본인인증수단으로 등록하려면, 휴대폰 본인확인 등으로 스마트폰 점유 확인 및 본인확인을 완료하여야 합니다.
  제7조 신규계좌의 실명확인
  ① 이용자의 실명확인은 비대면 실명확인을 기본으로 합니다.
  ② 키핑은 이용자의 비대면 실명확인을 하는 경우 다음 각 호의 방식을 조합하여 처리합니다.
  1.타 기관 실명확인 결과의 활용 : 휴대폰 본인인증을 통한 타기관 확인결과를 이용
  2.그 외 법규상 허용되는 비대면 실명확인 방법
  ③ 비대면 실명확인절차는 이용자의 계좌개설 신청행위 등 실명확인 원인행위가 있었던 날의 다음 날부터 30일 이내에 완료되어야 합니다.
  ④  키핑은 제시받은 실명확인증표가 금융거래시점 및 실명확인시점에 유효한 실명확인증표인지 여부를 확인합니다.
  제8조 이용계좌 지정 및 이체한도, 이체수수료
  ① 출금, 대출지정계좌 및 통지대상계좌는 반드시 이용자 명의의 키핑 계좌(외화계좌 포함)로 지정하여야 합니다. 단, 일부 서비스의 경우 이용계좌의 지정이 제한될 수 있습니다.
  ② 키핑은 이용자가 사용하는 거래인증수단의 안전성에 따라 <별표 1> 거래인증수단별 보안등급과 같이 이용자에게 보안등급을 부여합니다. 
  ③ 이용자는 자신의 보안등급에 따라 <별표 2> 전자금융 보안등급별 전자금융 이체한도의 범위 내에서 1회 및 1일 이체한도를 지정할 수 있습니다.
  ④ 계좌이체 이용수수료는 <별표 3> 계좌이체 이용수수료에서 정한 바와 같으며, 키핑은 이용자가 계좌이체 서비스를 완료함과 동시에 이용자의 출금계좌에서 이용수수료를 자동출금합니다. 단, 해당 수수료는 키핑이 별도로 정하는 바에 따라 감면될 수 있습니다.
  제9조 모바일뱅킹 서비스 이용의 제한 및 중단, 종료
  1.전자금융거래제한계좌 등록, 기기분실, 도난 등 사고신고가 접수된 경우
  ② 제1항의 경우에는 본인확인을 거쳐 비밀번호를 재설정한 후 모바일뱅킹 서비스를 다시 이용할 수 있습니다.
  ③ 키핑은 모바일뱅킹 서비스가 범죄 또는 불법·탈법행위에 이용되었거나, 이용된 것으로 합리적으로 의심되는 경우에는 최장 10년의 범위에서 해당 이용자에 대한 모바일뱅킹 서비스의 전부 또는 일부를 제한할 수 있습니다.
  ④ 키핑이 제공하는 이용 방법에 의하지 아니하고 이용자가 비정상적인 방법으로 서비스를 이용하거나 시스템에 접근하는 경우 모바일뱅킹 서비스의 전부 또는 일부를 제한할 수 있습니다.
  ⑤ 키핑은 다음 각 호의 어느 하나에 해당하는 사유가 있는 경우 서비스 이용을 일시적으로 중단할 수 있습니다.
  1.키핑 또는 연계기관 등의 설비 유지 · 보수 및 교체 공사 등을 위한 정기 또는 임시 점검의 경우
  2.서비스 또는 운영체제 등의 업그레이드 및 시스템 유지 · 보수 등이 필요한 경우
  3.정전, 제반 설비의 장애 또는 이용량의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 경우
  ⑥ 키핑은 다음 각 호의 어느 하나에 해당하는 사유가 있는 경우 서비스의 전부 또는 일부를 종료할 수 있습니다.
  1.제휴기관과의 계약종료 또는 기타 사업환경의 변화로 인하여 서비스를 계속 제공하기 어려운 경우
  2.특정 사양 이하의 스마트기기에 대한 서비스 지원 종료 등 기술 발전으로 인하여 서비스를 계속 제공하기 어려운 경우
  3.정부의 명령 · 규제 등으로 서비스를 계속 제공하기 어려운 경우
  4.전시, 사변, 천재지변 또는 국가비상사태 등 불가항력적 사유가 있는 경우
  ⑦ 키핑은 제1항, 제4항의 사유로 서비스를 제한하고자 하는 경우 이용자의 거래지시가 있을 때 전자적 장치를 통해 그 내용을 이용자에게 알리며, 제3항 및 제5항, 제6항 각 호의 사유로 서비스 이용을 제한 또는 중단, 종료하고자 하는 경우에는 그 내용을 사전에 알립니다. 다만, 긴급하게 서비스를 제한 또는 중단, 종료할 필요가 있는 경우에는 사후에 알릴 수 있습니다.
  제10조 모바일뱅킹 서비스 해지
  ① 이용자는 모바일앱 내 회원탈퇴 메뉴를 통하여 이 약관에 의하여 키핑과 체결한 모바일뱅킹 서비스 이용계약을 해지하고 키핑 회원에서 탈퇴할 수 있습니다. 단, 이용자가 키핑의 계좌를 보유하고 있는 경우에는 키핑에 보유한 모든 계좌를 해지한 후에 모바일뱅킹 서비스 이용계약의 해지 및 회원 탈퇴가 가능합니다.
  ② 이용자가 제1항에 따라 이용계약을 해지하고 키핑 회원에서 탈퇴하는 경우 해당 계정의 서비스 이용기록은 탈퇴시로부터 5년간 보관됩니다. 이용자는 모바일뱅킹 서비스 탈퇴 후 고객센터를 통하여 키핑이 보관하고 있는 본인의 모바일뱅킹 서비스 이용기록의 조회 및 제공 요청을 할 수 있고, 이 경우 키핑은 요청을 받은 날로부터 2주 이내에 요청받은 이용기록을 제공합니다.
  제11조 키핑의 의무
  ① 키핑은 제9조 및 제10조에서 정한 경우를 제외하고 이 약관에서 정한 바에 따라 계속적이며 안정적인 서비스를 제공합니다.
  ② 키핑은 서비스 장애 시 이를 신속히 복구하여야 합니다.
  ③ 키핑은 이용자가 제공한 개인정보를 서비스 제공목적 이외의 용도로 사용하지 아니하며 철저한 보안으로 이용자의 정보를 성실히 보호하여야 합니다.
  제12조 이용자의 의무
  ① 이용자는 실명, 실명확인번호, 주소, 휴대폰 번호의 변경이 생긴 경우에는 즉시 모바일앱에서 이용자의 회원정보를 변경하여야 합니다. 다만, 모바일앱에서 회원정보 변경이 불가능한 경우에는 고객센터를 통해 유선으로 변경사항을 신고할 수 있습니다.
  ② 이용자는 거래계좌에 관한 접근수단의 도난, 분실, 위조 또는 변조의 사실을 알았거나 기타 거래절차상 비밀을 요하는 사항이 누설되었음을 알았을 때에는 지체없이 이를 키핑에 신고하여야 합니다.
  ③ 이용자는 본인의 스마트폰에 저장된 생체정보가 유출되지 않도록 각별히 주의해야 합니다. 만약, 스마트폰의 도난·분실 등으로 저장된 생체정보가 유출되거나 기타 사고가 발생했을 시에는 즉시 키핑에 그 사실을 통지하여야 합니다.
  제13조 손해배상
  키핑은 이용자에게 손해가 발생한 경우에는 전자금융거래기본약관의 손해배상 및 면책 조항을 준용합니다.

  제14조 약관의 변경
  키핑이 이 약관을 변경하고자 하는 경우에는 전자금융거래기본약관의 약관의 변경 조항을 준용합니다.

  제15조 분쟁조정
  ①  키핑과 이용자는 개인정보에 관한 분쟁이 있는 경우 개인정보보호법 제40조에 따른 개인정보분쟁조정위원회에 조정을 신청할 수 있습니다.
  ② 이 약관과 관련한 소송의 관할법원은 민사소송법상 관할법원으로 합니다
  제16조 준용약관
  이 약관에서 정하지 않은 사항은 전자금융거래기본약관에 따릅니다.
''';
