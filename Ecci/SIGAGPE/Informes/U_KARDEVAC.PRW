#Include 'Protheus.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ KARDEVAC ³ Autor ³ Yamyl Saavedra        ³ Data ³ 25.03.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripcion Impresion de Kardex Vacaciones                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ INESCO													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function kardevac()
	Public _PAR01
	
	KarPerg()
	cPerg:="KAV580"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variables utilizadas para parametros                         ³
	//³ mv_par01             // Matricula de Empleados               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cString  := "SRA"
	titulo   := PADC("Kardex Vacaciones" ,74)
	cDesc1   := PADC("Sera solicitado la matricula para la emision del ",74)
	cDesc2   := PADC("kardex",74)
	cDesc3   := ""
	aReturn  := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci¢n"), 1, 2, 1,"",1 }
	NomeProg := "KARDEVAC" 
	nLin	 := 0
	   
	PERGUNTE(cPerg,.F.)
	wnrel:=SetPrint(cString,NomeProg,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"M")
	
	If nLastKey!=27
		SetDefault(aReturn,cString)
		If nLastKey!=27
			VerImp()       
			RptStatus({|| RptKardeV()})
		endif
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPTKARDEV ºAutor  ³    ºFecha ³  25/03/13					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao del remito transferencias                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INESCO								                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RptKardeV()
	Local cCidade := space(10)
	Local nTotAbo := 0
	Local nTotGoz := 0
	local i
	//Filtra do SRA: filial, matricula
	cAlias  := "SRA"
	cQrySRA := "QSRA"
	
	//montagem da query
	cQuery := "SELECT "
 	cQuery += "RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_CODFUNC, RA_DEPTO, RA_CC "		
	cQuery += " FROM " + RetSqlName(cAlias)
	cQuery += " WHERE "
	cQuery += " RA_MAT = '" + mv_par01 + "'"
	cQuery += "  AND "                
	cQuery += " D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY RA_FILIAL, RA_MAT"
  
	cQuery := ChangeQuery(cQuery)      
	aStruct := (cAlias)->(dbStruct())
			
	If  MsOpenDbf(.T.,"TOPCONN",TcGenQry(, ,cQuery),cQrySRA,.T.,.T.)
		For nAux := 1 To Len(aStruct)
			If ( aStruct[nAux][2] <> "C" )
				TcSetField(cQrySRA,aStruct[nAux][1],aStruct[nAux][2],aStruct[nAux][3],aStruct[nAux][4])
			EndIf
		Next nAux
	Endif

	dbSelectArea(cQrySRA)
	(cQrySRA)->(dbGoTop())

	//dbselectarea("SRA")
	//dbsetorder(1)		// RA_FILIAL+RA_MAT
	//dbgotop()
	//SRA->(dbseek(xfilial("SRA")+mv_par01))
	
	dbselectarea("SRF")
	dbsetorder(1)		// RF_FILIAL+RJ_FUNCAO
	dbgotop()
	SRF->(dbseek(xFILIAL("SRF")+(cQrySRA)->RA_MAT))
	
	dbselectarea("SR8")
	dbsetorder(8)		// R8_FILIAL+R8_MAT+R8_TIPOAFA
	dbgotop()
	SR8->(dbseek(xfilial("SR8")+(cQrySRA)->RA_MAT+"001"))
	
	dbselectarea("SRJ")
	dbsetorder(1)		// RJ_FILIAL+RJ_FUNCAO
	dbgotop()
	SRJ->(dbseek(xfilial("SRJ")+(cQrySRA)->RA_CODFUNC))
	
	dbselectarea("SQB")
	dbsetorder(1)		// QB_FILIAL+QB_DEPTO
	dbgotop()
	SQB->(dbseek(xfilial("SQB")+(cQrySRA)->RA_DEPTO))
	
	dbselectarea("CTT")
	dbsetorder(1)		// CTT_FILIAL+CTT_CUSTO
	dbgotop()
	CTT->(dbseek(xfilial("CTT")+(cQrySRA)->RA_CC))
	
	// ciudad a imprimir en el formulario
	do case
	case SM0->M0_CODFIL = "01"
			cCidade := "SANTA CRUZ"                  
		//case SM0->M0_CODFIL = "02"
			//cCidade := "SANTA CRUZ"	
	endcase
	
	(cQrySRA)->( setRegua(LastRec()) )
	
	while (cQrySRA)->( !eof() )
		IF (cQrySRA)->RA_MAT==mv_par01
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ 00, 00 PSAY AvalImp(132)
			
			nLin := 1
			@ nLin,050 PSAY "K A R D E X  -  V A C I O N E S"
			nLin++
			@ nLin,035 PSAY "============================================================="
			nLin++
			@ nLin,005 PSAY "CODIGO EMPLEADO : "+ (cQrySRA)->RA_MAT
			nLin++
			@ nLin,005 PSAY "NOMBRE          : "+ Alltrim((cQrySRA)->RA_NOME)
			nLin++
			@ nLin,005 PSAY "FECHA INGRESO   : "+ DtoC((cQrySRA)->RA_ADMISSA)
			nLin++
			@ nLin,005 PSAY "CARGO           : "+ Alltrim(SRJ->RJ_DESC)
			nLin++
			@ nLin,005 PSAY "DEPARTAMENTO    : "+ Alltrim(SQB->QB_DESCRIC)
			nLin++
			@ nLin,005 PSAY "CENTRO DE COSTOS: "+ Alltrim(CTT->CTT_DESC01)
			nLin++
			@ nLin,005 PSAY replicate("-",115)    
			nLin++
			@ nLin,015 PSAY "Abono dias Correspondientes a la gestion: "
			
			while SRF->RF_MAT==(cQrySRA)->RA_MAT .and. SRF->(!eof())
	  			@ nLin,060 PSAY Substr(DtoC(SRF->RF_DATABAS),7,4)+"-"+Substr(DtoC(SRF->RF_DATAFIM),7,4)+"       "+Transform(SRF->RF_DFERVAT+SRF->RF_DFERAAT, "999.9")
	  			nTotAbo += SRF->RF_DFERVAT+SRF->RF_DFERAAT
	  			nLin++
	  			SRF->(dbskip())
			enddo
	  		
			if SR8->(!eof())
		  		@ nLin,005 PSAY "                              Gozados "
		    	nLin++
			endif
	  		
			while SR8->R8_MAT==(cQrySRA)->RA_MAT .and. SR8->(!eof())
				@ nLin,042 PSAY "De:"+DtoC(SR8->R8_DATAINI)+"  Hasta:"+DtoC(SR8->R8_DATAFIM)+"               "+Transform(SR8->R8_DURACAO, "999.9")
	  			nTotGoz += SR8->R8_DURACAO
	  			nLin++
				SR8->(dbskip())
			enddo
			nLin += 3
			@ nLin,005 psay CHR(15)+"TOTALES      :"+CHR(18)
			@ nLin,076 psay Transform(nTotAbo, "999.9")
			@ nLin,088 psay Transform(nTotGoz, "999.9")
			nLin++
			@ nLin,005 psay "SALDO GESTIÓN:"
			@ nLin,088 psay Transform(nTotAbo-nTotGoz, "999.9")
			nLin++
			@ nLin,005 psay replicate("-",115)    
			nLin+=2  
			@ nLin,000 psay space(01)	// para "saltar" efetivamente e passar para a proxima pagina.
			setprc(0,0)
			incregua()
		ENDIF
	
		(cQrySRA)->( DBSKIP() )
	enddo
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Return
	
Static Function VerImp()
	nLin:= 0                
	Set Device To Screen
	If aReturn[5]==2
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif
//	MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ KarPerg  ³ Autor ³             ³ Data ³ 22/02/12           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam...     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 				                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function KarPerg()
local i
local j
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("KAV580",10)
aRegs := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Matricula de Empleados               ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aRegs,{cPerg,"01","Matricula ? ","¿Matricula ?","Matricula ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
				Endif
			Next
		MsUnlock()
		endif
	Next
dbSelectArea(_sAlias)
Return