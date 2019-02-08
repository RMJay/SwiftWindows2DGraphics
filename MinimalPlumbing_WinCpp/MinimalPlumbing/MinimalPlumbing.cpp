#include "Precompiled.h"
#include "MinimalPlumbing.h"

int __stdcall wWinMain(HINSTANCE module, HINSTANCE, PWSTR, int)
{
	WNDCLASS wc = {};
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.hCursor = LoadCursor(nullptr, IDC_ARROW);
	wc.hInstance = module;
	wc.lpszClassName = L"window";

	wc.lpfnWndProc = [](HWND window, UINT message, WPARAM wparam, LPARAM lparam) -> LRESULT
	{
		switch (message) {
		case WM_PAINT: return paintMsgHandler(window, wparam, lparam);
		case WM_SIZE: return sizeMsgHandler(window, wparam, lparam);
		case WM_MOUSEMOVE: return mouseMoveMsgHandler(window, wparam, lparam);
		case WM_DISPLAYCHANGE: return displayChangeMsgHandler(window, wparam, lparam);
		case WM_DESTROY: return destroyMsgHandler(window, wparam, lparam);
		default: return DefWindowProc(window, message, wparam, lparam);
		}
	};

	VERIFY(RegisterClass(&wc));

	auto hwnd = CreateWindow(wc.lpszClassName, L"Minimal Plumbing", WS_OVERLAPPEDWINDOW | WS_VISIBLE,
							 CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
							 nullptr, nullptr, module, nullptr);
	ASSERT(hwnd);

	MSG message;
	BOOL result;

	while (result = GetMessage(&message, 0, 0, 0))
	{
		if (-1 != result)
		{
			DispatchMessage(&message);
		}
	}
}

LRESULT paintMsgHandler(HWND window, WPARAM wparam, LPARAM lparam)
{
	PAINTSTRUCT ps; 
	VERIFY(BeginPaint(window, &ps));

	TRACE(L"Paint\n");

	EndPaint(window, &ps);
	return 0;
};

LRESULT destroyMsgHandler(HWND window, WPARAM wparam, LPARAM lparam)
{
	PostQuitMessage(0);
	return 0;
};

LRESULT sizeMsgHandler(HWND window, WPARAM wparam, LPARAM lparam)
{
	TRACE(L"Resized\n");
	return 0;
};

LRESULT mouseMoveMsgHandler(HWND window, WPARAM wparam, LPARAM lparam)
{
	TRACE(L"MouseMoved\n");
	return 0;
};

LRESULT displayChangeMsgHandler(HWND window, WPARAM wparam, LPARAM lparam)
{
	TRACE(L"DisplayChanged\n");
	return 0;
};