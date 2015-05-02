unit uOSFileWithHandle;

interface

uses
  Windows, SysUtils, Dialogs, uOSFile;

type
  TCreateFileDesiredAccess =
    (DesiredNone, DesiredReadOnly, DesiredReadWrite);

  TOSFileWithHandle = class abstract(TOSFile)
  public
    constructor Create(FileToGetAccess: String); overload; virtual; abstract;
    constructor Create(FileToGetAccess: String;
      DesiredAccess: TCreateFileDesiredAccess); overload;
    destructor Destroy; override;

  protected
    function GetFileHandle: THandle;
    function GetAccessPrivilege: TCreateFileDesiredAccess;
    function GetMinimumPrivilege: TCreateFileDesiredAccess; virtual; abstract;

    function IsHandleValid(HandleToCheck: THandle): Boolean;
    procedure IfInsufficientPrivilegeRaiseException(
      DesiredAccess: TCreateFileDesiredAccess);

  private
    FileHandle: THandle;
    AccessPrivilege: TCreateFileDesiredAccess;

    function GetDesiredAccessFromTCreateFileDesiredAccess
      (Source: TCreateFileDesiredAccess): DWORD;
    function CreateFileSystemCall(FileToGetAccess: LPCWSTR;
      DesiredAccess: DWORD): THandle;
    procedure CloseHandleAndCheckError;
    function IsPrivilegeValid(PrivilegeToTest: TCreateFileDesiredAccess):
      Boolean;
  end;

  EInsufficientPrivilege = class(Exception);

implementation

function TOSFileWithHandle.GetDesiredAccessFromTCreateFileDesiredAccess
  (Source: TCreateFileDesiredAccess): DWORD;
const
  AccessNothing = 0;
begin
  case Source of
    DesiredNone:
      exit(AccessNothing);
    DesiredReadOnly:
      exit(GENERIC_READ);
    DesiredReadWrite:
      exit(GENERIC_READ or GENERIC_WRITE);
    else
      raise
        EArgumentOutOfRangeException.Create
          ('ArgumentOutOfRange: Wrong Desired Access Parameter');
  end;
end;

function TOSFileWithHandle.GetFileHandle: THandle;
begin
  exit(FileHandle);
end;

function TOSFileWithHandle.GetAccessPrivilege: TCreateFileDesiredAccess;
begin
  exit(AccessPrivilege);
end;

function TOSFileWithHandle.IsHandleValid(HandleToCheck: THandle): Boolean;
begin
  result :=
    (HandleToCheck <> INVALID_HANDLE_VALUE) or
    (HandleToCheck <> 0);
end;

function TOSFileWithHandle.IsPrivilegeValid(
  PrivilegeToTest: TCreateFileDesiredAccess): Boolean;
begin
  result := PrivilegeToTest >= GetMinimumPrivilege;
end;

function TOSFileWithHandle.CreateFileSystemCall(FileToGetAccess: LPCWSTR;
  DesiredAccess: DWORD): THandle;
const
  OtherHandlesCanReadWrite = FILE_SHARE_WRITE or FILE_SHARE_READ;
  NoSecurityDescriptor = nil;
  NoFileAttributeFlag = 0;
  NoTemplateFile = 0;
begin
  result :=
    Windows.CreateFile
      (FileToGetAccess,
       DesiredAccess,
       OtherHandlesCanReadWrite,
       NoSecurityDescriptor,
       OPEN_EXISTING,
       NoFileAttributeFlag,
       NoTemplateFile);
end;

procedure TOSFileWithHandle.IfInsufficientPrivilegeRaiseException
  (DesiredAccess: TCreateFileDesiredAccess);
begin
  if not IsPrivilegeValid(DesiredAccess) then
    raise EInsufficientPrivilege.Create
      ('InsufficientPrevilege: More privilege is required');
end;

constructor TOSFileWithHandle.Create(FileToGetAccess: String;
  DesiredAccess: TCreateFileDesiredAccess);
var
  DesiredAccessInDWORD: DWORD;
begin
  inherited Create(FileToGetAccess);
  DesiredAccessInDWORD :=
    GetDesiredAccessFromTCreateFileDesiredAccess(DesiredAccess);
  FileHandle :=
    CreateFileSystemCall(PWideChar(FileToGetAccess), DesiredAccessInDWORD);
  IfOSErrorRaiseException;
  AccessPrivilege := DesiredAccess;
end;

procedure TOSFileWithHandle.CloseHandleAndCheckError;
begin
  CloseHandle(FileHandle);
  IfOSErrorRaiseException;
end;

destructor TOSFileWithHandle.Destroy;
begin
  if IsHandleValid(FileHandle) then
    CloseHandleAndCheckError;
  inherited Destroy;
end;

end.