#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³PesDocum    ºAuthor ³Yamyl Saavedra    º Date ³  18/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion trae los requisitos de acuerdo al tipo de cliente  º±±
±±º          ³ Los ingresa en la pestaña Doc.entregado                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ CIMA                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PesDocum()
	Local aAuxCol  := {}
	
	U_PesTarje()
	cTipCli := AllTrim(&(ReadVar()))
	cQryZRC := GetNextAlias()
	
	BeginSql alias cQryZRC
		SELECT *
		FROM %table:ZRC% ZRC
		WHERE ZRC.D_E_L_E_T_ = ' '
			AND ZRC_TIPO	= %Exp:cTipCli%
	EndSql
	
	dbSelectArea(cQryZRC)
	(cQryZRC)->(dbGoTop())
	
	
	
	if (cQryZRC)->( !Eof() )
//		Alert(Len(aCols7))
//		Alert((cQryZRC)->ZRC_REQUIS)
		
		aAuxCol := {}
		
		While (cQryZRC)->( !Eof() )
			aAdd(aAuxCol, {})
			For nX := 1 to Len(aHeader7)
				If aHeader7[nX, 10] == "V"
					If IsHeadRec( aHeader7[nX, 2] )
						aAdd(aAuxCol[Len(aAuxCol)], (cQryZRC)->(Recno()))
					ElseIf IsHeadAlias( aHeader7[nX, 2] )
						aAdd(aAuxCol[Len(aAuxCol)], "MAE")
					ElseIf Alltrim(aHeader7[nX, 2]) == "MAE_DOCDES"
						aAdd(aAuxCol[Len(aAuxCol)], AllTrim(fDesc("ZRQ",(cQryZRC)->ZRC_REQUIS,"ZRQ_DESCRI")) )
					Else
						aAdd(aAuxCol[Len(aAuxCol)], CriaVar(aHeader7[nX, 2]))            
					Endif
				Else    
					If IsHeadRec( aHeader7[nX, 2] )
						aAdd(aAuxCol[Len(aAuxCol)], (cQryZRC)->(Recno()))
					ElseIf IsHeadAlias( aHeader7[nX, 2] )
						aAdd(aAuxCol[Len(aAuxCol)], "MAE")
					ElseIf alltrim(aHeader7[nX, 2]) == "MAE_DESCR"
						aAdd(aAuxCol[Len(aAuxCol)], (cQryZRC)->ZRC_REQUIS + Space(3))
					ElseIf alltrim(aHeader7[nX, 2]) == "MAE_NUMDOC"
						aAdd(aAuxCol[Len(aAuxCol)], NtoC(nX,10) + Space(21))
					Else
						aAdd(aAuxCol[Len(aAuxCol)], CriaVar(aHeader7[nX, 2]))            
					Endif               
				Endif	
			Next nX
	
			aAdd(aAuxCol[Len(aAuxCol)], .F.)
			dbSkip()
		End
		
		aCols7:= aAuxCol
		oGetD7:oBrowse:SetArray(aCols7)
		oGetD7:aCols := aCols7
		oGetD7:oBrowse:Refresh(.T.)
		
		
/*		For j := 1 To Len(aCols7)
  			If aCols7[j,nPosCues] == cCueActi .And.;
  			   aCols7[j,nPosPreg] == cCodPreg .And. !GdDeleted( j, aHeader7, aCols7 )
				aCols7[j,nPosDocu] := (cQryZRC)->ZRC_REQUIS
   				aCols7[j,nPosNuDo] := j
				oGetD7:oBrowse:SetArray(aCols7)
				oGetD7:aCols := aCols7
				oGetD7:oBrowse:Refresh(.T.)
			END
  		Next*/
	Endif
	
Return &(ReadVar())


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Coloca datos a la pestaña Tarjetas                           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
User Function PesTarje()
	Local nPosNume := aScan(aHeader6,{|x| "MA6_NUM"	$ Trim(x[2]) })
	
	Private lRetor := .T.
	//Alert(nPosNume)
	if (Len(oGetD6:aCols)==1)
		//oGetD6:aCols[1,nPosNume] := If(Empty(M->A1_CGC),"123             ",M->A1_CGC)	//Se necesitari el codigo del CI para que no se duplique
		//Puede quedar asi
		//Alert(M->A1_COD)
		oGetD6:aCols[1,nPosNume] := M->A1_COD
		oGetD6:oBrowse:Refresh(.T.)
	Endif
	
Return