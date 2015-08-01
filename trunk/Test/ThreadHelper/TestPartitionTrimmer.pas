unit TestPartitionTrimmer;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework,
  uMockAutoTrimBasicsGetter,
  uMockVolumeBitmapGetter,
  uMockDeviceTrimmer,
  uPartitionTrimmer;

type
  // Test methods for class TPartitionTrimmer

  TestTPartitionTrimmer = class(TTestCase)
  strict private
    FPartitionTrimmer: TPartitionTrimmer;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestBasicTrim;
  end;

implementation

procedure TestTPartitionTrimmer.SetUp;
begin
  TVolumeBitmapGetter.CreateBitmapStorage;
  TDeviceTrimmer.CreateTrimOperationLogger;
  FPartitionTrimmer := TPartitionTrimmer.Create('');
end;

procedure TestTPartitionTrimmer.TearDown;
begin
  FPartitionTrimmer.Free;
  FPartitionTrimmer := nil;
  TVolumeBitmapGetter.FreeBitmapStorage;
  TDeviceTrimmer.FreeTrimOperationLogger;
end;

procedure TestTPartitionTrimmer.TestBasicTrim;
const
  NullSyncronization: TTrimSynchronization =
    (IsUIInteractionNeeded: False);
var
  BasicTest: TBitmapBuffer;
  Result: TTrimOperationList;
begin
  TVolumeBitmapGetter.SetLength(8);
  BasicTest[0] := $65; //0110 0101
  TVolumeBitmapGetter.AddAtBitmapStorage(BasicTest);
  FPartitionTrimmer.TrimPartition(NullSyncronization);
  Result := TDeviceTrimmer.GetTrimOperationLogger;

  CheckEquals(3, Result.Count, 'Result.Count');
  CheckEquals(1, Result[0].StartLBA, 'Result[0].StartLBA');
  CheckEquals(1, Result[0].LengthInLBA, 'Result[0].LengthInLBA');
  CheckEquals(3, Result[1].StartLBA, 'Result[1].StartLBA');
  CheckEquals(2, Result[1].LengthInLBA, 'Result[1].LengthInLBA');
  CheckEquals(7, Result[2].StartLBA, 'Result[2].StartLBA');
  CheckEquals(1, Result[2].LengthInLBA, 'Result[2].LengthInLBA');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTPartitionTrimmer.Suite);
end.

