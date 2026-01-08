#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgram   ณAntDeMor    บAuthor ณYamyl Saavedra    บ Date ณ  17/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funci๓n busca el puntaje 1ฐ pregunta del scoring           บฑฑ
ฑฑบ          ณ AM -  Antecedentes de Moralidad (BURO CREDITOS)            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUse       ณ CIMA                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AntDeMor(cCodPreg)
	Local nPosResp := aScan(aHeader8,{|x| "MAI_RESP"   $ Trim(x[2]) })
	Local nPosPreg := aScan(aHeader8,{|x| "MAI_PERG"   $ Trim(x[2]) })
	Local nPosCues := aScan(aHeader8,{|x| "MAI_QUEST"  $ Trim(x[2]) })
	Local nPosDeRe := aScan(aHeader8,{|x| "MAI_DESCRE" $ Trim(x[2]) })
	Local nPosPunt := aScan(aHeader8,{|x| "MAI_PONTO"  $ Trim(x[2]) }) 
	
	cCueActi := GetMV("MV_QUEST")
	nOpcBusc := CtoN(AllTrim(&(ReadVar())),10)
	cQryMAJ  := GetNextAlias()
	U_BuscarTab(@cQryMAJ, cCueActi, cCodPreg, nOpcBusc)
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
	
	
	nOpcBusc := -1
	cCodPreg := '000002'
	cQryMAJ  := GetNextAlias()
	U_BuscarTab(@cQryMAJ, cCueActi, cCodPreg, nOpcBusc)
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

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Busca el puntaje                                             ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
User Function BuscarTab(cQryTab, cCueActi, cCodPreg, nRango)
	
	BeginSql alias cQryTab
		SELECT MAJ_RESP, MAJ_DESCR, MAJ_PONTO, MAJ_UDESDE, MAJ_UHASTA
		FROM %table:MAJ% MAJ
		WHERE MAJ.D_E_L_E_T_ = ' '
			AND MAJ_QUEST	= %Exp:cCueActi%
			AND MAJ_PERG 	= %Exp:cCodPreg%
			And MAJ_UDESDE <= %Exp:nRango%
			And MAJ_UHASTA >= %Exp:nRango%
	EndSql
Return