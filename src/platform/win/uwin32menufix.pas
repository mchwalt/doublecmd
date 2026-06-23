{
  Double Commander
  -------------------------------------------------------------------------
  Fix keyboard navigation over menu separators on Windows

  Copyright (C) 2026 Alexander Koblov (alexx2000@mail.ru)

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version
  with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this program. If not, see <http://www.gnu.org/licenses/>.
}

unit uWin32MenuFix;

{$mode objfpc}{$H+}

interface

procedure ApplyMenuSeparatorFix;

implementation

uses
  Graphics, Menus, WSMenus, WSLCLClasses, Win32WSMenus, Windows;

type

  { TWin32WSMenuItemFix }

  TWin32WSMenuItemFix = class(TWin32WSMenuItem)
  published
    class procedure SetCaption(const AMenuItem: TMenuItem; const ACaption: string); override;
    class function SetCheck(const AMenuItem: TMenuItem; const Checked: boolean): boolean; override;
    class procedure UpdateMenuIcon(const AMenuItem: TMenuItem; const HasIcon: Boolean; const AIcon: Graphics.TBitmap); override;
  end;

{
  LCL bug workaround: TWin32WSMenuItem.UpdateCaption (called by SetCaption,
  SetCheck and UpdateMenuIcon) forces MFT_OWNERDRAW and clears
  MFT_SEPARATOR on every item. A separator then becomes a disabled owner-draw
  item that still takes the keyboard selection (a "dead" navigation stop)
  instead of being skipped by Windows. Re-assert MFT_SEPARATOR for line items.
}
procedure FixSeparator(const AMenuItem: TMenuItem);
var
  MenuInfo: TMenuItemInfoW;
begin
  if AMenuItem.IsLine and Assigned(AMenuItem.MergedParent) and
     AMenuItem.MergedParent.HandleAllocated then
  begin
    MenuInfo:= Default(TMenuItemInfoW);
    MenuInfo.cbSize:= SizeOf(TMenuItemInfoW);
    MenuInfo.fMask:= MIIM_FTYPE;
    if GetMenuItemInfoW(AMenuItem.MergedParent.Handle, AMenuItem.Command, False, @MenuInfo) then
    begin
      MenuInfo.fType:= (MenuInfo.fType or MFT_SEPARATOR) and not MFT_OWNERDRAW;
      SetMenuItemInfoW(AMenuItem.MergedParent.Handle, AMenuItem.Command, False, @MenuInfo);
    end;
  end;
end;

{ TWin32WSMenuItemFix }

class procedure TWin32WSMenuItemFix.SetCaption(const AMenuItem: TMenuItem;
  const ACaption: string);
begin
  inherited SetCaption(AMenuItem, ACaption);
  FixSeparator(AMenuItem);
end;

class function TWin32WSMenuItemFix.SetCheck(const AMenuItem: TMenuItem;
  const Checked: boolean): boolean;
begin
  Result:= inherited SetCheck(AMenuItem, Checked);
  FixSeparator(AMenuItem);
end;

class procedure TWin32WSMenuItemFix.UpdateMenuIcon(const AMenuItem: TMenuItem;
  const HasIcon: Boolean; const AIcon: Graphics.TBitmap);
begin
  inherited UpdateMenuIcon(AMenuItem, HasIcon, AIcon);
  FixSeparator(AMenuItem);
end;

procedure ApplyMenuSeparatorFix;
begin
  WSMenus.RegisterMenuItem;
  RegisterWSComponent(TMenuItem, TWin32WSMenuItemFix);
end;

end.
