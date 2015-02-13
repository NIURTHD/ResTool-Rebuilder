#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ResTool_Rebuilder.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Fileversion=0.2.150130
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.10.2
	Author:         Kevin Morgan

	Script Function:
	Downloads all the files necessary for a ResTool USB Disk to operate. Allows formatting and renaming of the device.
#ce ----------------------------------------------------------------------------
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#include <InetConstants.au3>
#include <ColorConstants.au3>
#include <Array.au3>
#Region ### START Koda GUI section ### Form=
$ResTool_Rebuilder = GUICreate("RTR", 170, 130, 192, 124)
$Drive = GUICtrlCreateCombo("Select a Drive...", 8, 8, 153, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$Format = GUICtrlCreateCheckbox("Format", 8, 32, 57, 17)
$Progresso = GUICtrlCreateProgress(8, 88, 150, 17)
$Start = GUICtrlCreateButton("Start", 8, 56, 75, 25)
$Exit = GUICtrlCreateButton("Exit", 88, 56, 75, 25)
$Text = GUICtrlCreateLabel("Waiting...", 8, 110, 150, 17, 0x01)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;init necessary info
$diskDrivesArr = DriveGetDrive("REMOVABLE")
$diskDrivesText = StringUpper(_ArrayToString($diskDrivesArr, "|", 1))
GUICtrlSetData($Drive, $diskDrivesText)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Start
			_Start()
		Case $Exit
			Exit

	EndSwitch
WEnd
Func _Start()
	GUICtrlSetStyle($Exit, 0x08000000)
	Global $opDrive = GUICtrlRead($Drive)
	If ($opDrive = "Select a Drive...") Then
		MsgBox(0, "Select a Drive...", "You must select a removable drive from the drop-down list in order to continue. If no options appear insert a removable disk and restart the program")
	Else
		If (GUICtrlRead($Format) = $GUI_CHECKED) Then
			RunWait(@ComSpec & " /c " & 'echo y | format ' & $opDrive & " /q /v:RESTOOL_NXT", "", @SW_HIDE)
		EndIf
		;mkdirs
		GUICtrlSetData($Text, "Making Directories")
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Scanners", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Logs", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Scanners\MWB", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Scanners\CF", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Scanners\ESET", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Scanners\HC", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Scanners\SAS", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Scanners\SB", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\OOB", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\OOB\32", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\OOB\64", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Installers", "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & "mkdir " & $opDrive & "\Script\Uninstallers", "", @SW_HIDE)
		;download to temp and move to FD
		$restech = "http://restech.niu.edu/ResTool/"
		_Download("CF.exe", "\Script\Scanners\CF", $restech & "Combofix.exe")
		_Download("MWB.exe", "\Script\Scanners\MWB", $restech & "MWB.exe")
		_Download("ESET.exe", "\Script\Scanners\ESET", "http://download.eset.com/special/eos/esetsmartinstaller_enu.exe");Eset Site (Can put on server)
		_Download("SB.exe", "\Script\Scanners\SB", $restech & "Spybot.exe")
		_Download("SAS.exe", "\Script\Scanners\SAS", $restech & "SAS.exe")
		_Download("HC.exe", "\Script\Scanners\HC", "http://go.trendmicro.com/housecall8/HousecallLauncher64.exe");HC Site (can put on server)
		_Download("CC.exe", "\Script\", $restech & "Ccleaner.exe")
		_Download("AIO.exe", "\Script\", "http://www.tweaking.com/files/setups/tweaking.com_windows_repair_aio_setup.exe");AIO Site (can put on server)
		_Download("devcon.exe", "\Script\OOB\32", "http://intranet.restech.niu.edu/f/1041/devcon32.exe");Intracloud
		_Download("devcon.exe", "\Script\OOB\64", "http://intranet.restech.niu.edu/f/1042/devcon64.exe");Intracloud
		_Download("WiFi.xml", "\Script\OOB", "http://intranet.restech.niu.edu/f/1037/WiFi.xml");Intracloud
		_Download("MSE32.exe", "\Script\Installers", $restech & "MSEx86.exe")
		_Download("MSE64.exe", "\Script\Installers", $restech & "MSEx64.exe")
		_Download("RMC.exe", "\Script\Uninstallers", $restech & "MCPR.exe")
		_Download("RNOR.exe", "\Script\Uninstallers", $restech & "NortonRT.exe")
		_Download("RAVG64.exe", "\Script\Uninstallers", $restech & "AVGr64.exe")
		_Download("RAVG86.exe", "\Script\Uninstallers", $restech & "AVGr86.exe")
		_Download("RAVS.exe", "\Script\Uninstallers", $restech & "Aswclear.exe")
		_Download("RKAS.exe", "\Script\Uninstallers", $restech & "KRT.exe")
		_Download("ResToolNXT.exe", "\", "https://github.com/kmorgan2/ResTool-NXT/releases/download/v0.2-beta/ResToolNXT.exe")
		_Download("ResToolNXT_x64.exe", "\", "https://github.com/kmorgan2/ResTool-NXT/releases/download/v0.2-beta/ResToolNXT_X64.exe")
		_Download("Pharos.exe", "\Script\Installers", "http://vm-pharosprint1.niunt.niu.edu/uniprint/AnywherePrint_for_Lte.exe")
		_Download("MWBAR.exe", "\Script\Scanners", "http://downloads.malwarebytes.org/file/mbar/")
		_Download("TDSS.exe", "\Script\Scanners", "http://media.kaspersky.com/utilities/VirusUtilities/EN/tdsskiller.exe")
	EndIf
	GUICtrlSetData($Progresso, 100)
	GUICtrlSetData($Text, "Done!")
	GUICtrlSetStyle($Exit, 0x0)
EndFunc   ;==>_Start
Func _Download($fileName, $directory, $webAddress)
	Local $inetObj = InetGet($webAddress, @TempDir & "\" & $fileName, 1, 1)
	GUICtrlSetData($Progresso, 0)
	GUICtrlSetData($Text, "Downloading " & $fileName)
	Do
		Sleep(100)
		GUICtrlSetData($Progresso, (90 * InetGetInfo($inetObj, $INET_DOWNLOADREAD) / InetGetSize($webAddress)))
	Until InetGetInfo($inetObj, $INET_DOWNLOADCOMPLETE)
	InetClose($inetObj)
	Move($fileName, $directory)
	GUICtrlSetData($Progresso, 100)
	Sleep(100)
EndFunc   ;==>_Download
Func Move($file, $dir)
	RunWait(@ComSpec & " /c move " & @TempDir & "\" & $file & " " & $opDrive & "\" & $dir, "", @SW_HIDE)
EndFunc   ;==>Move
