Attribute VB_Name = "Recorder"
Option Explicit

Private Type STARTUPINFO
    cb As Long
    lpReserved As String
    lpDesktop As String
    lpTitle As String
    dwX As Long
    dwY As Long
    dwXSize As Long
    dwYSize As Long
    dwXCountChars As Long
    dwYCountChars As Long
    dwFillAttribute As Long
    dwFlags As Long
    wShowWindow As Integer
    cbReserved2 As Integer
    lpReserved2 As Long
    hStdInput As Long
    hStdOutput As Long
    hStdError As Long
End Type

Private Type PROCESS_INFORMATION
    hProcess As Long
    hThread As Long
    dwProcessID As Long
    dwThreadID As Long
End Type

Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
Private Declare Function CreateProcessA Lib "kernel32" (ByVal lpApplicationName As String, ByVal lpCommandLine As String, ByVal lpProcessAttributes As Long, ByVal lpThreadAttributes As Long, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, ByVal lpEnvironment As Long, ByVal lpCurrentDirectory As String, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Private Declare Function TerminateProcess Lib "kernel32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long

Private Const NORMAL_PRIORITY_CLASS = &H20&
Private Const INFINITE = -1&
Private Const WM_USER = &H400&
   
Private Const KEYEVENTF_KEYUP = &H2
Private Const VK_SHIFT = &H10
Private Declare Sub keybd_event Lib "user32.dll" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, ByVal dwExtraInfo As Long)
Private Declare Function VkKeyScan Lib "user32" Alias "VkKeyScanA" (ByVal cChar As Byte) As Integer
Private Declare Function CharToOem Lib "user32" Alias "CharToOemA" (ByVal lpszSrc As String, ByVal lpszDst As String) As Long
Private Declare Function OemKeyScan Lib "user32" (ByVal wOemChar As Long) As Long
Private Declare Function MapVirtualKey Lib "user32" Alias "MapVirtualKeyA" (ByVal wCode As Long, ByVal wMapType As Long) As Long


' Virtual Keys, Standard Set
Const VK_LBUTTON = &H1
Const VK_RBUTTON = &H2
Const VK_CANCEL = &H3
Const VK_MBUTTON = &H4             '  NOT contiguous with L RBUTTON

Const VK_BACK = &H8
Const VK_TAB = &H9

Const VK_CLEAR = &HC
Const VK_RETURN = &HD

Const VK_CONTROL = &H11
Const VK_MENU = &H12
Const VK_PAUSE = &H13
Const VK_CAPITAL = &H14

Const VK_ESCAPE = &H1B

Const VK_SPACE = &H20
Const VK_PRIOR = &H21
Const VK_NEXT = &H22
Const VK_END = &H23
Const VK_HOME = &H24
Const VK_LEFT = &H25
Const VK_UP = &H26
Const VK_RIGHT = &H27
Const VK_DOWN = &H28
Const VK_SELECT = &H29
Const VK_PRINT = &H2A
Const VK_EXECUTE = &H2B
Const VK_SNAPSHOT = &H2C
Const VK_INSERT = &H2D
Const VK_DELETE = &H2E
Const VK_HELP = &H2F

' VK_A thru VK_Z are the same as their ASCII equivalents: 'A' thru 'Z'
' VK_0 thru VK_9 are the same as their ASCII equivalents: '0' thru '9'

Const VK_NUMPAD0 = &H60
Const VK_NUMPAD1 = &H61
Const VK_NUMPAD2 = &H62
Const VK_NUMPAD3 = &H63
Const VK_NUMPAD4 = &H64
Const VK_NUMPAD5 = &H65
Const VK_NUMPAD6 = &H66
Const VK_NUMPAD7 = &H67
Const VK_NUMPAD8 = &H68
Const VK_NUMPAD9 = &H69
Const VK_MULTIPLY = &H6A
Const VK_ADD = &H6B
Const VK_SEPARATOR = &H6C
Const VK_SUBTRACT = &H6D
Const VK_DECIMAL = &H6E
Const VK_DIVIDE = &H6F
Const VK_F1 = &H70
Const VK_F2 = &H71
Const VK_F3 = &H72
Const VK_F4 = &H73
Const VK_F5 = &H74
Const VK_F6 = &H75
Const VK_F7 = &H76
Const VK_F8 = &H77
Const VK_F9 = &H78
Const VK_F10 = &H79
Const VK_F11 = &H7A
Const VK_F12 = &H7B
Const VK_F13 = &H7C
Const VK_F14 = &H7D
Const VK_F15 = &H7E
Const VK_F16 = &H7F
Const VK_F17 = &H80
Const VK_F18 = &H81
Const VK_F19 = &H82
Const VK_F20 = &H83
Const VK_F21 = &H84
Const VK_F22 = &H85
Const VK_F23 = &H86
Const VK_F24 = &H87

Const VK_NUMLOCK = &H90
Const VK_SCROLL = &H91

'
'   VK_L VK_R - left and right Alt, Ctrl and Shift virtual keys.
'   Used only as parameters to GetAsyncKeyState() and GetKeyState().
'   No other API or message will distinguish left and right keys in this way.
'  /
Const VK_LSHIFT = &HA0
Const VK_RSHIFT = &HA1
Const VK_LCONTROL = &HA2
Const VK_RCONTROL = &HA3
Const VK_LMENU = &HA4
Const VK_RMENU = &HA5

Const VK_ATTN = &HF6
Const VK_CRSEL = &HF7
Const VK_EXSEL = &HF8
Const VK_EREOF = &HF9
Const VK_PLAY = &HFA
Const VK_ZOOM = &HFB
Const VK_NONAME = &HFC
Const VK_PA1 = &HFD
Const VK_OEM_CLEAR = &HFE

Public Sub Record(ByVal iChannel As Long, ByVal iLengthSeconds As Long, ByVal bRadio As Boolean)
    Dim hProcess As Long
    Dim sChannel As String
    
    If iLengthSeconds <= 0 Then
        Exit Sub
    End If
    If Not bRadio Then
        sChannel = Format$(iChannel, "00")
        hProcess = OpenApplication("C:\Program Files\Prolink\PlayTV Pro\PIXELTV.EXE", "C:\Program Files\Prolink\PlayTV Pro\")
        Wait 30, hProcess
        PressSingleKey Asc(Mid$(sChannel, 1, 1))
        PressSingleKey Asc(Mid$(sChannel, 2, 1))
        Wait 9, hProcess
        PressSingleKey Asc("X")
        Wait 1, hProcess
        CloseApplication hProcess
    Else
        sChannel = Format$(iChannel, "0000")
        hProcess = OpenApplication("C:\Program Files\Prolink\PlayTV Pro\PIXELFM.EXE", "C:\Program Files\Prolink\PlayTV Pro\")
        Wait 30, hProcess
        PressSingleKey Asc(Mid$(sChannel, 1, 1))
        PressSingleKey Asc(Mid$(sChannel, 2, 1))
        PressSingleKey Asc(Mid$(sChannel, 3, 1))
        PressSingleKey Asc(Mid$(sChannel, 4, 1))
        Wait 9, hProcess
        PressSingleKey Asc("X")
        Wait 1, hProcess
        CloseApplication hProcess
    End If

    hProcess = OpenApplication("D:\Applications\VirtualDub 1.5.10\VirtualDub.exe", "D:\Applications\VirtualDub 1.5.10\")
    'hProcess = OpenApplication("D:\Downloaded Applications\Applications\VirtuaDub\VirtualDub_sync.exe", "D:\Downloaded Applications\Applications\VirtuaDub\")
    Wait 5, hProcess
    PressSingleKey VK_MENU
    PressSingleKey Asc("F")
    PressSingleKey Asc("P")
    Wait 7, hProcess
    PressSingleKey Asc("C")
    PressSingleKey VK_UP
    'PressSingleKey VK_UP
    PressSingleKey VK_RETURN
    PressSingleKey VK_F5
    Wait iLengthSeconds, hProcess
    PressSingleKey VK_ESCAPE
    Wait 1, hProcess
    PressSingleKey VK_ESCAPE
    Wait 1, hProcess
    PressSingleKey VK_ESCAPE
    Wait 5, hProcess
    PressSingleKey VK_MENU
    PressSingleKey Asc("F")
    PressSingleKey Asc("X")
    Wait 1, hProcess
    PressSingleKey VK_MENU
    PressSingleKey Asc("F")
    PressSingleKey Asc("Q")
    Wait 5, hProcess
    CloseApplication hProcess
End Sub

Private Function Wait(ByVal lTimeout As Single, lprocessid As Long)
    WaitForSingleObject lprocessid, CLng(lTimeout * 1000)
End Function

Private Function OpenApplication(ByVal sPath As String, ByVal sFolderPath As String, Optional lTimeout As Single) As Long
    Dim proc As PROCESS_INFORMATION
    Dim start As STARTUPINFO
    
    start.cb = Len(start)
    CreateProcessA sPath, vbNullString, 0&, 0&, 1&, NORMAL_PRIORITY_CLASS, 0&, ByVal sFolderPath, start, proc
    OpenApplication = proc.hProcess
End Function

Private Function CloseApplication(lprocessid As Long)
    Dim x As Long
    
    If TerminateProcess(lprocessid, x) <> 0 Then
        'Call CloseHandle(proc.hThread)
        Call CloseHandle(lprocessid)
    End If
End Function

'Public Sub PressKeys(ByVal sKeys As String)
'    Dim VK As Integer
'    Dim nShiftScan As Integer
'    Dim nScan As Integer
'    Dim sOemChar As String
'    Dim nShiftKey As Integer
'    Dim i As Integer
'    For i = 1 To Len(sKeys)
'        DoEvents
'        'Loop through entire string being passed
'        'and send each character individually.
'
'        'Get the virtual key code for this character
'        VK = VkKeyScan(Asc(Mid(sKeys, i, 1))) And &HFF
'
'        'See if shift key needs to be pressed
'        nShiftKey = VkKeyScan(Asc(Mid(sKeys, i, 1))) And 256
'        sOemChar = " " '2 character buffer
'        'Get the OEM character - preinitialize the buffer
'        CharToOem Left$(Mid(sKeys, i, 1), 1), sOemChar
'        'Get the nScan code for this key
'        nScan = OemKeyScan(Asc(sOemChar)) And &HFF
'
'        'Send the key down
'        If nShiftKey = 256 Then
'            'if shift key needs to be pressed
'            nShiftScan = MapVirtualKey(VK_SHIFT, 0)
'            'press down the shift key
'            keybd_event VK_SHIFT, nShiftScan, 0, 0
'        End If
'
'        'press key to be sent
'        keybd_event VK, nScan, 0, 0
'
'        'Send the key up
'        If nShiftKey = 256 Then
'            'keyup for shift key
'            keybd_event VK_SHIFT, nShiftScan, KEYEVENTF_KEYUP, 0
'        End If
'
'        'keyup for key sent
'        keybd_event VK, nScan, KEYEVENTF_KEYUP, 0
'    Next
'End Sub

Private Sub PressSingleKey(lKeyCode As Long, Optional iType As Long)
    Dim VK As Integer
    Dim nShiftScan As Integer
    Dim nScan As Integer
    Dim sOemChar As String
    Dim nShiftKey As Integer
    Dim i As Integer
    
    DoEvents
    VK = lKeyCode
    nScan = OemKeyScan(lKeyCode) And &HFF
    Select Case iType
        Case 0
            keybd_event VK, nScan, 0, 0
            keybd_event VK, nScan, KEYEVENTF_KEYUP, 0
        Case 1
            keybd_event VK, nScan, 0, 0
        Case 2
            keybd_event VK, nScan, KEYEVENTF_KEYUP, 0
    End Select
End Sub
