object FOpenBanking: TFOpenBanking
  Left = 0
  Top = 0
  Caption = 'Open Banking'
  ClientHeight = 595
  ClientWidth = 970
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 970
    Height = 595
    Align = alClient
    TabOrder = 0
    object Splitter1: TSplitter
      AlignWithMargins = True
      Left = 4
      Top = 322
      Width = 962
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Beveled = True
      ResizeStyle = rsNone
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 373
    end
    object lblAgencia: TLabel
      Left = 224
      Top = 32
      Width = 38
      Height = 13
      Caption = 'Ag'#234'ncia'
    end
    object lblConta: TLabel
      Left = 224
      Top = 59
      Width = 29
      Height = 13
      Caption = 'Conta'
    end
    object Label1: TLabel
      Left = 424
      Top = 32
      Width = 48
      Height = 13
      Caption = 'CPF/CNPJ'
    end
    object mmToken: TMemo
      Left = 1
      Top = 90
      Width = 968
      Height = 229
      Align = alBottom
      Lines.Strings = (
        'Memo1')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object bGerarToken: TButton
      Left = 16
      Top = 24
      Width = 113
      Height = 49
      Caption = 'Gerar Token'
      TabOrder = 1
      OnClick = bGerarTokenClick
    end
    object mmRetornoAPI: TMemo
      Left = 1
      Top = 328
      Width = 968
      Height = 266
      Align = alBottom
      Lines.Strings = (
        'Memo1')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object btnConsumirAPI: TButton
      Left = 719
      Top = 24
      Width = 113
      Height = 49
      Caption = 'Consumir API'
      TabOrder = 3
      OnClick = btnConsumirAPIClick
    end
    object edtAgencia: TEdit
      Left = 288
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '0551'
    end
    object edtConta: TEdit
      Left = 288
      Top = 51
      Width = 121
      Height = 21
      TabOrder = 5
      Text = '1000'
    end
    object edtCpfCnpj: TEdit
      Left = 478
      Top = 24
      Width = 219
      Height = 21
      TabOrder = 6
      Text = '5887148012'
    end
  end
  object NetHTTPClient1: TNetHTTPClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharSet = 'utf-8, *;q=0.8'
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 888
    Top = 8
  end
end
