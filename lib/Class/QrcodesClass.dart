class QrcodesClass {
  int status;
  String msg;
  List<Data> data;

  QrcodesClass({this.status, this.msg, this.data});

  QrcodesClass.fromJson(Map<String, dynamic> json) {
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
  String wechatId;
  String wechatName;
  String userPhone;
  String job;
  String headImg;
  String qrcodeImg;
  String qrcodeUrl;
  String describes;
  int sort;
  int dataFlag;
  int addNum;
  int createTime;
  int updateTime;
  int isred;
  String provinceName;
  String provinceId;
  String cityName;
  String cityId;
  String areaName;
  String areaId;
  int viewType;
  Null addFinishedIds;

  Data(
      {this.id,
      this.userId,
      this.wechatId,
      this.wechatName,
      this.userPhone,
      this.job,
      this.headImg,
      this.qrcodeImg,
      this.qrcodeUrl,
      this.describes,
      this.sort,
      this.dataFlag,
      this.addNum,
      this.createTime,
      this.updateTime,
      this.isred,
      this.provinceName,
      this.provinceId,
      this.cityName,
      this.cityId,
      this.areaName,
      this.areaId,
      this.viewType,
      this.addFinishedIds});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    wechatId = json['wechat_id'];
    wechatName = json['wechat_name'];
    userPhone = json['user_phone'];
    job = json['job'];
    headImg = json['head_img'];
    qrcodeImg = json['qrcode_img'];
    qrcodeUrl = json['qrcode_url'];
    describes = json['describes'];
    sort = json['sort'];
    dataFlag = json['data_flag'];
    addNum = json['add_num'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    isred = json['isred'];
    provinceName = json['province_name'];
    provinceId = json['province_id'];
    cityName = json['city_name'];
    cityId = json['city_id'];
    areaName = json['area_name'];
    areaId = json['area_id'];
    viewType = json['view_type'];
    addFinishedIds = json['addFinishedIds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['wechat_id'] = this.wechatId;
    data['wechat_name'] = this.wechatName;
    data['user_phone'] = this.userPhone;
    data['job'] = this.job;
    data['head_img'] = this.headImg;
    data['qrcode_img'] = this.qrcodeImg;
    data['qrcode_url'] = this.qrcodeUrl;
    data['describes'] = this.describes;
    data['sort'] = this.sort;
    data['data_flag'] = this.dataFlag;
    data['add_num'] = this.addNum;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['isred'] = this.isred;
    data['province_name'] = this.provinceName;
    data['province_id'] = this.provinceId;
    data['city_name'] = this.cityName;
    data['city_id'] = this.cityId;
    data['area_name'] = this.areaName;
    data['area_id'] = this.areaId;
    data['view_type'] = this.viewType;
    data['addFinishedIds'] = this.addFinishedIds;
    return data;
  }
}