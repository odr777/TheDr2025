#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ OrdenFact x GFATI301 ³Edson G Mamani	 º Data ³ 11/04/19	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Orden de entrega                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP11BIB					query: Erick Etcheverry           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function OrdenFact(cxNro1,cxNro2,cxSerie,nLinInicial)

	OrdEntr('Orden de Entrega',.F.,cxNro1,cxNro2,cxSerie,nLinInicial)
	
Return nil

Static function OrdEntr(cTitulo,bImprimir,cNroFat1,cNroFat2,cSerie,nLinInicial)
	Private oPrn    := NIL
	Private oFont10  := NIL
	Private nTotPags := 1
	private oDelete := delFiles():new()
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetCurrentPrinterInUse()
	oPrn:SetPortrait()
	oPrn:setPaperSize(DMPAPER_LETTER)

	DEFINE FONT oFont08 NAME "Arial" SIZE 0,08 OF oPrn
	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 OF oPrn
	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oFont10N NAME "Arial" SIZE 0,10 Bold  OF oPrn
	DEFINE FONT oFont105N NAME "Arial" SIZE 0,10.5 Bold  OF oPrn
	DEFINE FONT oFont11N NAME "Arial" SIZE 0,11 Bold  OF oPrn
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
	DEFINE FONT oFont12N NAME "Arial" SIZE 0,12 Bold  OF oPrn
	DEFINE FONT oFont20N NAME "Arial" SIZE 0,20 Bold  OF oPrn
	DEFINE FONT oFont32N NAME "Arial" SIZE 0,32 OF oPrn
	DEFINE FONT oFont40N NAME "Arial" SIZE 0,40 OF oPrn
	FatMat(cNroFat1,cNroFat2,cSerie,cTitulo,bImprimir,1,nLinInicial) //Impresion de Orden De entrega
return Nil

static function FatMat(cDoc1,cDoc2,cSerie,cTitulo,bImprimir,nCopia,nLinInicial)
	Local aDupla   := {}
	Local aDetalle := {}
	Local aDetPen := {}
	Local nCantReg := 0
	Local bSw	   := .T.
	Local cMsgFat  := ""
	Local NextArea := GetNextAlias()
	Local cDireccion := ""
	Local cTelefono := ""
	Local cFilFact := ""
	LOCAL cPedid := ""
	local aDados
	Local i

	Local cSql	:= "SELECT F2_FILIAL,F2_REFTAXA,F2_REFMOED,F2_SERIE,F2_DOC,F2_NUMAUT,F2_EMISSAO,F2_UNOMCLI,F2_UNITCLI,F2_COND,F2_VALFAT,ROUND(F2_DESCONT,2) F2_DESCONT,F2_BASIMP1,F2_CODCTR,FP_DTAVAL,F2_USRREG,D2_PEDIDO,A1_MUN, A1_BAIRRO,A1_END"
	cSql		:= cSql+",F2_CLIENTE,F2_LOJA,F2_ESPECIE,F2_VEND1,D2_REMITO,D2_SERIREM,D2_CLIENTE,D2_COD,D2_ITEM,D2_FILIAL,D2_LOJA,A3_NOME , NNR_DESCRI ,    C5_ULUGENT"
	cSql		:= cSql+" FROM " + RetSqlName("SF2 ") +" SF2 JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F2_CLIENTE AND (F2_DOC BETWEEN '"+cDoc1+"' AND '"+cDoc2+ "' ) AND F2_SERIE='"+cSerie+"' AND SF2.D_E_L_E_T_ =' ' AND SA1.D_E_L_E_T_ =' ' AND A1_LOJA=F2_LOJA AND F2_ESPECIE='NF' ) "
	cSql		:= cSql+" JOIN " + RetSqlName("SD2") +" SD2 ON (D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_LOJA=F2_LOJA AND D2_ITEM='01' AND SD2.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" JOIN " + RetSqlName("SFP") +" SFP ON (FP_FILUSO=F2_FILIAL AND FP_SERIE=F2_SERIE AND SFP.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" AND F2_FILIAL='" + xFilial("SF2") + "' "
	cSql		:= cSql+" LEFT JOIN " + RetSqlName("SA3") +" SA3 ON A3_COD = F2_VEND1 "
	cSql		:= cSql+" LEFT JOIN " + RetSqlName("NNR") +" NNR ON NNR_FILIAL = F2_FILIAL AND F2_DOC = NNR_CODIGO"
	cSql		:= cSql+" LEFT JOIN " + RetSqlName("SC5") +" SC5 ON C5_CLIENTE = F2_CLIENTE  AND C5_NOTA = F2_DOC"
	cSql		:= cSql+" Order By F2_DOC"

//	aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	If !Empty(D2_REMITO)
		cPedid:= GETADVFVAL("SD2","D2_PEDIDO",D2_FILIAL+D2_REMITO+D2_SERIREM+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM,3,"erro")
	else
		cPedid := D2_PEDIDO
	ENDIF

	if(! EMPTY(F2_NUMAUT))//No deja imprimir si el numero de autorizacion esta mal realizado
		While !Eof()
			bSw		:= .T.

			If ( bSw == .T.)
				sDoc := F2_DOC
				sSerie := F2_SERIE
			
				AADD(aDupla,F2_FILIAL)		  	//1
				AADD(aDupla,sSerie)           //2
				AADD(aDupla,sDoc)             //3
				AADD(aDupla,F2_NUMAUT)          //4
				AADD(aDupla,F2_EMISSAO)         //5
				AADD(aDupla,F2_UNOMCLI)         //6
				AADD(aDupla,F2_UNITCLI)         //7
				AADD(aDupla,F2_COND)            //8
				AADD(aDupla,F2_VALFAT)          //9
				AADD(aDupla,F2_DESCONT)         //10
				AADD(aDupla,F2_BASIMP1)  		//11
				AADD(aDupla,F2_CODCTR)          //12
				AADD(aDupla,FP_DTAVAL)          //13
				AADD(aDupla,NIL)		    //14	//	AADD(aDupla,F2_UNROIMP)		    //14
				AADD(aDupla,cPedid)		    //15
				AADD(aDupla,A1_MUN)		    	//16
				AADD(aDupla,A1_BAIRRO)		    //17
				AADD(aDupla,A1_END)		    //18	//	AADD(aDupla,A1_UDIRFAC)		    //18
				AADD(aDupla,F2_USRREG)		    //19
				AADD(aDupla,F2_CLIENTE)		    //20
				AADD(aDupla,F2_LOJA)		    //21
				AADD(aDupla,F2_ESPECIE)		    //22
				AADD(aDupla,NIL)			    //23	//	AADD(aDupla,FP_SFC)			    //23
				AADD(aDupla,NIL)			//24	//	AADD(aDupla,F2_UAUTPRC)			//24
				AADD(aDupla,F2_VEND1)			//25
				AADD(aDupla,F2_REFTAXA)			//26
				AADD(aDupla,F2_REFMOED)			//27
				AADD(aDupla,A3_NOME)			//28
				AADD(aDupla,NNR_DESCRI)			//29
				AADD(aDupla,C5_ULUGENT)			//30

				aDetalle := FatDet(sDoc,sSerie)                	   	//Datos detalle de factura
				aDetPen := FatDetPen(sDoc,sSerie,cPedid) // datos detalle de ordenes pendientes 

				nCantReg := len(aDetalle)
				nCantReg += len(aDetPen)

				//Acumula para sacar el total de paginas Erick
				for i:= 1 to nCantReg
					if nCantReg >=37
						nCantReg = nCantReg - 37
						//	alert(nCantReg)
						nTotPags ++
					endif
				next i

				cFilFact := aDupla[1]
				DbSelectArea("SM0")
				SM0->(DBSETORDER(1))
				SM0->(DbSeek(cEmpAnt+cFilFact))

				cDireccion := AllTrim(SM0->M0_ENDENT)
				cTelefono := "Teléfono: "+AllTrim(SM0->M0_TEL)+If(!Empty(SM0->M0_FAX)," Fax: "+AllTrim(SM0->M0_FAX),"")

				FatImp(cTitulo,bImprimir,aDupla,aDetalle,aDetPen,nLinInicial,"ORIGINAL",cDireccion,cTelefono)    	//Imprimir Factura

				UpCntFat(aDupla[3],aDupla[2],aDupla[1],'NF')
				dbSelectArea(NextArea)
				aDupla:={}
			EndIf
			DbSkip()
		EndDo
		#IFDEF TOP
		dBCloseArea(NextArea)
		#ENDIF
		If (Len(cMsgFat)>0)
			cMsgFat	 :=SubStr(cMsgFat,1,Len(cMsgFat)-1)
			cMsgFat  :="Su Cuenta de Usuario No Esta Habilitado Para Imprimir Las Siguientes Facturas Ya Impresas:" +cMsgFat
			MsgInfo (cMsgFat)
		EndIf
		oPrn:Refresh()
		If bImprimir
			oPrn:Print()
		Else
			oPrn:Preview()
		End If

		/*Llama a la clase delFiles para que traiga los nombres a borrar Erick*/
		aDados := oDelete:getFiles()
		for i:= 1 to len(aDados)

			FERASE(aDados[i])//borra archivos

		next i

		oPrn:End()//Fin de la impresion
	ELSE
		MSGINFO("Código de Dosificación Invalido para imprimir la Factura")
	endif

return aDupla

//Private nContador := 0
static function FatImp(cTitulo,bImprimir,aMaestro,aDetalle,aPend,nLinInicial,cTipo,cDireccion,cTelefono)
	Local _nInterLin := 650
	Local aInfUser := pswret()
	Local nI:=0
	Local nItemFact:= 37
	Local nDim:=0
	Local _tamdesc:=80
	Local aDescTot := {}
	Local nDes1 := 0
	Local nDes2 := 0
	Local nDes3 := 0
	Local nDes4 := 0
	Local nSavedP := 0 /* to keep track of the position/row */
	Local nIb
	Default nLinInicial := 0
	Private nCont := 0
	Private nContador := 0
	Private nCantTotal := 0
	nDim:=len(aDetalle)

	CabOrdenFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	_nInterLin += nLinInicial

	For nI:=1 to nDim
		nDes1 = nDes1 + aDetalle[nI][7]
		nDes2 = nDes2 + aDetalle[nI][8]
		nDes3 = nDes3 + aDetalle[nI][9]
		nDes4 = nDes4 + aDetalle[nI][10]
	Next
	aadd(aDescTot,nDes1)
	aadd(aDescTot,nDes2)
	aadd(aDescTot,nDes3)
	aadd(aDescTot,nDes4)
	Private auxCant := 0
	For nI:=1 to nDim
		nContador ++	//edson. cuenta los item de la factura
		nSavedP++
		
		oPrn:Say(_nInterLin,80,cValtochar(nContador) ,oFont08)  //contador
		oPrn:Say(_nInterLin,220,FmtoValor(aDetalle[nI][4],10,0),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,440,memoline(aDetalle[nI][11],_tamdesc,1),oFont08)  //unidad
		oPrn:Say(_nInterLin,700,memoline(aDetalle[nI][1],_tamdesc,1),oFont08)  //Codigo
		oPrn:Say(_nInterLin,1300,memoline(aDetalle[nI][2],_tamdesc,1),oFont08)  //Descripcion
		oPrn:Say(_nInterLin,1860,memoline(aDetalle[nI][12],_tamdesc,1),oFont08)  //Descripcion

		auxCant = aDetalle[nI][4]
		nCantTotal := nCantTotal + auxCant

		_nInterLin:=_nInterLin+50

		_nlindet:=mlcount(allTrim(aDetalle[nI][2]),_tamdesc)

		If _nlindet > 1
			For nIb := 2 To  _nlindet
				oPrn:Say(_nInterLin,320,memoline(aDetalle[nI][2],_tamdesc,nIb),oFont08)  //Descripcion
				_nInterLin:=_nInterLin+50
			Next nIb
		EndIf
		if nI >= nItemFact	//Valida cambio de hoja
			PieFact(nLinInicial,aMaestro,nCont,aDescTot)
			_nInterLin := 720
			CabOrdenFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
			_nInterLin += nLinInicial
			nItemFact := nItemFact + 37
			
			nSavedP := 0
		Endif
	Next nI
	
	oPrn:Box( _nInterLin + 50, 50 ,  _nInterLin + 50 , 2360 )  // Edson  linea inferior
	_nInterLin := totaliza(_nInterLin,aMaestro,nCont,aDescTot,nCantTotal)
	
	/* IMPRIMIENDO ORDENES PENDIENTES */
	if !empty(aPend)
		CabOrdenPend(_nInterLin)
		_nInterLin += 100
		
		nDim := len(aPend)
		nContador := 0
		nCantTotal := 0
		For nI:=1 to nDim
			nContador++
		
			oPrn:Say(_nInterLin,80,cValtochar(nContador) ,oFont08)
			oPrn:Say(_nInterLin,220,FmtoValor(aPend[nI][3],10,0),oFont10) /* cantidad */
			oPrn:Say(_nInterLin,440,memoline(aPend[nI][4],_tamdesc,1),oFont08) /* unidad */
			oPrn:Say(_nInterLin,700,memoline(aPend[nI][1],_tamdesc,1),oFont08) /* codigo */
			oPrn:Say(_nInterLin,1300,memoline(aPend[nI][2],_tamdesc,1),oFont08) /* nombre/descripcion */
			
			auxCant := aPend[nI][3]
			nCantTotal := nCantTotal + auxCant
			
			_nInterLin:=_nInterLin+50

			_nlindet:=mlcount(allTrim(aPend[nI][2]),_tamdesc)
			
			if nI + nSavedP >= nItemFact	// Valida cambio de hoja
				PieFact(nLinInicial,aMaestro,nCont,aDescTot)
				_nInterLin := 720
				CabOrdenPend(nLinInicial)
				_nInterLin += nLinInicial
				nItemFact := nItemFact + 37
			Endif
		
		Next nI
	
	
		oPrn:Box( _nInterLin + 50, 50 ,  _nInterLin + 50 , 2360 )  // Edson  linea inferior
		oPrn:Say( _nInterLin + 60, 220, FmtoValor(nCantTotal,10,0) ,oFont10 )
		_nInterLin += 100
	endif
	
	PieFact(_nInterLin,aMaestro,nCont,aDescTot,nCantTotal)

return

Static Function CabOrdenFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	Local cFecVen := ""

	nCont ++ // cuenta hojas Erick
	oPrn:StartPage()
	cFechaPed := If(!Empty(aMaestro[15]),DTOC(Posicione("SC5",1,xFilial("SC5")+aMaestro[15],"C5_EMISSAO")),"") //fecha pedido

	//Edson 22/03/2019
	oPrn:Say( nLinInicial + 50 , 50,"Industris belen Srl." , oFont10)
	oPrn:Say( nLinInicial + 100, 50,"Productos Terminados" , oFont10)

	oPrn:Say( nLinInicial + 50 , 800,"ORDEN DE ENTREGA" , oFont20N)
	oPrn:Say( nLinInicial + 130, 1100,"(FACTURA)" , oFont10)

	oPrn:Say( nLinInicial + 50, 1650,"FACTURA No: "  ,oFont12N )
	oPrn:Say( nLinInicial + 50, 2000,AllTrim(str(val(aMaestro[3]))) ,oFont12N ) //Nro Factura

	oPrn:Say( nLinInicial + 100, 1650,"Nro. Aut : "  ,oFont12N )
	oPrn:Say( nLinInicial + 100, 2000, aMaestro[4] ,oFont12N ) //Nro Autorizacion
	oPrn:Say( nLinInicial + 150, 1720,"RE-IMPRESION"  ,oFont12 )
	oPrn:Say( nLinInicial + 200, 1720,"CRÉDITO"  ,oFont12)

	oPrn:Say( nLinInicial + 310, 50,"Cliente : " + aMaestro[6] , oFont10)
	oPrn:Say( nLinInicial + 310, 900,"NIT : " + AllTrim(Transform(SM0->M0_CGC,"999999.99")) ,oFont10)
	oPrn:Say( nLinInicial + 310, 1620,"Número : " + aMaestro[2] +"/" + AllTrim(str(val(aMaestro[3]))), oFont10)

	oPrn:Say( nLinInicial + 370, 50, aMaestro[6] ,oFont10)
	oPrn:Say( nLinInicial + 370, 900, cTelefono ,oFont10)
	oPrn:Say( nLinInicial + 370, 1620,"Fecha : " + DTOC(STOD(aMaestro[5])),oFont10)

	oPrn:Say( nLinInicial + 430, 50, aMaestro[18] + "    SANTA CRUZ" ,oFont10)

	if nTotPags >= 2
		oPrn:Say( nLinInicial + 375, 1100,"Pag: "+ cvaltochar(nCont) + " de " + cvaltochar(nTotPags) ,oFont09 )
	endif

	If aMaestro[8]=="002"
		cFecVen := DTOC(STOD(aMaestro[5]))
	Else
		cFecVen := FechVcto(aMaestro[1],aMaestro[3],aMaestro[2],aMaestro[20],aMaestro[21])
		If !Empty(cFecVen)
			cFecVen := DTOC(STOD(cFecVen))
		Else
			cFecVen := DTOC(STOD(aMaestro[5]))
		EndIf
	EndIf

	//Titulos reporte
	oPrn:Say(nLinInicial + 540, 50, "ITEM" ,oFont10N )
	oPrn:Say(nLinInicial + 540, 220, "CANTIDAD" ,oFont10N )
	oPrn:Say(nLinInicial + 540, 440, "UNIDAD" ,oFont10N )
	oPrn:Say(nLinInicial + 540, 700, "CODIGO" ,oFont10N )
	oPrn:Say(nLinInicial + 540, 1300, "NOMBRE / DESCRIPCION" ,oFont10N )
	oPrn:Say(nLinInicial + 540, 2100, "UBICACION" ,oFont10N )

	//				x                 y     x      y
	oPrn:Box( nLinInicial + 590 , 50 ,  590 , 2360 )  // Edson  linea superior

Return Nil

Static Function CabOrdenPend(nLinInicial)
	
	oPrn:StartPage()
	
	oPrn:Say(nLinInicial - 50, 50, "PENDIENTES DE ENTREGA" ,oFont10N )
	
	oPrn:Say(nLinInicial, 50, "ITEM" ,oFont10N )
	oPrn:Say(nLinInicial, 220, "CANTIDAD" ,oFont10N )
	oPrn:Say(nLinInicial, 440, "UNIDAD" ,oFont10N )
	oPrn:Say(nLinInicial, 700, "CODIGO" ,oFont10N )
	oPrn:Say(nLinInicial, 1300, "NOMBRE / DESCRIPCION" ,oFont10N )

Return Nil

static function totaliza(nLinInicial,aMaestro,nCont,aDesc,nCantTotal)

	oPrn:Say(nLinInicial + 60, 220,FmtoValor(nCantTotal,10,0) ,oFont10 )
	oPrn:Say(nLinInicial + 60, 1200, aMaestro[28],oFont10 )
	
	if !Empty(aMaestro[29])
	
		oPrn:Say(nLinInicial + 60, 300, aMaestro[29],oFont10 )
		nLinInicial += 60
	endif
	
	nLinInicial += 220
	
return nLinInicial

Static Function PieFact(nLinInicial,aMaestro,nCont,aDesc,nCantTotal)

	oPrn:Say(nLinInicial + 200, 910, "Cliente - Recibido Conforme" ,oFont10 )
	oPrn:Say(nLinInicial + 250, 910, "Nombre : " ,oFont10 )
	oPrn:Say(nLinInicial + 300, 910, "C.I.   : " ,oFont10 )

	oPrn:Say(nLinInicial + 200, 1610, "Transportista - Recibido Conforme" ,oFont10 )
	oPrn:Say(nLinInicial + 250, 1610, "Empresa de transportista : " ,oFont10 )
	oPrn:Say(nLinInicial + 300, 1610, "Placa  : " ,oFont10 )
	oPrn:Say(nLinInicial + 350, 1610, "Chofer : " ,oFont10 )
	oPrn:Say(nLinInicial + 400, 1610, "C.I.   : " ,oFont10 )
	oPrn:EndPage()

Return

Static Function TPix(nTam,cBorder,cTipo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desconta area nao imprimivel (Lexmark Optra T) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cBorder == "lb"			// Left Border
		nTam := nTam - 0.40
	ElseIf cBorder == "tb" 		// Top Border
		nTam := nTam - 0.60
	EndIf

	nPix := nTam * 120

Return(nPix)

static function FatDet (cDoc,cSerie) // Datos detalle de factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	cUnidad		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local   cLocal 		:= ""
	Local   cUbicacion 	:= ""
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT B1_COD, CASE WHEN LEN(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),''))=0 THEN C6_DESCRI "
	cSql				:= cSql+"ELSE ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),'') END B1_DESC, "
	cSql				:= cSql+"D2_LOTECTL,D2_DTVALID,D2_QUANT,CASE WHEN D2_PRUNIT!=0 THEN D2_PRUNIT ELSE D2_PRCVEN END D2_PRUNIT,CASE WHEN D2_PRUNIT!=0 THEN D2_QUANT*D2_PRUNIT ELSE D2_QUANT*D2_PRCVEN END D2_TOTAL, D2_PEDIDO, D2_ITEMPV , D2_DOC ,D2_FILIAL , D2_UM ,  C6_LOCALIZ "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"LEFT JOIN "+ RetSqlName("SC6") +" SC6 ON (C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM) AND SC6.D_E_L_E_T_=' ' "
	cSql				:= cSql+"ORDER BY D2_PEDIDO,D2_ITEM"

	//Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	//Descuentos para
	cPedc5 := ""
	aDescon := {}

	While !Eof()
		if cPedc5 <> D2_PEDIDO
			aDescon := getDescont(D2_DOC,D2_FILIAL,D2_PEDIDO)
		endif
		cPedc5 := D2_PEDIDO

		cProducto	:=B1_COD
		cNombre		:=B1_DESC
		If Len(AllTrim(D2_DTVALID+D2_DTVALID))>0
			cLote       :="L:"+AllTrim(D2_LOTECTL)+" V:"+ALLTRIM(STRZERO(MONTH(STOD(D2_DTVALID)),2))+ALLTRIM("/")+ALLTRIM(STRZERO(Year(STOD(D2_DTVALID)),4))
		Else
			cLote       := ""
		EndIf
		
		cPedido		:=D2_PEDIDO
		cItPedido	:=D2_ITEMPV
		nCant		:=D2_QUANT
		nPrecio		:=D2_PRUNIT
		nTotal		:=Round(nCant*nPrecio,2)
		cUnidad 	:=D2_UM
		cUbicacion 	:=C6_LOCALIZ

		aPerc := getDescPerc(nCant,aDescon,nPrecio) //Descuentos

		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,cLote)      //3
		AADD(aDupla,nCant)      //4
		AADD(aDupla,nPrecio)    //5
		AADD(aDupla,nTotal)     //6
		AADD(aDupla,aPerc[1])     //7 desc 1 usados de cliente
		AADD(aDupla,aPerc[2])     //8 desc 2
		AADD(aDupla,aPerc[3])     //9 desc 3
		AADD(aDupla,aPerc[4])     //10 desc 4 usados otros
		AADD(aDupla,cUnidad)     //11
		AADD(aDupla,cUbicacion)     //12

		AADD(aDatos,aDupla)
		DbSkip()
	end do
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
return  aDatos

Static Function UpCntFat(cNroFat,cSerie,cFilVta,cEspecie)
	Local bSw	:= .F.
	Local cSql	:= ""
	Local nSql	:= 0
	cSql	:=cSql+ "Update " + RetSqlName("SF2") +" Set "
	cSql	:=cSql+ "Where "
	cSql	:=cSql + "F2_DOC		= '"+cNroFat+"'  And "
	cSql	:=cSql + "F2_SERIE	= '"+cSerie+"' 	 And "
	cSql	:=cSql + "F2_FILIAL	= '"+cFilVta+"'	 And "
	cSql	:=cSql + "F2_ESPECIE	= '"+cEspecie+"' And "
	cSql	:=cSql + RetSqlName("SF2") +".D_E_L_E_T_ = ' ' "
	If ( nSql >=0)
		bSw:=.T.
	EndIf
Return bSw

Static Function  VldImpFat ()
	Local bSw 		:= .F.
	Local aDtsUsr	:=  &(GETMV("MV_UIMPFAC"))
	Local cUsrLocal	:= Alltrim(__CUSERID)
	Local nI		:= 0
	Local nDim		:= Len(aDtsUsr)
	For nI := 1 To  nDim
		If (aDtsUsr[nI] == cUsrLocal)
			bSw := .T.
		EndIf
	Next nI
Return bSw

Static Function FechVcto(cFil,cNroDoc,cPrefijo,cCliente,cLoja)
	Local cFechVcto := ""
	Local 	NextArea	:= GetNextAlias()

	Local cSql	:= "SELECT TOP 1 E1_VENCREA "
	cSql		:= cSql+" FROM " + RetSqlName("SE1") +" SE1 "
	cSql		:= cSql+" WHERE E1_FILIAL='"+cFil+"' AND E1_NUM='"+cNroDoc+"' AND E1_PREFIXO='"+cPrefijo+"' AND E1_CLIENTE='"+cCliente+"' AND E1_LOJA='"+cLoja+"' AND E1_SALDO <> 0 AND SE1.D_E_L_E_T_=' ' "
	cSql		:= cSql+" ORDER BY E1_PARCELA"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	cFechVcto	:= E1_VENCREA

Return cFechVcto

Static Function FmtoValor(cVal,nLen,nDec)
	Local cNewVal := ""
	If nDec == 2
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 9,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal

static Function getDescont(cNota,cFilla,cPed) //una linea debería ser
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local acNped := {}

	//Montando a Consulta... Tentem evitar o SELECT * pois isso pode travar o TOPCONN
	cQuery := " SELECT "
	cQuery += "   C5_DESC1, C5_DESC2, C5_DESC3, C5_DESC4 "
	cQuery += " FROM "
	cQuery += "   " + RetSQLName("SC5") + " SC5 "
	cQuery += " WHERE "
	cQuery += " SC5.D_E_L_E_T_ = ' ' "  // edson
	cQuery += " and C5_FILIAL = '"+cFilla+"' AND C5_NUM = '"+ cPed +"'"

	cQuery := ChangeQuery(cQuery)

	//Executando consulta
	TCQuery cQuery New Alias "qrr_SC5"

	//Percorrendo os registros
	While ! qrr_SC5->(EoF())
		AADD(acNped,qrr_SC5->C5_DESC1)
		AADD(acNped,qrr_SC5->C5_DESC2)
		AADD(acNped,qrr_SC5->C5_DESC3)
		AADD(acNped,qrr_SC5->C5_DESC4)
		qrr_SC5->(DbSkip())
	EndDo

	qrr_SC5->(DbCloseArea())
	RestArea(aArea)

Return acNped

//nQuan cantidad aPerDes - Array de descuentos hay 4 -  nPrunit precio unitario eet
static function getDescPerc(nQuan,aPerDes,nPrunit)
	Local aDesc := {}
	Local nPrUnitari := nPrunit
	Local nTmpDesc := 0 //Descuento al precio unitario 23 - 10% = 2,3
	Local nPrUnAct := 0 //Descuento al precio unitario 23 - 10 = 20,7
	Local i
	/* VALIDATION */
	if empty(aPerDes)
		aadd(aDesc,0)
		aadd(aDesc,0)
		aadd(aDesc,0)
		aadd(aDesc,0)
	endif

	for i:=1 to len(aPerDes)
		if aPerDes[i] > 0
			nPrUnAct := nPrUnitari * (aPerDes[i]/100) // 1,15
			nTmpDesc := nPrUnitari - nPrUnAct // 21,85
			
			nPrUnitari := nTmpDesc
			nDescont := noround(nPrUnAct*nQuan,1)

			aadd(aDesc,nDescont)
		else
			aadd(aDesc,0)
		endif
	next i

return aDesc


static function FatDetPen(cDoc,cSerie,cPed) /* Pendientes de entrega */
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cUnidad		:= ""
	Local	nCant		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local cSql := "SELECT C6_UM,C6_QTDVEN,C6_PRODUTO, CASE WHEN LEN(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),''))=0 THEN C6_DESCRI ELSE ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),'') END B1_DESC " +;
		" FROM " + RetSqlName("SC6") + " SC6 " +;
		" JOIN " + RetSqlName("SC5") + " SC5 ON C6_NUM = C5_NUM " +;
		" LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_PEDIDO = C5_NUM AND C6_ITEM = D2_ITEM " +;
		" LEFT JOIN " + RetSqlName("SB1") + " SB1 ON (D2_DOC = '" + cDoc + "' AND D2_SERIE = '" + cSerie + "' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) " +;
		" AND D2_DOC = '" + cDoc + "' " +;
		" AND D2_SERIE = '" + cSerie + "' " +;
		" WHERE C6_NUM = '" + cPed + "' " +;
		" AND D2_PEDIDO IS NULL " +;
		" UNION " +;
		" SELECT C6_UM,C6_QTDVEN-C6_QTDENT C6_QTDVEN,C6_PRODUTO, CASE WHEN LEN(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),''))=0 THEN C6_DESCRI ELSE ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),'') END B1_DESC " +;
		" FROM " + RetSqlName("SC6") + " SC6 " +;
		" JOIN " + RetSqlName("SC5") + " SC5 ON C6_NUM = C5_NUM " +;
		" LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_PEDIDO = C5_NUM AND C6_ITEM = D2_ITEM " +;
		" LEFT JOIN " + RetSqlName("SB1") + " SB1 ON (D2_DOC = '" + cDoc + "' AND D2_SERIE = '" + cSerie + "' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) " +; 
		" AND D2_DOC = '" + cDoc + "' " +;
		" AND D2_SERIE = '" + cSerie + "' " +;
		" WHERE C6_NUM = '" + cPed + "' " +;
		" AND C6_QTDVEN-C6_QTDENT > 0"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	While !Eof()
		cProducto	:= C6_PRODUTO
		cNombre		:= B1_DESC
		nCant		:= C6_QTDVEN
		cUnidad 	:= C6_UM

		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,nCant)      //3
		AADD(aDupla,cUnidad)    //4

		AADD(aDatos,aDupla)
		DbSkip()
	end do
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
return  aDatos
