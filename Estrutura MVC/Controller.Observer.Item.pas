unit Controller.Observer.Item;

interface

uses
  Controller.Observer.Interfaces, System.Generics.Collections;

type
  TControllerObserverItem = class(TInterfacedObject, ISubjectItem)
    private
      FList: TList<IObserverItem>;
    public
      constructor Create;
      destructor Destroy; override;
      class function New:ISubjectItem;

      function Add(Value: IObserverItem): ISubjectItem;
      function Notify(Value: TRecordItem): ISubjectItem;
  end;

implementation

uses
  System.SysUtils;

{ TControllerObserverItem }

function TControllerObserverItem.Add(Value: IObserverItem): ISubjectItem;
begin
  Result := Self;
  FList.Add(Value);
end;

constructor TControllerObserverItem.Create;
begin
  FList := TList<IObserverItem>.Create;
end;

destructor TControllerObserverItem.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

class function TControllerObserverItem.New: ISubjectItem;
begin

end;

function TControllerObserverItem.Notify(Value: TRecordItem): ISubjectItem;
var
  i: Integer;
begin
  Result := Self;
  for i := 0 to Pred(FList.Count) do
    FList[i].UpdateItem(Value);
end;

end.
