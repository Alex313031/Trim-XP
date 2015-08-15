﻿unit uExeFunctions;

interface

uses
  SysUtils, Windows, Dialogs,
  uSecurityDescriptor;

type
  TProcessOpener = class
  public
    class function OpenProcWithOutput(Path: String; Command: String):
      AnsiString;
  private
    class var SecurityDescriptorManipulator: TSecurityDescriptorManipulator;
    class function GetSecurityDescriptor: TSecurityAttributes;
    class procedure CreatePipeWithHandles(
      var ReadHandle, WriteHandle: THandle);
    class function ReadFromHandle(const ReadHandle: THandle): AnsiString; static;
  end;

implementation

class function TProcessOpener.GetSecurityDescriptor: TSecurityAttributes;
begin
  result.nLength := sizeof(result);
  result.lpSecurityDescriptor :=
    SecurityDescriptorManipulator.GetSecurityDescriptor;
  result.bInheritHandle := true;
end;

class procedure TProcessOpener.CreatePipeWithHandles(
  var ReadHandle, WriteHandle: THandle);
var
  SecurityAttributes: TSecurityAttributes;
begin
  SecurityAttributes := GetSecurityDescriptor;
  if not CreatePipe(ReadHandle, WriteHandle, @SecurityAttributes, 0) then
    raise EOSError.Create('CreatePipe Error (' + UIntToStr(GetLastError) + ')');
end;

class function TProcessOpener.ReadFromHandle(
  const ReadHandle: THandle): AnsiString;
var
  Buffer: array[0..512] of AnsiChar;
  BytesRead: DWORD;
begin
  result := '';
  while
    (ReadFile(ReadHandle, Buffer, Length(Buffer) - 1, BytesRead, nil)) and
    (BytesRead > 0) do
  begin
    Buffer[BytesRead] := #0;
    result := result + Buffer;
  end;
end;

class function TProcessOpener.OpenProcWithOutput(Path: String; Command: String):
  AnsiString;
const
  StartupSettingsTemplate: TStartupInfo =
    (cb: sizeof(STARTUPINFO);
     dwFlags: STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
     wShowWindow: SW_HIDE);
var
  StartupSettings: TStartupInfo;
  WriteHandle, ReadHandle: THandle;
  ProcessInformation: _PROCESS_INFORMATION;
begin
  SecurityDescriptorManipulator := TSecurityDescriptorManipulator.Create;

  CreatePipeWithHandles(ReadHandle, WriteHandle);
  StartupSettings := StartupSettingsTemplate;
  StartupSettings.hStdOutput := WriteHandle;
  StartupSettings.hStdError := WriteHandle;

  if not CreateProcess(nil,
    PWideChar(WideString(Command)), nil, nil, True, 0, nil,
    PWideChar(WideString(Path)), StartupSettings, ProcessInformation) then
      raise EOSError.Create(
        'CreateProcess Error (' + UIntToStr(GetLastError) + ')');
  CloseHandle(WriteHandle);
  result := ReadFromHandle(ReadHandle);
  CloseHandle(ReadHandle);

  FreeAndNil(SecurityDescriptorManipulator);
end;
end.
