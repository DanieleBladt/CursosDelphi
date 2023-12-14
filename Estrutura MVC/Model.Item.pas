unit Model.Item;

interface

uses
  Model.Interfaces;

type
  TModelItem = class(TInterfacedObject, IModelItem)
    private
      [weak]
      FParent : IModelVenda;
      FCodigo : Integer;
    public
      constructor Create(Parent: IModelVenda);
      destructor Destroy; override;
      class function New(Parent: IModelVenda): IModelItem;

      function Codigo(Value: Integer): IModelItem;
      function Vender: IModelItem;
      function &End: IModelVenda;
  end;

implementation

{ TModelItem }

function TModelItem.Codigo(Value: Integer): IModelItem;
begin
  Result := Self;
  FCodigo := Value;
end;

function TModelItem.&End: IModelVenda;
begin
  Result := FParent;
end;

constructor TModelItem.Create(Parent: IModelVenda);
begin
  FParent := Parent;
end;

destructor TModelItem.Destroy;
begin

  inherited;
end;

class function TModelItem.New(Parent: IModelVenda): IModelItem;
begin
  Result := Self.Create(Parent);
end;

function TModelItem.Vender: IModelItem;
begin
  Result := Self;
end;

end.
