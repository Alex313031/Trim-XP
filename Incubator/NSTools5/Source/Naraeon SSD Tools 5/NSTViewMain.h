
// NSTViewMain.h : ��� ����
//

#pragma once
#include "NSTDialog.h"
#include "NSTools5.h"
#include <GdiPlus.h>
#include "afxwin.h"

// CNSTViewMain ��ȭ ����
class CNSTViewMain : public CNSTDialog
{
// �����Դϴ�.
public:
	CNSTViewMain(CWnd* pParent = NULL);	// ǥ�� �������Դϴ�.

// ��ȭ ���� �������Դϴ�.
	enum { IDD = IDD_NSTVIEWMAIN_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV �����Դϴ�.

// �����Դϴ�.
protected:
	HICON m_hIcon;

	// ������ �޽��� �� �Լ�
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	CStatic iLogo;
};
