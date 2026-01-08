#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT462MNU ºAutor  ³Jorge Saavedra           º Data ³  07/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada que adiciona un boton para imprimir        º±±
±±º          ³de acuerdo a una rutina en especifica 					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INESCO                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT462MNU()

	Do Case
	Case FUNNAME() == 'MATA462TN'
		//	AADD(AROTINA,{ 'Imprimir',"U_REMITSUC()"     , 0 , 5})

		AADD(AROTINA,{ 'Imprimir',"U_TRAINV" , 0 , 5})

		If aCfgNf[1]==54
			AAdd(aRotina,{ "Leyenda"  ,"LocxLegenda()",0 , 2,0,.F.} )
			//AAdd(aCores,{  ' F2_TIPODOC=="54"' , 'BR_LARANJA'})
			AAdd(aCores,{  'U_IsTransPend() .AND.F2_TIPODOC=="54"' , 'BR_LARANJA'})
			AAdd(aCores,{  '!U_IsTransPend() .AND. F2_TIPODOC	==	"54"'    		, 'BR_PRETO'}) 		// Remito transf.
			//AAdd(aCores,{  "F2_DOC=='EDU-SAL-0001'", 'BR_LARANJA'})
		Endif
		//	 	AADD(AROTINA,{ 'Imp. Transf. Serie',"U_TRASERIE" , 0 , 5})
	CASE FUNNAME()='MATA462N'
		AADD(AROTINA,{ 'Impr Nota Entrega',"U_IMPRENTA(F2_DOC,F2_DOC,F2_SERIE,1)", 0 , 5})
		AADD(AROTINA,{ 'Impr Nota media',"U_NOTAMED(F2_DOC,F2_DOC,F2_SERIE,1)", 0 , 5})
	Case FUNNAME()$'MATA102N|MATA462N'
		AADD(AROTINA,{ 'Imprimir',"U_IMPREMITO()"     , 0 , 5})
		//AADD(AROTINA,{ 'Impr Nota Entrega',"U_IMPRENTA(F2_DOC,F2_DOC,F2_SERIE,1)", 0 , 5})
		//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
		//AADD(AROTINA,{ 'Conocimiento',"U_CONOC_REM()"     , 0 , 5})
	Case FUNNAME()=='MATA101N'
		AADD(AROTINA,{ 'Imprimir',"U_FacEnt()"     , 0 , 5})
		//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
	Case FUNNAME() == 'MATA467N'
		//AADD(AROTINA,{ 'Cobro',"U_FactQR()"     , 0 , 5})
		IF !(CUSERNAME $ SuperGetMv("MV_XBORFAC",.F.,cusername)) // caso no pertenezca al grupo que permite borrar factura, elimina la opción Nahim Terrazas 11/01/2022
			ntoDelete := aScan(AROTINA,{|x| "BORRAR" $ Upper(AllTrim(x[1]))})
			oABorrar := AROTINA[ntoDelete]
			AROTINA[ntoDelete] = AROTINA[len(AROTINA)]
			ADel(AROTINA,len(AROTINA))
			ASize(AROTINA,Len(AROTINA)-1)
		endif
		AADD(AROTINA,{ 'Imprimir Factura',"u_imprFat()"     , 0 , 9})
		AADD(AROTINA,{ 'Impr.Media Carta',"u_impFatc()"     , 0 , 9})
		AADD(AROTINA,{ 'Imp. Plan de Pago',"U_PlanPag(F2_CLIENTE,F2_DOC,F2_EMISSAO)"     , 0 , 9})
		AADD(AROTINA,{ 'Impr. Contrato', "U_ContrCre(F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_COND)", 0 , 9})
	EndCase

Return

// Imprimir Carta
user FUNCTION imprFat()
	_cFil		:= SF2->F2_FILIAL
	_cDoc		:= SF2->F2_DOC
	_cDoc		:= SF2->F2_DOC
	_cSerieFac	:= SF2->F2_SERIE

	nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+_cSerieFac,1,"0")
	if (nEnLinea <> "1")
		U_GFATI301(_cDoc,_cDoc,_cSerieFac,1)
	else
		//cNomArq 	:= 'l01000000000000000031nf.pdf'
		cNomArq	:= _cSerieFac + _cDoc + TRIM(SF2->F2_ESPECIE) + '.pdf'
		cDirUsr := GetTempPath()
		cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
		__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
		nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
		If nRet <= 32
			MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
		EndIf
	endif
return

// Imprimir Media Carta
user FUNCTION impFatc()
	_cFil		:= SF2->F2_FILIAL
	_cDoc		:= SF2->F2_DOC
	_cDoc		:= SF2->F2_DOC
	_cSerieFac	:= SF2->F2_SERIE

	nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+_cSerieFac,1,"0")
	if (nEnLinea <> "1")
		U_FACTMEDC(_cFil,_cDoc,_cDoc,_cSerieFac,1)
	else
		//cNomArq 	:= 'l01000000000000000031nf.pdf'
		cNomArq	:= _cSerieFac + _cDoc + TRIM(SF2->F2_ESPECIE) + '.pdf'
		cDirUsr := GetTempPath()
		cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
		__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
		nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
		If nRet <= 32
			MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
		EndIf
	endif
return
