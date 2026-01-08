#INCLUDE "Protheus.ch"
//----------------------------------------------------------------------------------------------------------------//
// Modelo 2.
//----------------------------------------------------------------------------------------------------------------//

User Function Mod2ZE2()

Local aCores := {}

Private	cAlias := "ZE2"

dbSelectArea(cAlias)

dbSetOrder(1)

Private cZE2User := cUserName
Private cCadastro := "Registro de Solicitud de Efectivo"

Private cZE2Fil := "ZE2_USR == "+ cZE2User

Private lDatosBco := .F.

Private	aRotina := {;
{ "Buscar", "AxPesqui", 0, 1},;
{ "Visualizar", "U_MntZE2(cAlias,,2)", 0, 2},; // Visualizar Solicitud
{ "Incluir", "U_MntZE2(cAlias,,3)", 0, 3},; // Incluir Solicitud
{ "Modificar", "U_MntZE2(cAlias,,4)", 0, 4},; // Modificar Solicitud
{ "Exlcuir", "U_MntZE2(cAlias,,5)", 0, 5},; // Exluir Solicitud
{ "Genera Título x Pago", "U_MntZE2(cAlias,,6)", 0, 6},; // Generar título CtaXPagar
{ "Leyenda", "U_ZE2Leg()", 0, 7},;
{ "Aprobar", "U_MntZE2(cAlias,,8)", 0, 8},; // Aprobar solicitud
{ "Revertir Título x Pago", "U_MntZE2(cAlias,,9)", 0, 9},; // Revierte / Anula CtaXPagar
{ "Disponer x Aprobación", "U_MntZE2(cAlias,,10)", 0, 10},; // Entregar solicitud a aprobación
{ "Devuelve (A revisión).", "U_MntZE2(cAlias,,11)", 0, 11}}  //No aprueba , rechaza a revisión

AADD(aCores,{"VAL(ZE2_ESTADO) == 0" ,"BR_VERDE" }) //Ingresado

AADD(aCores,{"VAL(ZE2_ESTADO) == 1" ,"BR_AZUL" })  //Pendiente de autorización

AADD(aCores,{"VAL(ZE2_ESTADO) == 2" ,"BR_BRANCO" }) // Aprobado o Pendiente de Titulo

AADD(aCores,{"VAL(ZE2_ESTADO) == 3" ,"BR_VERMELHO" }) // Con titulo o Pendiente de pago

AADD(aCores,{"VAL(ZE2_ESTADO) == 4" ,"BR_AMARELO" }) // Pagado

dbSelectArea(cAlias)
(cAlias)->(dbsetorder(1))

/* if alltrim(cZE2User) != "JCTABORGA"
SET FILTER TO &cZE2Fil
endif
*/

mBrowse( 6, 1, 22, 75, cAlias,,,,,2,aCores)
return

User Function MntZE2(cAlias,nReg, nOpc)

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
Private cAllOK   := "u_ZE2TudOK()"     // Funcao para validacao de tudo ZE2TudOK().
Private aGetsGD  := {}
Private bF4      := {|| }              // Bloco de Codigo para a tecla F4.

Private cIniCpos := ""         // String com o nome dos campos que devem inicializados ao pressionar a seta para baixo. "+ZE2_ITEM"

Private nMax     := 1                 // Nr. maximo de linhas na GetDados.

//Private aCordW   := {}
Private lDelGetD := .T.

Private aHeader  := {}                 // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                 // Colunas da GetDados.
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField)}

Private dData    := CtoD("  /  /  ")
Private cNumero  := Space(6)
Private aAlt     := {}

Private cSolicita := ""

Private nCantidad := 0

Private nTotalBs  := 0.00

// Variables Deposito BCO

Private cBcoMon := Space(TamSx3("E5_MOEDA")[1])
Private cBcoNom := Space(TamSx3("A6_NOME")[1])
Private cBcoCta := Space(TamSx3("A6_CONTA")[1])

// NATURALEZA PUENTE CREAR PARAMETRO MV_NATRDIC



Private cCodBco := Space(TamSx3("E5_BANCO")[1])
Private cAgencia := Space(TamSx3("E5_AGENCIA")[1])
Private cConta := Space(TamSx3("E5_CONTA")[1])
Private cCalcITF := Space(TamSx3("E5_CALCITF")[1])

Private cMemo := Space(TamSx3("E5_UGLOSA")[1])

Private dDataCXP := CtoD("  /  /  ")
Private cDeposito := Space(TamSx3("E5_DOCUMEN")[1])


// Variables de Administración de Cuenta X Pagar

Private cPrefixo := Space(TamSx3("E2_PREFIXO")[1])
Private cNumTit  := Space(TamSx3("E2_NUM")[1])
Private cTipo    := Space(TamSx3("E2_TIPO")[1])
Private cNat     := Space(TamSx3("E2_NATUREZ")[1])
Private cFornece := Space(TamSx3("E2_FORNECE")[1])

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
		!Trim(SX3->X3_Campo) $ "ZE2_NRO|ZE2_USR|ZE2_DREG"   // Campos que ficarao na parte da Enchoice?.
		
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
	
	cNumero   := (cAlias)->ZE2_NRO
	cSolicita := (cAlias)->ZE2_USR
	dData     := (cAlias)->ZE2_DREG
	
	
	DO CASE
		
		CASE nOpc==1 .or. nOpc==2     // Buscar o Visualizar
			lContinua := .T.
			
		CASE nOpc==4                  // Modificar
			lContinua := val((cAlias)->ZE2_ESTADO)==0  // Se modifica solo si está en revisión
			
		CASE nOpc==5                  // Excluir
			lContinua := val((cAlias)->ZE2_ESTADO)==0 // Se borra solo si está en revisión
			//MsgAlert("Solo puede excluir sus propias RDIE´s","RDIE 's")
			
		CASE nOpc==6                  // Generar cuenta por pagar
			lContinua := val((cAlias)->ZE2_ESTADO)==2
			
		CASE nOpc==8                  // Aprobar
			lContinua := val((cAlias)->ZE2_ESTADO)== 1
			
		CASE nOpc==9                  // Revierte Cta x Pagar
			lContinua := val((cAlias)->ZE2_ESTADO)== 3
			
		CASE nOpc==10                  // Entrega solicitud para aprobación
			lContinua := val((cAlias)->ZE2_ESTADO)== 0
			
		CASE nOpc==11                 // Rechaza o devuelve a revisión solicitud
			lContinua := val((cAlias)->ZE2_ESTADO)== 1 .or. val((cAlias)->ZE2_ESTADO) == 2
			
		OTHERWISE
			lContinua := .F.
	ENDCASE
	
	if !lContinua
		Msgalert("Acción no permitida para el estado de la solicitud!!","Atención!!")
	elseif lContinua
		
		dbSeek(xFilial(cAlias) + cNumero)
		
		While !EOF() .And. (cAlias)->(ZE2_Filial+ZE2_NRO) == xFilial(cAlias)+cNumero
			
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
	cNumero := GETSXENUM( cAlias, "ZE2_NRO", cAlias, 1 )
	
	// Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
	AAdd(aCols, Array(Len(aHeader)+1))
	
	For i := 1 To Len(aHeader)
		aCols[1][i] := CriaVar(aHeader[i][2])
	Next
	
	// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
	aCols[1][Len(aHeader)+1] := .F.
	//aCols[1][AScan(aHeader,{|x| Trim(x[2])=="ZE2_ITEM"})] := "01"
	
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
	AAdd(aC, {"dData"    , {15,070}, "Fecha Registro de Solicitud de efectivo"  , "99/99/99", , , (nOpc==3)})
	AAdd(aC, {"cSolicita", {15,280}, "Usuario"      , "@!"      , , , (nOpc==3)})
	
	
	// Coordenadas do objeto GetDados.
	aCGD := {34,5,110,315}
	
	// Validacao na mudanca de linha e quando clicar no botao OK.
	cLinOK := "ExecBlock('linOkZE2',.F.,.F.)"     // ExecBlock verifica se a funcao existe.
	
	dData 	:= dDataBase
	cSolicita := cUserName
	
	
	// Inicializa contador de items
	//cIniCpos := "+ZE2_SEQ"
	
	// Executa a funcao Modelo2().
	
	lRet := Modelo2(cTitulo, aC, aR, aCGD, nOpc, cLinOK, cAllOK, , , /*cIniCpos*/, nMax)
	
	
	If lRet  // Confirmou.
		
		If      nOpc == 3  // Inclusao
			If MsgYesNo("Confirma la grabación de los datos?", cTitulo)
				// Cria um dialogo com uma regua de progressao.
				Processa({||ZE2Inclu(cAlias)}, cTitulo, "Grabando los datos de la solicitud, aguarde...")
				ConfirmSX8()
			EndIf
		ElseIf nOpc == 4  // Alteracao
			If MsgYesNo("Confirma la alteración de los datos?", cTitulo)
				// Cria um dialogo com uma regua de progressao.
				Processa({||ZE2Alter(cAlias)}, cTitulo, "Modificando los datos de la solicitud, aguarde...")
			EndIf
		ElseIf nOpc == 5  // Exclusao
			If MsgYesNo("Confirma la eliminación de los datos?", cTitulo)
				// Cria um dialogo com uma regua de progressao.
				Processa({||ZE2Exclu(cAlias)}, cTitulo, "Excluyendo los datos de la solicitud, aguarde...")
			EndIf
		ElseIf nOpc == 6  // Genera titulo
			If MsgYesNo("Confirma generación del Titulo X Pagar?", cTitulo)
				// Cria um dialogo com uma regua de progressao.
				Processa({||ZE2GTit(cAlias)}, cTitulo, "Generando cuenta por pagar de la solicitud, aguarde...")
			EndIf
		ElseIf nOpc == 8  // Aprueba
			If MsgYesNo("Confirma aprobación de la solicitud?", cTitulo)
				// Cria um dialogo com uma regua de progressao.
				Processa({||ZE2Apr(cAlias)}, cTitulo, "Aprobando la solicitud, aguarde...")
			EndIf
		ElseIf nOpc == 9  // Anula o revierte titulo
			If MsgYesNo("Confirma reversión del Titulo?", cTitulo)
				// Cria um dialogo com uma regua de progressao.
				Processa({||ZE2RTit(cAlias)}, cTitulo, "Revirtiendo cuenta por pagar de la solicitud, aguarde...")
			EndIf
		ElseIf nOpc == 10  // Finaliza y entrega Solicitud de efectivo aprobación
			If MsgYesNo("Confirma disponer solicitud para aprobación?", cTitulo)
				// Cria um dialogo com uma regua de progressao.
				Processa({||ZE2Dis(cAlias)}, cTitulo, "Entregando la solicitud para aprobación, aguarde...")
			EndIf
		ElseIf nOpc == 11  // Devuelve a revisión Solicitud
			If MsgYesNo("Confirma devolución de solicitud a revisión?", cTitulo)
				// Cria um dialogo com uma regua de progressao.
				Processa({||ZE2Rec(cAlias)}, cTitulo, "Devolviendo la solicitud a revisión, aguarde...")
			EndIf
			
		EndIf
		
	Else
		RollbackSXE()
		
	EndIf
endif
Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function ZE2Inclu(cAlias)

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
		
		(cAlias)->ZE2_FILIAL := xFilial(cAlias)
		(cAlias)->ZE2_NRO	:= cNumero
		(cAlias)->ZE2_DREG	:= dData
		(cAlias)->ZE2_USR	:= cUserName
		
		
		MSUnlock()
		
	EndIf
	
Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function ZE2Alter(cAlias)

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
		
	EndIf
	
Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function ZE2Exclu(cAlias)

Local nReg:= 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias) + cNumero)

While !EOF() .And. (cAlias)->ZE2_Filial == xFilial(cAlias) .And. (cAlias)->ZE2_NRO == cNumero
	IncProc()
	RecLock(cAlias, .F.)
	dbDelete()
	MSUnlock()
	dbSkip()
EndDo

Return Nil

//----------------------------------------------------------------------------------------------------------------//
user Function ZE2TudOK()

Local lRet := .T.
Local i    := 0
Local nDel := 0

For i := 1 To Len(aCols)
	If aCols[i][Len(aHeader)+1]
		nDel++
	EndIf
Next

If nDel == Len(aCols)
	MsgInfo("Para excluir todos los items, utilice la opción EXCLUIR", cTitulo)
	lRet := .F.
EndIf

Return lRet

//----------------------------------------------------------------------------------------------------------------//
user Function linOkZE2()

Local lRet := .T.

If aCols[1][AScan(aHeader,{|x| Trim(x[2])=="ZE2_VAL"})] <= 0
	MsgAlert("Solicitud sin valor, revise!.", "Atención!")
	lRet := .F.
EndIf

Return lRet

User Function ZE2Leg()
Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE" ,"Ingresado (en revisión)" })
AADD(aLegenda,{"BR_AZUL" ,"Pendiente de aprobación" })
AADD(aLegenda,{"BR_BRANCO" ,"Aprobado" })
AADD(aLegenda,{"BR_VERMELHO" ,"Con título generado" })
AADD(aLegenda,{"BR_AMARELO" ,"Pagado" })
BrwLegenda(cCadastro, "Leyenda", aLegenda)

Return Nil

Static Function ZE2Dis(cAlias)

Local nValor := 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias) + cNumero)


While !EOF() .And. (cAlias)->ZE2_Filial == xFilial(cAlias) .And. (cAlias)->ZE2_NRO == cNumero
	IncProc()
	RecLock(cAlias, .F.)
	(cAlias)->ZE2_ESTADO := '1'
	MSUnlock()
	dbSkip()
EndDo

Return

//----------------------------

Static Function ZE2Rec(cAlias)

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias) + cNumero)

if val((cAlias)->ZE2_ESTADO) == 1 .or. val((cAlias)->ZE2_ESTADO) == 2 // Si esta pendiente de aprobación o aprobado puede devolverse a revisión
	
	ProcRegua(Len(aCols))
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbSeek(xFilial(cAlias) + cNumero)
	
	
	While !EOF() .And. (cAlias)->ZE2_Filial == xFilial(cAlias) .And. (cAlias)->ZE2_NRO == cNumero
		IncProc()
		RecLock(cAlias, .F.)
		(cAlias)->ZE2_ESTADO := '0'
		(cAlias)->ZE2_DAPR   := CtoD("  /  /  ")
		MSUnlock()
		dbSkip()
	EndDo
	
	msgalert("El documento devuelto con exito para revisión","Solicitud devuelta")
	
elseif val((cAlias)->ZE2_ESTADO) == 2
	msgalert("El documento ya tiene título generado debe revertirse/anularse primero","Solicitud con Título")
elseif val((cAlias)->ZE2_ESTADO) == 0
	msgalert("El documento sigue en revisión.","Solicitud en revisión")
Endif

Return
//-------------------------------------------
Static Function ZE2GTit(cAlias)
Local nValor := 0
Local aArray := {}
Local cPrefixo
Local cNumTit
Local cTipo
Local cNat
Local cMat
Local cFornece := ""
Local cHits    := ""
Local lFornece := .F.
Local dDataCXP
Local nMoneda


Private lMsErroAuto := .F.
// Busca al empleado como proveedor y obtiene su codigo

BEGIN TRANSACTION
ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias) + cNumero)



nValor := 0
cPrefixo  := (cAlias)->ZE2_TIPO
cNumTit   := (cAlias)->ZE2_TIPO + (cAlias)->ZE2_NRO
cTipo     := PADR(MVFATURA,3)
cNat      := (cAlias)->ZE2_NATURE
dDataCXP  := dDataBase
nMoneda   := (cAlias)->ZE2_MOEDA
cHist     := substr((cAlias)->ZE2_CONCEP,1,TamSx3("E2_HIST")[1])  //

// Matricula anterior original ingreso
dbSelectArea("ZB9")
dbSetOrder(1)
cMat      := POSICIONE("ZB9",1,xFilial("ZB9") +(cAlias)->ZE2_MAT,"ZB9_FICHA")
//alert("Ficha:" + cMat)
// obtengo codigo de proveedor del funcionario por el campo A2_NUMRA matricula antigua equiv. a ZB9_FICHA

dbSelectArea("SA2")
dbSetOrder(7) // A2_FILIAL+A2_NUMRA
SA2->(DbSeek(xFilial("SA2")+cMat))

if SA2->( Found() )	   // Verifica si el funcionario está registrado como proveedor
	cFornece := SA2->A2_COD
	lFornece := .T.
else
	lFornece := .F.
endif
//alert("Proveedor:" + cFornece)
if lFornece // Si el funcionerio esta como proveedor proceso
	
	// Proceso el titulo, 1ro Obtengo el valor del titulo
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbSeek(xFilial(cAlias) + cNumero)
	
	While !EOF() .And. (cAlias)->ZE2_Filial == xFilial(cAlias) .And. (cAlias)->ZE2_NRO == cNumero
		IncProc()
		nValor +=  (cAlias)->ZE2_VAL
		RecLock(cAlias, .F.)
		(cAlias)->ZE2_ESTADO := '3'
		MSUnlock()
		dbSkip()
	EndDo
	
	aArray := { { "E2_PREFIXO"  , cPrefixo             , NIL },;
	{ "E2_NUM"      , cNumTit            , NIL },;
	{ "E2_TIPO"     , cTipo              , NIL },;
	{ "E2_NATUREZ"  , cNat             , NIL },;
	{ "E2_FORNECE"  , cFornece            , NIL },;
	{ "E2_HIST"     , cHist               , NIL },;
	{ "E2_EMISSAO"  , dDataCXP, NIL },;
	{ "E2_VENCTO"   , dDataCXP, NIL },;
	{ "E2_VENCREA"  , dDataCXP, NIL },;
	{ "E2_MOEDA"    , nMoneda, NIL },;
	{ "E2_VALOR"    , nValor              , NIL } }
	
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
	If lMsErroAuto
		MostraErro()
	Else
		MsgInfo("Título de solicitud de efectivo: " + cNumTit+" incluído com éxito!","Generación de Título")
	Endif
	
else
	MsgAlert("Título no generado, funcionario no encontrado en maestro de proveedores","Atención!")
endif
END TRANSACTION
Return

Static Function ZE2Apr(cAlias)

Local aSaveArea:= GetArea()
Local nUltSeq := 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)
dbgotop()


dbSeek(xFilial(cAlias) + cNumero)

While !EOF() .And. (cAlias)->ZE2_Filial == xFilial(cAlias) .And. (cAlias)->ZE2_NRO == cNumero
	IncProc()
	RecLock(cAlias, .F.)
	(cAlias)->ZE2_ESTADO := '2'
	(cAlias)->ZE2_DAPR   := dDataBase
	MSUnlock()
	dbSkip()
	
EndDo

RestArea(aSaveArea)
Return

//-----------------------------------------------------------

Static Function ZE2RTit(cAlias)

Local nValor := 0
Local aArray := {}
Local cPrefixo
Local cNumTit
Local cTipo
Local cNat
Local cMat
Local dDataCXP
Local nMoneda
Local cCuota := Space(TamSx3("E2_PARCELA")[1])
Local cFornece := Space(TamSx3("E2_FORNECE")[1])
Local cLoja :=Space(TamSx3("E2_LOJA")[1])

Private lMsErroAuto := .F.

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias) + cNumero)


if  val((cAlias)->ZE2_ESTADO) == 3 //Solo se excluye si no fue pagado
	
	cPrefixo  := (cAlias)->ZE2_TIPO
	cNumTit   := PADR((cAlias)->ZE2_TIPO + (cAlias)->ZE2_NRO,TamSx3("E2_NUM")[1])
	cTipo     := PADR(MVFATURA,3)
	cNat      := (cAlias)->ZE2_NATURE
	cMat      := (cAlias)->ZE2_MAT
	dDataCXP  := dDataBase
	nMoneda   := (cAlias)->ZE2_MOEDA
	BEGIN TRANSACTION
	ProcRegua(Len(aCols))
	
	DbSelectArea("SE2")
	DbSetOrder(1)
	
	SE2->(DbSeek(xFilial("SE2")+cPrefixo+cNumTit+cCuota+cTipo)) //Exclusão deve ter o registro SE2 posicionado+cFornece+cLoja
	alert(xFilial("SE2")+cPrefixo+cNumTit+cCuota+cTipo)
	if SE2->(found())                                            //SE2->E2_PREFIXO + SE2->E2_NUM
		aArray := { { "E2_PREFIXO" , cPrefixo , NIL },;
		{ "E2_NUM" , cNumTit , NIL },;
		{ "E2_PARCELA" , cCuota , NIL },;
		{ "E2_TIPO"     , cTipo     , NIL } }
		
		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		
		If lMsErroAuto
			MostraErro()
		Else
			dbSelectArea(cAlias)
			dbSetOrder(1)
			dbSeek(xFilial(cAlias) + cNumero)
			
			
			While !EOF() .And. (cAlias)->ZE2_Filial == xFilial(cAlias) .And. (cAlias)->ZE2_NRO == cNumero
				IncProc()
				RecLock(cAlias, .F.)
				(cAlias)->ZE2_ESTADO := '2'
				MSUnlock()
				dbSkip()
			EndDo
			
			MsgAlert("Exclusión del Título exitosa!","Cuentas X Pagar")
		Endif
	else
		MsgAlert("Titulo no encontrado!","Cuentas X Pagar")
	endif
	
	END TRANSACTION
endif
Return

user function NatSolEfe()
Local cNatureza :=''

cNatureza := PADR(iif(M->ZE2_TIPO = 'SAR', '211001',iif(M->ZE2_TIPO = 'SAY', '210301',iif(M->ZE2_TIPO = 'SAB', '211101',iif(M->ZE2_TIPO = 'SAV', '211002',iif(ZE2_TIPO = 'ANR', '210701',iif(M->ZE2_TIPO = 'ANV', '210703','N/A')))))),TamSx3("ZE2_NATURE")[1])

return cNatureza         

user function SeqSolEfe(cMatS,dDataS)

Local nSeq := 0
Local cAlias:=""
Local cQuery:=""                   
Local cSeq

cQuery := "SELECT NVL(COUNT(*),0) NQUANT FROM " + retSqlName("ZE2") 
cQuery += " WHERE ZE2_FILIAL = '" + xFilial("ZE2") + "' AND ZE2_MAT = '" + cMatS + "' "
cQuery += " AND SUBSTR(ZE2_DREG,1,6) = '" + substr(DtoS(dDataS),1,6) +"' "  //cValtoChar(YEAR(dDataS)) + PADL(cValtoChar(MONTH(dDataS)),2,'0') + "' "
cQuery += " AND " +RetSQLName("ZE2")+".D_E_L_E_T_ <> '*' "   
cQuery += " GROUP BY SUBSTR(ZE2_DREG,1,6)"
 
if U_TESTQRY(cQuery)
	
	cAlias1:= CriaTrab(Nil,.F.)
	
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
	if !(cAlias1)->(Eof())
	nSeq :=  (cAlias1)->NQUANT + 1
	endif
	
endif  

return nSeq         



