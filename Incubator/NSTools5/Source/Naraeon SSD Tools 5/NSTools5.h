
// Naraeon SSD Tools 5.h : PROJECT_NAME ���� ���α׷��� ���� �� ��� �����Դϴ�.
//

#pragma once

#ifndef __AFXWIN_H__
	#error "PCH�� ���� �� ������ �����ϱ� ���� 'stdafx.h'�� �����մϴ�."
#endif

#include "resource.h"		// �� ��ȣ�Դϴ�.


// CNSTApplication:
// �� Ŭ������ ������ ���ؼ��� Naraeon SSD Tools 5.cpp�� �����Ͻʽÿ�.
//

class CNSTApplication : public CWinApp
{
public:
	CNSTApplication();

// �������Դϴ�.
public:
	virtual BOOL InitInstance();

// �����Դϴ�.

	DECLARE_MESSAGE_MAP()
};

extern CNSTApplication theApp;