unit TestBufferInterpreter.ATA;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, Device.SMART.List, SysUtils, BufferInterpreter.ATA,
  BufferInterpreter;

type
  // Test methods for class TATABufferInterpreter

  TestTATABufferInterpreter = class(TTestCase)
  strict private
    FATABufferInterpreter: TATABufferInterpreter;
  private
    procedure CompareWithOriginalIdentify(
      const ReturnValue: TIdentifyDeviceResult);
    procedure CompareWithOriginalSMART(const ReturnValue: TSMARTValueList);
    procedure CheckIDEquals(const Expected, Actual: TSMARTValueEntry;
      const Msg: String);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestBufferToIdentifyDeviceResult;
    procedure TestBufferToSMARTValueList;
    procedure TestLargeBufferToIdentifyDeviceResult;
    procedure TestLargeBufferToSMARTValueList;
  end;

const
  CrucialM500IdentifyDevice: TSmallBuffer =
    ($40,$04,$FF,$3F,$37,$C8,$10,$00,$00,$00,$00,$00,$3F,$00,$00,$00,$00,$00,$00,$00
    ,$20,$20,$20,$20,$20,$20,$20,$20,$34,$31,$35,$31,$43,$30,$33,$31,$46,$41,$44,$38
    ,$00,$00,$00,$00,$00,$00,$55,$4D,$35,$30,$20,$20,$20,$20,$72,$43,$63,$75,$61,$69
    ,$5F,$6C,$54,$43,$32,$31,$4D,$30,$30,$35,$53,$30,$44,$53,$20,$31,$20,$20,$20,$20
    ,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$10,$80,$01,$40,$00,$2F
    ,$01,$40,$00,$00,$00,$00,$00,$00,$FF,$3F,$10,$00,$3F,$00,$10,$FC,$FB,$00,$10,$B1
    ,$B0,$4B,$F9,$0D,$00,$00,$07,$00,$03,$00,$78,$00,$78,$00,$78,$00,$78,$00,$B0,$40
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$00,$0E,$F7,$C6,$00,$6C,$01,$CC,$00
    ,$F8,$03,$28,$00,$6B,$74,$09,$7D,$63,$61,$69,$74,$09,$BC,$63,$61,$7F,$40,$01,$00
    ,$01,$00,$FE,$00,$FE,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$B0,$4B,$F9,$0D,$00,$00,$00,$00,$00,$00,$08,$00,$08,$60,$00,$00,$0A,$50,$51,$07
    ,$13,$0C,$8D,$AF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$40
    ,$1C,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$29,$00,$55,$4D
    ,$35,$30,$30,$2E,$2E,$31,$30,$53,$00,$00,$00,$00,$00,$00,$34,$32,$34,$36,$20,$20
    ,$20,$20,$30,$30,$35,$43,$33,$32,$36,$31,$20,$20,$20,$20,$54,$4D,$44,$46,$41,$44
    ,$31,$4B,$30,$32,$41,$4D,$20,$56,$20,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$35,$00,$00,$00,$00,$00,$00,$40
    ,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$7F,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$A5,$B8);

  CrucialM500SMART: TSmallBuffer =
    ($10,$00,$01,$2F,$00,$64,$64,$00,$00,$00,$00,$00,$00,$00,$05,$33
    ,$00,$64,$64,$00,$00,$00,$00,$00,$00,$00,$09,$32,$00,$64,$64,$43
    ,$09,$00,$00,$00,$00,$00,$0C,$32,$00,$64,$64,$64,$04,$00,$00,$00
    ,$00,$00,$AB,$32,$00,$64,$64,$00,$00,$00,$00,$00,$00,$00,$AC,$32
    ,$00,$64,$64,$00,$00,$00,$00,$00,$00,$00,$AD,$32,$00,$64,$64,$09
    ,$00,$00,$00,$00,$00,$00,$AE,$32,$00,$64,$64,$C9,$00,$00,$00,$00
    ,$00,$00,$B4,$33,$00,$00,$00,$C6,$07,$00,$00,$00,$00,$00,$B7,$32
    ,$00,$64,$64,$00,$00,$00,$00,$00,$00,$00,$B8,$32,$00,$64,$64,$00
    ,$00,$00,$00,$00,$00,$00,$BB,$32,$00,$64,$64,$00,$00,$00,$00,$00
    ,$00,$00,$C2,$22,$00,$49,$31,$1B,$00,$00,$00,$33,$00,$00,$C4,$32
    ,$00,$64,$64,$00,$00,$00,$00,$00,$00,$00,$C5,$32,$00,$64,$64,$00
    ,$00,$00,$00,$00,$00,$00,$C6,$30,$00,$64,$64,$00,$00,$00,$00,$00
    ,$00,$00,$C7,$32,$00,$64,$64,$00,$00,$00,$00,$00,$00,$00,$CA,$31
    ,$00,$64,$64,$00,$00,$00,$00,$00,$00,$00,$CE,$0E,$00,$64,$64,$00
    ,$00,$00,$00,$00,$00,$00,$D2,$32,$00,$64,$64,$00,$00,$00,$00,$00
    ,$00,$00,$F6,$32,$00,$64,$64,$3D,$A3,$0C,$62,$00,$00,$00,$F7,$32
    ,$00,$64,$64,$44,$08,$12,$03,$00,$00,$00,$F8,$32,$00,$64,$64,$0A
    ,$1C,$17,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2B,$02,$00,$7B
    ,$03,$00,$01,$00,$02,$09,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$AE);

implementation

procedure TestTATABufferInterpreter.SetUp;
begin
  FATABufferInterpreter := TATABufferInterpreter.Create;
end;

procedure TestTATABufferInterpreter.TearDown;
begin
  FATABufferInterpreter.Free;
  FATABufferInterpreter := nil;
end;

procedure TestTATABufferInterpreter.TestBufferToIdentifyDeviceResult;
var
  ReturnValue: TIdentifyDeviceResult;
  Buffer: TSmallBuffer;
begin
  Buffer := CrucialM500IdentifyDevice;
  ReturnValue := FATABufferInterpreter.BufferToIdentifyDeviceResult(Buffer);
  CompareWithOriginalIdentify(ReturnValue);
end;

procedure TestTATABufferInterpreter.CompareWithOriginalIdentify(
  const ReturnValue: TIdentifyDeviceResult);
begin
  CheckEquals('Crucial_CT120M500SSD1', ReturnValue.Model);
  CheckEquals('MU05', ReturnValue.Firmware);
  CheckEquals('14150C13AF8D', ReturnValue.Serial);
  CheckEquals(117220824, ReturnValue.UserSizeInKB);
  CheckTrue(TSATASpeed.SATA600 = ReturnValue.SATASpeed,
    'TSATASpeed.SATA600 = ReturnValue.SATASpeed');
  CheckEquals(512, ReturnValue.LBASize);
end;

procedure TestTATABufferInterpreter.TestBufferToSMARTValueList;
var
  ReturnValue: TSMARTValueList;
  Buffer: TSmallBuffer;
begin
  Buffer := CrucialM500SMART;
  ReturnValue := FATABufferInterpreter.BufferToSMARTValueList(Buffer);
  CompareWithOriginalSMART(ReturnValue);
end;

procedure TestTATABufferInterpreter.CheckIDEquals(
  const Expected, Actual: TSMARTValueEntry;
  const Msg: String);
begin
  CheckEquals(Expected.ID, Actual.ID, Msg);
  CheckEquals(Expected.Current, Actual.Current, Msg);
  CheckEquals(Expected.Worst, Actual.Worst, Msg);
  CheckEquals(Expected.Threshold, Actual.Threshold, Msg);
  CheckEquals(Expected.RAW, Actual.RAW, Msg);
end;

procedure TestTATABufferInterpreter.CompareWithOriginalSMART(
  const ReturnValue: TSMARTValueList);
const
  ID0: TSMARTValueEntry = (ID: 1; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID1: TSMARTValueEntry = (ID: 5; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID2: TSMARTValueEntry = (ID: 9; Current: 100; Worst: 100; Threshold: 0; RAW: 2371);
  ID3: TSMARTValueEntry = (ID: 12; Current: 100; Worst: 100; Threshold: 0; RAW: 1124);
  ID4: TSMARTValueEntry = (ID: 171; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID5: TSMARTValueEntry = (ID: 172; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID6: TSMARTValueEntry = (ID: 173; Current: 100; Worst: 100; Threshold: 0; RAW: 9);
  ID7: TSMARTValueEntry = (ID: 174; Current: 100; Worst: 100; Threshold: 0; RAW: 201);
  ID8: TSMARTValueEntry = (ID: 180; Current: 0; Worst: 0; Threshold: 0; RAW: 1990);
  ID9: TSMARTValueEntry = (ID: 183; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID10: TSMARTValueEntry = (ID: 184; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID11: TSMARTValueEntry = (ID: 187; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID12: TSMARTValueEntry = (ID: 194; Current: 73; Worst: 49; Threshold: 0; RAW: 219043332123);
  ID13: TSMARTValueEntry = (ID: 196; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID14: TSMARTValueEntry = (ID: 197; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID15: TSMARTValueEntry = (ID: 198; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID16: TSMARTValueEntry = (ID: 199; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID17: TSMARTValueEntry = (ID: 202; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID18: TSMARTValueEntry = (ID: 206; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID19: TSMARTValueEntry = (ID: 210; Current: 100; Worst: 100; Threshold: 0; RAW: 0);
  ID20: TSMARTValueEntry = (ID: 246; Current: 100; Worst: 100; Threshold: 0; RAW: 1644995389);
  ID21: TSMARTValueEntry = (ID: 247; Current: 100; Worst: 100; Threshold: 0; RAW: 51513412);
  ID22: TSMARTValueEntry = (ID: 248; Current: 100; Worst: 100; Threshold: 0; RAW: 18291722);
begin
  CheckEquals(23, ReturnValue.Count, 'ReturnValue.Count');
  CheckIDEquals(ID0, ReturnValue[0], 'ReturnValue[0]');
  CheckIDEquals(ID1, ReturnValue[1], 'ReturnValue[1]');
  CheckIDEquals(ID2, ReturnValue[2], 'ReturnValue[2]');
  CheckIDEquals(ID3, ReturnValue[3], 'ReturnValue[3]');
  CheckIDEquals(ID4, ReturnValue[4], 'ReturnValue[4]');
  CheckIDEquals(ID5, ReturnValue[5], 'ReturnValue[5]');
  CheckIDEquals(ID6, ReturnValue[6], 'ReturnValue[6]');
  CheckIDEquals(ID7, ReturnValue[7], 'ReturnValue[7]');
  CheckIDEquals(ID8, ReturnValue[8], 'ReturnValue[8]');
  CheckIDEquals(ID9, ReturnValue[9], 'ReturnValue[9]');
  CheckIDEquals(ID10, ReturnValue[10], 'ReturnValue[10]');
  CheckIDEquals(ID11, ReturnValue[11], 'ReturnValue[11]');
  CheckIDEquals(ID12, ReturnValue[12], 'ReturnValue[12]');
  CheckIDEquals(ID13, ReturnValue[13], 'ReturnValue[13]');
  CheckIDEquals(ID14, ReturnValue[14], 'ReturnValue[14]');
  CheckIDEquals(ID15, ReturnValue[15], 'ReturnValue[15]');
  CheckIDEquals(ID16, ReturnValue[16], 'ReturnValue[16]');
  CheckIDEquals(ID17, ReturnValue[17], 'ReturnValue[17]');
  CheckIDEquals(ID18, ReturnValue[18], 'ReturnValue[18]');
  CheckIDEquals(ID19, ReturnValue[19], 'ReturnValue[19]');
  CheckIDEquals(ID20, ReturnValue[20], 'ReturnValue[20]');
  CheckIDEquals(ID21, ReturnValue[21], 'ReturnValue[21]');
  CheckIDEquals(ID22, ReturnValue[22], 'ReturnValue[22]');
end;

procedure TestTATABufferInterpreter.TestLargeBufferToIdentifyDeviceResult;
var
  ReturnValue: TIdentifyDeviceResult;
  Buffer: TLargeBuffer;
begin
  FillChar(Buffer, SizeOf(Buffer), #0);
  Move(CrucialM500IdentifyDevice, Buffer, SizeOf(CrucialM500IdentifyDevice));
  ReturnValue :=
    FATABufferInterpreter.LargeBufferToIdentifyDeviceResult(Buffer);
  CompareWithOriginalIdentify(ReturnValue);
end;

procedure TestTATABufferInterpreter.TestLargeBufferToSMARTValueList;
var
  ReturnValue: TSMARTValueList;
  Buffer: TLargeBuffer;
begin
  FillChar(Buffer, SizeOf(Buffer), #0);
  Move(CrucialM500SMART, Buffer, SizeOf(CrucialM500SMART));
  ReturnValue := FATABufferInterpreter.LargeBufferToSMARTValueList(Buffer);
  CompareWithOriginalSMART(ReturnValue);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTATABufferInterpreter.Suite);
end.

