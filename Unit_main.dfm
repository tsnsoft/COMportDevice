object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'COM PORT DEVICE, ver. 1.0 [TS]'
  ClientHeight = 356
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Button_ConnectOn: TButton
    Left = 24
    Top = 271
    Width = 273
    Height = 33
    Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1082' '#1087#1086#1088#1090#1072#1084
    TabOrder = 0
    OnClick = Button_ConnectOnClick
  end
  object Memo_Data: TMemo
    Left = 24
    Top = 8
    Width = 273
    Height = 225
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button_ConnectOff: TButton
    Left = 24
    Top = 312
    Width = 273
    Height = 32
    Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1086#1090' '#1087#1086#1088#1090#1086#1074
    TabOrder = 2
    OnClick = Button_ConnectOffClick
  end
  object CheckBox_R: TCheckBox
    Left = 33
    Top = 245
    Width = 129
    Height = 17
    Caption = #1095#1090#1077#1085#1080#1077' '#1080#1079' '#1087#1086#1088#1090#1072
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CheckBox_W: TCheckBox
    Left = 185
    Top = 245
    Width = 113
    Height = 17
    Caption = #1079#1072#1087#1080#1089#1100' '#1074' '#1087#1086#1088#1090
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object Timer_Reader: TTimer
    Enabled = False
    OnTimer = Timer_ReaderTimer
    Left = 120
    Top = 72
  end
  object Timer_Writer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer_WriterTimer
    Left = 120
    Top = 144
  end
end
