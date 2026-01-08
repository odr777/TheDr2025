#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³CalifSco    ºAuthor ³Yamyl Saavedra    º Date ³  18/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que califica al cliente en base al Scoring.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ CIMA                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CalifSco()
	Local nY       := 0
	Local nDocEst  := 0
	Local cMenCre  := ""
	Local aTabResu := {}
	Local nPosCues := aScan(aHeader8,{|x| "MAI_QUEST"	$ Trim(x[2]) })
	Local nPosPunt := aScan(aHeader8,{|x| "MAI_PONTO"	$ Trim(x[2]) })
	
	Local nPosEsta := aScan(aHeader7,{|x| "MAE_SITUA"	$ Trim(x[2]) })
	
	//IF ALTERA .And. M->A1_UESTADO <> "S"
	IF M->A1_UESTADO <> "S"
	
	For nY := 1 to Len( aCols7 )
		If aCols7[nY,nPosEsta] == '2'
			nDocEst++
		Endif
	Next nY
	
	If !Empty(M->MA7_UTIPVI) .And. !Empty(M->MA7_UMATVI) 
	If nDocEst == 0
		cCueActi := GetMV("MV_QUEST")
		cNotActi := GetNewPar("MV_CRDNOTA",'000002')
		nTotScor := 0
		nCanCuot := 0
		nLimScor := 0
		cBloScor := ' '
		
		For j := 1 To Len(aCols8)
  			If aCols8[j,nPosCues] == cCueActi .And. !GdDeleted( j, aHeader8, aCols8 )
   				nTotScor := nTotScor + aCols8[j,nPosPunt]
   				Aadd(aTabResu,aCols8[j,nPosPunt])
			End
  		Next
  		
  		cQryMAJ	:= GetNextAlias()
  		cCodDeu	:= M->A1_COD
		U_BuscarTab(@cQryMAJ, cNotActi, '000006', Round(nTotScor,0))
		
		if (cQryMAJ)->( !Eof() )
//			   if !U_UserPertGrp(cGruNiv2);	MsgInfo((cQryMAJ)->MAJ_DESCR,"LINEA DE CREDITO"); EndIf
//		   MsgInfo((cQryMAJ)->MAJ_DESCR,"LINEA DE CREDITO")
			
			cMenCre  := (cQryMAJ)->MAJ_DESCR 
			nPorSala := GetNewPar("MV_PORSAL",25)
//			Alert((cQryMAJ)->MAJ_PONTO)
//			nLimScor := M->MA7_UIMPCO
//			If ( (cQryMAJ)->MAJ_PONTO>10 )
			If ( (cQryMAJ)->MAJ_PONTO>2 )
//					nLimScor := nLimScor + ((M->MA7_UIMPCO*(cQryMAJ)->MAJ_PONTO)/100)
//					cBloScor := '2'
//				ElseIf ( (cQryMAJ)->MAJ_PONTO==3 )
				cBloScor := '2'
				nCanCuot := M->MA7_UCANCU
				nSalario := GetAdvFVal("MA8","MA8_RENDA",XFILIAL("MA8")+cCodDeu+M->A1_LOJA,3,0) //RS
				If M->A1_MOEDALC = 1
					nLimScor := ( (nSalario * nPorSala)/100 ) * nCanCuot
				Else
					nLimScor := ( (nSalario * nPorSala)/100 ) * nCanCuot
					nLimScor := XMOEDA(nLimScor,1,M->A1_MOEDALC,dDataBase)
				EndIf
				cMenCre  += " " + AllTrim( Transform(nLimScor, "99,999,999.99") ) + " $us." 
			Else
				cBloScor := '1'
			EndIf
			
			RecLock("SA1", .F.)
//				SA1->A1_MSBLQL  := M->A1_MSBLQL  := cBloScor
				SA1->A1_UESTADO := M->A1_UESTADO := "S"
				SA1->A1_LC      := M->A1_LC      := nLimScor
				SA1->A1_RISCO   := M->A1_RISCO   := If(cBloScor=='2','B','E')
				SA1->A1_VENCLC  := M->A1_VENCLC  := MonthSum(dDataBase,nCanCuot)
			MsUnlock()
			
			RecLock("MA7", .F.)
//				MA7->MA7_URESUL := (cQryMAJ)->MAJ_DESCR
//				MA7->MA7_UTIPRE := (cQryMAJ)->MAJ_PONTO
				MA7->MA7_DATABL := M->MA7_DATABL := dDataBase
				MA7->MA7_PONTOS := M->MA7_PONTOS := nTotScor
				MA7->MA7_BLOQUE := M->MA7_BLOQUE := If(cBloScor=='1','3','1')	//"1"
				MA7->MA7_PONCRE := M->MA7_PONCRE := GetNewPar("MV_CRDBDIA",9)	//Cantidad de días de bloqueo
				MA7->MA7_MOTTRA := M->MA7_MOTTRA := cMenCre
			MsUnlock()
		   
			lCalif := .F.
			MsgInfo(cMenCre,"LINEA DE CREDITO")
			
		Else
			Alert("No se encuentra el rango del Scoring")
		EndIf
	
	Else
		MsgAlert("No se puede realizar el análisis con documentos pendientes.","Analizar")
	Endif
	Else
		MsgAlert("Falta realizar la verificación; se debe llenar los campos 'Tipo de Vivienda' y 'Material de Vivienda'.","Analizar")
	Endif
	Else
		MsgAlert("El Cliente ya fue analizado.","Analizar")
	Endif
	
Return &(ReadVar())




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRDGRAVA  ºAutor  ³EDUAR ANDIA         º Data ³  29/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Permite validar informações do cadastro de Clientes.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLIVIA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CRDGRAVA
	Local nOpcx := Paramixb[1]
	Local lRet  := .T.
	Local lIncl := .T.
	
	cGruNiv1 := GetNewPar("MV_CRDNVL1",'000000')
	If (nOpcx==3 .OR. nOpcx==4) .And. !U_UserPertGrp(cGruNiv1) .And. .F.
		lIncl := If(nOpcx==4,(MA7->MA7_BLOQUE=="0" .Or. MA7->MA7_DATABL+MA7->MA7_PONCRE<dDataBase), .T.)
		If !lIncl .And. lCalif
			If !U_UserPertGrp(cGruNiv1)
				MsgStop("El usuario no tiene permisos para realizar esta operación.","TOTVS")
			ElseIf nOpcx==4
				MsgStop("No se puede modificar el registro. Presione Finalizar","TOTVS")
			Else
				MsgStop("El proceso no concluyó.","TOTVS")
			EndIf
			lRet := .F.
		EndIf
		
	Endif

Return(lRet)