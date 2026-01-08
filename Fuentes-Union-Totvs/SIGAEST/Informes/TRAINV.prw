#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  TRAINV  ºAutor  ³Jorge Saavedra      Fecha 28/05/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ Nota de ingreso a inventario                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TRAINV()

	Local oReport
	Local nOrdem  := 0
	Local wnrel   := "TRAINV" // Nome default do relatório em disco
	//Local tamanho := "M"
	//Local titulo  := OemToAnsi("ORDEN DE NACIONALIZACION Rev.1") //"Pick-List  (Expedicao)"
	Local cDesc1  := OemToAnsi("REVALORIZACION DE INVENTARIO") //"Emiss„o de produtos a serem separados pela expedicao, para"
	Local cDesc2  := OemToAnsi("") //"determinada faixa de pedidos."
	Local cDesc3  := ""
	Local cString := "SF1" // Alias do arquivo principal do relatório para o uso de filtro

	PRIVATE cPerg    := "TRINV" // Nome da pergunte a ser exibida para o usuário Nota de ingreso a inventario.
	Private _cAlm	  := ""
	PRIVATE aReturn  := {"Zebrado", 1,"Administracion", 2, 2, 1, "",1} //"Zebrado"###"Administracao" // Array com as informações para a tela de configuração da impressão
	PRIVATE nomeprog := "TRAINV" //Nome do programa do relatório
	PRIVATE nLastKey := 0 //Utilizado para controlar o cancelamento da impressão do relatório.
	PRIVATE nBegin   := 0
	PRIVATE aLinha   := {} //Array que contem informações para a impressão de relatórios cadastrais
	PRIVATE li       := 15 //Controle das linhas de impressão. Seu valor inicial é a quantidade máxima de linhas por página utilizada no relatório.
	PRIVATE limite   := 132 //Quantidade de colunas no relatório (80, 132, 220).
	PRIVATE lRodape  := .F.
	PRIVATE m_pag    := 1    //Controle do número de páginas do relatório.
	PRIVATE titulo   := "TRANSFERENCIA DE STOCK"
	PRIVATE cabec1   := ""
	PRIVATE cabec2   := ""
	PRIVATE tamanho  := "M"
	PRIVATE _cTipoOp
	PRIVATE cObs

	aOrd :={}
	cTipodoc	:= IIf(aCfgNf[1]==64,'E','S')
	//Pergunte('REMT10',.F.)
	//_cTipoOp:=If(mv_par01==1,'E','S')  //Indica se é transferencia de Entrada ou Saída

	If !Empty(cTipodoc)
		_cTipoOp :=	cTipodoc        //E: Entrada; S: Salida; P: Pantalla
	Else
		_cTipoOp := 'P'
	Endif
	If cTipodoc $ 'E'
		titulo += " (ENTRADA)"
	else
		titulo += " (SALIDA)"
	end
	//--------------------------------------------------------------------
	ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO
	GraContPert()

	If AllTrim(Funname()) == 'MATA462TN'
		Pergunte(cPerg,.F.)
	Else
		Pergunte(cPerg,.T.)
	Endif

	wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)

	If nLastKey == 27
		dbClearFilter()
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		dbClearFilter()
		Return
	Endif

	RptStatus({|lEnd| OCDAT1(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)

Return

//------------------------------------------------------
Static  Function OCDAT1(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)

	fImpInforme()

	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
	MS_FLUSH()

Return NIL

Static Function fImpInforme()

	Local nTotalcant    := 00.0
	Local nTotalval    := 00.0

	nOrdem:=aReturn[8]

	If _cTipoOp=='E'
		cQuery := "select F1_DOC,D1_NUMSEQ,F1_EMISSAO,F1_FILORIG,D1_LOJA,B1_UFABRIC,D1_SERIE,D1_FORNECE,F1_FILIAL,B1_DESC,D1_LOTECTL,D1_CUSTO,D1_DTVALID, "
		cQuery += " D1_ITEM,D1_LOTECTL,D1_COD,D1_QUANT,D1_NUMLOTE,D1_LOCALIZ,D1_VUNIT,D1_TOTAL,D1_UM,D1_PEDIDO,D1_ITEMORI,D1_NFORI ,F1_MOEDA,NNR.NNR_DESCRI as almdes,D1_VUNIT,D1_TOTAL,F1_SERIE,D1_LOCAL,D1_LOTECTL,D1_LOCALIZ,D1_NUMSERI,D1_NFORI,D1_SERIORI,F1_USRREG,F1_UCOBS  "//B2_QATU,B2_CM1  "
		cQuery += " from " + RetSqlName("SF1") + " SF1 "
		cQuery += " inner Join " + RetSqlName("SD1") + " SD1 on F1_DOC=D1_DOC and F1_FILIAL=D1_FILIAL and F1_SERIE=D1_SERIE and D1_TIPODOC='64' AND D1_FORNECE=F1_FORNECE AND SD1.D_E_L_E_T_!='*'"
		cQuery += " inner Join " + RetSqlName("SB1") + " SB1 on B1_COD=D1_COD AND SB1.D_E_L_E_T_!='*' "
		cQuery += " LEFT Join " + RetSqlName("NNR") + " NNR on NNR.NNR_CODIGO=D1_LOCAL and F1_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' "
		cQuery += " WHERE "
		cQuery += " F1_FILORIG = '"+trim(mv_par01)+"' AND F1_FILIAL = '"+trim(mv_par02)+"'"
		cQuery += " and F1_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
		cQuery += " and F1_DOC Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
		cQuery += " and F1_SERIE Between '"+trim(mv_par07)+"' and '"+trim(mv_par08)+"'"
		cQuery += " AND SF1.D_E_L_E_T_!='*'"
		cQuery += " order by D1_ITEM "
	Else
		cQuery := "select F2_FILIAL,F2_DOC,F2_EMISSAO,F2_FILDEST,B1_DESC,D2_LOTECTL,D2_CUSTO1,D2_UM,(D2_QUANT*D2_CUSTO1) as total,A1_NOME, max(A1_NOME) as cli1,min(A1_NOME) as cli2, "//c6_num,
		cQuery += "D2_ITEM,D2_COD,D2_QUANT,D2_PRCVEN,D2_LOTECTL,D2_NUMLOTE,D2_DTVALID,D2_LOCALIZ,D2_TOTAL,D2_UFABRIC,D2_PEDIDO,D2_ITEMORI,D2_NFORI ,F2_MOEDA,NNR.NNR_DESCRI as almdes,D2_LOCDEST,F2_SERIE,D2_LOCAL,D2_LOTECTL,D2_LOCALIZ,D2_NUMSERI,F2_USRREG,F2_UCOBS "//B2_QATU,B2_CM1  "
		cQuery += "from " + RetSqlName("SF2") + " SF2 "
		cQuery += "inner Join " + RetSqlName("SD2") + " SD2 on F2_DOC=D2_DOC and F2_FILIAL=D2_FILIAL and F2_SERIE=D2_SERIE and D2_TIPODOC='54' and SD2.D_E_L_E_T_=' ' "
		cQuery += "inner Join " + RetSqlName("SB1") + " SB1 on B1_COD=D2_COD and SB1.D_E_L_E_T_=' ' "
		cQuery += "left Join " + RetSqlName("NNR") + " NNR on NNR.NNR_CODIGO=D2_LOCAL and F2_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' "
		cQuery += "left outer Join " + RetSqlName("SA1") + " SA1 on A1_COD=F2_CLIENTE and F2_FILIAL = A1_FILIAL and F2_LOJA=A1_LOJA and SA1.D_E_L_E_T_=' ' "
		cQuery += " WHERE SF2.D_E_L_E_T_=' '   "//and sb1.d_e_l_e_t_=' ' "
		cQuery += " and F2_FILDEST = '"+trim(mv_par01)+"' AND F2_FILIAL = '"+trim(mv_par02)+"'"
		cQuery += " and F2_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
		cQuery += " and F2_DOC Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
		cQuery += " and F2_SERIE Between '"+trim(mv_par07)+"' and '"+trim(mv_par08)+"'"
		cQuery += " group by F2_FILIAL,F2_DOC,F2_EMISSAO,F2_FILDEST,B1_DESC,D2_CUSTO1,D2_UM,D2_ITEM,D2_COD,D2_QUANT,D2_LOTECTL,D2_NUMLOTE,D2_PRCVEN,D2_LOCALIZ,D2_UFABRIC,D2_TOTAL,D2_PEDIDO,D2_ITEMORI,D2_NFORI,F2_MOEDA,NNR.NNR_DESCRI,D2_PRCVEN,D2_TOTAL,A1_NOME,D2_LOCDEST,F2_SERIE,D2_LOCAL,D2_LOTECTL,D2_NUMSERI,F2_USRREG,D2_DTVALID,F2_UCOBS "//,c6_num,
		cQuery += " order by D2_ITEM "
	Endif

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MemoWrite("\TRAINV.sql",cQuery)
	TCQUERY cQuery NEW ALIAS "OrdenesCom"
	
	if _cTipoOp == 'E'
		cObs := OrdenesCom->F1_UCOBS
	else
		cObs := OrdenesCom->F2_UCOBS
	endif	
	
	moneda:=""

	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15,,.F.)
	fImpCab() // IMPRIME LA CABECERA

	li := 14
	j	:= 1
	sw	:= 1

	While OrdenesCom->(!EOF())
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15,,.F.)
		Endif
		If _cTipoOp=='E'

			@ li,01 PSAY OrdenesCom->D1_COD
			@ li,21 PSAY SUBSTR(OrdenesCom->B1_DESC,1,40)
			If Len(alltrim(OrdenesCom->B1_DESC))>45
				li++
				@ li,38 PSay alltrim(SubStr(OrdenesCom->B1_DESC,46,80))
			EndIf

			If (sw==1)
				_cAlm := Posicione("SD2",1,OrdenesCom->F1_FILORIG+OrdenesCom->D1_COD,"D2_LOCAL")
				sw:=2
			EndIf

			@ li,53 PSay OrdenesCom->B1_UFABRIC			
			@ li,61 PSay OrdenesCom->D1_UM			
			@ li,59 PSay OrdenesCom->D1_QUANT Picture "@E 999,999,999" 			
			@ li,75 PSay OrdenesCom->D1_LOTECTL
			@ li,85 PSay OrdenesCom->D1_NUMLOTE
			@ li,97 PSay POSICIONE("SDB",1,OrdenesCom->F1_FILIAL+OrdenesCom->D1_COD+OrdenesCom->D1_LOCAL+OrdenesCom->D1_NUMSEQ+OrdenesCom->F1_DOC,"DB_LOCALIZ")
			@ li,111 PSay DTOC(STOD(OrdenesCom->D1_DTVALID))
			

			nTotalval:=nTotalval+ OrdenesCom->D1_TOTAL
			nTotalcant:=nTotalcant+ OrdenesCom->D1_QUANT
			moneda :=OrdenesCom->F1_MOEDA
		Else

			@ li,01 PSay OrdenesCom->D2_COD
			@ li,21 PSay AllTrim(SubStr(OrdenesCom->B1_DESC,1,30))

			If Len(alltrim(OrdenesCom->B1_DESC)) > 45
				li++
				@ li,38 PSay AllTrim(SubStr(OrdenesCom->B1_DESC,46,80))
			EndIf

			@ li,53 PSay OrdenesCom->D2_UFABRIC
			@ li,61 PSay OrdenesCom->D2_UM
			@ li,59 PSay OrdenesCom->D2_QUANT Picture "@E 999,999,999"
			@ li,75 PSay OrdenesCom->D2_LOTECTL
			@ li,85 PSay OrdenesCom->D2_NUMLOTE
			@ li,97 PSay OrdenesCom->D2_LOCALIZ
			@ li,111 PSay DTOC(STOD(OrdenesCom->D2_DTVALID))

			nTotalval:=nTotalval+OrdenesCom->D2_TOTAL
			nTotalcant:=nTotalcant+ OrdenesCom->D2_QUANT
			moneda :=OrdenesCom->f2_moeda
		End

		li++
		j++
		OrdenesCom->(dbSkip())
	End
	@ li,02 PSAY REPLICATE('_',130)
	total( nTotalval,moneda,MV_PAR07,li,nTotalcant )
	OrdenesCom->(DbCloseArea())
Return

Static Function fImpCab()
	Local _aAreaSM0 := {}
	dbSelectArea("SM0")
	_aAreaSM0 := SM0->(GetArea())
	nomusuario:=Subs(cUsuario,7,15)

	@ 006,02 PSAY "Documento: " + If( _cTipoOp=='E' ,OrdenesCom->F1_SERIE+" - "+OrdenesCom->F1_DOC,OrdenesCom->F2_SERIE+" - "+OrdenesCom->F2_DOC)
	@ 006,90 PSAY "Fecha: " + ffechalatin(If(_cTipoOp=='E',OrdenesCom->f1_EMISSAO,OrdenesCom->f2_EMISSAO))
	@ 007,90 PSAY "T.C. : " + TRANSFORM(POSICIONE("SM2",1,If(_cTipoOp=='E',OrdenesCom->F1_EMISSAO,OrdenesCom->f2_EMISSAO),"M2_MOEDA2"),"@E 99.99")

	iF _cTipoOp=='S'
		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+OrdenesCom->F2_FILIAL,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		SM0->(DBCloseArea())
		@ 007,02 PSAY " SUCURSAL ORIGEN:  " + OrdenesCom->F2_FILIAL  + " " + alltrim(cNomeSuc) + "     DEPOSITO ORIGEN:  " + alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ OrdenesCom->D2_LOCAL,'NNR_DESCRI')) + " - " + alltrim(OrdenesCom->D2_LOCAL)
		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+OrdenesCom->F2_FILDEST,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		SM0->(DBCloseArea())
		@ 008,02 psay "SUCURSAL DESTINO: " + OrdenesCom->F2_FILDEST + " " + alltrim(cNomeSuc) + "     DEPOSITO DESTINO: " + alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ OrdenesCom->D2_LOCDEST,'NNR_DESCRI')) + " - " + alltrim(OrdenesCom->D2_LOCDEST)
	ELSe
		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+OrdenesCom->F1_FILORIG,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		SM0->(DBCloseArea())
		@ 007,02 PSAY " SUCURSAL ORIGEN:  " + OrdenesCom->F1_FILORIG + " " + alltrim(cNomeSuc) + "     DEPOSITO ORIGEN:  " + alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ Posicione("SD2",3,OrdenesCom->F1_FILORIG+OrdenesCom->(D1_NFORI+D1_SERIORI),"D2_LOCAL"),'NNR_DESCRI')) + " - " + alltrim(Posicione("SD2",3,OrdenesCom->F1_FILORIG+OrdenesCom->(D1_NFORI+D1_SERIORI),"D2_LOCAL"))
		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+OrdenesCom->F1_FILIAL,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		SM0->(DBCloseArea())	
		@ 008,02 psay "SUCURSAL DESTINO: " + OrdenesCom->F1_FILIAL  + " " + alltrim(cNomeSuc) + "     DEPOSITO DESTINO: " + alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ OrdenesCom->D1_LOCAL,'NNR_DESCRI')) + " - " +alltrim(OrdenesCom->D1_LOCAL)
	ENDif

	@ 009,02 PSAY "Registrado Por: " + upper( If( _cTipoOp=='E' ,OrdenesCom->F1_USRREG ,OrdenesCom->F2_USRREG ))
	@ 009,90 PSAY "Impreso Por: " + SUBSTR(CUSERNAME,1,15)
	@ 010,02 PSAY "Observaciones:  " + cObs
	
	alorigen:=""//OrdenesCom->ALMORG

	@ 012,05 PSAY "Codigo"
	@ 012,21 PSAY "Descripción"
	@ 012,52 PSAY "Fabric"
	@ 012,60 PSAY "UM"
	@ 012,63 PSAY "Cantidad"
	@ 012,75 PSAY "Lote"
	@ 012,85 PSAY "Sublote"
	@ 012,95 PSAY "Ubicacion"
	@ 012,110 PSAY "Validez"
	@ 013,02 PSAY REPLICATE('_',130)

	OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(RestArea(_aAreaSM0))//restaura al area original
return

Static function total( _nTotalVal,moneda,cambio,li,cant,cTipoOP)
	mone:=""
	li:=li+2

	li:=li+5
	@ li, 34 PSAY "_ _ _ _ _ _ _ _ _ _ _"
	@ li, 74 PSAY "_ _ _ _ _ _ _ _ _ _ _"
	li++
	@ li, 34 PSAY "   "+Subs(cUsuario,7,15)
	@ li, 76 PSAY "Firma Autorizada"
return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ValidPerg ºAutor  ³ Walter Alvarez ³  04/11/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{"01","De Sucursal Origen      :","mv_ch1","C",4,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,"SM0",""})
	aAdd(aRegs,{"02","A Sucursal Destino      :","mv_ch2","C",4,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"SM0",""})
	aAdd(aRegs,{"03","De Fecha de Emisión     :","mv_ch3","D",08,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"04","A Fecha de Emisión      :","mv_ch4","D",08,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"05","De Nro. Documento       :","mv_ch5","C",20,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"06","A Nro. Documento        :","mv_ch6","C",20,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"07","De Serie                :","mv_ch7","C",20,0,0,"G","mv_par07",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"08","A Serie                 :","mv_ch8","C",20,0,0,"G","mv_par08",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"09","De Proveedor            :","mv_ch9","C",20,0,0,"G","mv_par09",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"10","A Proveedor             :","mv_ch10","C",20,0,0,"G","mv_par10",""       ,""            ,""        ,""     ,"",""})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		dbSeek(cPerg+aRegs[i][1])
		If !Found()
			RecLock("SX1",!Found())
			SX1->X1_GRUPO    := cPerg
			SX1->X1_ORDEM    := aRegs[i][01]
			SX1->X1_PERSPA   := aRegs[i][02]
			SX1->X1_VARIAVL  := aRegs[i][03]
			SX1->X1_TIPO     := aRegs[i][04]
			SX1->X1_TAMANHO  := aRegs[i][05]
			SX1->X1_DECIMAL  := aRegs[i][06]
			SX1->X1_PRESEL   := aRegs[i][07]
			SX1->X1_GSC      := aRegs[i][08]
			SX1->X1_VAR01    := aRegs[i][09]
			SX1->X1_DEFSPA1    := aRegs[i][10]
			SX1->X1_DEFSPA2    := aRegs[i][11]
			SX1->X1_DEFSPA3    := aRegs[i][12]
			SX1->X1_DEFSPA4    := aRegs[i][13]
			SX1->X1_F3       := aRegs[i][14]
			SX1->X1_VALID    := aRegs[i][15]
			MsUnlock()
		Endif
	Next

	Return

Return

Static Function ffechalatin(sfechacorta)
	Local ffechalatin:=""
	Local sdia:=substr(sfechacorta,7,2)
	Local smes:=substr(sfechacorta,5,2)
	Local sano:=substr(sfechacorta,3,2)
	ffechalatin := sdia + "/" + smes + "/" + sano
Return(ffechalatin)

Static Function GraContPert()
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FILORIG,SF2->F2_FILDEST)       //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FILIAL,SF2->F2_FILIAL)          //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',dtoc(SF1->F1_EMISSAO),dtoc(SF2->F2_EMISSAO))        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',dtoc(SF1->F1_EMISSAO),dtoc(SF2->F2_EMISSAO))        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_DOC,SF2->F2_DOC)      //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_DOC,SF2->F2_DOC)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"07"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_SERIE,SF2->F2_SERIE)      //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"08"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_SERIE,SF2->F2_SERIE)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"09"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FORNECE,SF2->F2_CLIENTE)      //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"10"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FORNECE,SF2->F2_CLIENTE)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End
Return

static function  ciudad(filial)

	Local aSaveArea := GetArea()
	DbSelectArea('SM0')
	SM0->(DbGoTop())
	_cNomeEmp:=""
	While SM0->(!EOF())

		If SM0->(M0_CODFIL) == filial

			_cNomeEmp:=SM0->M0_FILIAL
			RestArea(aSaveArea)
			return (_cNomeEmp)
		EndIf
		SM0->(DbSkip())
	End
	RestArea(aSaveArea)
	return (_cNomeEmp)
Return