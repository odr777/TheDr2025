#Include "protheus.ch"
#Include "parmtype.ch"
#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณA087TUDOK  บAutor  TdeP Horeb SRL    บData  21/12/2019      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฑฑ
ฑฑบDesc.     ณPUNTO DE ENTRADA que valida cada salto de pantalla en	  	  บฑฑ
ฑฑบ           cobros diversos FINA087A      				  			  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฑฑ
ฑฑบUso       ณMP12BIB -UNIONAGRO					  					  บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A087TUDOK()
	Local lRet 		:= .T.	
	Local nCont1 	:= 0
	Local nCont2 	:= 0
	Local nCont3 	:= 0
	Local nCont4 	:= 0
	Local nCont5 	:= 0
	Local lValida 	:= .T.
	Local lValida1 	:= .T.
	Local lValida2 	:= .T.
	local cValRc 	:= ""
	Local nX 		:= 1
	
	Local nPosBcoDep	:= 0
	Local nPosAgeDep	:= 0
	Local nPosCtaDep	:= 0
	
  //Local cNomCliTit	:= cNome

	If GetRemoteType() < 0 // nahim Terrazas toma en cuenta s๓lo si no es un web services
		return .T.
	endif
	
	If nPanel == 1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Valida existencia Banco /Caja -Ag-Cta	ณ
		//ณ EA 30/01/2020							ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		nPosBcoDep	:= AScan(aHeader,{|x|Alltrim(x[2]) == "EL_BANCO"	})
		nPosAgeDep	:= AScan(aHeader,{|x|Alltrim(x[2]) == "EL_AGENCIA"	})
		nPosCtaDep	:= AScan(aHeader,{|x|Alltrim(x[2]) == "EL_CONTA"	})
		
		For nI:= 1 to Len(aCols)
			If !(aCols[n][Len(aCols[n])])    // Somente Linhas n?o Deletadas
				If !Empty(aCols[n][nPosBcoDep])
					
					DbSelectArea("SA6")
					DbSetOrder(1)
					If !DbSeek(xFilial("SA6")+aCols[n][nPosBcoDep]+aCols[n][nPosAgeDep]+aCols[n][nPosCtaDep])
						Help("",1,"FA087BCO")  //"Caja no existente"
						lRet	:=	.F.
					Endif
				Endif
			Endif
		Next nI
				
		//---------------------------
		If !lRet
			Return(lRet)
		Endif
		
	Endif
	
	
	If nPanel == 2  .and. type("_nValFac") <> "U"// cuando es panel uno va a validar el pedido
		//
				aLinSE1[1][1] := 1 // Nahim Escogiendo la cuenta a pagar en este caso es la nro 000533 - 356,7
				// escojo el monto
			    if aLinMoed[2][3] > 0 // validando si tenemos saldo en d๓lares
				 	aLinSE1[1][Ascan(aCposSE1,"nBxMoeda2")] += aLinMoed[2][3]			    	
				 	if aLinSE1[1][Ascan(aCposSE1,"E1_MOEDA")] == 2 // caso sea d๓lar
				 		aLinSE1[1][Ascan(aCposSE1,"nBaixar")] += aLinMoed[2][3]// * aLinMoed[2][3] // monto total a bajar montPagar
				 	else
				 		aLinSE1[1][Ascan(aCposSE1,"nBaixar")] += aLinMoed[2][2] * aLinMoed[2][3] // monto total a bajar montPagar				 	
				 	endif
//				 	aLinSE1[1][Ascan(aCposSE1,"nBaixar")] += aLinMoed[2][2] * aLinMoed[2][3] // solamente en DำLARES
				aLinSE1[1][Ascan(aCposSE1,"cMotBxSE1")]:= "NOR"	// NAHIM ESTA
				endif
				// TODO EN Bolivianos convertir ret
				if aLinMoed[1][3] > 0// validando si existe saldo en Bs.
					aLinSE1[1][Ascan(aCposSE1,"nBxMoeda1")] += aLinMoed[1][3]
				 	// caso pague igual
				 	if aLinSE1[1][Ascan(aCposSE1,"E1_MOEDA")] == 2 // caso sea d๓lar
				 		aLinSE1[1][Ascan(aCposSE1,"nBaixar")] += aLinMoed[1][3] / aLinMoed[2][2]// * aLinMoed[2][3] // monto total a bajar montPagar
				 	else
				 		aLinSE1[1][Ascan(aCposSE1,"nBaixar")] += aLinMoed[1][3] // monto total a bajar montPagar
//				 		aLinSE1[1][Ascan(aCposSE1,"nBaixar")] += aLinMoed[2][2] * aLinMoed[2][3] // monto total a bajar montPagar				 	
				 	endif
				 	/*
				 	if aLinSE1[1][Ascan(aCposSE1,"nBaixar")] >  _nValFac // si bajo por demแs 
				 		// TODO Validar
				 		aLinSE1[1][Ascan(aCposSE1,"nBaixar")] = _nValFac // caso est้ por demแs deberํamos validar
//				 		aLinMoed[1][3] 
				 	endif
				 	*/
				/*
				
				 	aLinSE1[1][Ascan(aCposSE1,"nBxMoeda1")] += aLinMoed[1][3]
				 	// caso pague igual
				 	
				 	aLinSE1[1][Ascan(aCposSE1,"nBaixar")] += aLinMoed[1][3] // monto total a bajar montPagar
				 	
				 	if aLinSE1[1][Ascan(aCposSE1,"nBaixar")] >  _nValFac // si bajo por demแs 
				 		aLinSE1[1][Ascan(aCposSE1,"nBaixar")] = _nValFac
//				 		aLinMoed[1][3] 
				 	endif
				 */
				endif
//				aLinSE1[1][Ascan(aCposSE1,"nBaixar")] := _nValFac // monto total a bajar montPagar
//				aLinSE1[1][Ascan(aCposSE1,"nBxMoeda1")] := _nValFac 
				//  aLinMoed[2][2] * aLinMoed[2][3]
//				aLinSE1[1][Ascan(aCposSE1,"nBxMoeda2")] := _nValFac // aLinMoed[2][2] * aLinMoed[2][3]
	endif
//	ALERT("PANEL " +  CVALTOCHAR(NPANEL))


//////////////////////////////////////////////////////////////////////////
//		Jorge Cardona - 27-09-2019										//
//		validar que recibo de cobro no use CMP que es para compensacion	//													//
/////////////////////////////////////////////////////////////////////////	

	For nX := 1 to Len(aCols)
		If aCols[nX][5] <> 0 .AND. aCols[nX][34] = .F.
			nCont1 += 1
		Endif
	Next
	
	If nCont1 == 0 
		// obliga a tener la compensaci๓n de manera correcta.
		if cSerie == GETMV("MV_XCOMPEN")  .AND. ALLTRIM(cNatureza) == '310001'
			lValida := .T.
		Else
			lValida := .F.
			Alert("Para Compensar digite la serie "+GETMV("MV_XCOMPEN")+" y la modalidad COMPENSACION CXC")
		EndIF
	Else //	if nCont1 >= 1 
		// si hay registros de dinero no se puede utilizar compensaci๓n 		
		IF cSerie != GETMV("MV_XCOMPEN") .AND. ALLTRIM(cNatureza) <> '310001'
			lValida := .T.
		Else
			lValida := .F.
			Alert("El Recibo de cobro esta usando la serie/modalidad "+GETMV("MV_XCOMPEN")+"/Compensaci๓n CxC, que son para compensacion. Debe usar otra. ")	
		EndIF
	endif

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida que el Recibo no est้ en uso   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cRecRep:= BRECSEL(cRecibo,cSerie,XFILIAL("SEL"))
	
	If alltrim(cRecRep) == alltrim(cRecibo)
		lValida := .F.
		nCont5 += 1
	EndIf
	
	If !lValida .and. nCont5 >= 1		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Caso seja CMP muda o Nro do Recibo  EA 24/10/2019 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If cSerie $ GetNewPar("MV_XCOMPEN","CMP")
			While  SEL->( dbSeek(xFilial("SEL")+cSerie+cRecibo) )  .Or. !MayIUseCode( "SEL"+xFilial("SEL")+cSerie+cRecibo )
				cRecibo := StrZero(Val(cRecibo)+1,TamSx3("EL_RECIBO")[1])
			EndDo
			If Type("aRecOrig")=="A" .And. Len(aRecOrig)>0
				aRecOrig[4]:= cRecibo
			Endif
			lValida := .T.
		Else
			lValida := .T.	//EDUAR 23/07/2020
			//Alert("El consecutivo de este Recibo de cobro ya estแ generado, debe usar otro. ")
		Endif
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida Recibos Provisorios 			  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If alltrim(cRecProv) <> ""
	
		cValRc := BRECPROV(cRecProv,cSerie,cCobrador,XFILIAL("SEL"))
	
		If alltrim(cValRc) <> "" 
			lValida := .F.
			nCont2 += 1
			//Aviso("F087ACOB","La serie "+cRecProv+" ya existe en otro recibo de cobro. Favor indicar otro n๚mero. ",{"OK"})
		EndIf 
		
		If !lValida .and. nCont2 >= 1
			Alert("El numero de recibo provisorio "+cRecProv+" ya existe en otro recibo de cobro. Favor indicar otro n๚mero")
		Endif
		
		If Select("BSEY") > 0
			BSEY->(DbCloseArea())
		Endif
		
		cQryD := "SELECT * "
		cQryD += "FROM "+ RetSqlName("SEY")
		cQryD += "WHERE EY_SERIE = '" + alltrim(cSerie) + "' " 
		cQryD += "AND EY_COBRAD = '"+cCobrador+"' "
		cQryD += "AND EY_FILIAL= '"+XFILIAL("SEL")+"' "
		cQryD += "AND EY_STATUS = '1' "
		cQryD += "AND D_E_L_E_T_ <> '*'"
		cQryD := ChangeQuery(cQryD)
		DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQryD), ("BSEY"), .F., .T.)
		
		//Aviso("cQuery1",cQryD,{"OK"},,,,,.T.)
		
		DbSelectArea("BSEY")
		DbGoTop()
		
		If BSEY->(Eof())
			nCont3 += 1
			lValida := .F.
		EndIf
		
		If !lValida .and. nCont3 >= 1
			Alert("El numero de recibo provisorio "+cRecProv+" no pertenece al talonario del cobrador")
		Endif
		
		While BSEY->(!Eof())
			//alert(alltrim(cRecProv) >= alltrim(BSEY->EY_RECINI))
			//alert(alltrim(cRecProv) <= alltrim(BSEY->EY_RECFIN))
			//alert((alltrim(cRecProv) >= alltrim(BSEY->EY_RECINI)) .and. (alltrim(cRecProv) <= alltrim(BSEY->EY_RECFIN)))
			
			If (alltrim(cRecProv) >= alltrim(BSEY->EY_RECINI)) .and. (alltrim(cRecProv) <= alltrim(BSEY->EY_RECFIN))
				
			Else
				nCont4 += 1
				lValida := .F.
			EndIf
			
			If !lValida .and. nCont4 >= 1
				Alert("El numero de recibo provisorio "+cRecProv+" no esta en el rango del talonario del cobrador")
			Endif
	
			BSEY->(dbSkip())
		End
		BSEY->(dbCloseArea())
	EndIF
	//Aviso("nPanel: "+Alltrim(Str(nPanel)),"lValida: "+If(lValida,"T","F"),{"OK"}) 
	If nPanel == 4
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Caso o Nro do Recibo jแ tem sido gravado EA 30/07/2020 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		// If lValida
		// 	//If ExisRec(xFilial("SEL"),cRecibo,cSerie)
		// 	DbSelectArea("SEL")
		// 	DbSetorder(8)			
		// 	If SEL->( dbSeek(xFilial("SEL")+cSerie+cRecibo) ) .or. !MayIUseCode( "SEL"+xFilial("SEL")+cSerie+cRecibo )
					
		// 		__cTexto := "El Nro de Recibo: " +cRecibo+"-"+cSerie+" ya Existe" +CRLF
		// 		__cTexto += "Desea modificar para el siguiente disponible?"
				
		// 		If Aviso("CORRELATIVO",__cTexto,{"Si","No"}) == 1
					
		// 			cRecOld := cRecibo
		// 			While  SEL->( dbSeek(xFilial("SEL")+cSerie+cRecibo) )  .Or. !MayIUseCode( "SEL"+xFilial("SEL")+cSerie+cRecibo )
		// 				cRecibo := StrZero(Val(cRecibo)+1,TamSx3("EL_RECIBO")[1])
		// 			EndDo
					
		// 			If cRecOld <> cRecibo
		// 				If Type("aRecOrig")=="A" .And. Len(aRecOrig)>0
		// 					aRecOrig[4]:= cRecibo
		// 				Endif
						
		// 				For nX := 1 to Len(aCols)
		// 					If !(aCols[nX,Len(aHeader)+1])
		// 						If aCols[nX][1] $ "EF|TF|CH"
		// 							If cRecOld == Left( aCols[nX][3], TamSX3("EL_RECIBO")[1] )
		// 								aCols[nX][3] := cRecibo
		// 							Endif
		// 						Endif
		// 					Endif
		// 				Next nX
		// 			Endif
		// 		Else
		// 			lValida := .F.
		// 		Endif
		// 	Endif
		// Endif
	
	Endif
Return lValida

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRECPROV บAutor  ณJORGE CARDONA 	     บ Data ณ 01/10/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ UNIONAGRO                			  	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC Function BRECPROV(cRecProv,cSerie,cCobrad,_cFilial)

	If Select("SEL") > 0
		SEL->(DbCloseArea())
	Endif
	
	cQryD := "SELECT EL_RECPROV "
	cQryD += "FROM "+ RetSqlName("SEL")
	cQryD += "WHERE EL_SERIE = '" + cSerie + "' " 
	cQryD += "AND EL_COBRAD = '"+cCobrad+"' "
	cQryD += "AND EL_RECPROV= '"+cRecProv+"' "
	cQryD += "AND EL_FILIAL= '"+_cFilial+"' "
	cQryD += "AND EL_CANCEL = 'F'"
	cQryD += "AND D_E_L_E_T_ <> '*'"
	cQryD := ChangeQuery(cQryD)
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQryD), ("SEL"), .F., .T.)
	
	//Aviso("cQuery1",cQryD,{"OK"},,,,,.T.)
	
	DbSelectArea("SEL")
	DbGoTop()
	
	cRec := SEL->EL_RECPROV
	//cDoc := StrZero(cDoc,6,0)

	SEL->(dbCloseArea())
	
Return cRec


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRECSEL บAutor  ณJORGE CARDONA 	     บ Data ณ 01/10/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 								  							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ UNIONAGRO                			  	  				  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC Function BRECSEL(cRecibo,cSerie,_cFilial)

	If Select("BSEL") > 0
		BSEL->(DbCloseArea())
	Endif
	
	cQryD := "SELECT *"
	cQryD += "FROM "+ RetSqlName("SEL")
	cQryD += "WHERE EL_SERIE = '" + alltrim(cSerie) + "' " 
	cQryD += "AND EL_RECIBO= '"+alltrim(cRecibo)+"' "
	cQryD += "AND EL_FILIAL= '"+alltrim(_cFilial)+"' "
	cQryD += "AND D_E_L_E_T_ <> '*'"
	cQryD := ChangeQuery(cQryD)
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQryD), ("BSEL"), .F., .T.)
	
	DbSelectArea("BSEL")
	DbGoTop()
	
	cRec := BSEL->EL_RECIBO
	//cDoc := StrZero(cDoc,6,0)

	BSEL->(dbCloseArea())
	
Return cRec



Static Function ExisRec(cSuc,cRecibo,cSerie)
Local cQry	:= ""
Local lRet	:= .F.

cQry := "SELECT *"
cQry += "FROM "+ RetSqlName("SEL")
cQry += "WHERE EL_FILIAL= '"+ cSuc		+ "' "
cQry += "AND EL_SERIE= '" 	+ cSerie 	+ "' " 
cQry += "AND EL_RECIBO= '"	+ cRecibo	+ "' "
cQry += "AND D_E_L_E_T_ <> '*'"
cQry := ChangeQuery(cQry)

If Select("QSEL") > 0
	QSEL->(DbCloseArea())
Endif
DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), ("QSEL"), .F., .T.)
	
DbSelectArea("QSEL")
DbGoTop()
If !Empty(QSEL->EL_RECIBO)
	lRet	:= .T.
Endif
QSEL->(dbCloseArea())
	
Return(lRet)
