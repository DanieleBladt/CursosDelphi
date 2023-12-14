unit uOpenBanking;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, REST.Types,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Authenticator.OAuth, System.Classes,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TFOpenBanking = class(TForm)
    Panel1: TPanel;
    mmToken: TMemo;
    bGerarToken: TButton;
    NetHTTPClient1: TNetHTTPClient;
    mmRetornoAPI: TMemo;
    btnConsumirAPI: TButton;
    Splitter1: TSplitter;
    edtAgencia: TEdit;
    edtConta: TEdit;
    lblAgencia: TLabel;
    lblConta: TLabel;
    Label1: TLabel;
    edtCpfCnpj: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure bGerarTokenClick(Sender: TObject);
    procedure btnConsumirAPIClick(Sender: TObject);
  private
    FcAccessToken: String;
    FcTokenType  : String;
    FcScope      : String;
    FcExpireIn   : String;

    function GerarBasic: String;
    procedure GerarToken;
    function MontarGrantType: String;
    function MontarScope: String;
    procedure SetarParametros(AcURL: String);
    procedure AlimentarMemoToken(AcURL: String;
      FResponse: IHTTPResponse);
    function RetornarValorTagJSON(AcJSON, AcTag: String): String;
    procedure AlimentarVariaveisJSON(AcJSON: String);
    procedure AlimentarMemoTokenFormatado(AcURL: String);
    function MontarAgenciaConta: String;
    function MontarGwDevAppKey: String;
    function MontarCpfCnpj: String;
    function GerarBearer: String;
    procedure ConsumirAPI;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FOpenBanking: TFOpenBanking;

const
  BASE_URL_OAUTH = 'https://oauth.hm.bb.com.br/oauth/token?';
  BASE_URL_OAUTH_SANDBOX = 'https://oauth.sandbox.bb.com.br/oauth/token?';

  BASE_URL_COBRANCA = 'https://api.hm.bb.com.br/cobrancas/v2/boletos?';
  BASE_URL_COBRANCA_SANDBOX = 'https://api.sandbox.bb.com.br/cobrancas/v2/boletos?';

  BASE_URL_VALIDACAOCONTA = 'https://api.hm.bb.com.br/validacao-contas/v1/contas';
  BASE_URL_VALIDACAOCONTA_SANDBOX = 'https://api.sandbox.bb.com.br/validacao-contas/v1/contas';


  CLIENT_ID = 'eyJpZCI6ImU5YzA4OTAtYjcxZi00MzY4LTgxNTEtOTU1NTdjIiwiY29kaWdvUHVibGljYWRvciI6MCwiY29kaWdvU29mdHdhcmUiOjQ1MzU0LCJzZXF1ZW5jaWFsSW5zdGFsYWNhbyI6MX0';
  CLIENT_SECRET = 'eyJpZCI6IjBiMTA5ODQtYjk5OC00OTZkLTk3MDAtNmI3MyIsImNvZGlnb1B1YmxpY2Fkb3IiOjAsImNvZGlnb1NvZnR3YXJlIjo0NTM1NCwic2VxdWVuY2lhbEluc3RhbGFjYW8iOjEsInNlcXVlbmNpYWxDcmVkZW5jaWFsIjoxLCJhbWJpZW50ZSI6ImhvbW9sb2dhY2FvIiwiaWF0IjoxNjY0NjY4Njg3Mzg3fQ';

  DEVELOPER_APPLICATION_KEY = 'd27ba7790dffabc01360e17dc0050656b981a5be';
implementation

uses
  System.NetEncoding,
  System.Generics.Collections,
  System.JSON;

{$R *.dfm}

procedure TFOpenBanking.FormCreate(Sender: TObject);
begin
  mmToken.Clear;
  mmRetornoAPI.Clear;
end;

procedure TFOpenBanking.bGerarTokenClick(Sender: TObject);
begin
  mmToken.Clear;
  GerarToken;
end;

procedure TFOpenBanking.btnConsumirAPIClick(Sender: TObject);
begin
  mmRetornoAPI.Clear;
  ConsumirAPI;
end;

procedure TFOpenBanking.ConsumirAPI;
var
  cURL: String;
  LBodyStream: TStringStream;
  LHeaders: TList<TNetHeader>;
  FResponse: IHTTPResponse;
begin
  cURL := Format('%s%s%s?%s&%s',
            [BASE_URL_VALIDACAOCONTA_SANDBOX,
             MontarAgenciaConta,
             '/situacao',
             MontarGwDevAppKey,
             MontarCpfCnpj]);

  NetHTTPClient1.ContentType := 'application/json';
//  NetHTTPClient1.AcceptCharSet := 'utf-8';
//  NetHTTPClient1.Accept := 'application/json';

  LBodyStream := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  LHeaders := TList<TNetHeader>.Create;
  LHeaders.Add(TNetHeader.Create('accept', 'application/json'));
  LHeaders.Add(TNetHeader.Create('Authorization', GerarBearer));

  FResponse := NetHTTPClient1.Get(cURL, LBodyStream, LHeaders.ToArray);

  mmRetornoAPI.Lines.Add(cURL);
  mmRetornoAPI.Lines.Add('');
  mmRetornoAPI.Lines.Add(FResponse.StatusCode.ToString + ': ' + FResponse.StatusText);
end;

procedure TFOpenBanking.GerarToken;
var
  cURL: String;
  LBodyStream: TStringStream;
  LHeaders: TList<TNetHeader>;
  FResponse: IHTTPResponse;
begin
  cURL := BASE_URL_OAUTH + MontarGrantType + MontarScope;

  LBodyStream := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  LHeaders := TList<TNetHeader>.Create;
  LHeaders.Add(TNetHeader.Create('Authorization', GerarBasic));

  SetarParametros(cURL);
  FResponse := NetHTTPClient1.Post(cURL, LBodyStream, nil, LHeaders.ToArray);

  AlimentarMemoToken(cURL, FResponse);
end;

procedure TFOpenBanking.AlimentarMemoToken(AcURL: String;
  FResponse: IHTTPResponse);
begin
  mmToken.Lines.Add(AcURL);
  mmToken.Lines.Add('');
  case FResponse.StatusCode of
    200:
    begin
      mmToken.Lines.Add(FResponse.StatusCode.ToString + ': ' + FResponse.StatusText);
      mmToken.Lines.Add('');
      AlimentarVariaveisJSON(FResponse.ContentAsString(TEncoding.UTF8));
      AlimentarMemoTokenFormatado(FResponse.ContentAsString(TEncoding.UTF8));
    end;
    400:
    begin
      mmToken.Lines.Add(FResponse.StatusCode.ToString + ': ' + FResponse.StatusText);
      mmToken.Lines.Add(FResponse.ContentAsString(TEncoding.UTF8));
    end;
    401:
    begin
      mmToken.Lines.Add(FResponse.StatusCode.ToString + ': ' + FResponse.StatusText);
      mmToken.Lines.Add(FResponse.ContentAsString(TEncoding.UTF8));
    end;
  end;
end;

procedure TFOpenBanking.AlimentarMemoTokenFormatado(AcURL: String);
begin
  mmToken.Lines.Add('token_type: ' + FcTokenType);
  mmToken.Lines.Add('');
  mmToken.Lines.Add('access_token: ' + FcAccessToken);
  mmToken.Lines.Add('');
  mmToken.Lines.Add('scope: ' + FcScope);
  mmToken.Lines.Add('');
  mmToken.Lines.Add('expires_in: ' + FcExpireIn);
end;

procedure TFOpenBanking.SetarParametros(AcURL: String);
begin
  NetHTTPClient1.ContentType := 'application/x-www-form-urlencoded';
  NetHTTPClient1.SecureProtocols :=
    [THTTPSecureProtocol.SSL3,
     THTTPSecureProtocol.TLS1,
     THTTPSecureProtocol.TLS11,
     THTTPSecureProtocol.TLS12,
     THTTPSecureProtocol.TLS13];
end;

function TFOpenBanking.GerarBasic: String;
var
  Encoder : TBase64Encoding;
begin
  Result := EmptyStr;

  Encoder := TBase64Encoding.Create(0);
  Result  := Format('Basic %s', [Encoder.Encode(Format('%s:%s', [CLIENT_ID, CLIENT_SECRET]))]);
end;

function TFOpenBanking.GerarBearer: String;
var
  Encoder : TBase64Encoding;
begin
  Result := EmptyStr;

  Encoder := TBase64Encoding.Create(0);
  Result  := Format(FcTokenType + ' %s', [Encoder.Encode(Format('%s', [FcAccessToken]))]);
end;

function TFOpenBanking.MontarGrantType: String;
begin
  Result := TNetEncoding.URL.EncodeQuery('grant_type=client_credentials');
end;

function TFOpenBanking.MontarScope: String;
begin
  Result := TNetEncoding.URL.EncodeQuery('&validacao-contas.info');
end;

procedure TFOpenBanking.AlimentarVariaveisJSON(AcJSON: String);
begin
  FcAccessToken := RetornarValorTagJSON(AcJSON, 'access_token');
  FcTokenType   := RetornarValorTagJSON(AcJSON, 'token_type');
  FcScope       := RetornarValorTagJSON(AcJSON, 'scope');
  FcExpireIn    := RetornarValorTagJSON(AcJSON, 'expires_in');
end;

function TFOpenBanking.RetornarValorTagJSON(AcJSON, AcTag: String): String;
var
  LJSONObject: TJSONObject;

  function TratarObjetoJSON(AoObjeto:TJSONObject): String;
  var
    i: Integer;
    jPar: TJSONPair;
   begin
     Result := EmptyStr;
     for i := 0 to AoObjeto.Size - 1 do
     begin
       jPar := AoObjeto.Get(i);
       if jPar.JsonValue Is TJSONObject then
          result := TratarObjetoJSON((jPar.JsonValue As TJSONObject)) else
       if sametext(trim(jPar.JsonString.Value), AcTag) then
       begin
         Result := jPar.JsonValue.Value;
         break;
       end;
       if result <> EmptyStr then
          break;
     end;
   end;

begin
  Result := EmptyStr;
  try
    LJSONObject := nil;
    LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AcJSON),0) as TJSONObject;
    Result := TratarObjetoJSON(LJSONObject);
  finally
    LJSONObject.Free;
  end;
end;

function TFOpenBanking.MontarAgenciaConta: String;
begin
  Result := '/' + edtAgencia.Text + '-' + edtConta.Text;
end;

function TFOpenBanking.MontarGwDevAppKey: String;
begin
  Result := 'gw-dev-app-key=' + DEVELOPER_APPLICATION_KEY;
end;

function TFOpenBanking.MontarCpfCnpj: String;
begin
  Result := 'cpfCnpj=' + edtCpfCnpj.Text;
end;

end.
