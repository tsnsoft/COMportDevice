unit Unit_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls;

const BUFFER_LENGTH = 14; // Размер буфера для работы с COM-портом

type ARR_BYTE = array [1 .. BUFFER_LENGTH] of byte; // Тип буфера для работы с COM-портом

type
  TForm1 = class(TForm)
    Button_ConnectOn: TButton;
    Timer_Reader: TTimer;
    Memo_Data: TMemo;
    Button_ConnectOff: TButton;
    Timer_Writer: TTimer;
    CheckBox_R: TCheckBox;
    CheckBox_W: TCheckBox;
    procedure Button_ConnectOnClick(Sender: TObject);
    procedure Timer_ReaderTimer(Sender: TObject);
    procedure Button_ConnectOffClick(Sender: TObject);
    function ConvertArrByteToStr(arr: array of byte; len: integer): shortstring;
    function ConvertStrToArrByte(st: shortstring): ARR_BYTE;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer_WriterTimer(Sender: TObject);
    function InitPort(var h: Thandle; cport: string; access: dword): boolean;
    procedure ClosePort(var h: Thandle);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  COM_PORT_WRITE = 'COM6'; // Имя COM-порта для записи
  COM_PORT_READ = 'COM7'; // Имя COM-порта для чтения

  FDCB: dcb = (BaudRate: 9600; ByteSize: 8; Parity: NOPARITY;
    Stopbits: TWOSTOPBITS); // Настройки соединения

  TOUT: CommTimeouts = (ReadIntervalTimeout: 15; ReadTotalTimeoutConstant: 70;
    WriteTotalTimeoutMultiplier: 15; WriteTotalTimeoutConstant: 60); // Таймауты связи

var
  Form1: TForm1;

  h_W: Thandle = 0; // Хэндл COM-порта для записи
  h_R: Thandle = 0; // Хэндл COM-порта для чтения

  bufferR: ARR_BYTE; // Буфер для приема данных
  bufferW: ARR_BYTE; // Буфер для передачи данных

implementation

{$R *.dfm}

function TForm1.InitPort(var h: Thandle; cport: string; access: dword): boolean;
// Инициализация подключения к COM-порту
var port: string; err_code: integer;
begin
  port := '\\.\' + cport; InitPort := false;
  if h <> 0 then Closehandle(h);
  h := CreateFile(Pchar(port), access, 0, Nil, OPEN_EXISTING, 0, 0);
  SetCommState(h, FDCB); SetCommTimeouts(h, TOUT);
  if h = high(h) then begin
    Closehandle(h); err_code := GetLastError;
    case err_code of
      5: begin
          MessageDlg('К порту ' + cport + ' доступ запрещен.' + #13#10 +
            'Дескриптор порта=' + InttoStr(h), mtError, [mbOK], 0);
        end;
      6: begin
          MessageDlg('Порт ' + cport +
            ' не существует или занят другой программой.' + #13#10 +
            'Дескриптор порта=' + InttoStr(h), mtError, [mbOK], 0);
        end;
    end;
  end else InitPort :=true;
end;

procedure TForm1.ClosePort(var h: Thandle);
// Откключение от COM-порта
begin
  if h <> 0 then begin
    PurgeComm(h, PURGE_TXABORT or PURGE_RXABORT or PURGE_TXCLEAR or PURGE_RXCLEAR);
    Closehandle(h); h := 0;
  end;
end;

procedure TForm1.Button_ConnectOnClick(Sender: TObject);
// Подключение к COM-портам
begin
  Memo_Data.Lines.Clear;
  if CheckBox_R.Checked then
    if InitPort(h_R, COM_PORT_READ, GENERIC_READ) then Timer_Reader.Enabled := true;
  if CheckBox_W.Checked then
    if InitPort(h_W, COM_PORT_WRITE, GENERIC_WRITE) then Timer_Writer.Enabled := true;
  CheckBox_R.Enabled:=false; CheckBox_W.Enabled:=false;
end;

function TForm1.ConvertArrByteToStr(arr: array of byte; len: integer): shortstring;
// Функция преобразования массива байт в строку
var i: integer; s: shortstring;
begin
  s := '';
  for i := 0 to len - 1 do s := s + ansichar(arr[i]);
  result := s;
end;

function TForm1.ConvertStrToArrByte(st: shortstring): ARR_BYTE;
// Функция преобразования строки в массив байт
var arr: ARR_BYTE; i: integer;
begin
  for i := 1 to BUFFER_LENGTH do
     if i<=length(st) then arr[i] := ord(st[i]) else arr[i] := ord(' ');
  result := arr;
end;


procedure TForm1.Timer_ReaderTimer(Sender: TObject);
// Чтение данных с COM-порта
var bytesReceived: cardinal; messageR: shortstring;
begin
  PurgeComm(h_R, PURGE_RXABORT or PURGE_RXCLEAR);
  ReadFile(h_R, bufferR, BUFFER_LENGTH, bytesReceived, nil);
  messageR := trim(ConvertArrByteToStr(bufferR, bytesReceived));
  if (bytesReceived = BUFFER_LENGTH) then
    Memo_Data.Lines.Add('Получены данные: ' + messageR)
  else
    Memo_Data.Lines.Add('ожидание данных ...');
  Application.ProcessMessages;
end;

procedure TForm1.Timer_WriterTimer(Sender: TObject);
// Запись данных в COM-порт
var bytesTransmitted: cardinal; messageW: shortstring;
begin
  PurgeComm(h_W, PURGE_TXABORT or PURGE_TXCLEAR);
  EscapeCommFunction(h_W, SETRTS);
  messageW := 'Привет, всем !';
  bufferW := ConvertStrToArrByte(messageW);
  WriteFile(h_W, bufferW, BUFFER_LENGTH, bytesTransmitted, nil);
  sleep(20);
  EscapeCommFunction(h_W, CLRRTS);
  Memo_Data.Lines.Add('Записаны данные: ' + ConvertArrByteToStr(bufferW, BUFFER_LENGTH));
  Application.ProcessMessages;
end;

procedure TForm1.Button_ConnectOffClick(Sender: TObject);
// Отключение от COM-портов
begin
  Timer_Reader.Enabled := false; Timer_Writer.Enabled := false;
  Memo_Data.Clear; ClosePort(h_R); ClosePort(h_W);
  CheckBox_R.Enabled:=true; CheckBox_W.Enabled:=true;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
// Выход из программы
begin
  Button_ConnectOffClick(Sender);
end;

end.
