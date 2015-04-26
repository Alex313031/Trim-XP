unit uStrFunctions;

interface

uses
  SysUtils, Math,
  uDatasizeUnit, uTimeUnit, uLanguageSettings;

type
  FormatSizeSetting = record
    FNumeralSystem: TNumeralSystem;
    FPrecision: Integer;
  end;


function TrimEx(input: String): String; //�߰� ������� ����

//���� ���
function FormatSizeInMB(SizeInMB: Double; Setting: FormatSizeSetting): String;
function FormatTimeInSecond(TimeInSecond: Double): String;

implementation

function GetSizeUnitString
  (SizeInMB: Double;
   UnitToTest: TDatasizeUnit;
   Setting: FormatSizeSetting): String;
const
  Threshold = 0.75;
var
  DivideUnitSize: Integer;
  UnitSizeInMB: Int64;
begin
  DivideUnitSize := GetDivideUnitSize(Setting.FNumeralSystem);
  UnitSizeInMB :=
    Floor(Power(DivideUnitSize, UnitToTest.FPowerOfKUnit - 1));

  if SizeInMB >
    (UnitSizeInMB * Threshold) then
  begin
    result :=
      Format('%.' + IntToStr(Setting.FPrecision) + 'f' + UnitToTest.FUnitName,
        [SizeInMB / UnitSizeInMB]);
  end;
end;

function GetTimeUnitString
  (var TimeInSecond: Double;
   UnitToTest: TimeUnit;
   UnitName: String): String;
var
  UnitSizeInSecond: Int64;
  TimeInThisUnit: Integer;
begin
  result := '';
  UnitSizeInSecond :=
    Floor(Power(UnittimePerHigherUnittime, UnitToTest.FPowerOfSUnit));

  TimeInThisUnit := Floor(TimeInSecond / UnitSizeInSecond);
  if TimeInThisUnit > 0 then
  begin
    TimeInSecond := TimeInSecond - (TimeInThisUnit * UnitSizeInSecond);

    result := IntToStr(TimeInThisUnit) + UnitName;
    if TimeInThisUnit > 1 then
      result := result + CapMultiple[CurrLang];
  end;
end;

function FormatSizeInMB(SizeInMB: Double; Setting: FormatSizeSetting): String;
begin
  result := GetSizeUnitString(SizeInMB, PetaUnit, Setting);
  if result <> '' then exit;

  result := GetSizeUnitString(SizeInMB, TeraUnit, Setting);
  if result <> '' then exit;

  result := GetSizeUnitString(SizeInMB, GigaUnit, Setting);
  if result <> '' then exit;

  result := GetSizeUnitString(SizeInMB, MegaUnit, Setting);
end;

function FormatTimeInSecond(TimeInSecond: Double): String;
var
  CurrStr: String;
begin
  CurrStr :=
    GetTimeUnitString(TimeInSecond, HourUnit, CapHour[CurrLang]);
  if CurrStr <> '' then
    result := CurrStr + ' ';

  CurrStr :=
    GetTimeUnitString(TimeInSecond, MinuteUnit, CapMin[CurrLang]);
  if CurrStr <> '' then
    result := result + CurrStr + ' ';

  CurrStr :=
    GetTimeUnitString(TimeInSecond, SecondUnit, CapSec[CurrLang]);
  if CurrStr <> '' then
    result := result + CurrStr + ' ';
end;

function TrimEx(input: String): String;
var
  i: integer;
begin
  result := '';
  for i := 1 to Length(input) do
    if input[i] <> ' ' then
      result := result + input[i];
end;

end.
