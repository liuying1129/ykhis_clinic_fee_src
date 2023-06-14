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
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 392
    Align = alLeft
    TabOrder = 1
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 407
      Height = 81
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 18
        Top = 18
        Width = 52
        Height = 13
        Caption = #26085#26399#33539#22260
      end
      object Label5: TLabel
        Left = 180
        Top = 19
        Width = 7
        Height = 13
        Caption = '-'
      end
      object DateTimePicker1: TDateTimePicker
        Left = 80
        Top = 15
        Width = 95
        Height = 21
        Date = 44923.000011574080000000
        Time = 44923.000011574080000000
        TabOrder = 0
        OnChange = DateTimePicker1Change
      end
      object DateTimePicker2: TDateTimePicker
        Left = 192
        Top = 15
        Width = 95
        Height = 21
        Date = 44923.999988425920000000
        Time = 44923.999988425920000000
        TabOrder = 1
        OnChange = DateTimePicker1Change
      end
      object LabeledEdit1: TLabeledEdit
        Left = 80
        Top = 40
        Width = 201
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #24739#32773
        LabelPosition = lpLeft
        TabOrder = 2
        OnKeyDown = LabeledEdit1KeyDown
      end
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 82
      Width = 407
      Height = 309
      Align = alClient
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
    end
  end
  object Panel4: TPanel
    Left = 409
    Top = 0
    Width = 445
    Height = 392
    Align = alClient
    TabOrder = 2
    object DBGrid2: TDBGrid
      Left = 1
      Top = 89
      Width = 443
      Height = 302
      Align = alClient
      DataSource = DataSource2
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
    end
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 443
      Height = 88
      Align = alTop
      TabOrder = 1
      object Panel2: TPanel
        Left = 104
        Top = 1
        Width = 338
        Height = 86
        Align = alRight
        TabOrder = 0
        object Label2: TLabel
          Left = 126
          Top = 53
          Width = 7
          Height = 13
          Caption = '='
        end
        object Label3: TLabel
          Left = 231
          Top = 54
          Width = 7
          Height = 13
          Caption = '-'
        end
        object Label4: TLabel
          Left = 38
          Top = 13
          Width = 39
          Height = 13
          Caption = #35745#31639#22120
        end
        object LabeledEdit2: TLabeledEdit
          Left = 142
          Top = 50
          Width = 81
          Height = 21
          EditLabel.Width = 26
          EditLabel.Height = 13
          EditLabel.Caption = #23454#25910
          TabOrder = 0
          OnChange = LabeledEdit2Change
        end
        object LabeledEdit3: TLabeledEdit
          Left = 246
          Top = 50
          Width = 81
          Height = 21
          EditLabel.Width = 26
          EditLabel.Height = 13
          EditLabel.Caption = #25214#36174
          Enabled = False
          TabOrder = 1
        end
        object LabeledEdit4: TLabeledEdit
          Left = 38
          Top = 50
          Width = 81
          Height = 21
          EditLabel.Width = 26
          EditLabel.Height = 13
          EditLabel.Caption = #24212#25910
          Enabled = False
          TabOrder = 2
        end
      end
      object BitBtn1: TBitBtn
        Left = 16
        Top = 32
        Width = 75
        Height = 25
        Caption = #25910#36153
        TabOrder = 1
        OnClick = BitBtn1Click
      end
    end
  end
  object TimerIdleTracker: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = TimerIdleTrackerTimer
    Left = 376
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = MyQuery1
    Left = 168
    Top = 136
  end
  object MyQuery1: TUniQuery
    AfterOpen = MyQuery1AfterOpen
    AfterScroll = MyQuery1AfterScroll
    Left = 200
    Top = 136
  end
  object DataSource2: TDataSource
    DataSet = MyQuery2
    Left = 528
    Top = 168
  end
  object MyQuery2: TUniQuery
    AfterOpen = MyQuery2AfterOpen
    Left = 560
    Top = 168
  end
end
