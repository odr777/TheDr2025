#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³TipDeViv    ºAuthor ³Yamyl Saavedra    º Date ³  17/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion busca el puntaje 4° pregunta del scoring           º±±
±±º          ³ TIV - Tipo de vivienda                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ CIMA                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TipDeViv(cCodPreg)
	Local nPosResp := aScan(aHeader8,{|x| "MAI_RESP"   $ Trim(x[2]) })
	Local nPosPreg := aScan(aHeader8,{|x| "MAI_PERG"   $ Trim(x[2]) })
	Local nPosCues := aScan(aHeader8,{|x| "MAI_QUEST"  $ Trim(x[2]) })
	Local nPosDeRe := aScan(aHeader8,{|x| "MAI_DESCRE" $ Trim(x[2]) })
	Local nPosPunt := aScan(aHeader8,{|x| "MAI_PONTO"  $ Trim(x[2]) }) 
	
	cCueActi := GetMV("MV_QUEST")
	nTipVivi := CtoN(AllTrim(&(ReadVar())),10)
	cQryMAJ  := GetNextAlias()
	U_BuscarTab(@cQryMAJ, cCueActi, cCodPreg, nTipVivi)
	dbSelectArea(cQryMAJ)
	(cQryMAJ)->(dbGoTop())
	
	if (cQryMAJ)->( !Eof() )
		For j := 1 To Len(aCols8)
  			If aCols8[j,nPosCues] == cCueActi .And.;
  			   aCols8[j,nPosPreg] == cCodPreg .And. !GdDeleted( j, aHeader8, aCols8 )
				aCols8[j,nPosResp] := (cQryMAJ)->MAJ_RESP
   				aCols8[j,nPosDeRe] := (cQryMAJ)->MAJ_DESCR
   				aCols8[j,nPosPunt] := (cQryMAJ)->MAJ_PONTO
				oGetD8:oBrowse:SetArray(aCols8)
				oGetD8:aCols := aCols8
				oGetD8:oBrowse:Refresh(.T.)
			END
  		Next
	Endif
	
Return &(ReadVar())