unit uDownloadThreadToModel;
unit uTrimThreadToModel;

interface

uses
  SysUtils, Classes, Windows,
  uLanguageSettings;

type
  TDownloadThreadToModel = class
  public
    constructor Create(TrimSynchronizationToApply: TTrimSynchronization);
    procedure ApplyOriginalUI;
    procedure ApplyProgressToUI(ProgressToApply: Integer);
    procedure ApplyNextDriveStartToUI(ProgressToApply: Integer);

  private
    Progress: Integer;
    TrimSynchronization: TTrimSynchronization;
    procedure SynchronizedApplyProgressToUI;
    procedure SynchronizedApplyOriginalUI;
    procedure SynchronizedApplyNextDriveStartToUI;
    function IsTrimInProgress: Boolean;
    procedure SynchronizedApplyProgressToLabel;
  end;

implementation

uses
  uMain;

constructor TDownloadThreadToModel.Create(
  TrimSynchronizationToApply: TTrimSynchronization);
begin
  TrimSynchronization := TrimSynchronizationToApply;
end;

procedure TDownloadThreadToModel.ApplyProgressToUI(ProgressToApply: Integer);
begin
  if TrimSynchronization.IsUIInteractionNeeded then
  begin
    Progress := ProgressToApply;
    TThread.Synchronize(
      TrimSynchronization.ThreadToSynchronize,
      SynchronizedApplyProgressToUI);
  end;
end;

procedure TDownloadThreadToModel.ApplyNextDriveStartToUI(ProgressToApply: Integer);
begin
  if TrimSynchronization.IsUIInteractionNeeded then
  begin
    Progress := ProgressToApply;
    TThread.Synchronize(
      TrimSynchronization.ThreadToSynchronize,
      SynchronizedApplyNextDriveStartToUI);
  end;
end;

procedure TDownloadThreadToModel.ApplyOriginalUI;
begin
  if TrimSynchronization.IsUIInteractionNeeded then
  begin
    TThread.Synchronize(
      TrimSynchronization.ThreadToSynchronize,
      SynchronizedApplyOriginalUI);
  end;
end;

procedure TDownloadThreadToModel.SynchronizedApplyProgressToUI;
begin
  fMain.pDownload.Position := Progress;
end;

function TDownloadThreadToModel.IsTrimInProgress: Boolean;
begin
  result := TrimSynchronization.Progress.CurrentPartition <=
    TrimSynchronization.Progress.PartitionCount;
end;

procedure TDownloadThreadToModel.SynchronizedApplyProgressToLabel;
begin
  fMain.lProgress.Caption :=
    CapProg1[CurrLang] +
    IntToStr(TrimSynchronization.Progress.CurrentPartition) + ' / ' +
    IntToStr(TrimSynchronization.Progress.PartitionCount);
end;

procedure TDownloadThreadToModel.SynchronizedApplyOriginalUI;
begin
  fMain.pDownload.Position := 0;
  fMain.gTrim.Visible := true;
end;

procedure TDownloadThreadToModel.SynchronizedApplyNextDriveStartToUI;
begin
  SynchronizedApplyProgressToUI;

  if TrimSynchronization.Progress.CurrentPartition < 0 then
    exit;

  if IsTrimInProgress then
    SynchronizedApplyProgressToLabel;
end;

end.