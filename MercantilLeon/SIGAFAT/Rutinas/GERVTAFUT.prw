#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"
#Include 'ParmType.ch'
#Include 'Protheus.ch'
#Include "Topconn.ch"
////NO OLVIDAR REVISAR DISPARADORES C6 PRODUTO 7
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  GERVTAFUT  ºAutor  ³ERICK ETCHEVERRY   ºFecha ³  11/12/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Que crea el 2do pedido de Venta futura, si hubo       º±±
±±º          ³ algun error con los correlativos y no se llego a generar   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MERCANTIL LEON                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GERVTAFUT(cxNumVld,lValMsg)  ///PASAMOS EL PEDIDO FUTURO DE LA LISTA
	Local aArea 	:= GetArea()
	Local lGeraPed := .t.
	Local aVld
	Private cResObs := ""
	DEFAULT cxNumVld := ""
	Default lValMsg := .f.

	if SC5->C5_DOCGER == "3" ///EL PEDIDO ES PARA ENTREGA FUTURA

		IF EMPTY(cxNumVld)
			IF !FWIsInCallStack("U_FIXVTAFUT")
				cxNumVld := SC5->C5_UPVFUT
				IF EMPTY(cxNumVld)
					//alert("Pedido futuro vacio en la Nota de venta")
					cxNumVld = GETADVFVAL("SF2","F2_PEDPEND",SC5->C5_FILIAL+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_NOTA+SC5->C5_SERIE+"N"+"NF",2,"")
				ENDIF
			ENDIF
		ELSE
			///si encuentra el pedido quiere decir que tiene factura entonces actualizamos
			RECLOCK( "SC5", .F. )
			SC5->C5_UPVFUT := cxNumVld
			MSUNLOCK()
			//REVISAMOS SU FACTURA PARA REALIZAR EL PEDIDO DE REMITO EL 2
			DbSelectArea("SF2")
			DbSetOrder(1)

			IF DbSeek(xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI)//BUSCAMOS LA FACTURA DE VENTA CON EL PEDIDO TIPO
				////actualizamos la SF2
				RECLOCK( "SF2", .F. )
				SF2->F2_PEDPEND :=cxNumVld
				MSUNLOCK()
			ENDIF

			SF2->(DbCloseArea())

		ENDIF

		IF !EMPTY(cxNumVld)  //VERIFICAMOS EL ESTADO DE ESE PEDIDO SI ES DEL MISMO CLIENTE
			aVld := GetVtaFut(SC5->C5_FILIAL,cxNumVld,SC5->C5_CLIENTE,SC5->C5_LOJACLI) ///ya tiene pedido o no

			if aVld[1][1]///si tiene pedido de alguno de los tipos
				lGeraPed = .f.
				cResObs += "PEDIDO FUT YA GENERADO: |'"+SC5->C5_NUM+"' - '"+ aVld[1][2] +"' |"

				//alert("Pedido de venta futura ya generado, " + aVld[1][2] ) ///numero pedido generado
			ELSE
				cResObs += "PEDIDO NO GENERADO AUN: |'"+SC5->C5_NUM+"' |"
			endif
		ELSE
			cResObs += "PEDIDO NO GENERADO AUN: |'"+SC5->C5_NUM+"' |"
		endif

		//validamos si tiene pedido sino hacemos el PEDIDO remito
		IF lGeraPed ////si es verdadero generamos el pedido de venta
			////// el pedido tiene factura
			DbSelectArea("SF2")
			DbSetOrder(1)

			IF DbSeek(xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI)//BUSCAMOS LA FACTURA DE VENTA CON EL PEDIDO TIPO

				if A468RemFut(GetNewPar("MV_UTESFUT","801"),SF2->F2_EMISSAO) ///si genero ok creamos la salida
					cResObs += "|PEDIDO GENERO PEDIDO FUTURO: '"+SC5->C5_NUM+"' |"
					GERVFUTREM(1)///genera PEDIDO remito

				ELSE
					cResObs += "|PEDIDO NO GENERO PEDIDO FUTURO: '"+SC5->C5_NUM+"' |"
				endif
			else
				cResObs += "|PEDIDO SIN FACTURA: '"+SC5->C5_NUM+"' |"
			ENDIF

			SF2->(DbCloseArea())

		else ////sino verificamos si tiene remitos por que hay pedido
			if len(aVld) > 0
				if aVld[1][1] ////tiene pedido futuro?
					if !lRemitd2(aVld[1][4],aVld[1][5],aVld[1][6]) ////sino tiene remitos EL PEDIDO FUTURO
						///POSICIONA AL PEDIDO FUTURO
						dbSelectArea("SC5")
						SC5->(dbgotop())
						SC5->(dbsetOrder(1))
						MsSeek(xFilial("SC5")+aVld[1][4])///FILIAL PEDIDO

						IF SC5->C5_DOCGER $ '2'  ///TIENE QUE GENERAR REMITO
							GERVFUTREM(2)
							//cResObs += ",{PEDIDO GENERO REMITO: '"+SC5->C5_NUM+"' -> '"+SF2->F2_DOC +"' - '" + SF2->F2_SERIE+ "' }"  ///ok
						ELSE
							IF SC5->C5_BLQ <> ' '
								cResObs += "|PEDIDO NO GENERO REMITO: |'"+SC5->C5_NUM+"'| C5_BLQ : '"+SC5->C5_BLQ+ "' |"  ///ok
							endif
						ENDIF

						SC5->(DbCloseArea())

					else
						cResObs += "|PEDIDO TIENE REMITOS: |'"+SC5->C5_NUM+"' |"
						//alert("El pedido ya tiene remitos")
					endif
				ELSE
					cResObs += "|PEDIDO NO TIENE PEDIDO FUTURO: |'"+SC5->C5_NUM+"' |"
				endif
			endif
		endif

	elseIF SC5->C5_DOCGER == "2"//REMITO
		cxNumVld := SC5->C5_UPVFUT

		IF EMPTY(cxNumVld)
			cxNumVld = GETADVFVAL("SF2","F2_PEDPEND",SC5->C5_FILIAL+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_NOTA+SC5->C5_SERIE+"N"+"NF",2,"")
		ENDIF

		IF !EMPTY(cxNumVld)
			if !lRemitd2(SC5->C5_NUM,SC5->C5_FILIAL,SC5->C5_CLIENTE) ////Pedido ya tiene remitos
				GERVFUTREM(2)
			ELSE
				alert("El pedido ya tiene remitos")
			endif
		else
			alert("El pedido no es de venta futura")
		endif

	ELSE
		alert("El pedido no es de venta futura")
	endif

	cResObs += CRLF

	if !lValMsg
		Aviso("",cResObs,{'ok'},,,,,.t.)
	endif

	RestArea(aArea)
return cResObs

///VALIDACION PEDIDO GENERADO EN CABECERA
Static Function GetVtaFut(cxFilial,cxNumFut,cxCli,cxLoja)  ////tiene vta futura
	Local aArea			:= getArea()
	Local aResp := {}
	Local cAliasQry		:= GetNextAlias()
	Local cQuery		:= ""


    /*
    SELECT 1 TIPO,C5_UPVFUT,C5_DOCGER,* FROM SC5010
    WHERE C5_DOCGER = '2' --REMITO
    --AND C5_UPVFUT <> ' '  ---VENTA FUTURA
    AND C5_NUM =  '234300'  
    AND C5_CLIENTE = '000497'
    AND C5_LOJACLI = '01'
    UNION ---TIENE NUMERO PERO ES OTRO CLIENTE POSIBLE ERROR
    SELECT 2 TIPO,C5_UPVFUT,C5_DOCGER,* FROM SC5010
    WHERE C5_DOCGER = '2' --REMITO
    ---AND C5_UPVFUT <> ' '  ---VENTA FUTURA
    AND C5_NUM =  '234300'  
    AND C5_CLIENTE <> '000497'*/

	cQuery += "SELECT 1 TIPO,C5_UPVFUT,C5_DOCGER,C5_NUM,C5_FILIAL,C5_CLIENTE "
	cQuery += "FROM " + RetSQLName("SC5") + " SC5 "
	cQuery += "WHERE "
	cQuery += " 		SC5.C5_FILIAL     = '" +cxFilial+ "' "
	cQuery += "         AND SC5.C5_NUM    = '" +cxNumFut+ "' "
	cQuery += "         AND SC5.C5_CLIENTE    = '" +cxCli+ "' "
	cQuery += "         AND SC5.C5_LOJACLI    = '" +cxLoja+ "' "
	cQuery += "         AND SC5.D_E_L_E_T_ = ' ' "
    cQuery += "         UNION "
    cQuery += "SELECT 2 TIPO,C5_UPVFUT,C5_DOCGER,C5_NUM,C5_FILIAL,C5_CLIENTE "
	cQuery += "FROM " + RetSQLName("SC5") + " SC5 "
	cQuery += "WHERE "
	cQuery += " 		SC5.C5_FILIAL     = '" +cxFilial+ "' "
	cQuery += "         AND SC5.C5_NUM    = '" +cxNumFut+ "' "
	cQuery += "         AND SC5.C5_CLIENTE    <> '" +cxCli+ "' "
	cQuery += "         AND SC5.D_E_L_E_T_ = ' ' "

	//aviso("Query",cQuery,{'Ok'},,,,,.t.)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

	IF (cAliasQry)->( !EOF() ) ///trae algo
		if (cAliasQry)-> TIPO == 1
			aadd(aResp,{.t.,"Pedido generado: " +(cAliasQry)->C5_NUM,1,(cAliasQry)->C5_NUM,(cAliasQry)->C5_FILIAL,(cAliasQry)->C5_CLIENTE})
		ELSEIF (cAliasQry)-> TIPO == 2
			aadd(aResp,{.t.,"Cliente distinto verificar pedido: " +(cAliasQry)->C5_NUM,2,(cAliasQry)->C5_NUM,(cAliasQry)->C5_FILIAL,(cAliasQry)->C5_CLIENTE})
		ENDIF
	ELSE
		aadd(aResp,{.F.,'','','',''})
	EnDIF

	(cAliasQry)->(DbCloseArea())

	restArea(aArea)

Return aResp

Static Function A468RemFut(cTesPend,dxDataFac)
Local aCabPV		:= {}
Local aItemPV		:= {}
Local cCond,cTabela
Local cNumPed		:=	GetNextNrPed(SC5->C5_CONDPAG)//Criavar("C5_NUM")
Local cvC6_PRUNIT	:=	""
Local cvC6_UNSVEN	:=	""
Local cvC6_SEGUM	:=	""
Local nPorcDesc := 0
Local nPrcVenta := 0
Local nVlrTtlIt := 0
Local lRet := .t.
Local cNumant := SC5->C5_NUM

// RollBackSx8 necessario pois GetSxeNum já foi executado na CriaVar("C5_NUM") acima
// e ao chamar MATA410 por rotina automatrica, o sistema executara novamente GetSxeNum
// no inicializador padrao do campo C5_NUM.
RollBAckSx8()

SX3->(DbSetOrder(2))
SX3->(MsSeek("C6_PRUNIT"))
cvC6_PRUNIT	:=	Alltrim(SX3->X3_VALID) +If(Empty(SX3->X3_VLDUSER),"",".AND."+Alltrim(SX3->X3_VLDUSER))
SX3->(MsSeek("C6_UNSVEN"))
cvC6_UNSVEN	:=	Alltrim(SX3->X3_VALID) +If(Empty(SX3->X3_VLDUSER),"",".AND."+Alltrim(SX3->X3_VLDUSER))
SX3->(MsSeek("C6_SEGUM"))
cvC6_SEGUM	:=	Alltrim(SX3->X3_VALID) +If(Empty(SX3->X3_VLDUSER),"",".AND."+Alltrim(SX3->X3_VLDUSER))

Private lMsErroAuto := .f.


SA1->(DbSetOrder(1))
SA1->(MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
lTpPedBenf := .f.


SB1->(DbSetOrder(1))

cCond	:= If(Empty(SF2->F2_COND),If(lTpPedBenf,SA2->A2_COND,SA1->A1_COND),SF2->F2_COND)
cTabela	:= If( lTpPedBenf, SC5->C5_TABELA, If(Empty(SC5->C5_TABELA),SA1->A1_TABELA,SC5->C5_TABELA) )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Asumo que usa carga, pois mesmo assim pode ser remitido sem carga, no caso contrario, ³
//³nunca poderia utilizar o pedido numa carga e soh poderia usalo em um remito           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Cabecalho
aCabPV:={{"C5_NUM"    ,cNumPed    ,Nil},; // Numero do pedido
	{"C5_TIPO"   ,If(lTpPedBenf,"B","N")         	,Nil},; // Tipo de pedido
	{"C5_CLIENTE",If(lTpPedBenf,SA2->A2_COD ,SA1->A1_COD )	,Nil},; // Codigo do cliente
	{"C5_LOJAENT",If(lTpPedBenf,SA2->A2_LOJA,SA1->A1_LOJA)	,Nil},; // Loja para entrada
	{"C5_LOJACLI",If(lTpPedBenf,SA2->A2_LOJA,SA1->A1_LOJA)	,Nil},; // Loja do cliente
	{"C5_EMISSAO",dxDataFac   	,Nil},; // Data de emissao
	{"C5_TABELA" ,cTabela       	,Nil},; // Codigo da Tabela de Preco
	{"C5_CONDPAG",cCond          ,Nil},; // Codigo da condicao de pagamanto*
	{"C5_DESC1"  ,0           	,Nil},; // Percentual de Desconto
	{"C5_INCISS" ,"N"         	,Nil},; // ISS Incluso
	{"C5_TIPLIB" ,"1"         	,Nil},; // Tipo de Liberacao
	{"C5_MOEDA"  ,SF2->F2_MOEDA 	,Nil},; // Moeda
	{"C5_LIBEROK","S"         	,Nil},; // Liberacao Total
	{"C5_TIPOCLI",If(lTpPedBenf,SA2->A2_TIPO,SA1->A1_TIPO)	,Nil},;
	{"C5_TIPOREM","0"				,Nil},;
	{"C5_VEND1"  ,SF2->F2_VEND1	,Nil},;
	{"C5_DOCGER" ,'2'        		,Nil},;
	{"C5_TPCARGA",'1'        		,Nil},;
	{"C5_NATUREZ",SF2->F2_NATUREZ,Nil},;
    {"C5_ULOCAL",SC5->C5_ULOCAL,Nil}}

//Items
DbSelectArea("SD2")
DbSetOrder(3)
If  !DbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE)
	Alert("Registros no encontrado en SD2 no se genero pedido futuro")
    return .f.
else
    nItem := 1

    While SD2->(!Eof()) .AND. SD2->D2_FILIAL == SF2->F2_FILIAL    .And. SD2->D2_DOC == SF2->F2_DOC    .And. SD2->D2_SERIE == SF2->F2_SERIE

        Sb1->(MsSeek(xFilial()+SD2->D2_COD))
        
        nPorcDesc := ((SD2->D2_DESCON / SD2->D2_TOTAL)*100)
        nPrcVenta := SD2->D2_PRCVEN + (SD2->D2_DESCON / SD2->D2_QUANT)
        nVlrTtlIt := SD2->D2_TOTAL + SD2->D2_DESCON
        
        AAdd(aItemPV,{{"C6_NUM"    ,cNumped        ,Nil},; // Numero do Pedido
            {"C6_ITEM"   ,StrZero(nItem,2)  ,Nil},; // Numero do Item no Pedido
            {"C6_PRODUTO",SD2->D2_COD 	,Nil},; // Codigo do Produto
            {"C6_QTDVEN" ,SD2->D2_QUANT	,Nil},; // Quantidade Vendida
            {"C6_PRUNIT" ,SD2->D2_PRUNIT	,If(!Empty(cvC6_PRUNIT),+"Vazio().Or."+cvC6_PRUNIT,Nil)},; // PRECO DE LISTA
            {"C6_PRCVEN" ,IIf(cPaisLoc == "ARG", nPrcVenta, SD2->D2_PRCVEN),Nil},; // Preco Unitario Liquido
            {"C6_VALOR"  ,IIf(cPaisLoc == "ARG", nVlrTtlIt, SD2->D2_TOTAL),Nil},; // Valor Total do Item
            {"C6_ENTREG" ,dxDataFac      ,Nil},; // Data da Entrega
            {"C6_UM"     ,SD2->D2_UM     ,Nil},; // Unidade de Medida Primar.
            {"C6_TES"    ,cTesPend  		,Nil},; // Tipo de Entrada/Saida do Item
            {"C6_LOCAL"  ,SD2->D2_LOCAL	,Nil},; // Almoxarifado
            {"C6_DESCONT",IIf(cPaisLoc == "ARG", nPorcDesc, 0),Nil},; // Percentual de Desconto
            {"C6_COMIS1" ,0              ,Nil},; // Comissao Vendedor
            {"C6_CLI"    ,SD2->D2_CLIENTE,Nil},; // Cliente
            {"C6_LOJA"   ,SD2->D2_LOJA   ,Nil},; // Loja do Cliente
            {"C6_SEGUM"  ,SD2->D2_SEGUM  ,If(!Empty(cvC6_SEGUM ) ,"Vazio().Or."+cvC6_SEGUM  ,Nil)},;
            {"C6_DESCRI" ,SB1->B1_DESC   ,Nil},;
            {"C6_UNSVEN" ,SD2->D2_QTSEGUM,If(!Empty(cvC6_UNSVEN) ,"Vazio().Or."+cvC6_UNSVEN ,Nil)},;
            {"C6_GERANF" ,"N"            ,Nil},;
            {"C6_QTDEMP" ,0              ,Nil},; // Quantidade Empenhada
            {"C6_QTDLIB" ,0              ,Nil},;  // Quantidade Liberada
            {"C6_VALDESC" ,IIf(cPaisLoc == "ARG", SD2->D2_DESCON,0),Nil}})  // Valor de Descuento

            SD2->(DbSkip())

            nItem++
    EndDo

EndIf


MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPv,aItemPV,3)

If lMsErroAuto
	DisarmTransaction()
	MostraErro()
	lRet = .f.
Else
	RecLock("SF2",.F.)
	Replace F2_PEDPEND   With  cNumPed
	Replace F2_UOBSERV    With "GEN.PED.VTA FUT "+dtoc(DDATABASE) +" "+cUsername
	MsUnLock()
	
	///AL NUEVO LE PONEMOS EL ANTERIOR
	RECLOCK("SC5",.F.)
	SC5->C5_UPVFUT := cNumant
	REPLACE C5_UPVFUT WITH cNumant
	Replace C5_UOBSERV With "GEN.PED.VTA FUT "+dtoc(DDATABASE) +" "+cUsername
	SC5->( MsUnlock())

	//AL ANTERIOR LO MARCAMOS IGUAL CON EL NUEVO
	dbSelectArea("SC5")
	SC5->(dbgotop())
	SC5->(dbsetOrder(1))
	MsSeek(xFilial("SC5")+cNumant)

	RECLOCK("SC5",.F.)
	SC5->C5_UPVFUT := cNumPed
	REPLACE C5_UPVFUT WITH cNumPed
	SC5->( MsUnlock())

	///VOLVEMOS A POSICIONAR AL GENERADO
	dbSelectArea("SC5")
	SC5->(dbgotop())
	SC5->(dbsetOrder(1))
	MsSeek(xFilial("SC5")+cNumPed)


	DbSelectArea("SC6")
	dbSetOrder(1)
	MsSeek(xFilial()+cNumPed)
	//Tenho Que garantir a gravacao deste campo com "N" pois o campo pode nao
	//estar em uso e eh preciso que esteja gravado com "N" pois este pedido nao pode ser fatuurado. Bruno.
	While !Eof() .And. C6_FILIAL == xFilial() .And. C6_NUM == cNumPed
		RecLock("SC6",.F.)
		Replace C6_GERANF	With	"N"
		MsUnLock()
		DbSkip()
	Enddo

EndIf

Return lRet

static Function GetNextNrPed(cCondPag)
Local cQuery  := ""
Local cQueryx := ""
Local cNumPed := ""

If !Empty(cCondPag)
		If (cCondPag) == "002"
			cQueryx += " And Left(C5_NUM,1) <> 'C' " 
		Else
			cQueryx += " And Left(C5_NUM,1) = 'C' " 
		EndIf
		
		cQuery := " SELECT TOP 1 C5_NUM "
		cQuery += " From " + RetSqlName("SC5") 
		cQuery += " Where C5_FILIAL = '" + xFilial("SC5")+ "' "
		cQuery += cQueryx
	   	cQuery += " And D_E_L_E_T_  <> '*' "
		cQuery += " AND SUBSTRING(C5_NUM,2,5)  NOT LIKE '%[A-Z]%' "
		cQuery += " ORDER BY C5_NUM DESC "

		//Aviso("",cQuery,{'ok'},,,,,.t.)		
		If Select("StrSQL") > 0  //En uso
		   StrSQL->(DbCloseArea())
		Endif
		
		TcQuery cQuery New Alias "StrSQL"

		If Empty(StrSQL->C5_NUM) 
	  		If (cCondPag) == "002"
	  			cNumPed := "000001"
	  		Else
	  			cNumPed := "C00001"
	  		EndIf
		Else
	  		//Obtiene el valor Numérico del Ultimo Código
	  		If (cCondPag) == "002"
	  			cNumero := CValToChar(VAL(AllTrim(StrSQL->C5_NUM))+1)
	  			cNumPed := REPLICATE("0",6 - LEN(AllTrim(cNumero)))+AllTrim(cNumero)
	  		Else
	  			cNumero := CValToChar(VAL(SUBSTR(AllTrim(StrSQL->C5_NUM),2,5))+1)
	  			cNumPed := "C"+REPLICATE("0",5 - LEN(AllTrim(cNumero)))+AllTrim(cNumero)
	  		EndIf  
	  	EndIf

EndIf

//Alert("GetNextNrPed - cNumPed: '" + cNumPed + "''")

Return(cNumPed)

static function GERVFUTREM(nTipo)
	Local aArea		:= GetArea()
	Local aBloqueio	:= {{"","","","","","","",""}}
	Local aPvlNfs		:= {}
	Local nX
	Local lBloq := .f.

	///quiere decir que ya hay pedido y tambien SC9 intentamos liberar
	if nTipo == 2
		fnlibera()
	endif

	Ma410LbNfs(2,@aPvlNfs,@aBloqueio)  //libera sino esta liberadoF
	
	Ma410LbNfs(1,@aPvlNfs,@aBloqueio)  ///monta array nf
	

	if len(aBloqueio) > 0
			lBloq = .t.
			//alert("Existen items con bloqueo de stock en el pedido: "+ SC5->C5_NUM + " no se haran las salidas")
	endif

	If !Empty(aPvlNfs) .and. !lBloq

			aReg:={}

			For nX:=1 To Len(aPvlNfs)
				Aadd(aReg,aPvlNfs[nX][8])
			Next

			If SC5->C5_DOCGER=="2"		//gerar remision
				ProcRegua(Len(aReg))
				Pergunte("MT462A",.F.)
				aParams:={2,2,2,2,01,SC5->C5_MOEDA}
				cMarca:=GetMark(,'SC9','C9_OK')
				cMarcaSC9:=cMarca
				For nX:=1 To Len(aReg) ///marca los registros SC9
					IncProc()
					SC9->(DbGoTo(aReg[nX]))
					RecLock("SC9",.F.)
					Replace SC9->C9_OK With cMarca
					SC9->(MsUnLock())
				Next
				
				SetInvert(.F.)

				aRems := A462ANGera(Nil,cMarca,.T.,aReg,.F.,aParams)

				if len(aRems) > 0
					RecLock("SF2",.F.)
					Replace F2_UOBSERV    With "REG.ENT.FUT "+dtoc(DDATABASE) +" "+cUsername
					MsUnLock()
					cResObs += "|PEDIDO GENERO REMITO: |'"+SC5->C5_NUM+"' | -> |'"+SF2->F2_DOC +"'| - |'" + SF2->F2_SERIE+ "'|"
				else
					cResObs += "|PEDIDO NO GENERO REMITO: |'"+SC5->C5_NUM+"' |"
				endif

			endif
	ELSE
		cResObs += "|PEDIDO NO GENERO REMITO: |'"+SC5->C5_NUM+"' |"
	endif

	RestArea(aArea)
return

//pedido tiene algun remito
Static Function lRemitd2(cxNum,cxFilial,cxCli)
	Local aArea			:= getArea()
	Local lRet			:= .f.
	Local cAliasQry		:= GetNextAlias()
	Local cQuery		:= ""

	cQuery += "SELECT DISTINCT SF2.F2_DOC "
	cQuery += "FROM " + RetSQLName("SC5") + " SC5 "
	cQuery += "    INNER JOIN " + RetSQLName("SD2") + " SD2 "
	cQuery += "		     ON (SD2.D2_FILIAL = '" +cxFilial+ "' "
	cQuery += "			 AND SD2.D2_PEDIDO = '" +cxNum+ "' "
	cQuery += "			 AND SD2.D2_CLIENTE = '" +cxCli+ "' "
	cQuery += "			 AND SD2.D_E_L_E_T_ = ' ')  "
	cQuery += "    INNER JOIN " + RetSQLName("SF2") + " SF2 "
	cQuery += "		    ON (SF2.F2_FILIAL   = SD2.D2_FILIAL "
	cQuery += "			AND SF2.F2_DOC   	= SD2.D2_DOC    "
	cQuery += "			AND SF2.F2_SERIE 	= SD2.D2_SERIE  "
	cQuery += "			AND SF2.D_E_L_E_T_ = ' ')
	cQuery += "WHERE "
	cQuery += " 		SC5.C5_FILIAL     = '" +cxFilial+ "' "
	cQuery += "         AND SC5.C5_NUM    = '" +cxNum+ "' "
	cQuery += "         AND SC5.C5_CLIENTE    = '" +cxCli+ "' "
	cQuery += "         AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SF2.F2_DOC"

	//aviso("Query",cQuery,{'Ok'},,,,,.t.)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

	IF (cAliasQry)->( !EOF() )
		lRet := .t.
	EnDIF

	(cAliasQry)->(DbCloseArea())

	restArea(aArea)

Return lRet

///liberar el pedido de ventas
static function fnlibera
	Local aArea			:= getArea()

	Pergunte( "LIBAT2", .F. )

	MV_PAR01 = SC5->C5_NUM
	MV_PAR02 = SC5->C5_NUM
	MV_PAR03 = SC5->C5_CLIENTE
	MV_PAR04 = SC5->C5_CLIENTE
	MV_PAR05 = SC5->C5_EMISSAO
	MV_PAR06 = SC5->C5_EMISSAO
	MV_PAR07 = 1 //STOCK WMS
			
	Ma450Proces( "SC9", .F., .T., .F., Nil, MV_PAR07==2)

	
restArea(aArea)

return
