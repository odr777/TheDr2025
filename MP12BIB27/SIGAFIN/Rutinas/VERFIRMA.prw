#include 'protheus.ch'
#include 'parmtype.ch'
#include "fileio.ch"

user function VERFIRMA()

	local cEncode64 :=  SubStr(SE2->E2_USIGN, 23 )

	DEFINE DIALOG oDlg TITLE "Imagen" FROM 180,180 TO 500,600 PIXEL

//	cFLogo := GetSrvProfString("Startpath","") + "logopr2.png"	
	
	cDecode64 := Decode64(cEncode64,"/Users/edson/Downloads/imagedds.png",.F.)	
	
	fHdl := fOpen("/Users/edson/Downloads/image.png",FO_READ,,.F.)
	
	oTBitmap1 := TBitmap():New(50,55,260,184,,fHdl,.T.,oDlg,;
	{||Alert(cEncode64)},,.F.,.F.,,,.F.,,.T.,,.F.)
	oTBitmap1:lAutoSize := .T.

	@ 110,85  BUTTON btn PROMPT "Salir" SIZE 40,15 ;
	ACTION (resp := .T. , oDlg:End()) OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTERED

return