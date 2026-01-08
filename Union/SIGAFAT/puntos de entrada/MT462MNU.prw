#include 'protheus.ch'
#include 'parmtype.ch'

/*
----------------------------------------------------------------------------
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------------------------------------------------------+||
|| Programa  | MT462MNU        autor | Jorge Saavedra Data  | 07/01/12    ||
||+----------------------------------------------------------------------+||
|| Descricao | Punto de Entrada que adiciona un boton para imprimir       ||
||             de acuerdo a una rutina en especifica  	                  ||
||+----------------------------------------------------------------------+||
|| Uso       | Union agronegocios                                         ||
||+----------------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
----------------------------------------------------------------------------
*/

User Function MT462MNU()

	Do Case
		Case FUNNAME() == 'MATA462TN'
			//	AADD(AROTINA,{ 'Imprimir',"U_REMITSUC()"     , 0 , 5})

			IIf(aCfgNf[1]==64,AADD(AROTINA,{ 'Imprimir',"U_TRANS2ENT" , 0 , 5}),AADD(AROTINA,{ 'Imprimir',"U_TRANS2SAL" , 0 , 5})) //e s

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
		Case FUNNAME()$'MATA102N|MATA462N'
			AADD(AROTINA,{ 'Imprimir',"U_IMPREMITO()"     , 0 , 5})
			//AADD(AROTINA,{ 'Impr Nota Entrega',"U_IMPRENTA(F2_DOC,F2_DOC,F2_SERIE,1)", 0 , 5})
			//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
			//AADD(AROTINA,{ 'Conocimiento',"U_CONOC_REM()"     , 0 , 5})
		Case FUNNAME()=='MATA101N'
			AADD(AROTINA,{ 'Imprimir',"U_remitpe(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE)"     , 0 , 5})
			//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
		Case FUNNAME() == 'MATA467N'
			AADD(AROTINA,{ 'Imp. Nota Entrega',"u_impnopv()"     , 0 , 9})
			AADD(AROTINA,{ 'Imprimir Factura',"u_imprFat()"     , 0 , 9})
			AADD(AROTINA,{ 'Imp. Plan de Pago',"U_PlanPag(F2_CLIENTE,F2_DOC,F2_EMISSAO)"     , 0 , 9})

		Case FUNNAME() == 'MATA465N'
			AADD(AROTINA,{ 'Imprimir NCC',"u_imprNcc()"     , 0 , 9})
			AADD(AROTINA,{ 'Imprimir Nota Dev.',"U_UNDEVNO()"     , 0 , 9})
	EndCase

Return

user FUNCTION imprFat()

	local cTemp			:= getNextAlias()
	Local cQuery	    := ""
	Local nlote := '0'
	Local nvalidez
	local valor := SF2->F2_BASIMP1
	local nMoneda := SF2->F2_MOEDA

	If nMoneda == 1

		valortotal := ROUND(valor,2)

		if valortotal >= 50000

			MSGINFO("Esta a punto de emitir una factura igual o mayor a Bs. 50.000 !!!!!! Por favor, exigir el pago mediante : Cheque, Deposito bancario, transferencia, tarjeta de credito." , "AVISO:"  )

		endif

	elseIF nMoneda == 2
		//		alert("entro dolar")

		valorImporteBS := ROUND(xMoeda(valor,2,1,SF2->F2_EMISSAO,3,0,SF2->F2_REFTAXA),2)

		if valorImporteBS >= 50000
			MSGINFO("Esta a punto de emitir una factura igual o mayor a Bs. 50.000 !!!!!! Por favor, exigir el pago mediante : Cheque, Deposito bancario, transferencia, tarjeta de credito." , "AVISO:"  )

		endif

	endif

	cQuery+= "SELECT FP_LOTE , FP_DTAVAL "
	cQuery+= "FROM " + RetSqlName("SF2") + " F2 "
	cQuery+= "JOIN " + RetSqlName("SFP") + " FP "
	cQuery+= "ON F2.F2_SERIE = FP.FP_SERIE "
	cQuery+= "AND F2.F2_FILIAL = FP.FP_FILIAL "
	cQuery+= "AND F2.F2_DOC = '"+ SF2->F2_DOC +"' "
	cQuery+= "AND F2.F2_SERIE = '"+ SF2->F2_SERIE +"' "

	cQuery:= ChangeQuery(cQuery)

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTemp, .F., .T.)
	dbSelectArea(cTemp)
	dbGoTop()

	While (cTemp)->(!EOF())

		nlote := (cTemp)->FP_LOTE
		nvalidez := (cTemp)->FP_DTAVAL

		//	alert(nValor)
		(cTemp)->(dbSkip())
	enddo

	if( val(nlote) == 1)
		alert("No es permitido imprimir Factura manual")
	elseif( val(nlote) == 2)

		nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SFP")+SF2->F2_SERIE,1,"0")
		if (nEnLinea <> "1")
			U_FACTLOCAL(SF2->F2_DOC,SF2->F2_DOC,SF2->F2_SERIE,1,"ORIGINAL")
			U_FACTLOCAL(SF2->F2_DOC,SF2->F2_DOC,SF2->F2_SERIE,1,"COPIA")		
		else
			//cNomArq 	:= 'l01000000000000000031nf.pdf'		
			cNomArq	:= SF2->F2_SERIE + SF2->F2_DOC + TRIM(SF2->F2_ESPECIE) + '.pdf'
			cDirUsr := GetTempPath()
			cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
			__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
			nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
			If nRet <= 32
				MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
			EndIf
		endif
	else
		alert("Revise los datos de la factura, serie u otros")
	endif

return

user function impnopv()

	U_CPICK(SF2->F2_DOC,SF2->F2_SERIE,"ORIGINAL")
	U_CPICK(SF2->F2_DOC,SF2->F2_SERIE,"COPIA")

	/*nVerificador := getCodigo()
	if(nVerificador)
	MSGINFO( "Venta con productos de tipo BIOLOGICO" , "AVISO:"  )
	U_CPICK(SF2->F2_DOC,SF2->F2_SERIE)
	endif*/

return

static FUNCTION getCodigo()
	Local aArea		:= getArea()
	Local cTemp		:= getNextAlias()
	Local cQuery	:= ""
	Local nD2_COD
	Local lRet 		:= .F.

	cQuery := " SELECT D2_COD "
	cQuery += " FROM " + RetSqlName("SF2")
	cQuery += " LEFT JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery += " ON (D2_FILIAL = F2_FILIAL "
	cQuery += " AND D2_DOC = F2_DOC "
	cQuery += " AND D2_SERIE = F2_SERIE "
	cQuery += " AND D2_LOJA = F2_LOJA "
	cQuery += " AND SF2010.D_E_L_E_T_ = ' ' "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ') "
	cQuery += " JOIN "+ RetSqlName("SB1")
	cQuery += " ON D2_FILIAL  = '"+xFilial("SC6")+"' "
	cQuery += " AND  D2_PEDIDO = '"+SC5->C5_NUM+"' "
	cQuery += " AND B1_COD = D2_COD "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN "+ RetSqlName("SC6") +" SC6 "
	cQuery += " ON (C6_FILIAL = D2_FILIAL "
	cQuery += " AND D2_PEDIDO = C6_NUM "
	cQuery += " AND D2_ITEMPV = C6_ITEM) "
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY D2_COD"

	cQuery:= ChangeQuery(cQuery)

	//	Aviso("",cQuery,{'ok'},,,,,.t.)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTemp, .F., .T.)
	dbSelectArea(cTemp)
	(cTemp)->(dbGoTop())

	While (cTemp)->(!EOF() .AND. !lRet)

		SB1->(dbSeek(xFilial("SB1")+(cTemp)->D2_COD))

		nD2_COD := (cTemp)->D2_COD

		if(SB1->B1_UTIPOPR = '003')
			lRet := .T.
		endif

		(cTemp)->(dbSkip())
	enddo
	(cTemp)->(dbCloseArea())
	restArea(aArea)
return lRet

user FUNCTION imprNcc()
	nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SFP")+SF1->F1_SERIE,1,"0")
	if (nEnLinea <> "1")
		U_NOTAUNION(SF1->F1_DOC,SF1->F1_DOC,SF1->F1_SERIE,1,"ORIGINAL")
		U_NOTAUNION(SF1->F1_DOC,SF1->F1_DOC,SF1->F1_SERIE,1,"COPIA")
	else
		//cNomArq 	:= 'l01000000000000000031nf.pdf'		
		cNomArq	:= SF1->F1_SERIE + SF1->F1_DOC + TRIM(SF1->F1_ESPECIE) + '.pdf'
		cDirUsr := GetTempPath()
		cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
		__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
		nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
		If nRet <= 32
			MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
		EndIf
	endif
return
