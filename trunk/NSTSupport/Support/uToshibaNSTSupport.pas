unit uToshibaNSTSupport;

interface

uses
  SysUtils,
  uNSTSupport, uSMARTValueList;

type
  TToshibaNSTSupport = class sealed(TNSTSupport)
  private
    InterpretingSMARTValueList: TSMARTValueList;
    function GetEraseError: UInt64;
    function GetFullSupport: TSupportStatus;
    function GetTotalWrite: TTotalWrite;
    function IsModelHasToshibaString: Boolean;
    function IsProductOfToshiba: Boolean;
    function IsTHNSNF: Boolean;
    function IsTHNSNH: Boolean;
    function IsTHNSNS: Boolean;

  public
    function GetSupportStatus: TSupportStatus; override;
    function GetSMARTInterpreted(SMARTValueList: TSMARTValueList):
      TSMARTInterpreted; override;
  end;

implementation

{ TToshibaNSTSupport }

function TToshibaNSTSupport.IsModelHasToshibaString: Boolean;
begin
  result := Pos('TOSHIBA', Model) > 0;
end;

function TToshibaNSTSupport.IsTHNSNF: Boolean;
begin
  result := Pos('THNSNF', Model) > 0;
end;

function TToshibaNSTSupport.IsTHNSNH: Boolean;
begin
  result := Pos('THNSNH', Model) > 0;
end;

function TToshibaNSTSupport.IsTHNSNS: Boolean;
begin
  result := Pos('THNSNS', Model) > 0;
end;

function TToshibaNSTSupport.IsProductOfToshiba: Boolean;
begin
  result := IsModelHasToshibaString and (IsTHNSNF or IsTHNSNH or IsTHNSNS);
end;

function TToshibaNSTSupport.GetFullSupport: TSupportStatus;
begin
  result.Supported := true;
  result.FirmwareUpdate := true;
  
  if IsTHNSNS then
    result.TotalWriteType := TTotalWriteType.WriteSupportedAsValue
  else
    result.TotalWriteType := TTotalWriteType.WriteNotSupported;
end;

function TToshibaNSTSupport.GetSupportStatus: TSupportStatus;
begin
  result.Supported := false;
  if IsProductOfToshiba then
    result := GetFullSupport;
end;

function TToshibaNSTSupport.GetTotalWrite: TTotalWrite;
const
  GiBToMiB = 1024;
  IDOfHostWrite = 241;
var
  RAWValue: UInt64;
begin
  result.TrueHostWriteFalseNANDWrite := true;

  RAWValue :=
    InterpretingSMARTValueList.IndexByID(IDOfHostWrite);

  result.ValueInMiB := RAWValue * GiBToMiB;
end;

function TToshibaNSTSupport.GetEraseError: UInt64; 
const
  IDOfEraseErrorTHNSNS = 172;
  IDOfEraseErrorElse = 182;
begin
  if IsTHNSNS then 
    result :=
      InterpretingSMARTValueList.IndexByID(IDOfEraseErrorTHNSNS)
  else
    result :=
      InterpretingSMARTValueList.IndexByID(IDOfEraseErrorElse);
end;

function TToshibaNSTSupport.GetSMARTInterpreted(
  SMARTValueList: TSMARTValueList): TSMARTInterpreted;
const
  IDOfReplacedSector = 5;
  IDOfUsedHour = 1;
  ReplacedSectorThreshold = 50;
  EraseErrorThreshold = 10;
begin
  InterpretingSMARTValueList := SMARTValueList;
  result.TotalWrite := GetTotalWrite;

  result.UsedHour := 
    InterpretingSMARTValueList.IndexByID(IDOfUsedHour);
  result.EraseError := GetEraseError;
  result.SMARTAlert.EraseError :=
    result.EraseError >= EraseErrorThreshold;

  result.ReplacedSectors :=
    InterpretingSMARTValueList.IndexByID(IDOfReplacedSector);
  result.SMARTAlert.ReplacedSector :=
    result.ReplacedSectors >= ReplacedSectorThreshold;
end;

end.
