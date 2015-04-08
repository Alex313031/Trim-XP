unit uATABufferInterpreter;

interface

uses
  SysUtils,
  uBufferInterpreter, uSMARTValueList;

type
  TATABufferInterpreter = class sealed(TBufferInterpreter)
  public
    function BufferToIdentifyDeviceResult
      (Buffer: T512Buffer): TIdentifyDeviceResult; override;
    function BufferToSMARTValueList
      (Buffer: T512Buffer): TSMARTValueList; override;

  private
    SMARTValueList: TSMARTValueList;
    BufferInterpreting: T512Buffer;
    function GetFirmwareFromBuffer: String;
    function GetLBASizeFromBuffer: Cardinal;
    function GetModelFromBuffer: String;
    function GetSATASpeedFromBuffer: TSATASpeed;
    function GetSerialFromBuffer: String;
    function GetUserSizeInKBFromBuffer: UInt64;
    function GetCurrentOfRow(CurrentRowStart: Integer): Byte;
    function GetIDOfRow(CurrentRowStart: Integer): Byte;
    function GetRAWOfRow(CurrentRowStart: Integer): UInt64;
    function GetWorstOfRow(CurrentRowStart: Integer): Byte;
    procedure IfValidSMARTAddToList(CurrentRow: Integer);
  end;

implementation

{ TATABufferInterpreter }

function TATABufferInterpreter.GetIDOfRow
  (CurrentRowStart: Integer): Byte;
begin
  result := BufferInterpreting[CurrentRowStart];
end;

function TATABufferInterpreter.GetCurrentOfRow
  (CurrentRowStart: Integer): Byte;
const
  CurrentValuePosition = 3;
begin
  result := BufferInterpreting[CurrentRowStart + CurrentValuePosition];
end;

function TATABufferInterpreter.GetWorstOfRow
  (CurrentRowStart: Integer): Byte;
const
  WorstValuePosition = 4;
begin
  result := BufferInterpreting[CurrentRowStart + WorstValuePosition];
end;

function TATABufferInterpreter.GetRAWOfRow
  (CurrentRowStart: Integer): UInt64;
const
  RAWValueStart = 5;
  RAWValueLength = 7;
var
  RAWStart, RAWEnd: Integer;
  CurrentRAW: Integer;
begin
  RAWStart := CurrentRowStart + RAWValueStart;
  RAWEnd := RAWStart + RAWValueLength - 1;

  result := 0;
  for CurrentRAW := RAWStart to RAWEnd do
  begin
    result := result shl 8;
    result :=
      result +
      BufferInterpreting[CurrentRAW];
  end;
end;

procedure TATABufferInterpreter.IfValidSMARTAddToList
  (CurrentRow: Integer);
var
  SMARTValueEntry: TSMARTValueEntry;
begin
  SMARTValueEntry.ID := GetIDOfRow(CurrentRow);
  if SMARTValueEntry.ID = 0 then
    exit;

  SMARTValueEntry.Current := GetCurrentOfRow(CurrentRow);
  SMARTValueEntry.Worst := GetWorstOfRow(CurrentRow);
  SMARTValueEntry.RAW := GetRAWOfRow(CurrentRow);
  SMARTValueList.Add(SMARTValueEntry);
end;

function TATABufferInterpreter.BufferToSMARTValueList
  (Buffer: T512Buffer): TSMARTValueList;
const
  SMARTStartPadding = 2;
  SMARTValueLength = 12;
var
  CurrentRow: Integer;
begin
  SMARTValueList := TSMARTValueList.Create;
  BufferInterpreting := Buffer;
  for CurrentRow := 0 to
    (Length(BufferInterpreting) - SMARTStartPadding) div SMARTValueLength do
    IfValidSMARTAddToList((CurrentRow * SMARTValueLength) + SMARTStartPadding);
  result := SMARTValueList;
end;

function TATABufferInterpreter.GetModelFromBuffer: String;
const
  ModelStart = 27;
  ModelEnd = 46;
var
  CurrentByte: Integer;
begin
  result := '';
  for CurrentByte := ModelStart to ModelEnd do
    result :=
      result +
      Chr(BufferInterpreting[CurrentByte * 2 + 1]) +
      Chr(BufferInterpreting[CurrentByte * 2]);
  result := Trim(result);
end;

function TATABufferInterpreter.GetFirmwareFromBuffer: String;
const
  FirmwareStart = 23;
  FirmwareEnd = 26;
var
  CurrentByte: Integer;
begin
  result := '';
  for CurrentByte := FirmwareStart to FirmwareEnd do
    result :=
      result +
      Chr(BufferInterpreting[CurrentByte * 2 + 1]) +
      Chr(BufferInterpreting[CurrentByte * 2]);
  result := Trim(result);
end;

function TATABufferInterpreter.GetSerialFromBuffer: String;
const
  SerialStart = 10;
  SerialEnd = 19;
var
  CurrentByte: Integer;
begin
  result := '';
  for CurrentByte := SerialStart to SerialEnd do
    result :=
      result +
      Chr(BufferInterpreting[CurrentByte * 2 + 1]) +
      Chr(BufferInterpreting[CurrentByte * 2]);
  result := Trim(result);
end;

function TATABufferInterpreter.GetUserSizeInKBFromBuffer: UInt64;
const
  UserSizeStart = 100;
  UserSizeEnd = 103;
var
  CurrentByte: Integer;
begin
  result := 0;
  for CurrentByte := UserSizeStart to UserSizeEnd do
  begin
    result :=
      result +
      BufferInterpreting[CurrentByte * 2] shl
        (((CurrentByte - UserSizeStart) * 2) * 8) +
      BufferInterpreting[CurrentByte * 2 + 1]  shl
        ((((CurrentByte - UserSizeStart) * 2) + 1) * 8);
  end;
end;

function TATABufferInterpreter.GetLBASizeFromBuffer: Cardinal;
const
  ATA_LBA_SIZE = 512;
begin
  result := ATA_LBA_SIZE;
end;

function TATABufferInterpreter.GetSATASpeedFromBuffer: TSATASpeed;
const
  SataNegStart = 77;
var
  SATASpeedInNum: Cardinal;
begin
  SATASpeedInNum := BufferInterpreting[SataNegStart * 2 + 1] +
                    BufferInterpreting[SataNegStart * 2];
  SATASpeedInNum := (SATASpeedInNum shr 1 and 3) + 1;
  result := TSATASpeed(SATASpeedInNum);
end;

function TATABufferInterpreter.BufferToIdentifyDeviceResult
  (Buffer: T512Buffer): TIdentifyDeviceResult;
begin
  BufferInterpreting := Buffer;
  result.Model := GetModelFromBuffer;
  result.Firmware := GetFirmwareFromBuffer;
  result.Serial := GetSerialFromBuffer;
  result.UserSizeInKB := GetUserSizeInKBFromBuffer;
  result.SATASpeed := GetSATASpeedFromBuffer;
  result.LBASize := GetLBASizeFromBuffer;
end;

end.
