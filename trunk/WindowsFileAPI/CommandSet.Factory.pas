unit CommandSet.Factory;

interface

uses
  Windows, SysUtils, Dialogs,
  CommandSet, BufferInterpreter,
  CommandSet.ATA, CommandSet.ATA.Legacy, CommandSet.SAT,
  CommandSet.NVMe.Intel, CommandSet.NVMe.Samsung, CommandSet.NVMe.WithoutDriver;

type
  TMetaCommandSet = class of TCommandSet;
  ENoCommandSetException = class(EArgumentNilException);
  ENoNVMeDriverException = class(EArgumentOutOfRangeException);
  TCommandSetFactory = class
  public
    function GetSuitableCommandSet(FileToGetAccess: String):
      TCommandSet;
    class function Create: TCommandSetFactory;
  private
    function TryCommandSetsAndGetRightSet: TCommandSet;
    function TestCommandSetCompatibility(
      TCommandSetToTry: TMetaCommandSet; LastResult: TCommandSet): TCommandSet;
    var
      FileToGetAccess: String;
  end;

var
  CommandSetFactory: TCommandSetFactory;

implementation

{ TCommandSetFactory }

class function TCommandSetFactory.Create: TCommandSetFactory;
begin
  if CommandSetFactory = nil then
    result := inherited Create as self
  else
    result := CommandSetFactory;
end;

function TCommandSetFactory.GetSuitableCommandSet(
  FileToGetAccess: String): TCommandSet;
begin
  self.FileToGetAccess := FileToGetAccess;
  result := TryCommandSetsAndGetRightSet;
  if result = nil then
    raise ENoCommandSetException.Create('Argument Nil: CommandSet is not set');
end;

function TCommandSetFactory.TryCommandSetsAndGetRightSet: TCommandSet;
begin
  result := nil;
  result := TestCommandSetCompatibility(TIntelNVMeCommandSet, result);
  result := TestCommandSetCompatibility(TSamsungNVMeCommandSet, result);
  result := TestCommandSetCompatibility(TATACommandSet, result);
  result := TestCommandSetCompatibility(TLegacyATACommandSet, result);
  result := TestCommandSetCompatibility(TSATCommandSet, result);
  if result = nil then
  begin
    result := TestCommandSetCompatibility(TNVMeWithoutDriverCommandSet, result);
    if result <> nil then
    begin
      FreeAndNil(result);
      raise ENoNVMeDriverException.Create('No NVMe Driver with: ' +
        FileToGetAccess);
    end;
  end;
end;

function TCommandSetFactory.TestCommandSetCompatibility
  (TCommandSetToTry: TMetaCommandSet; LastResult: TCommandSet): TCommandSet;
var
  IdentifyDeviceResult: TIdentifyDeviceResult;
begin
  if LastResult <> nil then
    exit(LastResult);
  
  result := TCommandSetToTry.Create(FileToGetAccess);
  
  try
    IdentifyDeviceResult := result.IdentifyDevice;
  except
    IdentifyDeviceResult.Model := '';
  end;

  if IdentifyDeviceResult.Model = '' then
    FreeAndNil(result);
end;

initialization
  CommandSetFactory := TCommandSetFactory.Create;
finalization
  CommandSetFactory.Free;
end.
