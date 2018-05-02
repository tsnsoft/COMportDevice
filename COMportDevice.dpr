program COMportDevice;

uses
  Vcl.Forms,
  Unit_main in 'Unit_main.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Night');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
