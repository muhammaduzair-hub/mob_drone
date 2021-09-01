class DB_Mob{
  final int mid;
  final String mname;
  final DateTime ms_time;
  final DateTime me_time;
  final String desc;
  final int mflag;
  final int did;

  DB_Mob({this.mid, this.mname, this.ms_time, this.me_time, this.desc, this.mflag, this.did});

  factory DB_Mob.fromJson(Map<String, dynamic> json){
    return DB_Mob(
      did: json['mdevice'],
      mname: json['mname'],
     // ms_time: json['ms_time'],
     // me_time: json['me_time'],
      desc: json['mdesc'],
      mflag: json['mflag'],
      mid: json['mid']
    );
  }
}