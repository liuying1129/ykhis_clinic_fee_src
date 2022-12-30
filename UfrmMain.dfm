object frmMain: TfrmMain
  Left = 192
  Top = 123
  Width = 870
  Height = 450
  Caption = 'frmMain'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 42
    Top = 18
    Width = 59
    Height = 13
    Caption = #26085#26399#33539#22260':'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 392
    Width = 854
    Height = 19
    Panels = <
      item
        Width = 65
      end
      item
        Text = #25805#20316#20154#21592#24037#21495':'
        Width = 80
      end
      item
        Width = 50
      end
      item
        Text = #25805#20316#20154#21592#22995#21517':'
        Width = 80
      end
      item
        Width = 50
      end
      item
        Text = #25480#26435#20351#29992#21333#20301':'
        Width = 80
      end
      item
        Width = 150
      end
      item
        Text = #26381#21153#22120':'
        Width = 45
      end
      item
        Width = 75
      end
      item
        Text = #25968#25454#24211':'
        Width = 45
      end
      item
        Width = 50
      end
      item
        Text = #37096#38376':'
        Width = 35
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 64
    Width = 457
    Height = 321
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object DateTimePicker1: TDateTimePicker
    Left = 104
    Top = 15
    Width = 95
    Height = 21
    Date = 44923.000682870370000000
    Time = 44923.000682870370000000
    TabOrder = 2
    OnChange = DateTimePicker1Change
  end
  object DateTimePicker2: TDateTimePicker
    Left = 216
    Top = 15
    Width = 95
    Height = 21
    Date = 44923.000011574080000000
    Time = 44923.000011574080000000
    TabOrder = 3
    OnChange = DateTimePicker1Change
  end
  object LabeledEdit1: TLabeledEdit
    Left = 104
    Top = 40
    Width = 201
    Height = 21
    EditLabel.Width = 26
    EditLabel.Height = 13
    EditLabel.Caption = #24739#32773
    LabelPosition = lpLeft
    TabOrder = 4
  end
  object TimerIdleTracker: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = TimerIdleTrackerTimer
    Left = 504
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = MyQuery1
    Left = 168
    Top = 136
  end
  object MyQuery1: TMyQuery
    Left = 200
    Top = 136
  end
end
