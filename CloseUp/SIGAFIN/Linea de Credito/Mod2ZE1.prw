#INCLUDE "Protheus.ch"
//----------------------------------------------------------------------------------------------------------------//
// Modelo 2.
//----------------------------------------------------------------------------------------------------------------//

User Function Mod2ZE1()

	Local aCores := {}

	Private	cAlias := "ZE1"

	dbSelectArea(cAlias)

	dbSetOrder(1)

	Private cZE1User := PADR(cUserName,40)
	Private cCadastro := " Planes de Pago "

	Private cZE1Fil := "ZE1_USR == "+ cZE1User

	Private lDatosBco := .F.

	Private	aRotina := {;
	{ "Buscar", "AxPesqui", 0, 1},;
	{ "Visualizar", "U_MntZE1(cAlias,,2)", 0, 2},;
	{ "Incluir", "U_MntZE1(cAlias,,3)", 0, 3},;
	{ "Modificar", "U_MntZE1(cAlias,,4)", 0, 4},;
	{ "Genera Titulo provisorio", "U_MntZE1(cAlias,,5)", 0, 6},;
	{ "Leyenda", "U_ZE1Leg()", 0, 7},;
	{ "Confirma Plan para procesar", "U_MntZE1(cAlias,,10)", 0, 10},;
	{ "Devuelve Plan a revisión.", "U_MntZE1(cAlias,,11)", 0, 11}}

	//{ "Eliminar", "U_MntZE1(cAlias,,5)", 0, 5},;
	//{ "Genera Titulos provisorios", "U_MntZE1(cAlias,,6)", 0, 6},;
	//{ "Revierte Titulos provisorios", "U_MntZE1(cAlias,,9)", 0, 9},;

	AADD(aCores,{"ZE1_ESTADO == '0'" ,"BR_VERDE" })      // Ingresado

	AADD(aCores,{"ZE1_ESTADO == '1'" ,"BR_AZUL" })       // Revisado para pago

	AADD(aCores,{"ZE1_ESTADO == '2'" ,"BR_BRANCO" })     // Con títulos provisorios

	AADD(aCores,{"ZE1_ESTADO == '3'" ,"BR_VERMELHO" })   // Pagado

	dbSelectArea(cAlias)
	(cAlias)->(dbsetorder(1))

	//

	/* if alltrim(cZE1User) != "JCTABORGA"
	SET FILTER TO &cZE1Fil
	endif
	*/

	mBrowse( 6, 1, 22, 75, cAlias,,,,,3,aCores)
return

User Function MntZE1(cAlias,nReg, nOpc)

	Local cChave := ""
	Local nCols  := 0
	Local i      := 0
	Local lRet   := .F.
	Local aSaveArea

	Private aRdicDat:={}

	// Parametros da funcao Modelo2().
	Private cTitulo  := cCadastro
	Private aC       := {}                 // Campos do Enchoice.
	Private aR       := {}                 // Campos do Rodape.
	Private aCGD     := {}                 // Coordenadas do objeto GetDados.
	Private cLinOK   := ""                 // Funcao para validacao de uma linha da GetDados.
	Private cAllOK   := "u_Md2TudOK()"     // Funcao para validacao de tudo.
	Private aGetsGD  := {}
	Private bF4      := {|| }              // Bloco de Codigo para a tecla F4.

	Private cIniCpos := "+ZE1_ITEM"         // String com o nome dos campos que devem inicializados ao pressionar a seta para baixo. "+ZE1_ITEM"

	Private nMax     := 99                 // Nr. maximo de linhas na GetDados.

	//Private aCordW   := {}
	Private lDelGetD := .T.

	Private aHeader  := {}                 // Cabecalho de cada coluna da GetDados.
	Private aCols    := {}                 // Colunas da GetDados.
	Private nCount   := 0
	Private bCampo   := {|nField| FieldName(nField)}

	Private dData    := CtoD("  /  /  ")
	Private cNumero  := Space(6)
	Private cCuota   := Space(2)

	Private aAlt     := {}

	Private cSolicita := ""

	Private nCantidad := 0

	Private nTotalBs  := 0.00

	// Variables Deposito BCO

	Private cBcoMon := Space(TamSx3("E5_MOEDA")[1])
	Private cBcoNom := Space(TamSx3("A6_NOME")[1])
	Private cBcoCta := Space(TamSx3("A6_CONTA")[1])

	// NATURALEZA PUENTE CREAR PARAMETRO MV_NATPEM

	Private cNat := PADR("",TamSx3("E5_NATUREZ")[1]) // CUENTA CONTABLE BCO

	Private cCodBco := Space(TamSx3("E5_BANCO")[1])
	Private cAgencia := Space(TamSx3("E5_AGENCIA")[1])
	Private cConta := Space(TamSx3("E5_CONTA")[1])

	Private dDataDps := CtoD("  /  /  ")
	Private cDeposito := Space(TamSx3("E5_DOCUMEN")[1])

	Private lContinua := .F.

	// Cria variaveis de memoria: para cada campo da tabela, cria uma variavel de memoria com o mesmo nome.
	dbSelectArea(cAlias)

	For i := 1 To FCount()
		M->&(Eval(bCampo, i)) := CriaVar(FieldName(i), .T.)
		// Assim tambem funciona: M->&(FieldName(i)) := CriaVar(FieldName(i), .T.)
	Next

	/////////////////////////////////////////////////////////////////////
	// Cria vetor aHeader.                                             //
	/////////////////////////////////////////////////////////////////////

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)

	While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias

		If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
		cNivel >= SX3->X3_Nivel .And.;                  // Nivel do Usuario é maior que o Nivel do Campo.
		!Trim(SX3->X3_Campo) $ "ZE1_NRO|ZE1_USR|ZE1_DREG"   // Campos que ficarao na parte da Enchoice?.

			AAdd(aHeader, {Trim(SX3->X3_Titulo),;
			SX3->X3_Campo       ,;
			SX3->X3_Picture     ,;
			SX3->X3_Tamanho     ,;
			SX3->X3_Decimal     ,;
			SX3->X3_Valid       ,;
			SX3->X3_Usado       ,;
			SX3->X3_Tipo        ,;
			SX3->X3_Arquivo     ,;
			SX3->X3_Context})

		EndIf

		SX3->(dbSkip())

	EndDo

	/////////////////////////////////////////////////////////////////////
	// Cria o vetor aCols: contem os dados dos campos da tabela.       //
	// Cada linha de aCols é uma linha da GetDados e as colunas sao as //
	// colunas da GetDados.                                            //
	/////////////////////////////////////////////////////////////////////

	// Se a opcao nao for INCLUIR, atribui os dados ao vetor aCols.
	// Caso contrario, cria o vetor aCols com as caracteristicas de cada campo.

	dbSelectArea(cAlias)
	dbSetOrder(1)

	If (nOpc <> 3)      // A opcao selecionada nao é INCLUIR.

		cNumero   := (cAlias)->ZE1_NRO
		cSolicita := (cAlias)->ZE1_USR
		dData     := (cAlias)->ZE1_DREG
		cCuota    := (cAlias)->ZE1_ITEM

		DO CASE

			CASE nOpc==1 .or. nOpc==2     // Buscar o Visualizar
			lContinua := .T.
			//MsgAlert("Solo puede ver y modifcar sus propias RDIE´s","RDIE 's")

			CASE nOpc==4                  // Modificar
			lContinua := val((cAlias)->ZE1_ESTADO)==0  // Se modifica solo si está en revisión

			CASE nOpc==5                  // Genera título del plan marcado
			lContinua := val((cAlias)->ZE1_ESTADO)==1 // Genera titulo provisorio
			//MsgAlert("Solo puede excluir sus propias RDIE´s","RDIE 's")
			//lContinua:= u_validacuota(cAlias) // Valida si corresponde generar el pago de esa cuetoa

			CASE nOpc==6 .And. val((cAlias)->ZE1_ESTADO)== 1                 // generar titulos provisorios
			// Validar datos del banco
			if EXISTBLOCK("RDICBCO")
				EXECBLOCK("RDICBCO",.F.,.F.,)
				lContinua := lDatosBco
			else
				alert("No existe modulo de datos Banco")
				lContinua := .F.
			endif
			CASE nOpc==9 .And. val((cAlias)->ZE1_ESTADO)== 2                 // Revierte titulos provisorios
			lContinua := .F.
			CASE nOpc==10 .And. val((cAlias)->ZE1_ESTADO)== 0                  // Entrega Plan depagos para deposito fin revisión
			if EXISTBLOCK("RDICBCO")
				EXECBLOCK("RDICBCO",.F.,.F.,)
			else
				alert("No existe modulo de datos Banco")
				return nil
			endif

			lContinua := lDatosBco

			CASE nOpc==11 .And. val((cAlias)->ZE1_ESTADO)== 1                 // Devuelve Plan de pagos a revisión
			lContinua := .T.

			OTHERWISE
			lContinua := .F.
		ENDCASE

		if lContinua

			dbSeek(xFilial(cAlias) + cNumero + cCuota)

			While !EOF() .And. (cAlias)->(ZE1_Filial+ZE1_NRO) == xFilial(cAlias)+cNumero

				AAdd(aCols, Array(Len(aHeader)+1))   // Cria uma linha vazia em aCols.
				nCols++

				// Preenche a linha que foi criada com os dados contidos na tabela.
				For i := 1 To Len(aHeader)
					If aHeader[i][10] <> "V"    // Campo nao é virtual.
						aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
					Else
						// A funcao CriaVar() le as definicoes do campo no dic.dados e carrega a variavel de acordo com
						// o Inicializador-Padrao, que, se nao foi definido, assume conteudo vazio.
						aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
					EndIf
				Next

				// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
				aCols[nCols][Len(aHeader)+1] := .F.

				// Atribui o numero do registro neste vetor para o controle na gravacao.
				AAdd(aAlt, Recno())
				dbSelectArea(cAlias)
				dbSkip()

			EndDo
		endif
	Else  //(nOpc == 3)             // Opcao INCLUIR.

		// Atribui à variavel o inicializador padrao do campo.
		lContinua := .T.
		cNumero := GETSXENUM( cAlias, "ZE1_NRO", cAlias, 1 )

		//cCTJ_Rateio := CriaVar("CTJ_RATEIO") := "9"+ substr(cNumero,2,5)

		// Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
		AAdd(aCols, Array(Len(aHeader)+1))

		For i := 1 To Len(aHeader)
			aCols[1][i] := CriaVar(aHeader[i][2])
		Next

		// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
		aCols[1][Len(aHeader)+1] := .F.

		// Atribui 01 para a primeira linha da GetDados.
		if len(aCols) = 1
			aCols[1][AScan(aHeader,{|x| Trim(x[2])=="ZE1_ITEM"})] := "01"
		else
			aCols[len(aCols)][AScan(aHeader,{|x| Trim(x[2])=="ZE1_ITEM"})] := PADL(CVALTOCHAR(VAL(aCols[len(aCols)-1][AScan(aHeader,{|x| Trim(x[2])=="ZE1_ITEM"})+1])),2,'0')
		endif

	EndIf

	if lContinua
		/////////////////////////////////////////////////////////////////////
		// Cria o vetor Enchoice.                                          //
		/////////////////////////////////////////////////////////////////////

		// aC[n][1] = Nome da variavel. Ex.: "cCliente"
		// aC[n][2] = Array com as coordenadas do Get [x,y], em Pixel.
		// aC[n][3] = Titulo do campo
		// aC[n][4] = Picture
		// aC[n][5] = Validacao
		// aC[n][6] = F3
		// aC[n][7] = Se o campo é editavel, .T., senao .F.

		AAdd(aC, {"cNumero"  , {15,010}, "Numero"           , "@!"      , , , .F.      })
		AAdd(aC, {"dData"    , {15,070}, "Fecha Registro Plan de Pagos"  , "99/99/99", , , (nOpc==3)})
		AAdd(aC, {"cSolicita", {15,280}, "Usuario"      , "@!"      , , , (nOpc==3)})

		nTotalBs  := U_CalTotRDI(cAlias,cNumero,@aRdicDat)
		nCantidad := aRdicDat[2]

		AAdd(aR, {"nCantidad"  , {120,010}, "Cantidad Registros" , "99" , , , .F.})
		AAdd(aR, {"nTotalBs"   , {120,280}, "Total Bs."  ,PESQPICT("SE5","E5_VALOR"), , , .F.})

		// Coordenadas do objeto GetDados.
		aCGD := {34,5,110,315}
		//aCGD :=  {44,5,118,315}

		// Validacao na mudanca de linha e quando clicar no botao OK.
		cLinOK := "ExecBlock('linOkZE1',.F.,.F.)"     // ExecBlock verifica se a funcao existe.

		dData 	:= dDataBase
		cSolicita := cUserName

		// Inicializa contador de items

		/*	cIniCpos := iif( len(aCols) = 1,;
		"+ZE1_ITEM",;
		"PADL(CVALTOCHAR(VAL(aCols[len(aCols)][AScan(aHeader,{|x| Trim(x[2])=='ZE1_ITEM'})])+1),2,'0')"  )
		*/

		// Executa a funcao Modelo2().
		if nOpc <> 5
			lRet := Modelo2(cTitulo, aC, aR, aCGD, nOpc, cLinOK, cAllOK, , , cIniCpos, nMax)
		else
			lRet:= nOpc == 5
		endif

		If lRet  // Confirmou.

			If      nOpc == 3  // Inclusao
				If MsgYesNo("Confirma la grabación de los datos?", cTitulo)
					// Cria um dialogo com uma regua de progressao.
					Processa({||Md2Inclu(cAlias)}, cTitulo, "Grabando los datos, aguarde...")
					ConfirmSX8()
				EndIf
			ElseIf nOpc == 4  // Alteracao
				If MsgYesNo("Confirma la alteración de los datos?", cTitulo)
					// Cria um dialogo com uma regua de progressao.
					Processa({||Md2Alter(cAlias)}, cTitulo, "Modificando los datos, aguarde...")
				EndIf
			ElseIf nOpc == 5  // Genera  titulo para registro de plan de pagos
				If MsgYesNo("Confirma genera titulo para esta cuota del plan?", cTitulo)
					// Cria um dialogo com uma regua de progressao.
					Processa({||Md2CXP()}, cTitulo, "Creando título, aguarde...")
				EndIf
			ElseIf nOpc == 6  // Deposito
				If MsgYesNo("Confirma generación de títulos provisorios para plan de pagos?", cTitulo)
					// Cria um dialogo com uma regua de progressao.
					Processa({||Md2Dps(cAlias)}, cTitulo, "Generando títulos, aguarde...")
				EndIf
			ElseIf nOpc == 9  // Revierte deposito
				If MsgYesNo("Confirma reversión del Depósito?", cTitulo)
					// Cria um dialogo com uma regua de progressao.
					Processa({||Md2RDps(cAlias)}, cTitulo, "Revirtiendo depósito, aguarde...")
				EndIf
			ElseIf nOpc == 10  // Confirma plan de pagos para procesar
				If MsgYesNo("Confirma el Plan de Pagos para procesar?", cTitulo)
					// Cria um dialogo com uma regua de progressao.
					Processa({||Md2Ent(cAlias)}, cTitulo, "Confirmado Plan de Pagos para procesar, aguarde...")
				EndIf
			ElseIf nOpc == 11  // Devuelve a revisión Plan de pagos
				If MsgYesNo("Confirma devolución del Plan de Pagos para revisión?", cTitulo)
					// Cria um dialogo com uma regua de progressao.
					Processa({||Md2Dev(cAlias)}, cTitulo, "Devolviendo Plan de pagos a revisión, aguarde...")
				EndIf

			EndIf

			/*     OPCION DE EXCLUSION
			ElseIf nOpc == 5  // EXCLUSION
			If MsgYesNo("Confirma la exclusíón de los datos?", cTitulo)
			// Cria um dialogo com uma regua de progressao.
			Processa({||Md2Exclu(cAlias)}, cTitulo, "Excluyendo los datos, aguarde...")
			EndIf
			*/
		Else
			RollbackSXE()

		EndIf
	endif
Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Inclu(cAlias)

	Local i := 0
	Local y := 0

	ProcRegua(Len(aCols))

	dbSelectArea(cAlias)
	dbSetOrder(1)

	For i := 1 To Len(aCols)

		IncProc()

		If !aCols[i][Len(aHeader)+1]  // A linha nao esta deletada, logo, deve ser gravada.

			RecLock(cAlias, .T.)

			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next

			(cAlias)->ZE1_FILIAL := xFilial(cAlias)
			(cAlias)->ZE1_NRO	:= cNumero
			(cAlias)->ZE1_DREG	:= dData
			(cAlias)->ZE1_USR	:= cUserName

			MSUnlock()

		EndIf

	Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Alter(cAlias)

	Local i := 0
	Local y := 0
	Local nReg

	ProcRegua(Len(aCols))

	dbSelectArea(cAlias)
	dbSetOrder(1)

	For i := 1 To Len(aCols)

		If i <= Len(aAlt)

			// aAlt contem os Recno() dos registros originais.
			// O usuario pode ter incluido mais registros na GetDados (aCols).

			dbGoTo(aAlt[i])                 // Posiciona no registro.
			RecLock(cAlias, .F.)
			If aCols[i][Len(aHeader)+1]     // A linha esta deletada.
				dbDelete()                   // Deleta o registro correspondente.
			Else
				// Regrava os dados.
				For y := 1 To Len(aHeader)
					FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
				Next
			EndIf
			MSUnlock()

		Else     // Foram incluidas mais linhas na GetDados (aCols), logo, precisam ser incluidas.

			If !aCols[i][Len(aHeader)+1]
				RecLock(cAlias, .T.)
				For y := 1 To Len(aHeader)
					FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
				Next
				(cAlias)->ZE1_Filial := xFilial(cAlias)
				(cAlias)->ZE1_NRO := cNumero
				(cAlias)->ZE1_DREG := dData
				(cAlias)->ZE1_USR	:= cUserName
				//Corrije numeracion cuando se modifica ZE1
				(cAlias)->ZE1_ITEM := PADL(CVALTOCHAR(i),2,'0')
				MSUnlock()
			EndIf

		EndIf

	Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Exclu(cAlias)

	Local nReg:= 0

	ProcRegua(Len(aCols))

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbSeek(xFilial(cAlias) + cNumero+'01')

	While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero
		IncProc()
		RecLock(cAlias, .F.)
		dbDelete()
		MSUnlock()
		dbSkip()
	EndDo

Return Nil

//----------------------------------------------------------------------------------------------------------------//
user Function Md2TudOK()

	Local lRet := .T.
	Local i    := 0
	Local nDel := 0
	Local xObj

	For i := 1 To Len(aCols)
		If aCols[i][Len(aHeader)+1]
			nDel++
		EndIf
	Next

	nTotalBs  := U_CalTotRDI(cAlias,cNumero,@aRdicDat)
	nCantidad := aRdicDat[2]

	xObj := CallMod2Obj()
	xObj:oBrowse:Refresh() // Actualiza Browse

	If nDel == Len(aCols)
		MsgInfo("Para excluir todos los itens, utilice la opción EXCLUIR", cTitulo)
		lRet := .F.
	EndIf

Return lRet

//----------------------------------------------------------------------------------------------------------------//
user Function linOkZE1()

	Local lRet := .T.
	Local xObj

	If aCols[1][AScan(aHeader,{|x| Trim(x[2])=="ZE1_VAL"})] <= 0
		MsgAlert("Valor debe ser positivo.", "Atención!")
		lRet := .F.
	EndIf

	nTotalBs  := U_CalTotRDI(cAlias,cNumero,@aRdicDat)
	nCantidad := aRdicDat[2]

	xObj := CallMod2Obj()
	xObj:oBrowse:Refresh() // Actualiza Browse

Return lRet

User Function ZE1Leg()
	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE" ,"Plan de pagos en revisión" })

	AADD(aLegenda,{"BR_AZUL" ,"Plan de pago aprobado para pago" })

	AADD(aLegenda,{"BR_BRANCO" ,"Plan de pagos con títulos provisorios" })

	AADD(aLegenda,{"BR_VERMELHO" ,"Plan de pagos con título pagado" })

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

//----------------------------------------------------------------------------------------------------------------//

user Function RdicBco()
	Local lRet := .F.
	Local aSaveArea:= GetArea()
	Static lITF := .F.
	if NaoVazio((cAlias)->ZE1_BANCO)
		cCodBco := (cAlias)->ZE1_BANCO
		cAgencia := (cAlias)->ZE1_AGENCI
		cConta  := (cAlias)-> ZE1_CONTAB
	endif
	lRet := U_VALRDIBCO()
Return lRet

user function ValRdiBco()
	//Valida datos de Bco
	Local aSaveArea:= GetArea()
	lDatosBco := .F.
	dbSelectArea("SA6")

	If SA6->(DbSeek(XFilial("SA6") + cCodBco+ cAgencia + cConta))
		// Tomamos Moneda y Nombre del Banco
		cBcoMon :=  PADL(cValToChar(POSICIONE("SA6",1, xFilial("SA6") + cCodBco + cAgencia + cConta, "A6_MOEDA")),2,"0")
		cBcoNom :=  alltrim(POSICIONE("SA6",1, xFilial("SA6") + cCodBco + cAgencia + cConta, "A6_NOME"))
		cBcoCta    :=  POSICIONE("SA6",1, xFilial("SA6") + cCodBco + cAgencia + cConta, "A6_CONTA")
		lDatosBco := .T.
	Else
		lDatosBco := .F.
	Endif
	lRet := lDatosBco
	RestArea(aSaveArea)
return lRet

Static Function Md2Ent(cAlias)

	Local nValor := 0
	Local cHisto := ""

	if !lDatosBco
		MsgAlert("Datos errados. Debe ingresar datos correctos del Banco para la operación.", "Atención!")
	else

		dbSelectArea(cAlias)
		dbSetOrder(1)
		dbSeek(xFilial(cAlias) + cNumero+'01')

		While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero
			IncProc()
			nValor +=  Round(xMoeda((cAlias)->ZE1_VALBS,1,val(cBcoMon),dDataBase,3),2)  //(cAlias)->ZE1_VALBS
			cHisto := "Préstamo Nro.:" + (cAlias)->ZE1_NORDIC
			dbSkip()
		EndDo

		aRetorno:= U_fRMoeda(val(cBcoMon))
		cDescri := aRetorno[1,1]

		if msgyesno("Confirma  Plan de pagos por " + cvaltochar(nValor)+ " " + cDescri + CHR(10)+CHR(13) + "En Banco " + cBcoNom + " - Cuenta: " + cConta +CHR(10)+CHR(13) + "de " + cHisto +" ?","Confirma Plan de Pagos")
			BEGIN TRANSACTION

				ProcRegua(Len(aCols))

				dbSelectArea(cAlias)
				dbSetOrder(1)
				dbSeek(xFilial(cAlias) + cNumero+'01')
				While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero
					IncProc()
					RecLock(cAlias, .F.)
					(cAlias)->ZE1_ESTADO := '1'
					MSUnlock()
					dbSkip()
				EndDo
			END TRANSACTION
		endif
	endif

Return

//----------------------------

Static Function Md2Dev(cAlias)

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbSeek(xFilial(cAlias) + cNumero)

	if (cAlias)->ZE1_ESTADO == '1' //.or. (cAlias)->ZE1_ESTADO == '2'// Si fue entregado fin de revisión o solo tiene rateo puede devolver a revisión
		BEGIN TRANSACTION
			ProcRegua(Len(aCols))

			dbSelectArea(cAlias)
			dbSetOrder(1)
			dbSeek(xFilial(cAlias) + cNumero+'01')
			While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero
				IncProc()
				RecLock(cAlias, .F.)
				(cAlias)->ZE1_ESTADO := '0'
				MSUnlock()
				dbSkip()
			EndDo
		END TRANSACTION
		msgalert("El Plan de pagos se pasó a revisión con éxito","Plan de Pagos a Revisión")
	elseif (cAlias)->ZE1_ESTADO == '3'
		msgalert("El plan de pagos, ya tiene pagos asociados no se puede mandar a revisión","Plan de Pagos en proceso")
	elseif (cAlias)->ZE1_ESTADO == '0'
		msgalert("El Plan de pagos sigue en revisión.","Plan de Pagos en revisión")
	Endif
Return
//-------------------------------------------
Static Function Md2Dps(cAlias)

	Local nOpc     := 0
	Local aFINA100 := {}
	Local aArray := {}
	Local nValor := 0
	Local cHisto := ""
	Local lRet := .T.
	Local cDescri := ""
	Local nTaxa   := 0

	Private lMsErroAuto := .F.

	// TOMAR DATOS: FECHA DEPOSITO, BANCO AGENCIA, CUENTA (Consulta estandar Bancos),
	// MONEDA, NATURALEZA (Consulta estandar Modalidades)

	if !lDatosBco
		MsgAlert("Datos Banco errados. Debe ingresar datos correctos del banco para el pago.", "Atención!")
	else

		dbSelectArea(cAlias)
		dbSetOrder(1)

		if dbSeek(xFilial(cAlias) + cNumero+'01')

			nValor := 0
			cHisto := "Plan de pagos: " + cNumero + " Prestamo Nro:"+(cAlias)->ZE1_NORDIC

			While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero
				IncProc()
				nValor +=  Round(xMoeda((cAlias)->ZE1_VALBS,1,val(cBcoMon),dDataBase,3),2)  //(cAlias)->ZE1_VALBS
				dbSkip()
			EndDo

			aRetorno:= U_fRMoeda(val(cBcoMon))
			cDescri := aRetorno[1,1]

			if msgyesno("Confirma generación de títulos por " + cvaltochar(nValor)+ " " + cDescri + CHR(10)+CHR(13) + "de " + cHisto +" ?","Genera títulos por pagar")
				BEGIN TRANSACTION
					ProcRegua(Len(aCols))

					dbSelectArea(cAlias)
					dbSetOrder(1)
					dbSeek(xFilial(cAlias) + cNumero+'01')

					nValor := 0
					cHisto := "Plan de pagos: " + cNumero + " Prestamo Nro:" +(cAlias)->ZE1_NORDIC

					lExec:= .T.
					While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero .And. lExec
						IncProc()

						nValor    := (cAlias)->ZE1_VAL    //Round(xMoeda((cAlias)->ZE1_VALBS,1,val(cBcoMon),dDataBase,3),2)
						nValBs    := (cAlias)->ZE1_VALBS
						cPrefixo  := (cAlias)->ZE1_PREFIX
						cNumTit   := (cAlias)->ZE1_NORDIC
						cTipo     := PADR(MVFATURA,3)
						cNat      := (cAlias)->ZE1_NATURE
						dDataCXP  := dDataBase
						dDataVcto := (cAlias)->ZE1_DRDIC

						nCuota    := val((cAlias)->ZE1_ITEM)
						cCuot     := cvaltochar(nCuota)

						nMoneda   := (cAlias)->ZE1_MOEDA
						cHist     := substr((cAlias)->ZE1_CONCEP,1,TamSx3("E2_HIST")[1])  //

						cBanco    := (cAlias)->ZE1_BANCO  // BANCO
						cAgencia  := (cAlias)->ZE1_AGENCI // AGENCIA BANCO
						cContab   := (cAlias)->ZE1_CONTAB // CUENTA BANCARIA

						cFornece  := Posicione("SA6",1,xFilial('SA6')+cBanco+cAgencia+cContab,"A6_CODFOR") // '000481' //TRAER SA6_CODFOR CON EL COD DEL BANCO, QUE LO TRAE DE CODIGO DE PROVEEDOR DEL BANCO EN SA2
						cLoja     := Posicione("SA2",1,xFilial('SA2')+cFornece,"A2_LOJA")

						aRetorno:= U_fRMoeda(nMoneda) // retorna descripcion y valor de tasa de la momeda en fecha de emisión ddatabase
						cDescri := aRetorno[1,1]

						nTasa     := aRetorno[1,2]  //FuncaMoeda(dDataCXP,nValor,nMoneda)[nMoneda]

						aArray := { { "E2_PREFIXO"  , cPrefixo             , NIL },;
						{ "E2_NUM"      , cNumTit            , NIL },;
						{ "E2_TIPO"     , cTipo              , NIL },;
						{ "E2_PARCELA"  , cCuot              , NIL },;
						{ "E2_NATUREZ"  , cNat             , NIL },;
						{ "E2_FORNECE"  , cFornece            , NIL },;
						{ "E2_LOJA"     , cLoja            , NIL },;
						{ "E2_HIST"     , cHist               , NIL },;
						{ "E2_EMISSAO"  , dDataCXP, NIL },;
						{ "E2_VENCTO"   , dDataVcto, NIL },;
						{ "E2_VENCREA"  , dDataVcto, NIL },;
						{ "E2_MOEDA"    , nMoneda, NIL },;
						{ "E2_VLCRUZ"   , nValBs, NIL },;
						{ "E2_SALDO"    , nValor, NIL },;
						{ "E2_TXMOEDA"    , nTasa, NIL },;
						{ "E2_VALOR"    , nValor              , NIL } }

						if (cAlias)->ZE1_ESTADO == '1'
							alert('Numero ' +cNumero + ' Titulo '+cNumTit +' cuota: '+ cCuota)
							lMsErroAuto:= .F.

							lMsErroAuto:= MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
							If lMsErroAuto
								MostraErro()
								lExec:= .F.
							Else
								RecLock(cAlias, .F.)
								(cAlias)->ZE1_ESTADO := '2'
								MSUnlock()
								lExec:= .T.
							Endif
						endif
						dbSkip()
					EndDo

				END TRANSACTION
			else
				MsgAlert("No se generaron los títulos","Atención!")
			endif  //genera titulos
		endif // estado con rateo?
	endif // existe datos banco?

Return

//-----------------------------------------------------------
static function Md2CXP()
	/////////////////////////////////////
	//alert(cAlias)

	if dbSeek(xFilial(cAlias) + cNumero+cCuota)

		BEGIN TRANSACTION
			ProcRegua(Len(aCols))
			cHisto := "Plan de pagos: " + cNumero + " Prestamo Nro:"+ZE1->ZE1_NORDIC

			nValor    := ZE1->ZE1_VAL
			nValBs    := ZE1->ZE1_VALBS

			nInteres   := ZE1->ZE1_INT
			nIntBs     := ZE1->ZE1_INTBS

			cPrefixo  := ZE1->ZE1_PREFIX
			cPrefint  := 'INT'
			cNumTit   := ZE1->ZE1_NORDIC
			cTipo     := PADR(MVFATURA,3) //PADR(MVPROVIS,3)
			cNat      := ZE1->ZE1_NATURE
			dDataCXP  := dDataBase
			dDataVcto := ZE1->ZE1_DRDIC
			nCuota    := val(ZE1->ZE1_ITEM)
			nMoneda   := ZE1->ZE1_MOEDA
			cHist     := substr(ZE1->ZE1_CONCEP,1,TamSx3("E2_HIST")[1])  //

			cBanco    := ZE1->ZE1_BANCO  // BANCO
			cAgencia  := ZE1->ZE1_AGENCI // AGENCIA BANCO
			cContab   := ZE1->ZE1_CONTAB // CUENTA BANCARIA
			aRetorno:= U_fRMoeda(val(cBcoMon))

			cFornece  := Posicione("SA6",1,xFilial('SA6')+cBanco+cAgencia+cContab,"A6_CODFOR") // '000481' //TRAER SA6_CODFOR CON EL COD DEL BANCO, QUE LO TRAE DE CODIGO DE PROVEEDOR DEL BANCO EN SA2
			cLoja     := Posicione("SA2",1,xFilial('SA2')+cFornece,"A2_LOJA")

			nTasa     := aRetorno[1,2] //FuncaMoeda(dDataCXP,nValor,nMoneda)[nMoneda]
			cNomfor   := Posicione("SA2",1,xFilial('SA2')+cFornece,"A2_NOME")
			cFuncion  := FUNNAME()
			dbSelectArea("SE2")
			dbSetOrder(1)

			if ZE1->ZE1_ESTADO = '1'
				//CtaxPagar Capital
				RecLock("SE2", .T.)
				SE2->E2_FILIAL  := xFilial("SE2")
				SE2->E2_PREFIXO := cPrefixo
				SE2->E2_NUM     := cNumTit
				SE2->E2_PARCELA := cCuota
				SE2->E2_TIPO    := cTipo
				SE2->E2_NATUREZ := cNat
				SE2->E2_FORNECE := cFornece
				SE2->E2_NOMFOR  := cNomfor
				SE2->E2_LOJA    := cLoja
				SE2->E2_HIST    := cHist
				SE2->E2_EMISSAO := dDataCXP
				SE2->E2_VENCTO  := dDataVcto
				SE2->E2_VENCREA := dDataVcto
				SE2->E2_MOEDA   := nMoneda
				SE2->E2_VALOR   := nValor
				SE2->E2_VLCRUZ  := nValBs
				SE2->E2_SALDO   := nValor
				SE2->E2_PORTADO := cBanco
				SE2->E2_TXMOEDA := nTasa
				SE2->E2_ORIGEM  := cFuncion
				MSUnlock()

				//CtaxPagar Interes
				RecLock("SE2", .T.)
				SE2->E2_FILIAL  := xFilial("SE2")
				SE2->E2_PREFIXO := cPrefint
				SE2->E2_NUM     := cNumTit
				SE2->E2_PARCELA := cCuota
				SE2->E2_TIPO    := cTipo
				SE2->E2_NATUREZ := cNat
				SE2->E2_FORNECE := cFornece
				SE2->E2_NOMFOR  := cNomfor
				SE2->E2_LOJA    := cLoja
				SE2->E2_HIST    := cHist
				SE2->E2_EMISSAO := dDataCXP
				SE2->E2_VENCTO  := dDataVcto
				SE2->E2_VENCREA := dDataVcto
				SE2->E2_MOEDA   := nMoneda
				SE2->E2_VALOR   := nInteres
				SE2->E2_VLCRUZ  := nIntBs
				SE2->E2_SALDO   := nInteres
				SE2->E2_PORTADO := cBanco
				SE2->E2_TXMOEDA := nTasa
				SE2->E2_ORIGEM  := cFuncion
				MSUnlock()

				RecLock("ZE1", .F.)
				ZE1->ZE1_ESTADO := '2'
				MSUnlock()
				MsgInfo("Título e interés de prestamo: " + cNumTit+" incluídos con éxito!","Generación de Título")
			else
				MsgInfo("Título de prestamo: " + cNumTit+" no pudo ser incluído!","Generación de Título")
			endif

			/*
			aArray := { { "E2_PREFIXO"  , cPrefixo             , NIL },;
			{ "E2_NUM"      , cNumTit            , NIL },;
			{ "E2_PARCELA"  , nCuota            , NIL },;
			{ "E2_TIPO"     , cTipo              , NIL },;
			{ "E2_NATUREZ"  , cNat             , NIL },;
			{ "E2_FORNECE"  , cFornece            , NIL },;
			{ "E2_HIST"     , cHist               , NIL },;
			{ "E2_EMISSAO"  , dDataCXP, NIL },;
			{ "E2_VENCTO"   , dDataVcto, NIL },;
			{ "E2_VENCREA"  , dDataVcto, NIL },;
			{ "E2_MOEDA"    , nMoneda, NIL },;
			{ "E2_VALOR"    , nValor              , NIL } }

			if ZE1->ZE1_ESTADO = '1'

			lMsErroAuto := .F.
			alert('Numero ' +cNumero + ' Titulo '+cNumTit +' cuota: '+ cCuota)

			lMsErroAuto:=MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			If lMsErroAuto
			MostraErro()
			Else
			if dbSeek(xFilial("ZE1") + cNumero+cCuota)
			RecLock("ZE1", .F.)
			ZE1->ZE1_ESTADO := '2'
			MSUnlock()
			MsgInfo("Título de prestamo: " + cNumTit+" incluído con éxito!","Generación de Título")
			endif
			Endif

			else
			MsgInfo("Título de prestamo: " + cNumTit+" no está disponible para generar provisorio!","Generación de Título")
			endif
			*/
			/////////////////////////////////////
		END TRANSACTION

	else
		alert('no encontró cuota')
	endif

Return

Static Function Md2RDps(cAlias)

	Local nOpc     := 0
	Local aFINA100 := {}
	Local nValor := 0
	Local cHisto := ""
	Local lRet := .T.

	Private lMsErroAuto := .F.

	dbSelectArea(cAlias)
	dbSetOrder(1)

	if dbSeek(xFilial(cAlias) + cNumero+'01') .And. (cAlias)->ZE1_ESTADO = '2'

		BEGIN TRANSACTION
			ProcRegua(Len(aCols))

			dDataDps := (cAlias)->ZE1_DDEP
			cCodBco := (cAlias)->ZE1_BANCO
			cAgencia := (cAlias)->ZE1_AGENCI
			cConta := (cAlias)->ZE1_CONTAB
			cDeposito := (cAlias)->ZE1_NODEP
			cBcoMon :=  PADL(cValToChar(POSICIONE("SA6",1, xFilial("SA6") + cCodBco + cAgencia + cConta, "A6_MOEDA")),2,"0")

			nValor := 0
			cHisto := "Reversion Dps RDIE: " + cNumero + " RDICs:"

			While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero
				IncProc()
				nValor +=  Round(xMoeda((cAlias)->ZE1_VALBS,1,val(cBcoMon),dDataDps,3),2)  //(cAlias)->ZE1_VALBS
				cHisto += (cAlias)->ZE1_NORDIC + ","
				dbSkip()
			EndDo

			dbSelectArea("SE5")
			SE5->(dbSetOrder(1))
			SE5->(dbSeek(xFilial("SE5")+DToS(dDataDps) ))
			// apuntar al reg
			//{"E5_UGLOSA"   ,cMemo    ,Nil},; retirado
			//{"E5_CALCITF"  ,cCalcITF    ,Nil},; retirado
			aFINA100 := {       {"E5_DATA"     ,dDataDps ,Nil},;
			{"E5_MOEDA"    ,cBcoMon    ,Nil},;
			{"E5_VALOR"    ,nValor    ,Nil},;
			{"E5_NATUREZ"  ,cNat      ,Nil},;
			{"E5_BANCO"    ,cCodBco   ,Nil},;
			{"E5_AGENCIA"  ,cAgencia  ,Nil},;
			{"E5_CONTA"    ,cConta    ,Nil},;
			{"E5_HISTOR"   ,cHisto    ,Nil},;
			{"E5_RATEIO"   ,"S"    ,Nil},;
			{"E5_DOCUMEN"  ,cDeposito ,Nil} }

			MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)

			If lMsErroAuto
				MostraErro()
			Else

				dbSelectArea(cAlias)
				dbSetOrder(1)
				dbSeek(xFilial(cAlias) + cNumero+'01')

				While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero
					RecLock(cAlias, .F.)
					(cAlias)->ZE1_ESTADO := '1'
					MSUnlock()
					dbSkip()
				EndDo
				MsgInfo("Movimiento Bancario: Depósito incluido con éxito!!!","Deposito RDIE")
			EndIf
		END TRANSACTION

	endif
Return
//-----------------------------------------------------------

user  function getxmoeda(dFecha,cMoneda)
	Local nXchange := 0.00
	LOCAL aAreaAnt := GETAREA()

	dbSelectArea("CTP")
	dbsetorder(1)

	if dbSeek(xFilial("CTP")+DTOS(dFecha)+ PADL(cMoneda,2,"0"))     // Filial: 01 / Código: 000001 / Loja: 02
		nXchange := POSICIONE("CTP",1,xFilial("CTP")+DTOS(dFecha)+PADL(cMoneda,2,"0"),"CTP->CTP_TAXA")
	endif
	RESTAREA(aAreaAnt)

return nXchange

user function CalTotRDI(cAlias, cNumero,aRdicDat)
	Local nTotal := 0
	Local nQuant := 0
	Local aSaveArea:= GetArea()

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbSeek(xFilial(cAlias) + cNumero+'01')

	While !EOF() .And. (cAlias)->ZE1_Filial == xFilial(cAlias) .And. (cAlias)->ZE1_NRO == cNumero
		nTotal += (cAlias)->ZE1_VALBS //iif((cAlias)->ZE1_VALBS<0,(cAlias)->ZE1_VALBS*-1,(cAlias)->ZE1_VALBS)
		nQuant++
		dbSkip()
	EndDo

	aAdd(aRdicDat,nTotal)
	aAdd(aRdicDat,nQuant)
	RestArea(aSaveArea)
return nTotal
