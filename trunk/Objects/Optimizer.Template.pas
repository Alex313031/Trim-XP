unit Optimizer.Template;

interface

uses
  Generics.Collections,
  Getter.OS.Version, OS.Version.Helper;

type
  IOptimizationUnit = interface
    function IsOptional: Boolean;
    function IsCompatible: Boolean;
    function IsApplied: Boolean;
    function GetName: String;
    procedure Apply;
    procedure Undo;
  end;
  TOptimizationUnit = class abstract(TInterfacedObject, IOptimizationUnit)
  public
    function IsOptional: Boolean; virtual; abstract;
    function IsCompatible: Boolean; virtual; abstract;
    function IsApplied: Boolean; virtual; abstract;
    function GetName: String; virtual; abstract;
    procedure Apply; virtual; abstract;
    procedure Undo; virtual; abstract;
  protected
    function IsBelowWindows8: Boolean;
  end;
  TOptimizerList = TList<IOptimizationUnit>;

implementation

{ TOptimizationUnit }

function TOptimizationUnit.IsBelowWindows8: Boolean;
begin
  result := OS.Version.Helper.IsBelowVista(VersionHelper.Version);
end;

end.
