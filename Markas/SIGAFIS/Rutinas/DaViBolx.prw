#Include "Protheus.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DaVinci   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Preparacao do meio-magnetico para o software DaVinci-LCV,   ³±±
±±³          ³geracao dos Livros de Compra e Vendas IVA.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DaViBolx(cLivro)

Local aArea	:= GetArea()

// Local aTpNf	 := &(GetNewPar("MV_DAVINC1","{}")) //Tipo de Factura: 1-Compras para Mercado Interno;2-Compras para Exportacoes;3-Compras tanto para o Mercado Intero como para Exportacoes; JLJR: Se elimino porque no esta utilizando
// Local cCpoPza := GetNewPar("MV_DAVINC2","")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion; JLJR: Se elimino porque no esta utilizando
// Local cCpoDta := GetNewPar("MV_DAVINC3","")		//Campo da tabela SF1: que contem a Data de Poliza de Importacion; JLJR: Se elimino porque no esta utilizando
// Local lOrdem	:= GetNewPar("MV_DAVINC4",.T.)     //Indica se arquivo sera ordenado por Emissao ou Entrada sendo F=Emissao e T=Entrada; 
// Local lPza	:= SF1->(FieldPos(cCpoPza)) > 0 .And. SF1->(FieldPos(cCpoDta)) > 0
// Local lProc	:= .T. // JLJR: Validaba que esten definidos los parametros.

GeraTemp()

If cPaisLoc == "BOL" .And. LocBol()
	ProcLivro(cLivro)
Endif

RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GeraTemp   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Gera arquivos temporarios                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTemp()

 Local aStru	:= {}
 Local cArq	:= ""

 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³Temporario LCV - Livro de Compras e Vendas IVA ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 AADD(aStru,{"NUMERO"	   ,"C", 014,0}) // JLJR: 5:13 PM 2/12/2015: Parte del nuevo Formato.
 AADD(aStru,{"TIPONF"	   ,"C", 001,0})
 AADD(aStru,{"NIT"		   ,"C", 014,0})
 AADD(aStru,{"RAZSOC"	   ,"C", 060,0})
 AADD(aStru,{"NFISCAL"	   ,"C", 013,0}) // JLJR: 5:13 PM 2/12/2015: El por defecto es 12 en F1_DOC y F2_DOC
 AADD(aStru,{"POLIZA"	   ,"C", 020,0}) 
 AADD(aStru,{"NUMAUT"	   ,"C", 015,0})
 AADD(aStru,{"EMISSAO"	   ,"D", 008,0}) 
 AADD(aStru,{"VALCONT"	   ,"N", 016,2})
 AADD(aStru,{"ICE"		   ,"N", 016,2}) // JLJR: 5:13 PM 2/12/2015: En el nuevo formato es parte del Excento...
 AADD(aStru,{"EXENTAS"	   ,"N", 016,2})
 AADD(aStru,{"DESCUENTO"   ,"N", 016,2}) // JLJR: 5:13 PM 2/12/2015: Parte del nuevo Formato.
 AADD(aStru,{"SUBTOTAL"    ,"N", 016,2}) // JLJR: 5:13 PM 2/12/2015: Parte del nuevo Formato.
 AADD(aStru,{"BASEIMP"	   ,"N", 016,2})
 AADD(aStru,{"VALIMP"	 ,"N", 016,2})
 AADD(aStru,{"STATUSNF"	 ,"C", 001,0})
 AADD(aStru,{"CODCTR"	 ,"C", 014,0})
 AADD(aStru,{"SERIE"	 ,"C", 003,0}) // JLJR: 09/03/2015: Para que revise algun problema por el Control de Folio.
 AADD(aStru,{"CLIEFOR"	 ,"C", 006,0}) // JLJR: 09/03/2015: Para actualizar algun dato que corresponda.
 AADD(aStru,{"LOJA"		 ,"C", 002,0}) // JLJR: 09/03/2015
 AADD(aStru,{"FILIAL"	 ,"C", 003,0}) // JLJR: 25/03/2015
 AADD(aStru,{"FILIALNOM" ,"C", 015,0}) // JLJR: 14/05/2015
 AADD(aStru,{"NODIA"     ,"C", 010,0}) // JLJR: 26/03/2015: 0902000001
 AADD(aStru,{"DOSIFICACI","C", 013,0}) // JLJR: 14/05/2015: DOSIFICACIION: 'COMPUTARIZADO'

 cArq := CriaTrab(aStru)
 dbUseArea(.T.,__LocalDriver,cArq,"LCV")

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ProcLivro  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa o Livro de Compras e Vendas IVA                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcLivro(cLivro)

Local aImp		:= {}
Local aAlias	:= {"SF3",""}

Local cTop		:= " F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "'"
Local cDbf		:= " DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "'"

Local cChave	:= ""
Local cFilialAnt:= ""
Local nTamDoc := TamSX3( "F3_NFISCAL" )[ 1 ] //JLJR: Adicionado por 'Eduard Andia', para borrar ceros a la izquierda.
Local nNumero := 0

Private _cNIT	:= ""
Private _cRazSoc := ""
Private _cTpNf	:= "5"	// JLJR: Actualizado: 
Private _nDescuento := 0
Private _cCorrelativoCtb := ""

If mv_par06 == 1 // JLJR: MTA950,06 (Corregido, estaba en el 07);y al ser Combo sólo permite Número, aunque está como Caracter...
	cTop += "  AND  F3_FILIAL = '" + xFilial('SF3') + "'"
	cDbf += " .AND. F3_FILIAL == '" + xFilial('SF3') + "'"
EndIf

If cLivro == "C"	//------------COMPRAS---------
	cTop += "  AND  SUBSTRING(F3_CFO,1,1) < '5' "
	cDbf += " .AND. SUBSTRING(F3_CFO,1,1) < '5' "
Else				//Vendas
	cTop += "  AND  SUBSTRING(F3_CFO,1,1) >= '5' "
	cDbf += " .AND. SUBSTRING(F3_CFO,1,1) >= '5' "
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aImp com as informacoes dos impostos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SFB")
dbSetOrder(1)
dbGoTop()

AADD(aImp,{"IVA",""})                
While !SFB->(Eof()) 
	If aScan(aImp,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImp[aScan(aImp,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	Endif	
	dbSkip()
Enddo                 
aSort(aImp,,,{|x,y| x[2] < y[2]})

AAdd(aImp[1],SF3->(FieldPos("F3_BASIMP"+aImp[1][2])))		//Base de Calculo
AAdd(aImp[1],SF3->(FieldPos("F3_VALIMP"+aImp[1][2])))		//Valor do Imposto

//SF2->(DbSetorder(1))// JLJR: Adicionado por Luis Ferdnando Ibarra, aparentemente sólo debería ser para Ventas, analizar con las Devoluciones.
//SD2->(DbSetorder(3))
//SC5->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria Query / Filtro                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF3->(dbSetOrder(1))
FsQuery(aAlias,1,cTop,cDbf,SF3->(IndexKey()))

dbSelectArea("SF3")
While !Eof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Como podem existir mais de um SF3 para um mesmo documento, deve ser aglutinado³
	//³gerando apenas uma linha no arquivo magnetico.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cChave) .Or. cChave <> SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA

		If SF3->F3_STATUS == ' ' .AND. Empty(SF3->F3_DTCANC)
			/* (F3_TIPO) Tipo de asiento: 			L = Factura en Lote;
				S = Registro de ISS;	B = Mejora
				D = Devolucion;			C = Complemento
				P = Complemento de IPI;	I = Complemento de ICMS */
			// XXX: JLJR: Cuidado para los Libros de "Debito-Credito", al incluir el 'Proveedor Fiscal'
			If cLivro == "C" //JLJR: .AND. !(F3_TIPO $ "D") Refeencias al 12:57 p.m. 14/03/2015
				EntradasNitYRazSocYTpNf()
			Else
				SalidasNitYRazSoc()
			EndIf
		EndIf

		If cFilialAnt != SF3->F3_FILIAL .AND. cLivro != "C"
			cFilialAnt := SF3->F3_FILIAL
			nNumero := 0
		EndIf

		RecLock( "LCV", .T.)

		LCV->NUMERO		:= CValToChar(++nNumero)
		LCV->TIPONF		:= _cTpNf // JLJR: Verificar si no da problemas para Ventas; aunque no lo utiliza en el .ini
		LCV->NIT		:= _cNIT
		LCV->RAZSOC		:= _cRazSoc
		LCV->NODIA		:= _cCorrelativoCtb
		LCV->NFISCAL	:= PadL( Borrar0Izq( SF3->F3_NFISCAL ), nTamDoc ) // JLJR: Adicionado por 'Eduard Andia', su cambio de logica no permitia reunir las Facturas.
		LCV->POLIZA		:= "0" // JLJR: Antes esto lo tenia en el Davinc.ini
		LCV->EMISSAO	:= SF3->F3_EMISSAO // JLJR: De la Vs.9 se quito 'lOrdem', porque deberia estar en la Consulta, aqui no funciona.
		LCV->NUMAUT		:= SF3->F3_NUMAUT
		LCV->CODCTR		:= SF3->F3_CODCTR
		LCV->SERIE		:= SF3->F3_SERIE
		LCV->FILIAL	    := SF3->F3_FILIAL
		LCV->DOSIFICACI := GetAdvFVal( "SFP", "FP_UTPDSFC", SF3->( F3_FILIAL + F3_FILIAL + F3_SERIE + '1' ), 5)
		LCV->FILIALNOM  := FWFilialName( cEmpAnt, SF3->F3_FILIAL, 1)

		//If Empty( AllTrim(SF3->F3_PROVFIS) ) // JLJR: Sea F3_TIPOMOV = 'C' o 'V'.
			LCV->CLIEFOR	:= SF3->F3_CLIEFOR
			LCV->LOJA	    := SF3->F3_LOJA
		/*Else
			LCV->CLIEFOR	:= SF3->F3_PROVFIS
			LCV->LOJA	    := SF3->F3_TIENFIS
		EndIf*/

		LCV_STATUSNF()

		LCV->ICE := 0
		If !Empty(SF3->F3_DTCANC)
			LCV->VALCONT	:= 0
			LCV->BASEIMP	:= 0	//Base de Calculo
			LCV->VALIMP		:= 0	//Valor do Imposto

			LCV->EXENTAS	:= 0
			LCV->SUBTOTAL	:= 0

			LCV->DESCUENTO  := 0
		Else
			LCV->DESCUENTO  := _nDescuento
		EndIf
	Else

		RecLock( "LCV", .F. )
	EndIf

	If Empty(SF3->F3_DTCANC) // JLJR: Asigna si está anulado...

		LCV->VALCONT	+= SF3->F3_VALCONT

		If aImp[1][3] > 0
			LCV->BASEIMP	+= SF3->(FieldGet(aImp[1][3]))		//Base de Calculo
		Endif

		If aImp[1][4] > 0
			LCV->VALIMP		+= SF3->(FieldGet(aImp[1][4]))		//Valor do Imposto
		Endif

		// XXX: JLJR: En AGUAI, casi siempre asigna el Exento, mientras que no siempre en GLADYMAR, Por que?
		LCV->EXENTAS	+= Iif( SF3->F3_EXENTAS == 0, LCV->VALCONT - LCV->BASEIMP, SF3->F3_EXENTAS )
		LCV->SUBTOTAL	:= LCV->VALCONT + LCV->DESCUENTO - LCV->EXENTAS
	EndIf

	MsUnlock()

	cChave := SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA

	dbSelectArea("SF3")
	dbSkip()
Enddo

FsQuery(aAlias,2)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Borrar0IzqºAutor  ³EDUAR ANDIA         ºFecha ³  08/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función que quita los '0' de la izquierda de un número     º±±
±±º          ³ utilizado para convertir el Num. Doc. de la Factura        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Borrar0Izq(cString)
	Local cCadena 	:= AllTrim(cString)
	cString 	:= AllTrim(cString)
	For nI 			:= 1 To Len(cString)
		cChar		:= Substr(cString,nI,1)
		If cChar $"0"
			cCadena := Substr(cString,nI+1,Len(cString))
		Else
			Return ( cCadena )
		Endif
	Next nI
Return ( cCadena )

Static Function EntradasNitYRazSocYTpNf()
	//Ú Tipo de Factura (F1_UTIPOFA) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valor único del 1 al 5 que representa el destino que se le dará a la compra realizada: ³
	//³ 1 = Compras para mercado interno con destino a actividades gravadas,				  ³
	//³ 2 = Compras para mercado interno con destino a actividades no gravadas,				  ³
	//³ 3 = Compras sujetas a proporcionalidad,												  ³
	//³ 4 = Compras para exportaciones,														  ³
	//³ 5 = Compras tanto para el mercado interno como para exportaciones.					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If SF1->(dbSeek( SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA ))
		_cTpNf := "0"//SF1->F1_UTIPOFA 
		_nDescuento := SF1->F1_DESCONT
		_cCorrelativoCtb := SF1->F1_NODIA
		_cRazSoc := SF1->F1_UNOMBRE
  		_cNIT	   := SF1->F1_UNIT
	Else
		_nDescuento := 0
		_cTpNf := "5" // "3"
	EndIf

	
	If Empty(AllTrim(_cNIT))
	
		_cNIT	 := Posicione("SA2",1,xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA),"A2_CGC")
		_cRazSoc := Posicione("SA2",1,xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA),"A2_NOME")
	EndIf

Return 

Static Function SalidasNitYRazSoc()
   	_cNIT	 := Alltrim( SF3->F3_NIT )
   	_cRazSoc := Alltrim( SF3->F3_RAZSOC )
	
	aDatosCli:= u_GetNomNit(SF3->F3_NFISCAL,SF3->F3_SERIE,SF3->F3_CLIEFOR,SF3->F3_LOJA,SF3->f3_filial) 
	iF Len(aDatosCli)>0
		_cRazSoc := alltrim(aDatosCli[1])
		_cNIT	   := aDatosCli[2]
			_nDescuento := aDatosCli[6]
		_cCorrelativoCtb := aDatosCli[7]
	end

	If Empty(_cNIT)
		_cRazSoc := Posicione( "SA1", 1, xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA, "A1_NOME")
		_cNIT	:= Posicione( "SA1", 1, xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA, "A1_CGC")
	EndIf

Return

Static Function LCV_STATUSNF()
	If !Empty(SF3->F3_DTCANC) ; // JLJR: Asigna si está anulado...
	.Or. SF3->F3_STATUS != ' ' // JLJR: Se consulto a la BD de AGUAI, y hasta ahora no hay ningun SF3->F3_STATUS != ' '
	// If SF3->(FieldPos("F3_STATUS")) > 0 //JLJR: Se dudaba en DaVinci.prw Vs9; quizás porque necesitaba de alguna actualizacion...
		LCV->NIT := "0"
		Do Case
			Case SF3->F3_STATUS == 'E'
				LCV->STATUSNF := 'E'
				LCV->RAZSOC   := 'E X T R A V I A D A'
			Case SF3->F3_STATUS == 'N'
				LCV->STATUSNF := 'N'
				LCV->RAZSOC   := 'N O   U T I L I Z A D A'
			OtherWise
				LCV->STATUSNF := "A"
				LCV->RAZSOC   := 'A N U L A D A'
		EndCase
		// If U_AnuReutil(SF3->F3_SERIE,SF3->F3_NFISCAL) // JLJR: Al sumarlos igualmente lo estaria saltando...
	Else
		LCV->STATUSNF	:= "V"
	EndIf

Return