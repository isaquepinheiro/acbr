{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
{ Colaboradores nesse arquivo: Juliomar Marchetti                              }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ufrmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, ComCtrls, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls
  , ACBrBase, ACBrDFe, ACBrNFSe, ACBrDFeReport, ACBrNFSeDANFSeClass, ACBrNFSeDANFSeFR
  , pcnConversao
  , frxClass
  {$IFDEF DELPHIXE6_UP}, IOUtils{$ENDIF}
  ;

type
  TfrmPrincipal = class(TForm)
    imgLogo: TImage;
    pnlbotoes: TPanel;
    btnImprimir: TButton;
    btncarregar: TButton;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    frxReport1: TfrxReport;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lstbxFR3: TListBox;
    TabSheet2: TTabSheet;
    RbCanhoto: TRadioGroup;
    ACBrNFSe1: TACBrNFSe;
    ACBrNFSeDANFSeFR1: TACBrNFSeDANFSeFR;
    rbTipoAmbiente: TRadioGroup;
    Panel1: TPanel;
    edtEmitUF: TEdit;
    Label22: TLabel;
    edtCodCidade: TEdit;
    Label20: TLabel;
    cbCidades: TComboBox;
    Label21: TLabel;
    Label1: TLabel;
    edtProvedor: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btncarregarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure cbCidadesChange(Sender: TObject);
    procedure edtCodCidadeChange(Sender: TObject);
  private
    procedure Configuracao;
    procedure AtualizarCidades;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  IniFiles;

{$R *.dfm}

procedure TfrmPrincipal.btncarregarClick(Sender: TObject);
begin
  ACBrNFSe1.NotasFiscais.Clear;
  ACBrNFSe1.Configuracoes.WebServices.Ambiente := TpcnTipoAmbiente(rbTipoAmbiente.ItemIndex);
  if not OpenDialog1.Execute then
    Exit;
  if not ACBrNFSe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName) then
    raise Exception.Create('Erro ao carregar o XML da NFSe');
end;

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
begin
  Configuracao;
  if lstbxFR3.ItemIndex = -1 then
    raise Exception.Create('Selecione um arquivo fr3 ');

  if ACBrNFSe1.NotasFiscais.Count = 0 then
    raise Exception.Create('N�o foi carregado nenhum xml para impress�o');

  ACBrNFSeDANFSeFR1.FastFile := lstbxFR3.Items[lstbxFR3.ItemIndex];
  ACBrNFSe1.NotasFiscais.Imprimir;
end;

procedure TfrmPrincipal.cbCidadesChange(Sender: TObject);
var
  Tamanho: Integer;
begin
  Tamanho := Length(Trim(cbCidades.Text));
  //edtEmitCidade.Text := Copy(cbCidades.Text, 1, Tamanho - 11);
  edtEmitUF.Text := Copy(cbCidades.Text, Tamanho - 1, 2);
  edtCodCidade.Text := Copy(cbCidades.Text, Tamanho - 9, 7);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
{$IFDEF DELPHIXE6_UP}
  fsFiles: string;
{$ELSE}
  SR : TSearchRec;
{$ENDIF}

begin
  AtualizarCidades;

  {$IFDEF DELPHIXE6_UP}

  for fsFiles in TDirectory.GetFiles('..\Delphi\Report\') do
    if Pos('.fr3', LowerCase(fsFiles)) > 0 then
      lstbxFR3.AddItem(fsFiles, nil);

  {$ELSE}

  if findfirst('..\Delphi\Report\*.fr3', faArchive, SR) = 0 then
  begin
    repeat
      lstbxFR3.AddItem('..\Delphi\Report\' + SR.Name, nil);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

  {$ENDIF}
  ACBrNFSe1.Configuracoes.Geral.PathIniCidades := '..\ArqINI';
end;

procedure TfrmPrincipal.Configuracao;
begin
  // defina margens como 0 para usar as margens do .fr3
  ACBrNFSeDANFSeFR1.MargemInferior := 0;
  ACBrNFSeDANFSeFR1.MargemSuperior := 0;
  ACBrNFSeDANFSeFR1.MargemEsquerda := 0;
  ACBrNFSeDANFSeFR1.MargemDireita := 0;
end;

procedure TfrmPrincipal.edtCodCidadeChange(Sender: TObject);
begin
  if Length(edtCodCidade.Text) <> 7 then
    Exit;
  ACBrNFSe1.Configuracoes.Geral.CodigoMunicipio := StrToIntDef(edtCodCidade.Text, 0);
  ACBrNFSe1.Configuracoes.Geral.SetConfigMunicipio;
  edtProvedor.Text := ACBrNFSe1.Configuracoes.Geral.xProvedor;
end;

procedure TfrmPrincipal.AtualizarCidades;
var
  IniFile: String;
  Ini: TIniFile;
  Cidades: TStringList;
  I: Integer;
  sNome, sCod, sUF: String;
begin
  IniFile := IncludeTrailingPathDelimiter(ACBrNFSe1.Configuracoes.Geral.PathIniCidades) + 'Cidades.ini';

  Ini := TIniFile.Create(IniFile);
  Cidades := TStringList.Create;
  try
    Ini.ReadSections(Cidades);
    cbCidades.Items.Clear;
    for I := 0 to Pred(Cidades.Count) do
      if (StrToIntdef(Cidades[I], 0) > 0) then
        begin
          //Exemplo: Alfenas/3101607/MG
          sCod := Cidades[I];
          sNome := Ini.ReadString(sCod, 'Nome', '');
          sUF := Ini.ReadString(sCod, 'UF', '');

          cbCidades.Items.Add(Format('%s/%s/%s', [sNome, sCod, sUF]));
        end;

    //Sort
    cbCidades.Sorted := false;
    cbCidades.Sorted := true;
  finally
    Ini.Free;
    Cidades.Free;
  end;
end;


end.
