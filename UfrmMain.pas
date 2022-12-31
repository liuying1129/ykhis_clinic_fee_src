unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,StrUtils, ExtCtrls,IniFiles, DB, MemDS, DBAccess,
  MyAccess, Grids, DBGrids, StdCtrls,VirtualTable, Buttons;

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
    DataSource1: TDataSource;
    MyQuery1: TMyQuery;
    DataSource2: TDataSource;
    MyQuery2: TMyQuery;
    Panel3: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    LabeledEdit1: TLabeledEdit;
    DBGrid1: TDBGrid;
    Panel4: TPanel;
    DBGrid2: TDBGrid;
    Panel5: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TimerIdleTrackerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MyQuery1AfterScroll(DataSet: TDataSet);
    procedure MyQuery1AfterOpen(DataSet: TDataSet);
    procedure MyQuery2AfterOpen(DataSet: TDataSet);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
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
    procedure UpdateMyQuery2(const tm_unid:integer);
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

  DateTimePicker1.Date:=Date();
  DateTimePicker2.Date:=Date();

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
  MyQuery2.Connection:=DM.MyConnection1;
end;

procedure TfrmMain.UpdateMyQuery1;
var
  ss:string;
begin
  ss:=ifThen(LabeledEdit1.Text<>'',' and patient_name like ''%'+LabeledEdit1.Text+'%''');

  MyQuery1.Close;
  MyQuery1.SQL.Clear;
  MyQuery1.SQL.Text:='select register_treat_date as 看诊日期,department as 科别,patient_name as 姓名,patient_sex as 性别,patient_age AS 年龄,'+
                     'certificate_type as 证件类型,certificate_num as 证件号码,'+
                     'clinic_card_num as 诊疗卡号,health_care_num as 医保卡号,address as 住址,work_company as 工作单位,work_address as 工作地址,'+
                     'if_marry as 婚否,native_place as 籍贯,telephone as 联系电话,remark as 备注,operator as 医生,register_morning_afternoon as 午别,register_no_type as 号别,patient_unid,unid,creat_date_time,register_operator,audit_doctor,audit_date '+
                     ' from treat_master '+
                     ' where DATE_FORMAT(register_treat_date,''%Y-%m-%d'')>='''+FormatDateTime('YYYY-MM-DD',DateTimePicker1.Date)+''' '+
                     ' and DATE_FORMAT(register_treat_date,''%Y-%m-%d'')<='''+FormatDateTime('YYYY-MM-DD',DateTimePicker2.Date)+''' '+ss;
  MyQuery1.Open;
end;

procedure TfrmMain.DateTimePicker1Change(Sender: TObject);
begin
  UpdateMyQuery1;
end;

procedure TfrmMain.LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key<>13 then exit;

  UpdateMyQuery1;
end;

procedure TfrmMain.MyQuery1AfterScroll(DataSet: TDataSet);
begin
  UpdateMyQuery2(DataSet.fieldbyname('unid').AsInteger);
end;

procedure TfrmMain.UpdateMyQuery2(const tm_unid:integer);
var
  VirtualTable:TVirtualTable;
  cc:Currency;
begin
  cc:=0;
  
  MyQuery2.Close;
  MyQuery2.SQL.Clear;
  MyQuery2.SQL.Text:='select ts.item_type,sum(ts.drug_num*ts.unit_price) as 应收,'+
                     '(select sum(cf.fee) from clinic_fee cf where cf.tm_unid='+inttostr(tm_unid)+' and cf.item_type=ts.item_type) as 已收'+
                     ' from treat_slave ts '+
                     'WHERE ts.tm_unid='+inttostr(tm_unid)+
                     ' GROUP BY ts.item_type';
  MyQuery2.Open;
  
  VirtualTable:=TVirtualTable.Create(nil);
  VirtualTable.Assign(MyQuery2);//clone数据集
  VirtualTable.Open;
  while not VirtualTable.Eof do
  begin
    cc:=cc+(VirtualTable.fieldbyname('应收').AsFloat-VirtualTable.fieldbyname('已收').AsFloat);
    
    VirtualTable.Next;
  end;
  VirtualTable.Close;
  VirtualTable.Free;

  LabeledEdit4.Text:=floattostr(cc);
end;

procedure TfrmMain.MyQuery1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;

  dbgrid1.Columns.Items[0].Width:=72;//看诊日期
  dbgrid1.Columns.Items[1].Width:=42;//科别
  dbgrid1.Columns.Items[2].Width:=42;//姓名
  dbgrid1.Columns.Items[3].Width:=30;//性别
  dbgrid1.Columns.Items[4].Width:=30;//年龄
  dbgrid1.Columns.Items[5].Width:=55;//证件类型
  dbgrid1.Columns.Items[6].Width:=130;//证件号码
  dbgrid1.Columns.Items[7].Width:=130;//诊疗卡号
  dbgrid1.Columns.Items[8].Width:=130;//医保卡号
  dbgrid1.Columns.Items[9].Width:=120;//住址
  dbgrid1.Columns.Items[10].Width:=120;//工作单位
  dbgrid1.Columns.Items[11].Width:=120;//工作地址
  dbgrid1.Columns.Items[12].Width:=42;//婚否
  dbgrid1.Columns.Items[13].Width:=55;//籍贯
  dbgrid1.Columns.Items[14].Width:=80;//联系电话
  dbgrid1.Columns.Items[15].Width:=100;//备注
end;

procedure TfrmMain.MyQuery2AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;

  dbgrid2.Columns.Items[0].Width:=72;//看诊日期
  dbgrid2.Columns.Items[1].Width:=52;//科别
  dbgrid2.Columns.Items[2].Width:=52;//金额
end;

procedure TfrmMain.LabeledEdit2Change(Sender: TObject);
var
  aa,bb:Double;
begin
  if not TryStrToFloat(LabeledEdit2.Text,aa) then exit;
  if not TryStrToFloat(LabeledEdit4.Text,bb) then exit;
  
  LabeledEdit3.Text:=FloatToStr(aa-bb);
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  VirtualTable:TVirtualTable;
  cc:Currency;
begin
  VirtualTable:=TVirtualTable.Create(nil);
  VirtualTable.Assign(MyQuery2);//clone数据集
  VirtualTable.Open;
  while not VirtualTable.Eof do
  begin
    cc:=VirtualTable.fieldbyname('应收').AsFloat-VirtualTable.fieldbyname('已收').AsFloat;
    if cc<=0 then begin VirtualTable.Next;continue;end;

    ExecSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'insert into clinic_fee (tm_unid,item_type,operator,fee) values ('+MyQuery1.fieldbyname('unid').AsString+','''+VirtualTable.fieldbyname('item_type').AsString+''','''+operator_name+''','+floattostr(cc)+')');

    VirtualTable.Next;
  end;
  VirtualTable.Close;
  VirtualTable.Free;
end;

end.
