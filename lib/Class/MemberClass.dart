class MenberClass {
  int status;
  String msg;
  Data data;

  MenberClass({this.status, this.msg, this.data});

  MenberClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  UserInfo userInfo;
  String shareUrl;

  Data({this.userInfo, this.shareUrl});

  Data.fromJson(Map<String, dynamic> json) {
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
    shareUrl = json['shareUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.toJson();
    }
    data['shareUrl'] = this.shareUrl;
    return data;
  }
}

class UserInfo {
  int userId;
  String nickName;
  String headImg;
  String userName;
  String userPhone;
  String userPass;
  int userType;
  int userMoney;
  int lockMoney;
  int userScore;
  int lockScore;
  String token;
  int status;
  String openId;
  String lastip;
  int createTime;
  int updateTime;
  int shareCode;
  int aShareCode;
  int aId;
  int bId;
  int dataFlag;

  UserInfo(
      {this.userId,
      this.nickName,
      this.headImg,
      this.userName,
      this.userPhone,
      this.userPass,
      this.userType,
      this.userMoney,
      this.lockMoney,
      this.userScore,
      this.lockScore,
      this.token,
      this.status,
      this.openId,
      this.lastip,
      this.createTime,
      this.updateTime,
      this.shareCode,
      this.aShareCode,
      this.aId,
      this.bId,
      this.dataFlag});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    nickName = json['nick_name'];
    headImg = json['head_img'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userPass = json['user_pass'];
    userType = json['user_type'];
    userMoney = json['user_money'];
    lockMoney = json['lock_money'];
    userScore = json['user_score'];
    lockScore = json['lock_score'];
    token = json['token'];
    status = json['status'];
    openId = json['open_id'];
    lastip = json['lastip'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    shareCode = json['share_code'];
    aShareCode = json['a_share_code'];
    aId = json['a_id'];
    bId = json['b_id'];
    dataFlag = json['data_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['nick_name'] = this.nickName;
    data['head_img'] = this.headImg;
    data['user_name'] = this.userName;
    data['user_phone'] = this.userPhone;
    data['user_pass'] = this.userPass;
    data['user_type'] = this.userType;
    data['user_money'] = this.userMoney;
    data['lock_money'] = this.lockMoney;
    data['user_score'] = this.userScore;
    data['lock_score'] = this.lockScore;
    data['token'] = this.token;
    data['status'] = this.status;
    data['open_id'] = this.openId;
    data['lastip'] = this.lastip;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['share_code'] = this.shareCode;
    data['a_share_code'] = this.aShareCode;
    data['a_id'] = this.aId;
    data['b_id'] = this.bId;
    data['data_flag'] = this.dataFlag;
    return data;
  }
}