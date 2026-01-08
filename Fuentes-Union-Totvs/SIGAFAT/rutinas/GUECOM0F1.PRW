#Include 'protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GUECOM0F1 ºAutor ³Ruben Rivera - HD MEXº Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Funcio de filtro para fact salida                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GUECOM0F1()

Local aFilBrowse 	:= { {} , "" }
Local cFilSZ3		:= FilterExpr("SF2")
Private	bFiltraBrw 	:= ""
Private cfiltra 	:= ""
IF !Empty(bFiltraBrw)
	Eval(bFiltraBrw,1) //aFilBrowse := Eval(bFiltraBrw,1)
Endif

//If cNivel < 7

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se um filtro foi estabelecido                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilSZ3)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Remove a filtragem anterior                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF2")
		RetIndex("SF2")
		dbClearFilter()
		aEval(aFilBrowse[1],{|x| Ferase(x[1]+OrdBagExt())})
		SF2->(dbSetOrder(1))
		aFilBrowse[1] := {}

		If !Empty(cFiltra)
			If !(cFiltra $ cFilSZ3)
				cFilSZ3 := cFiltra + " .AND. " + cFilSZ3
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Determina o novo filtro                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//cFilSZ3 := aFilBrowse[2]+" .And. ("+cFilSZ3+") "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa o novo filtro                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//bFiltraBrw := {|x| IIf( x == Nil, FilBrowse("SF2",@aFilBrowse[1],@cFilSZ3), aFilBrowse ) }
		//Eval(bFiltraBrw)
		
	   	bFilBrw	:=	{|| FilBrowse("SF2",@aIndD1D2,@cFilSZ3 /*@cFilD1D2*/)}
	    Eval(bFilBrw)

	Else
		dbSelectArea("SF2")
		RetIndex("SF2")
		dbClearFilter()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Determina o novo filtro                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilSZ3 := cFiltra //aFilBrowse[2]+" .And. ("+cFilSZ3+")"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa o novo filtro                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		bFiltraBrw := {|x| IIf(x==Nil,FilBrowse("SF2",@aFilBrowse[1],@cFilSZ3),aFilBrowse) }
		Eval(bFiltraBrw)
	EndIf

	SF2->(MsSeek(xFilial("SF2")))

//Endif                                                       	
RfBrowse(GetObjBrow(),cFilSZ3)      // actualizamos filtro del mbrowse

Return             


// actualiza el filtro en el mbrowse
Static Function RfBrowse( oObjBrow, cFilroX)      
Local cFilAltNative:=  " F2_TIPODOC $ '" + ACFGNF[25] + "' "  // ACFGNF[25] FILTRO ORIGEN  //    oObjBrow:odata:cfilternative              

//oObjBrow:odata:cfilternative:="F2_TIPODOC $ '01/06/07/11/50/61' " + iif (empty(cFilroX),"",".AND. " + cFilroX )
//oObjBrow:odata:cfilternative:=cFilroX oObjBrow:odata:cfilterdefault:="F2_TIPODOC $ '01/06/07/11/50/61' "       
oObjBrow:odata:cfilternative:=" F2_TIPODOC $ '" + ACFGNF[25] + "' " + iif (empty(cFilroX),"",".AND. " + cFilroX )
oObjBrow:Refresh()         
IF EMPTY(SF2->F2_DOC)
	ALERT("NO se encontraron registros...")
	oObjBrow:odata:cfilternative:=cFilAltNative
	oObjBrow:Refresh()         
ENDIF

Return NIL
                        

