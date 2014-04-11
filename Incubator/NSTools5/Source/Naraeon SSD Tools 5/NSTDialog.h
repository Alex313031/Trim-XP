
// NSTDialog.h : ��� ����
//

#pragma once
#include "stdafx.h"

int operator== (const RECT a, const RECT b);

// CNSTDialog Ŭ����
// �� Ŭ������ Property Getter/Setter���� ������ GetLastError()�� �ǰ�, Error Code�� ������.
class CNSTDialog : public CDialogEx
{
private:
	int fWidth, fHeight, fX, fY, fClientWidth, fClientHeight;
	int fMaxWidth, fMaxHeight, fMinWidth, fMinHeight;
	int ClientDelta_X, ClientDelta_Y;
	RECT CurrWinRect, CurrClientRect;
	CBrush fBrush;
	COLORREF fBkColor;
public:
	CNSTDialog(UINT IDD, CWnd* pParent = NULL); // ǥ�� �������Դϴ�.

	// Property ���� Getter
	// Constraints
	int GetMaxWidth();
	int GetMaxHeight();
	int GetMinWidth();
	int GetMinHeight();

	// Width/Height
	int GetWidth();
	int GetHeight();
	int GetClientWidth();
	int GetClientHeight();

	// X/Y
	int GetX();
	int GetY();

	// BkColor
	COLORREF GetBgColor();
	

	// Property ���� Setter
	// Constraints
	int SetMaxWidth(int iWidth);
	int SetMaxHeight(int iHeight);
	int SetMinWidth(int iWidth);
	int SetMinHeight(int iHeight);

	// Width/Height
	int SetWidth(int iWidth);
	int SetHeight(int iHeight);
	int SetClientWidth(int iWidth);
	int SetClientHeight(int iHeight);

	// X/Y
	int SetX(int iX);
	int SetY(int iY);
	
	// BkColor
	COLORREF SetBgColor(COLORREF iBkColor);

protected:
	int RefreshWinVar();
};