unit uFormvenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controller.Observer.Interfaces,
  Vcl.StdCtrls, Controller.Interfaces;

type
  TForm1 = class(TForm, IObserverItem)
    ListBox1: TListBox;
  private
    { Private declarations }
    FVenda: IControllerVenda;
    function UpdateItem(Value: TRecordItem): IObserverItem;
  public
    { Public declarations }
    procedure ExibirForm(Parent: IControllerVenda);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.ExibirForm(Parent: IControllerVenda);
begin
  FVenda := Parent;
  FVenda.ObserverItem.Add(Self);
  Self.Show;
end;

function TForm1.UpdateItem(Value: TRecordItem): IObserverItem;
begin
  ListBox1.Items.Add(Value.Descricao);
end;

end.
