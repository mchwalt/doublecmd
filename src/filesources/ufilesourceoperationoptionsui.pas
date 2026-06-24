unit uFileSourceOperationOptionsUI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms;

type
  TFileSourceOperationOptionsUIClass = class of TFileSourceOperationOptionsUI;

  { TFileSourceOperationOptionsUI }

  TFileSourceOperationOptionsUI = class(TFrame)
  public
    constructor Create(AOwner: TComponent; AFileSource: IInterface); virtual; reintroduce;
    class function GetOptionsClass: TFileSourceOperationOptionsUIClass;
    {en
       Informs the UI whether the source files come from a flat view, so it can
       show/hide flat-view-specific options. No-op by default.
    }
    procedure SetSourceFlatView({%H-}AFlatView: Boolean); virtual;
    procedure SaveOptions; virtual; abstract;
    {en
       Set operation options from GUI controls.
    }
    procedure SetOperationOptions(Operation: TObject); virtual; abstract;
  end;

implementation

{ TFileSourceOperationOptionsUI }

constructor TFileSourceOperationOptionsUI.Create(AOwner: TComponent; AFileSource: IInterface);
begin
  inherited Create(AOwner);
end;

class function TFileSourceOperationOptionsUI.GetOptionsClass: TFileSourceOperationOptionsUIClass;
begin
  Result := Self;
end;

procedure TFileSourceOperationOptionsUI.SetSourceFlatView(AFlatView: Boolean);
begin
  // Default: nothing to do.
end;

end.

