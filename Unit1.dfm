object Form1: TForm1
  Left = 390
  Top = 0
  Caption = 'Grafy'
  ClientHeight = 523
  ClientWidth = 1085
  Color = clBtnFace
  Constraints.MaxHeight = 570
  Constraints.MinHeight = 570
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbFinishPoint: TLabel
    Left = 586
    Top = 226
    Width = 19
    Height = 13
    Caption = 'End'
  end
  object lbStartPoint: TLabel
    Left = 586
    Top = 180
    Width = 27
    Height = 13
    Caption = 'Begin'
  end
  object lbTextMaxWay: TLabel
    Left = 535
    Top = 23
    Width = 98
    Height = 16
    Caption = 'The longest way'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbTextMinWay: TLabel
    Left = 532
    Top = 71
    Width = 101
    Height = 16
    Caption = 'The shortest way'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbTextCenterGraph: TLabel
    Left = 532
    Top = 127
    Width = 115
    Height = 16
    Caption = 'The centre of a graf'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbMaxWay: TLabel
    Left = 559
    Top = 45
    Width = 6
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbMinWay: TLabel
    Left = 559
    Top = 93
    Width = 6
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbCenterGraph: TLabel
    Left = 559
    Top = 149
    Width = 6
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbAllWay: TLabel
    Left = 640
    Top = 290
    Width = 49
    Height = 16
    Caption = 'All ways'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object gbGraphView: TGroupBox
    Left = 8
    Top = 8
    Width = 504
    Height = 550
    Constraints.MaxHeight = 550
    Constraints.MaxWidth = 704
    Constraints.MinHeight = 550
    TabOrder = 0
    object imgGraphView: TImage
      Left = 2
      Top = 15
      Width = 500
      Height = 533
      Align = alClient
      Constraints.MaxHeight = 700
      Constraints.MaxWidth = 700
      Constraints.MinHeight = 500
      Constraints.MinWidth = 500
      ExplicitHeight = 642
    end
  end
  object btnGraphPaint: TButton
    Left = 708
    Top = 193
    Width = 95
    Height = 33
    Caption = 'Build a graf'
    TabOrder = 1
    OnClick = btnGraphPaintClick
  end
  object btnDoCalculation: TButton
    Left = 708
    Top = 245
    Width = 95
    Height = 33
    Caption = 'Find a way'
    Enabled = False
    TabOrder = 2
    OnClick = btnDoCalculationClick
  end
  object mmAllWay: TMemo
    Left = 518
    Top = 320
    Width = 285
    Height = 169
    TabOrder = 3
  end
  object seFinishPoint: TEdit
    Left = 559
    Top = 245
    Width = 87
    Height = 21
    TabOrder = 4
  end
  object seStartPoint: TEdit
    Left = 559
    Top = 199
    Width = 87
    Height = 21
    TabOrder = 5
  end
  object OpenDialog1: TOpenDialog
    Left = 784
    Top = 16
  end
end
