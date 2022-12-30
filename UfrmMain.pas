unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,StrUtils, ExtCtrls,IniFiles, DB, MemDS, DBAccess,
  MyAccess, Grids, DBGrids, StdCtrls;

//==为了通过发送消息更新主窗体状态栏而增加==//
const
  WM_UPDATETEXTSTATUS=WM_USER+1;
TYPE
  TWMUpdateTextStatus=TWMSetText;
//=========================================//

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    TimerIdleTracker: TTimer;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    MyQuery1: TMyQuery;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure TimerIdleTrackerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
  private
    { Private declarations }
    //==为了通过发送消息更新主窗体状态栏而增加==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS消息处理函数}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
    //==========================================//
    procedure ReadConfig;
    procedure ReadIni;
    procedure UpdateMyQuery1;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses UfrmLogin, UDM;

{$R *.dfm}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  frmLogin.ShowModal;
  
  ReadConfig;
  UpdateStatusBar(#$2+'0:'+SYSNAME);
  UpdateStatusBar(#$2+'6:'+SCSYDW);
  UpdateStatusBar(#$2+'8:'+g_Server);
  UpdateStatusBar(#$2+'10:'+g_Database);

  TimerIdleTracker.Enabled:=true;//TimerIdleTrackerTimer事件中需用到配置文件变量LoginTime
  
  UpdateMyQuery1;
end;

procedure TfrmMain.updatestatusBar(const text: string);
//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
var
  i,J2Pos,J2Len,TextLen,j:integer;
  tmpText:string;
begin
  TextLen:=length(text);
  for i :=0 to StatusBar1.Panels.Count-1 do
  begin
    J2Pos:=pos(#$2+inttostr(i)+':',text);
    J2Len:=length(#$2+inttostr(i)+':');
    if J2Pos<>0 then
    begin
      tmpText:=text;
      tmpText:=copy(tmpText,J2Pos+J2Len,TextLen-J2Pos-J2Len+1);
      j:=pos(#$2,tmpText);
      if j<>0 then tmpText:=leftstr(tmpText,j-1);
      StatusBar1.Panels[i].Text:=tmpText;
    end;
  end;
end;

procedure TfrmMain.WMUpdateTextStatus(var message: twmupdatetextstatus);
begin
  UpdateStatusBar(pchar(message.Text));
  message.Result:=-1;
end;

procedure TfrmMain.ReadConfig;
begin
  ReadIni();
end;

procedure TfrmMain.ReadIni;
var
  configini:tinifile;

  pInStr,pDeStr:Pchar;
  i:integer;
begin
  //读系统代码
  SCSYDW:=ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select Name from commcode where TypeName=''系统代码'' and ReMark=''授权使用单位'' ');
  if SCSYDW='' then SCSYDW:='2F3A054F64394BBBE3D81033FDE12313';//'未授权单位'加密后的字符串
  //======解密SCSYDW
  pInStr:=pchar(SCSYDW);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(SCSYDW,length(pDeStr));
  for i :=1  to length(pDeStr) do SCSYDW[i]:=pDeStr[i-1];
  //==========

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  ifAutoCheck:=configini.ReadBool('选项','打印处方时自动审核',false);
  LoginTime:=configini.ReadInteger('选项','弹出登录窗口的时间',30);

  configini.Free;
end;

procedure TfrmMain.TimerIdleTrackerTimer(Sender: TObject);
begin
  //自动弹出登录窗口
  if (StopTime>LoginTime) and (FindWindow(PCHAR('TfrmLogin'),PCHAR('登录'))=0) then
    frmLogin.ShowModal;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MyQuery1.Connection:=DM.MyConnection1;
end;

procedure TfrmMain.UpdateMyQuery1;
begin
  MyQuery1.Close;
  MyQuery1.SQL.Clear;
  MyQuery1.SQL.Text:='select register_treat_date as 看诊日期,patient_name as 姓名,patient_sex as 性别,patient_age AS 年龄,'+
                     'certificate_type as 证件类型,certificate_num as 证件号码,'+
                     'clinic_card_num as 诊疗卡号,health_care_num as 医保卡号,address as 住址,work_company as 工作单位,work_address as 工作地址,'+
                     'if_marry as 婚否,native_place as 籍贯,telephone as 联系电话,remark as 备注,operator as 医生,department as 科别,register_morning_afternoon as 午别,register_no_type as 号别,patient_unid,unid,creat_date_time,register_operator,audit_doctor,audit_date '+
                     ' from treat_master '+
                     ' where register_treat_date between :register_treat_date_begin and :register_treat_date_end';
    //if trystrtofloat(LabeledEdit3.Text,f_dosage) then
    //  adotemp12.ParamByName('dosage').Value:=f_dosage
    //else adotemp12.ParamByName('dosage').Value:=null;
  MyQuery1.ParamByName('register_treat_date_begin').Value:=DateTimePicker1.DateTime;
  MyQuery1.ParamByName('register_treat_date_end').Value:=DateTimePicker2.DateTime;
  MyQuery1.Open;
end;

procedure TfrmMain.DateTimePicker1Change(Sender: TObject);
begin
  UpdateMyQuery1;
end;

end.
