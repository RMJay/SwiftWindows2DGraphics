#pragma once

#include "Precompiled.h"

LRESULT paintMsgHandler(HWND window, WPARAM wparam, LPARAM lparam);

LRESULT destroyMsgHandler(HWND window, WPARAM wparam, LPARAM lparam);

LRESULT sizeMsgHandler(HWND window, WPARAM wparam, LPARAM lparam);

LRESULT mouseMoveMsgHandler(HWND window, WPARAM wparam, LPARAM lparam);

LRESULT displayChangeMsgHandler(HWND window, WPARAM wparam, LPARAM lparam);
