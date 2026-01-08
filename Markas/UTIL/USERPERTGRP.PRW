#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUserPertGrp บAutor  ณEDUAR ANDIA       บ Data ณ  24/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funci๓n que verifica si el usuario logueado u otro usuario บฑฑ
ฑฑบ          ณ Pertenece a un Grupo de Usuario                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function UserPertGrp(cGrupo,cNomeUser)
Local cCodGrupo	:= ""
Local aDadUser	:= {}
Local aGrupo		:= {}
Local i			:= 0
Local lRet			:= .F.
Default cNomeUser	:= SubStr(cUsuario,7,15)	// Nombre del Usuario Logueado

PSWorder(2)
If PswSeek(cNomeUser,.T.)
	aDadUser	:= Pswret(1)
 	aGrupo		:= Array(Len(aDadUser[1,10]))
  	PswOrder(1)
   	For i:=1 to Len(aDadUser[1,10])
    	If PswSeek(aDadUser[1,10,i],.F.)
     		aGrupo[i]	:= Pswret(NIL)        		
       		cCodGrupo  	:= aGrupo[i,1,1] // C๓digo del Grupo: 000001
       		If cCodGrupo == cGrupo
       			lRet	:= .T.
       			Exit
       		Endif
       	Endif
   	Next
Endif
Return(lRet)