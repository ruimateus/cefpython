# Copyright (c) 2012-2014 The CEF Python authors. All rights reserved.
# License: New BSD License.
# Website: http://code.google.com/p/cefpython/

include "../cefpython.pyx"

cimport cef_types

# cef_paint_element_type_t, PaintElementType
PET_VIEW = cef_types.PET_VIEW
PET_POPUP = cef_types.PET_POPUP

# cef_drag_operations_mask_t, DragOperation, DragOperationsMask
DRAG_OPERATION_NONE    = cef_types.DRAG_OPERATION_NONE
DRAG_OPERATION_COPY    = cef_types.DRAG_OPERATION_COPY
DRAG_OPERATION_LINK    = cef_types.DRAG_OPERATION_LINK
DRAG_OPERATION_GENERIC = cef_types.DRAG_OPERATION_GENERIC
DRAG_OPERATION_PRIVATE = cef_types.DRAG_OPERATION_PRIVATE
DRAG_OPERATION_MOVE    = cef_types.DRAG_OPERATION_MOVE
DRAG_OPERATION_DELETE  = cef_types.DRAG_OPERATION_DELETE
DRAG_OPERATION_EVERY   = cef_types.DRAG_OPERATION_EVERY


cdef public cpp_bool RenderHandler_GetRootScreenRect(
        CefRefPtr[CefBrowser] cefBrowser,
        CefRect& cefRect
        ) except * with gil:
    cdef PyBrowser pyBrowser
    cdef list pyRect = []
    cdef py_bool ret
    try:
        pyBrowser = GetPyBrowser(cefBrowser)
        callback = pyBrowser.GetClientCallback("GetRootScreenRect")
        if callback:
            ret = callback(browser=pyBrowser, rect_out=pyRect)
            if ret:
                assert (pyRect and len(pyRect) == 4), "rectangle not provided"
                cefRect.x = pyRect[0]
                cefRect.y = pyRect[1]
                cefRect.width = pyRect[2]
                cefRect.height = pyRect[3]
                return True
            else:
                return False
        else:
            return False
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public cpp_bool RenderHandler_GetViewRect(
        CefRefPtr[CefBrowser] cefBrowser,
        CefRect& cefRect
        ) except * with gil:
    cdef PyBrowser pyBrowser
    cdef list pyRect = []
    cdef py_bool ret
    try:
        pyBrowser = GetPyBrowser(cefBrowser)
        callback = pyBrowser.GetClientCallback("GetViewRect")
        if callback:
            ret = callback(browser=pyBrowser, rect_out=pyRect)
            if ret:
                assert (pyRect and len(pyRect) == 4), "rectangle not provided"
                cefRect.x = pyRect[0]
                cefRect.y = pyRect[1]
                cefRect.width = pyRect[2]
                cefRect.height = pyRect[3]
                return True
            else:
                return False
        else:
            return False
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public cpp_bool RenderHandler_GetScreenRect(
        CefRefPtr[CefBrowser] cefBrowser,
        CefRect& cefRect
        ) except * with gil:
    cdef PyBrowser pyBrowser
    cdef list pyRect = []
    cdef py_bool ret
    try:
        pyBrowser = GetPyBrowser(cefBrowser)
        callback = pyBrowser.GetClientCallback("GetScreenRect")
        if callback:
            ret = callback(browser=pyBrowser, rect_out=pyRect)
            if ret:
                assert (pyRect and len(pyRect) == 4), (
                        "rectangle not provided or invalid")
                cefRect.x = pyRect[0]
                cefRect.y = pyRect[1]
                cefRect.width = pyRect[2]
                cefRect.height = pyRect[3]
                return True
            else:
                return False
        else:
            return False
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public cpp_bool RenderHandler_GetScreenPoint(
        CefRefPtr[CefBrowser] cefBrowser,
        int viewX, int viewY,
        int& screenX, int& screenY
        ) except * with gil:
    cdef PyBrowser pyBrowser
    cdef list screenCoordinates = []
    cdef py_bool ret
    try:
        pyBrowser = GetPyBrowser(cefBrowser)
        callback = pyBrowser.GetClientCallback("GetScreenPoint")
        if callback:
            ret = callback(browser=pyBrowser,
                           view_x=viewX,
                           view_y=viewY,
                           screen_coordinates_out=screenCoordinates)
            if ret:
                assert (screenCoordinates and len(screenCoordinates) == 2), (
                        "screenCoordinates not provided or invalid")
                (&screenX)[0] = int(screenCoordinates[0])
                (&screenY)[0] = int(screenCoordinates[1])
                return True
            else:
                return False
        else:
            return False
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public cpp_bool RenderHandler_GetScreenInfo(
        CefRefPtr[CefBrowser] cefBrowser,
        CefScreenInfo& cefScreenInfo
        ) except * with gil:
    # Not yet implemented.
    return False

cdef public void RenderHandler_OnPopupShow(
        CefRefPtr[CefBrowser] cefBrowser,
        cpp_bool show
        ) except * with gil:
    cdef PyBrowser pyBrowser
    try:
        pyBrowser = GetPyBrowser(cefBrowser)
        callback = pyBrowser.GetClientCallback("OnPopupShow")
        if callback:
            callback(browser=pyBrowser, show=show)
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public void RenderHandler_OnPopupSize(
        CefRefPtr[CefBrowser] cefBrowser,
        const CefRect& cefRect
        ) except * with gil:
    cdef PyBrowser pyBrowser
    cdef list pyRect
    try:
        pyBrowser = GetPyBrowser(cefBrowser)
        callback = pyBrowser.GetClientCallback("OnPopupSize")
        if callback:
            pyRect = [cefRect.x, cefRect.y, cefRect.width, cefRect.height]
            callback(browser=pyBrowser, rect_out=pyRect)
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public void RenderHandler_OnPaint(
        CefRefPtr[CefBrowser] cefBrowser,
        cef_types.cef_paint_element_type_t paintElementType,
        cpp_vector[CefRect]& cefDirtyRects,
        const void* cefBuffer,
        int width,
        int height
        ) except * with gil:
    cdef PyBrowser pyBrowser
    cdef list pyDirtyRects = []
    cdef list pyRect
    # TODO: cefDirtyRects should be const, but const_iterator is
    #       not yet implemented in libcpp.vector.
    cdef cpp_vector[CefRect].iterator iterator
    cdef CefRect cefRect
    cdef PaintBuffer paintBuffer
    try:
        pyBrowser = GetPyBrowser(cefBrowser)

        iterator = cefDirtyRects.begin()
        while iterator != cefDirtyRects.end():
            cefRect = deref(iterator)
            pyRect = [cefRect.x, cefRect.y, cefRect.width, cefRect.height]
            pyDirtyRects.append(pyRect)
            preinc(iterator)

        # In CEF 1 width and height were fetched using GetSize(),
        # but in CEF 3 they are passed as arguments to OnPaint().
        # OFF: | (width, height) = pyBrowser.GetSize(paintElementType)

        paintBuffer = CreatePaintBuffer(cefBuffer, width, height)

        callback = pyBrowser.GetClientCallback("OnPaint")
        if callback:
            callback(
                    browser=pyBrowser,
                    element_type=paintElementType,
                    dirty_rects=pyDirtyRects,
                    paint_buffer=paintBuffer,
                    width=width,
                    height=height)
        else:
            return
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public void RenderHandler_OnCursorChange(
        CefRefPtr[CefBrowser] cefBrowser,
        CefCursorHandle cursor
        ) except * with gil:
    cdef PyBrowser pyBrowser
    try:
        pyBrowser = GetPyBrowser(cefBrowser)
        callback = pyBrowser.GetClientCallback("OnCursorChange")
        if callback:
            callback(browser=pyBrowser, cursor=<uintptr_t>cursor)
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public void RenderHandler_OnScrollOffsetChanged(
        CefRefPtr[CefBrowser] cefBrowser
        ) except * with gil:
    cdef PyBrowser pyBrowser
    try:
        pyBrowser = GetPyBrowser(cefBrowser)
        callback = pyBrowser.GetClientCallback("OnScrollOffsetChanged")
        if callback:
            callback(browser=pyBrowser)
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public cpp_bool RenderHandler_StartDragging(
        CefRefPtr[CefBrowser] cef_browser,
        CefRefPtr[CefDragData] cef_drag_data,
        long long allowed_ops,
        int x, int y
        ) except * with gil:
    cdef PyBrowser browser
    cdef DragData drag_data
    cdef py_bool ret
    try:
        browser = GetPyBrowser(cef_browser)
        drag_data = DragData_Init(cef_drag_data)
        callback = browser.GetClientCallback("StartDragging")
        if callback:
            ret = callback(
                    browser=browser,
                    drag_data=drag_data,
                    allowed_ops=allowed_ops,
                    x=x,
                    y=y)
            if ret:
                return True
            else:
                return False
        else:
            return False
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

cdef public void RenderHandler_UpdateDragCursor(
        CefRefPtr[CefBrowser] cef_browser,
        long long operation,
        ) except * with gil:
    cdef PyBrowser browser
    try:
        browser = GetPyBrowser(cef_browser)
        callback = browser.GetClientCallback("UpdateDragCursor")
        if callback:
            callback(browser=browser, operation=operation)
    except:
        (exc_type, exc_value, exc_trace) = sys.exc_info()
        sys.excepthook(exc_type, exc_value, exc_trace)

