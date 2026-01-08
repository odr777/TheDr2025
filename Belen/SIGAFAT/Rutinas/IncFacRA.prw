#include 'protheus.ch'
#include 'parmtype.ch'

user function IncFacRA(cPedido,cSerie)//inclui si es ra
	Local aArea1		:= GetArea()
	Local aCab	    	:= {}
	Local aLinha    	:= {}
	Local aItens    	:= {}
	Local lOk			:= .T.
	Private lMsErroAuto := .T.
	cNumFac := Posicione("SX5",1,xFilial("SX5")+"01"+ "A","SX5->X5_DESCRI")

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	//C5_FILIAL+C5_NUM
	SC5->(dbSeek(xfilial("SC5") + cPedido))
	//dbSeek(cSucursal + cPedido)

	If SX1->(MsSeek("MT468B    01"))
		RecLock("SX1",.F.)
		X1_CNT01 := cPedido
		MsUnlock()
	EndIf
	If SX1->(MsSeek("MT468B    02"))
		RecLock("SX1",.F.)
		X1_CNT01 := cPedido
		MsUnlock()
	EndIf
		
	//	cNumSer :=  Posicione("SX5",1,xFilial("SX5")+"01"+ "A","X5_DESCRI")  //Posicione()xFilial("SX5")+"99"
	/*dbSelectArea("SX5")
	//X5_FILIAL+X5_TABELA+X5_CHAVE
	DbSeek(xFilial("SX5") + "01" + "A")
	cNumSer := SX5->X5_DESCRI
	nNumSerie := val(cNumSer) + 1
	IF FOUND()
		RECLOCK("SX5", .F.)
		SX5->X5_DESCRI 	:= cvaltochar(nNumSerie)
		SX5->X5_DESCSPA := cvaltochar(nNumSerie)
		SX5->X5_DESCENG := cvaltochar(nNumSerie)
		MSUNLOCK()     // Destraba el registro.
	ENDIF

	conout(cNumSer)*/
	while(!EOF() .and. SC5->C5_NUM == cPedido)
		aadd(aCab,{"F2_EMISSAO"   ,DDATABASE,Nil})
		aadd(aCab,{"F2_CLIENTE"   ,SC5->C5_CLIENTE,Nil})
		aadd(aCab,{"F2_LOJA"      ,SC5->C5_LOJACLI,Nil})
		aadd(aCab,{"F2_SERIE"	  ,cSerie,Nil})
		//aadd(aCab,{"F2_SERIE"	  ,'A',Nil})
//		aadd(aCab,{"F2_DOC"       ,cPedido,Nil})
		aadd(aCab,{"F2_DOC"       ,cNumFac,Nil})
		aadd(aCab,{"F2_MOEDA"    ,SC5->C5_MOEDA,Nil})
		aadd(aCab,{"F2_HORA"    ,"17,02",Nil})
		aadd(aCab,{"F2_TXMOEDA"  ,RecMoeda(dDatabase,STR(SC5->C5_MOEDA)),Nil})
		aadd(aCab,{"F2_COND"    ,SC5->C5_CONDPAG,Nil})
		aadd(aCab,{"F2_PEDVEN"    ,SC5->C5_NUM,Nil})
		aadd(aCab,{"F2_TABELA"    ,SC5->C5_TABELA,Nil})
		aadd(aCab,{"F2_VEND1"    ,SC5->C5_VEND1,Nil})
		aadd(aCab,{"F2_TIPORET"    ," ",Nil})
		aadd(aCab,{"F2_LIQPROD"    ,"2",Nil})

		AAdd( aCab, { "F2_TIPO"   , "N"		               	, Nil } )
		AAdd( aCab, { "F2_ESPECIE", "NF   "		        , Nil } )
		AAdd( aCab, { "F2_TIPODOC", "01"		        , Nil } )
		AAdd( aCab, { "F2_FORMUL" , "S"		               	, Nil } )
		AAdd( aCab, { "F2_PREFIXO", "A  "		        , Nil } )
		AAdd( aCab, { "F2_EST"    , "SC"		        , Nil } )

		SC5->(DbSkip())
	enddo
	SC5->(dbCloseArea())
	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	SC6->(dbSeek(xfilial("SC6") + cPedido))
	//dbSeek(cSucursal + cNum)
	while(!EOF()) .and. SC6->C6_NUM == cPedido
		aLinha := {}
		aadd(aLinha,{"D2_ITEM",SC6->C6_ITEM,Nil})
		aadd(aLinha,{"D2_COD",SC6->C6_PRODUTO,Nil})
		aadd(aLinha,{"D2_QUANT",SC6->C6_QTDVEN,Nil})
		aadd(aLinha,{"D2_PRCVEN",SC6->C6_PRCVEN,Nil})
		aadd(aLinha,{"D2_TOTAL",SC6->C6_VALOR,Nil})
		aadd(aLinha,{"D2_TES",SC6->C6_TES,Nil})
		//AAdd( aLinha, { "D2_UM", SC6->C6_UM, Nil } )
		//AAdd( aLinha, { "D2_ESPECIE", "NF", Nil } )
		aadd(aLinha,{"D2_CF",SC6->C6_CF,Nil})
		aadd(aLinha,{"D2_PEDIDO",SC6->C6_NUM,Nil})
		aadd(aLinha,{"D2_ITEMPV",SC6->C6_ITEM,Nil})
		
		//alert("SC6->C6_NUM:"+SC6->C6_NUM)
		
		aadd(aItens,aLinha)
		SC6->(DbSkip())
	enddo
	SC6->(dbCloseArea())
	//MSExecAuto( { |x,y,z| Mata468n(x,y,z) }, aCab, aItens, 3 )
//	MsgRun("Exportando Produto...", "Aguarde por favor .....", ;
//	{ ||	Mata468n(aCab, aItens, 3) } )
//	alert("INCFACRA")
//	MsAguarde({|lFim| Mata468n(aCab, aItens, 3) },"Processamento","Aguarde a finalização do processamento...")
//	{ | | Mata468n(aCab, aItens, 3) }
	Mata468n(aCab, aItens, 3)
	
	If lMsErroAuto // siempre aparece como error aunque grabe correctamente
		if(!empty(MostraErro()))
			MsgStop("Erro na gravação.")
			//MsgStop(MostraErro())
			conout(MostraErro())
			MostraErro("/temp","error.log")
			lOk:= .F.
		endif
	Else
		MsgAlert('Incluido com sucesso.')
		lOk:= .T.
	EndIf
	RestArea( aArea1 )
return 