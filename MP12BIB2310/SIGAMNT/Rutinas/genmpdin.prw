#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.CH"
#include 'parmtype.ch'


/*/{Protheus.doc} User Function genmpdin
    Generación Masiva de integración de parte diario con activos fijos y 
    costo de mano diario
    @type  Function
    @author user
    @since 07/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function genmpdin()
	Local oSay       := nil
	Local titulo     := nil
	LOCAL nX
	public aPVSelec := {}
	private oDlgTela
	private aHeader := {}
	private cEstado
	private aColsCidades := {}
	private lChkSel    := .F.
	private lOkSalva   := .F.
	private lChkFiltro := .F.
	private oGetDados
	static oChk, oChkFiltro
	private ValTotal := 0.0
	private cPrimComp := ""
	private cUltimaCom := ""
	//	LOCAL cTexto := OEMTOANSI("Valor total")
	CriaSX1("GENMPDIN")
	PERGUNTE("GENMPDIN",.t.)
	//array de cabeçalho do GetDados
	//Neste caso serão 4 colunas incluindo o campo que possui caixa de seleção ou checkBox
	aadd(aHeader,{''		  ,'CHECKBOL'     ,'@BMP', 2,0,,	             ,"C",     ,"V",,,'seleciona','V','S'})
	aadd(aHeader,{"Filial"    ,"TV1_FILIAL"   ,"@!"  , 04,0,,"€€€€€€€€€€€€€€ ","C","TV1","R"})
	aadd(aHeader,{"Bien"    ,"TV1_CODBEM"   ,"@!"  , 16,0,,"€€€€€€€€€€€€€€ ","C","TV1","R"})
	aadd(aHeader,{"Fecha" ,"TV1_DTSERV"      ,"@!"  ,6,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"}) // EDSON 17.07.2019
	aadd(aHeader,{"Contador Ini"    ,"TV1_CONINI"      ,"@!",10,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Contador Final"    ,"TV1_CONFIM"      ,"@!",18,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Nombre Operad."    ,"TV1_NOMEOP"     ,"@!"  , 30,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})

    // Local cFilTV1 := PARAMIXB[2] // M->TV1_FILIAL
    // Local cEmpTv1 := PARAMIXB[3] // M->TV1_EMPRES
    // Local cBemTv1 := PARAMIXB[4] // M->TV1_CODBEM
    // Local dDtTv1  := PARAMIXB[5] // M->TV1_DTSERV

	// aadd(aHeader,{"Anticipo"    ,"numeroRa"      ,"@!",8,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	// aadd(aHeader,{"Serie Ant."    ,"E1_SERREC"      ,"@!",3,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	// aadd(aHeader,{"Saldo Anticipo."    ,"SaldoRA"      ,"@E 999,999,999.99"  , 13,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})
	// aadd(aHeader,{"PrefixoFac"    ,"PREFIXO"      ,"@!",3,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	// aadd(aHeader,{"Cuota Ra"    ,"CUOTARA"      ,"@!",2,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	// aadd(aHeader,{"Tienda Cliente"    ,"PREFIXO"      ,"@!",2,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	buscaTV1()

	if empty(aColsCidades) // caso no existan pedidos es retornado
		return .F.
	endif

	//Nosso programa irá listar todos os municípios e fazer filtros por Estado
	@003,003 to 530,1150 dialog oDlgTela title "Generación masiva Parte diario "

	//Aqui onde o usuário informará o estado que buscará as cidades pertencentes
	//		@011,006 say "Nombre: " pixel of oDlgTela
	//este elemento get é a caixa de testo que possui a consulta padrão (opção F3).
	//esta consulta SC5EST foi configurada no Configurador somente para este uso
	//		@011,030 get cEstado Picture "99/99/99"  size 80,11

	//botão pesquisar que, quando acionado, efetua a busca dos municípios de acordo com o Estado inserido pelo usuário
	//a variável cEstado armazena o conteúdo existente no elemento "get" acima
	//		@012,145 button "&Buscar" size 40,11 pixel of oDlgTela action filtNombre(cEstado)

	//o objeto oGetDados (MsNewGetDados) com os atributos configurados
	oGetDados := MsNewGetDados():New(025,006,230,570, GD_UPDATE, , , , {'CHECKBOL'}, 1, 99, , , , oDlgTela, aHeader, aColsCidades,,)
	//quando clicado duas vezes sobre o aCols[oGetDados:nAt,1], ou seja, onde ficará a coluna com o checkbox, ele irá alternar de LBOK para LBNO e vice versa
	oGetDados:oBrowse:bLDblClick := {|| oGetDados:EditCell(), oGetDados:aCols[oGetDados:nAt,1] := iif(oGetDados:aCols[oGetDados:nAt,1] == 'LBOK','LBNO','LBOK')}

	//objeto oChk de checkbox e variável lChkSel. Quando clicado, executa o método "seleciona" e possibilita
	//que o usuário selecione todas as cidades ao mesmo tempo. Facilita também no momento da escolha em casos de listas extensas
	@240,006 checkbox oChk var lChkSel PROMPT "Selecionar todos" size 60,07 on CLICK seleciona(lChkSel , oSay)

	//botao confirmar comum, ainda daremos utilidade à ele :)
	@240,125 button "&Confirmar" size 40,11 pixel of oDlgTela action Llamacompensa()
	//botão padrão de Cancelar
	@240,190 button "&Cancelar"  size 40,11 pixel of oDlgTela action close(oDlgTela)

	//Titulo de la sumato del monto
	//	@240,400 SAY titulo Prompt "Monto total:" SIZE 55,07 OF oDlgTela PIXEL
	//	Va mostrando la sumatoria de la funccion "sumarMonto"
	//	@240,450 SAY oSay Prompt "0.0" SIZE 55,07 OF oDlgTela PIXEL

	//antes de ativar a tela (oDlgTela) e centralizá-la para o usuário,
	//o método "buscaTV1" pesquisa todas as cidades e estados para pré carregar o oGetDados
	refresh(aColsCidades,oSay)

	//ativa o oDlgTela
	activate dialog oDlgTela center

	For nX := 1 to Len(oGetDados:aCols)
		if(oGetDados:aCols[nX,1] == 'LBOK')
			aadd(aPVSelec,oGetDados:aCols[nX,2])
			//			alert(oGetDados:aCols[nX,2])
		endif
	Next nX

return

static function Llamacompensa()

	MsgRun ("Generando Apuntes en ATF y Costos", "Por favor espere", {|| compensa() } )
	close(oDlgTela)

return

static function compensa()
	// las compensaciones son todas al contado
	Local nX
    Local cMesage := ''
	// cNumRA := "000000" // NRO RA
	// nMonComp :=  0 //
	// nMenorValor := 0

	cCompensaciones := ""
	For nX := 1 to Len(oGetDados:aCols)

		if(oGetDados:aCols[nX,1] == 'LBOK') // realiza una compensación

			// if cNumRA == oGetDados:aCols[nX,8] // si el RA está pagando varias Facturas
			// 	// el monto de RA debería disminuir al monto anterior
			// 	//				oGetDados:aCols[nX,10] := oGetDados:aCols[nX,10] - nMenorValor // Nahim 06/09/2019 toma en cuenta más de 3 pedidos de una
			// 	oGetDados:aCols[nX,10] := oGetDados:aCols[nX-1,10] - nMenorValor
			// endif
			// escogiendo el menor
			//						factura 				Anticipo
		// TV2_FILIAL+TV2_EMPRES+TV2_CODBEM+DTOS(TV2_DTSERV)+TV2_TURNO+TV2_PDIHRI+TV2_PDIHRF+TV2_HRINI+TV2_CODATI
        cKey    := oGetDados:aCols[nX,2] + "01" + PADR(oGetDados:aCols[nX,3],TamSX3("TV2_CODBEM")[1]) + DTOS(CTOD(oGetDados:aCols[nX,4]))
		cBemTv1 := PADR(oGetDados:aCols[nX,3],TamSX3("TV2_CODBEM")[1])
	    dDtTv1  := CTOD(oGetDados:aCols[nX,4]) // PARAMIXB[5] // M->TV1_DTSERV
		// xValor := PADR(xValor,TamSX3(SX3->X3_CAMPO)[1])
        dbSelectArea('TV2')
        dbSetOrder(1)
            If dbSeek( cKey )
            aArrayPTd :={}
                While TV2->( !Eof() ) .And. cKey == TV2->TV2_FILIAL + TV2->TV2_EMPRES + TV2->TV2_CODBEM + DToS( TV2->TV2_DTSERV )
                    //Nahim posicione en la TV0 para veriificar si corresponde el apunte
                    // TV0_FILIAL+TV0_CODATI
					cMesage := ''
                    dbSelectArea('TV0')
                    TV0->(dbSetOrder(1))
                    TV0->(dbSeek(xFilial("TV0") + TV2->TV2_CODATI)) // posicionandomé en la actividad
                    
                    if TV0->TV0_TIPHOR $ '1|4' // Tipo de hora trabajada y planificación deberían apuntarse 29/12/2020
                    // if alltrim(TV2->TV2_CODATI) == "1"
                        // Nahim Adicionando array para enviar apuntes de costos SD3
                                        // Nahim probando muestra hora inicial 30/06/2020
                        // Posicione BIEN DE MANTENIMIENTO (ST9)
                        dbSelectArea("ST9")
                        dbSetOrder(1)
                        // T9_FILIAL+T9_CODBEM
                        IF dbSeek(xFilial("ST9")+cBemTv1)
                            dbSelectArea("SN3") //Posicione SN3
                            dbSetOrder(1)
                            // N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ
                            IF dbSeek(xFilial("SN3")+ST9->T9_CODIMOB) // Encuentra SN3
                                if !empty(SN3->N3_CLVLCON)  // no tiene que estár vacio
                            		cProducto := U_getProByCl(SN3->N3_CLVLCON)// obtengo el código del producto
                                    if !empty(cProducto) // obtengo el producto de costo de mano de obra
										// u_cosParDi(_cDoc,cCodigo,nQUant,dEmissao,cCusto,cTM,cAccount) // Ejecuta movimiento SD3 que genera costo
										cMax := U_isInSD3(cBemTv1,TV2->TV2_DTSERV,TV2->TV2_SEQREL)
										IF TV2->TV2_XTOTCO <> 0 .AND. cMax <> "XX"// Nahim 22/06/2021
											cItemCont := U_getItemContable(TV2->TV2_CODBEM,TV2->TV2_DTSERV) // Busca código del item cuenta NT 20/07/2020
											if !empty(cItemCont) // tiene que estar relacionado con el item contable. Nahim 12/07/2021
												aRegTv2 := {}
												AADD( aRegTv2,cProducto)      // 1
												// AADD( aRegTv2,TV2->TV2_UTOTHD)  // 2
												// AADD( aRegTv2,Val(SubStr(TV2->TV2_TOTHOR,1,2))+Val(SubStr(TV2->TV2_TOTHOR,4,2))/60 )  // 2
												AADD( aRegTv2,TV2->TV2_XTOTCO)  // 2
												AADD( aRegTv2,TV2->TV2_DTSERV)  // 3
												AADD( aRegTv2,TV2->TV2_CODFRE)  // 4
												AADD( aRegTv2,SN3->N3_CLVLCON)  // 5
												AADD( aRegTv2,SN3->N3_FILIAL)  // 6
												AADD( aRegTv2,cItemCont)  // 7 item cuenta
												AADD( aRegTv2,TV2->TV2_SEQREL)  //8 secuencia
												AADD( aRegTv2,VAL(cMax)+1)  //9 secuencia
												AADD( aArrayPTd,aRegTv2)
											endif
										ENDIF
										// u_cosParDi("NTP-00001",SB1->B1_COD,TV2_UTOTHD,TV2->TV2_DTSERV,TV2->TV2_CODFRE,"512",SB1->B1_UCTAPRO) // Ejecuta movimiento SD3 que genera costo 19/06/2020
                                    else
                                        alert("No encontró Producto de mano de Obra, Clase Valor: " + SN3->N3_CLVLCON)
                                    endif
                                else
                                    alert("campo N3_CLVLCON vacio en el bien: "  + SN3->N3_CBASE)
                                endif
                            else
                                alert("NO RELACION EN LA SN3 (ACTIVOS) :" +ST9->T9_CODIMOB)
                            ENDIF
                        else
                            alert("NO RELACION EN LA ST9 (Bienes) - Mant. " +cBemTv1)
                        endif
                    endif

                cMesage += 'Bien ' +  cBemTv1 + ' - Actividad: ' + TV2->TV2_CODATI + ' / ' + TV2->TV2_HRINI + ' - ' + TV2->TV2_HRFIM + CRLF

                TV2->( dbSkip() )
                End
            // Nahim Terrazas 07/03/2020
            // Verificando si debería hacer el apunte de parte diario
                if !empty(aArrayPTd)
//                cDoc := "PT" + Alltrim(cBemTv1) + DTOC(dDtTv1) // Nro de docuemtno
				cDoc := ALLTRIM(cBemTv1) +  RIGHT(cValToChar(year(dDtTv1)),2) + cValToChar(MONTH(dDtTv1)) +cValToChar(day(dDtTv1)) + "0" + cvaltochar(aArrayPTd[1][9])
				// TERC00000721040901

                // Realiza el costo de mano de obra SD3
                u_cosParDi(ALLTRIM(cBemTv1),SUPERGETMV("MV_XTMMANOB", .T., "513"),aArrayPTd)
				nHorasApunt := 0 // controla la cantidad porque sólo debe realizarse un sólo apunte. Nahim 24/06/2021
				// 17/07/2021
				// Comentado dado que se separo la rutina de parte diario en apunte unitario de la FNA y apunte de la SD3
                    // For nI := 1 To Len(aArrayPTd) 
                    // U_getATF(aArrayPTd[nI][5],aArrayPTd[nI][6])
					// 	nHorasApunt+= aArrayPTd[nI][2]
                    //     if ! VW_CPX->(EoF())
					// 		if nI == Len(aArrayPTd) // si el último registro.
					// 			ArrTeste := {}
					// 			AADD(Arrteste, GetSXENum("FNA", "FNA_IDMOV")) //IDMOV
					// 			// AADD(Arrteste, '001') //ITMOV NAHIM LA SECUENCIA
					// 			AADD(Arrteste,aArrayPTd[nI][8] ) //ITMOV
					// 			//AADD(Arrteste, ctod('20191113'))//DATA   dEmissa
					// 			AADD(Arrteste, aArrayPTd[nI][3])
					// 			AADD(Arrteste, 'P2') ///TIPO APUNTE
					// 			AADD(Arrteste,  aArrayPTd[nI][3]) //PERIODO INICIAL
					// 			AADD(Arrteste,  aArrayPTd[nI][3]) //PERIODO FINAL
					// 			AADD(Arrteste, nHorasApunt) // cantidad de horas D1_UHORAEQ 01/07/2020
					// 			AADD(Arrteste, VW_CPX->N3_CBASE)// N3_CBASE
					// 			AADD(Arrteste, VW_CPX->N3_ITEM)// N3_ITEM
					// 			AADD(Arrteste, VW_CPX->N3_TIPO)// N3_TIPO
					// 			AADD(Arrteste, VW_CPX->N3_SEQ) 
					// 			U_AF110EXC(Arrteste)
					// 			ConfirmSx8()
					// 		endif
                    //     VW_CPX->(DbCloseArea())
                    //    ENDIF
                    // next nI
					cCompensaciones +=  cMesage + Chr(13) + Chr(10)
                endif

            EndIf

            // If nOperat == 4

            //     For nIndex := 1 to Len( aCols )

            //         If GDDeleted( nIndex, aHeader, aCols ) .And.;
            //             nCodati > 0 .And. !Empty( aCols[nIndex, nCodati ] ) .And.;
            //             nHrini > 0 .And. !Empty( aCols[nIndex, nHrini ] ) .And.;
            //             nHrFim > 0 .And. !Empty( aCols[nIndex, nHrFim ] )

            //         cMesage += 'Item excluído: Atividade ' + aCols[nIndex, nCodati ] + ' - '
            //         cMesage += aCols[nIndex, nHrini ] + '/' + aCols[nIndex, nHrFim ] + CRLF

            //             EndIf

            //     Next

            // EndIf
        // MsgInfo( cMesage, 'Parte diária')
        EndIf
	Next nX
	aviso("Se registraron los siguientes partes diarios en ATF y Costos. ",cCompensaciones,{'ok'},,,,,.t.)
	//	ALERT(cPrimComp)
	//	ALERT(cUltimaCom)
	//	alert("compensando..")
return

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ buscaTV1   ¦ Autor ¦ Renan R. Ramos      ¦ Data ¦ 11.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Pesquisa as cidades de acordo com o estado escolhido. Caso ¦¦¦
¦¦¦          ¦ cEstado esteja vazio, serão apresentadas todas as cidades e¦¦¦
¦¦           ¦ estados presentes na tabela.                               ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function buscaTV1()

	//	private aColsCidades := {}
	//atualiza/recarrega o oGetDados e o oDlgTela antes de receber novos dados
	//	refresh(aColsCidades)
	// cbusqueda := "PT"+ alltrim(cCodBem) + SUBSTR(CVALTOCHAR(YEAR(cfechaServ)),3,2) + StrZero(MONTH(cfechaServ),2) + StrZero(day(cfechaServ),2) +"-"+ cSecuen

        // SELECT * FROM TV1010 WHERE
        // TV1010.R_E_C_N_O_ NOT IN (
        // SELECT TV1.R_E_C_N_O_ FROM TV1010 TV1 JOIN SD3010 SD3 ON TRIM(D3_DOC) = 'PT'+ TRIM(TV1_CODBEM) + substring(TV1_DTSERV,7,2) +'/' + substring(TV1_DTSERV,5,2) +'/'+ substring(TV1_DTSERV,1,4)
		// AND TV1.D_E_L_E_T_ LIKE '' AND SD3.D_E_L_E_T_ LIKE '' and SD3.D3_ESTORNO <> 'S'
        // ) and TV1_DTSERV BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
        // and TV1_INDERR = 2
		// AND TV1_CODBEM BETWEEN  %exp:MV_PAR03% AND %exp:MV_PAR04%
		// and D_E_L_E_T_ = ''

	cTemp:= getNextAlias()
	BeginSql alias cTemp

        SELECT * FROM TV1010 WHERE
        TV1_DTSERV BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
        and TV1_INDERR = 2
		AND TV1_CODBEM BETWEEN  %exp:MV_PAR03% AND %exp:MV_PAR04%
		and D_E_L_E_T_ = ''

	EndSql
	dbSelectArea( cTemp )
	(cTemp)->(dbGotop())

	While !(cTemp)->(eof())

		/*
            aadd(aHeader,{''		  ,'CHECKBOL'     ,'@BMP', 2,0,,	             ,"C",     ,"V",,,'seleciona','V','S'})
            aadd(aHeader,{"Bien"    ,"TV1_CODBEM"   ,"@!"  , 16,0,,"€€€€€€€€€€€€€€ ","C","TV1","R"})
            aadd(aHeader,{"Fecha" ,"TV1_DTSERV"      ,"@!"  ,6,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"}) // EDSON 17.07.2019
            aadd(aHeader,{"Contador Ini"    ,"TV1_CONINI"      ,"@!",10,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
            aadd(aHeader,{"Contador Final"    ,"TV1_CONFIM"      ,"@!",18,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
            aadd(aHeader,{"Nombre Operad."    ,"TV1_NOMEOP"     ,"@!"  , 30,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})
		*/

		aadd(aColsCidades,{'LBNO',allTrim((cTemp)->TV1_FILIAL), allTrim((cTemp)->TV1_CODBEM),;
        allTrim(DTOC(STOD((cTemp)->TV1_DTSERV))), (cTemp)->TV1_CONINI,;
		(cTemp)->TV1_CONFIM,(cTemp)->TV1_NOMEOP, .F.})

		(cTemp)->(dbskip())

	EndDo

	(cTemp)->(dbCloseArea())

	//atualiza o oGetDados com o novo array

return

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ REFRESH  ¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 13.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Realiza limpeza dos dados na MsGetDados e inclui novo array¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function refresh(aDados,oSay)

	oGetDados:oBrowse:Refresh()
	oDlgTela:Refresh()

	oGetDados := MsNewGetDados():New(025,006,230,570, GD_UPDATE, , , , {'CHECKBOL'}, 1, 99, , , , oDlgTela, aHeader, aColsCidades,,)
	oGetDados:oBrowse:bLDblClick := {|| oGetDados:EditCell(), oGetDados:aCols[oGetDados:nAt,1] := iif(oGetDados:aCols[oGetDados:nAt,1] == 'LBOK','LBNO','LBOK'), sumarMonto( oSay ,oGetDados:aCols[oGetDados:nAt,1],oGetDados:aCols[oGetDados:nAt,6]) }

return
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ seleciona¦ Autor ¦ edson                 ¦ Data ¦ 22.05.19 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Suma el monto de la celdas selecionada y lo muestra en un say¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function sumarMonto(oSay, isCheck , valor)
	//	private aux := 0.0
	if isCheck == 'LBOK'
		//		aux := valor
		//		ValTotal += aux
		//		oSay:SetText(FmtoValor(ValTotal,13,2))
	else
		//		aux := valor
		//		ValTotal -= aux
		//		oSay:SetText(FmtoValor(ValTotal,13,2))
	end if

	oGetDados:oBrowse:Refresh()
	oDlgTela:Refresh()
return
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ seleciona¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 08.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Seleciona todas as cidades apresentadas no aCols.          ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function seleciona(lChkSel ,oSay)
	//percorre todas as linhas do oGetDados
	local i 
	ValTotal  := 0
	for i := 1 to len(oGetDados:aCols)
		//verifica o valor da variável lChkSel
		//se verdadeiro, define a primeira coluna do aCols como LBOK ou marcado (checked)
		//		private aux := 0.0
		if lChkSel
			oGetDados:aCOLS[i,1] := 'LBOK'
			//			aux := oGetDados:aCOLS[i,6]
			//			ValTotal += 1
			//			oSay:SetText()
			//			oDlgTela:CommitControls()
			//se falso, marca como LBNO ou desmarcado (unchecked)
		else
			oGetDados:aCOLS[i,1] := 'LBNO'
			//			ValTotal -= 1
			//			oSay:SetText(ValTotal)
		endif
	next
	//executa refresh no getDados e na tela
	//esses métodos Refresh() são próprio da classe MsNewGetDados e do dialog
	//totalmente diferentes do método estático definido no corpo deste fonte
	oGetDados:oBrowse:Refresh()
	oDlgTela:Refresh()
return
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ selFiltro¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 03.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Executa o filtro de cidades selecionadas.                  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function selFiltro(lChkFiltro)

	buscaTV1()//atualiza o grid de dados

	oGetDados:oBrowse:Refresh()
	oDlgTela:Refresh()

return
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ VERIFLIN ¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 09.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Verifica se existem cidades selecionadas.                  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function verifLin()

	local lRet := .F.

	for i := 1 to len(oGetDados:aCols)
		if oGetDados:aCols[i,1] == 'LBOK'
			aadd(aCidades,{oGetDados:aCols[i,2],oGetDados:aCOLS[i,3],oGetDados:aCOLS[i,5]})
			lRet := .T.
		endIf
	next

return lRet

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  ¦ Autor ¦ edson                         ¦ Data ¦ 22.05.19 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ convierte el monto a dos decimales                         ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Static Function FmtoValor(cVal,nLen,nDec)
	Local cNewVal := ""
	If nDec == 2
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 9,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal



Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSx1(cPerg,"01","De fecha ?","De fecha ?","De fecha ?",         "mv_ch1","D",10,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A fecha ?","A fecha ?","A fecha ?",         "mv_ch2","D",10,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"03","¿De Bien?" , "¿De Bien?"	,"¿De Bien?"	,"MV_CH3","C",16,0,0,"G","","ST9","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Bien?" 	, "¿A Bien?"	,"¿A Bien?"	,"MV_CH4","C",16,0,0,"G","NaoVazio()","ST9","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	// xPutSx1(cPerg,"03","Moneda","Moneda","Moneda",         "mv_ch3","N",02,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")

return


Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return



static function getProByCl(cCod)
    Local aArea 	 := GetArea()
    OrdenConsul	:= GetNextAlias()
    // consulta a la base de datos
    BeginSql Alias OrdenConsul
	
		SELECT B1_COD
		FROM  %Table:SB1% SB1 
		WHERE B1_CLVL = %exp:cCod%
        AND B1_TIPO = 'MO'
		AND SB1.%notdel%

    EndSql

    DbSelectArea(OrdenConsul)
    cNum:= ''
    If (OrdenConsul)->(!Eof()) // Encuentro
        cNum:= (OrdenConsul)->B1_COD
    endif
	DBCLOSEAREA(OrdenConsul)
    restarea(aArea)
return cNum
