class CheckAddStatusClass {
  int status;
  String msg;
  List<Data> data;

  CheckAddStatusClass({this.status, this.msg, this.data});

  CheckAddStatusClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  int userId;
  int fansId;
  String wechatId;
  String wechatName;
  String qrcodeImg;
  String headImg;
  int createTime;
  int updateTime;
  int dataFlag;

  Data(
      {this.id,
      this.userId,
      this.fansId,
      this.wechatId,
      this.wechatName,
      this.qrcodeImg,
      this.headImg,
      this.createTime,
      this.updateTime,
      this.dataFlag});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fansId = json['fans_id'];
    wechatId = json['wechat_id'];
    wechatName = json['wechat_name'];
    qrcodeImg = json['qrcode_img'];
    headImg = json['head_img'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    dataFlag = json['data_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['fans_id'] = this.fansId;
    data['wechat_id'] = this.wechatId;
    data['wechat_name'] = this.wechatName;
    data['qrcode_img'] = this.qrcodeImg;
    data['head_img'] = this.headImg;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['data_flag'] = this.dataFlag;
    return data;
  }
}