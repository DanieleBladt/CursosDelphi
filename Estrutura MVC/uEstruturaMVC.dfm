object FEstruturaMVC: TFEstruturaMVC
  Left = 0
  Top = 0
  Caption = 'Estrutura MVC'
  ClientHeight = 371
  ClientWidth = 671
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
    Width = 671
    Height = 371
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 8
    object Edit1: TEdit
      Left = 104
      Top = 32
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      OnChange = Edit1Change
    end
  end
end
