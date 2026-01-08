#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Tbiconn.ch"
#include "Topconn.ch"
#Include "FileIO.ch"

#Define ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpFacen  ºAutor  ³Erick Etcheverry	 ºFecha ³  10/03/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa Importação de Fatura de entrada         	  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// IMPFACEN
User Function impFacen
	Private oDlg
	pergunte("MTXRED",.T.)

	@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importación de Facturas de entrada")
	@ 003,003 TO 058,188
	@ 010,018 Say "Este programa tiene como objetivo importar una o mas "
	@ 018,018 Say "Facturas de entrada desde un archivo *.csv"

	@ 040,128 BMPBUTTON TYPE 01 ACTION MsAguarde({|| Importar(),"Procesando. Hora de inicio: " + Time()})
	@ 040,158 BMPBUTTON TYPE 02 ACTION oDlg:End()

	Activate Dialog oDlg Centered
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Importar  ºAutor  ³EDUAR ANDIA   		 ºFecha ³  23/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Importar
	Local cTabla		:= ""
	Local cStrCpos		:= ""
	Local nX			:= 1
	Local cTitulo1  	:= "Seleccione Archivo"
	Local cExtens   	:= "Archivo | "
	Local cFile 		:= ""
	Local aArchi		:= {}
	Local cLinea		:= ""
	Local cCampo		:= ""
	Local cNumPed		:= ""
	Local cNumAux		:= ""
	Local lFirst		:= .T.
	Local lGrabCab		:= .T.
	Local aValores		:= {}
	Local aCpos			:= {}
	Local cHoraIni		:= Time()
	Local cProxReg		:= ""
	Local cFileLog		:= ""
	Local cDirLog		:= ""
	Local cPath			:= ""
	Local lError		:= .F.
	Local nCantReg		:= 0
	Local lFin			:= .F.
	Local aArray		:= {}
	Local aTotCabs		:= {}
	Local aItArray		:= {}
	Local xValor
	Local cxDoc			:= ""
	Local aCabec		:= {}
	Local aItem			:= {}
	Local aLinha		:= {}

	Private lMSHelpAuto := .T. //.F. // Para nao mostrar os erro na tela
	Private lMSErroAuto := .F. //.F. // Inicializa como falso, se voltar verdadeiro e' que deu erro

	/***
	* _________________________________________________________
	* cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
	* ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	* <ExpC1> - Expressao de filtro
	* <ExpC2> - Titulo da janela
	* <ExpN1> - Numero de mascara default 1 para *.Exe
	* <ExpC3> - Diretório inicial se necessário
	* <ExpL1> - .F. botão salvar - .T. botão abrir
	* <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
	*/

	cExtens += "*.CSV"
	cFile := cGetFile(cExtens,cTitulo1,,,.T.)

	If File( cFile )

		AutoGrLog( "Fecha Inicio.......: " + DToC(MsDate()) )
		AutoGrLog( "Hora Inicio........: " + Time() )
		AutoGrLog( "Environment........: " + GetEnvServer() )
		AutoGrLog( "Archivo............: " + Alltrim( Lower( cFile ) ) )
		AutoGrLog( " " )

		FT_FUse(cFile)
		FT_FGotop()

		cLinea	:= FT_FREADLN()
		aCpos	:= Str2Array(cLinea,';')

		//AddCampoOblg()

		FT_FSkip()

		While (!FT_FEof() .And. !lFin)

			cLinea		:= FT_FREADLN()
			aValores	:= Str2Array(cLinea,';')
			nCantReg++

			DbSelectArea("SX3")
			DbSetOrder(2)
			For nX := 1 To Len(aValores)
				cCampo := AllTrim(aCpos[nX])

				If SX3->(DbSeek(cCampo))
					xValor 	:= UPPER(AllTrim(aValores[nX]))

					If !lError
						lError	:= Len(xValor) > SX3->X3_TAMANHO + 7
						If lError
							/*alert(cCampo)
							alert(xValor)*/
							AutoGrLog( aValores[1] + " - Linea Nro: "+cValToChar(nCantReg)+". El valor del campo "+cCampo+" Excede el tamano del diccionario." )
							Exit
						Else
							Do Case
								Case SX3->X3_TIPO == "N"
								xValor := Val(xValor)
								Case SX3->X3_TIPO == "D"
								xValor := CTOD(xValor)
								Case SX3->X3_TIPO == "C"
								xValor := PADR(xValor,TamSX3(SX3->X3_CAMPO)[1])
							EndCase

							aAdd(aArray,{cCampo,xValor,NIL})
						EndIf
					EndIF
				Else
					lFin := .T.
					AutoGrLog( "El campo " + cCampo + " no se encuentra en el diccionario de datos." )
					Exit
				EndIf

			Next nX

			If lError
				aArray  := {}
				FT_FSkip()
				Loop
			EndIf

			If lFin
				Loop
			EndIf

			/*
			**
			*/

			aAdd(aTotCabs,aArray)
			aArray 	:= {}

			FT_FSkip()
		EndDo

		If !lError
			For nX := 1 To Len(aTotCabs)
				lMSErroAuto := .F.

				nPosDocu := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_DOC"	})
				nPosAuto := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_NUMAUT"	})
				nPosCodc := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_CODCTR"	})
				nPosSeri := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_SERIE"	})
				nPosForn := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_FORNECE"})
				nPosLoja := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_LOJA"	})
				nPosEmis := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_EMISSAO"})
				//nPosDtDg := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_DTDIGIT"})
				nPosMoed := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_MOEDA"	})
				nPosTxMo := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_TXMOEDA"})
				nPosCcon := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_COND"})

				//cxLlave	 := aTotCabs[nX,nPosDocu] + aTotCabs[nX,nPosSeri] +aTotCabs[nX,nPosForn] +aTotCabs[nX,nPosLoja]

				cxFilial	:= xFilial("SF1")
				cxDocumento	:= If(nPosDocu > 0	,aTotCabs[nX,nPosDocu][2]	, ""	)
				cxCondPag	:= If(nPosCcon > 0	,aTotCabs[nX,nPosCcon][2]	, ""	)
				cxAutoriza	:= If(nPosAuto > 0	,aTotCabs[nX,nPosAuto][2]	, ""	)
				cxCodctr	:= If(nPosCodc > 0	,aTotCabs[nX,nPosCodc][2]	, ""	)
				cxSerie		:= If(nPosSeri > 0	,aTotCabs[nX,nPosSeri][2]	, "   "	)
				cxProveedor	:= If(nPosForn > 0	,aTotCabs[nX,nPosForn][2]	, ""	)
				cxTienda	:= If(nPosLoja > 0	,aTotCabs[nX,nPosLoja][2]	, " "	)
				dxEmissao	:= If(nPosEmis > 0	,aTotCabs[nX,nPosEmis][2]	, dDataBase)
				//dxDtDigit	:= If(nPosDtDg > 0	,aTotCabs[nX,nPosDtDg][2]	, dDataBase)
				nxMoeda		:= If(nPosMoed > 0	,aTotCabs[nX,nPosMoed][2]	, 1		)
				//nxTxMoeda	:= 1
				nxTxMoeda	:= If(nPosTxMo > 0	,aTotCabs[nX,nPosTxMo][2]	, 1		)
				If nxMoeda <> 1
					nxTxMoeda	:= If(nPosTxMo > 0	,aTotCabs[nX,nPosTxMo][2]	,	RecMoeda(dDataBase,nxMoeda))
				Endif

				/*
				*
				Verificando se existe a remisão
				*
				*/

				DbSelectArea("SF1")
				SF1->(DbSetOrder(1))
				If SF1->(DbSeek(xFilial("SF1")+cxDocumento+cxSerie+cxProveedor+cxTienda))
					lError := .T.
					AutoGrLog( "La factura: " + cxDocumento + "/" + cxSerie + " ya existe" )
					MostraErro()
					Return
				Endif

				aCabec := {}
				aAdd(aCabec,{"F1_FILIAL"	,cxFilial	})
				aAdd(aCabec,{"F1_DOC"		,cxDocumento})
				aAdd(aCabec,{"F1_NUMAUT"	,cxAutoriza	})
//				alert(cxCodctr)
				aAdd(aCabec,{"F1_CODCTR"	,cxCodctr	})
				aAdd(aCabec,{"F1_SERIE"		,cxSerie	})
				aAdd(aCabec,{"F1_FORNECE"	,cxProveedor})
				aAdd(aCabec,{"F1_LOJA"		,cxTienda	})
				aAdd(aCabec,{"F1_EMISSAO"	,dxEmissao	})
				aAdd(aCabec,{"F1_MOEDA"		,nxMoeda	})
				aAdd(aCabec,{"F1_TXMOEDA"	,nxTxMoeda	})
				if !empty(cxCondPag)
					//
					aAdd(aCabec,{"F1_COND"	,cxCondPag	})
				else// cxCondPag
					aAdd(aCabec,{"F1_COND"	,Posicione('SA2',1,xFilial('SA2')+cxProveedor+cxTienda, 'A2_COND')	})
				endif

				aAdd(aCabec,{"F1_TIPO"		,"N"		})
				aAdd(aCabec,{"F1_FORMUL"	,"N"		})
				aAdd(aCabec,{"F1_ESPECIE"	,"NF"	})
				aAdd(aCabec,{"F1_TIPODOC"	,"10"		})

				/*** Campos especificos para Inesco ***/
				/*
				aAdd(aCabec,{"F1_DIACTB"	,"02"		})
				aAdd(aCabec,{"F1_UALMACE"	,"01"		})
				*/

				aLinha 	:= {}
				While   nX <= Len(aTotCabs) .AND. cxFilial == xFilial("SF1")	.AND. cxDocumento == aTotCabs[nX,nPosDocu][2]	;
				.AND. cxSerie  == aTotCabs[nX,nPosSeri][2] .AND. cxProveedor == aTotCabs[nX,nPosForn][2]				;
				.AND. cxTienda == aTotCabs[nX,nPosLoja][2]

					aItem:= {}

					nPosItProd	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_COD"	 	})
					nPosItQuant	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_QUANT"	})
					nPosItVlUni	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_VUNIT"	})
					nPosItTotal := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_TOTAL"	})
					nPosItTes 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_TES"  	})
					//nPosItTipo 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_TIPO" 	})
					nPosItLocal := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_LOCAL"	})
					nPosItItCta := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_CONTA"	})
					nPosItPed	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_PEDIDO"	})
					//nPosItIPC 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_ITEMPC"	})
					nPosItCC 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_CC"		})
					nPosClasValor := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_CLVL"		})

					cxProd	:= If(nPosItProd	> 0, aTotCabs[nX,nPosItProd ][2]	,	"")
					nxQuant	:= If(nPosItQuant	> 0, aTotCabs[nX,nPosItQuant][2]	,	0 )
					nxVlUni	:= If(nPosItVlUni	> 0, aTotCabs[nX,nPosItVlUni][2]	,	0 )
					nxTotal	:= If(nPosItTotal	> 0, aTotCabs[nX,nPosItTotal][2]	,	nxQuant * nxVlUni)
					cxTes	:= If(nPosItTes		> 0, aTotCabs[nX,nPosItTes  ][2]	,	"")
					cxLocal	:= If(nPosItLocal	> 0, aTotCabs[nX,nPosItLocal][2]	,	"" )
					cxItCta	:= If(nPosItItCta	> 0, aTotCabs[nX,nPosItItCta][2]	,	"" )

					//cxPedid	:= If(nPosItPed		> 0, aTotCabs[nX,nPosItPed	][2]	,	"" )
					//cxItPed	:= If(nPosItIPC		> 0, aTotCabs[nX,nPosItIPC	][2]	,	"" )
					cxCCost := If(nPosItCC		> 0, aTotCabs[nX,nPosItCC	][2]	,	"" )
					cxClasVal := If(nPosClasValor		> 0, aTotCabs[nX,nPosClasValor	][2]	,	"" )

					aAdd(aItem,{"D1_COD"	,cxProd		,Nil})
					aAdd(aItem,{"D1_QUANT"	,nxQuant	,Nil})
					aAdd(aItem,{"D1_VUNIT"	,nxVlUni	,Nil})
					aAdd(aItem,{"D1_TOTAL"	,nxTotal	,Nil})
					aAdd(aItem,{"D1_TIPO"	,"N"		,Nil})
					if !empty(cxTes)
						aAdd(aItem,{"D1_TES"	,cxTes		,Nil})
					endif
					if !empty(cxLocal)
						aAdd(aItem,{"D1_LOCAL"	,cxLocal		,Nil})
					endif
					if !empty(cxItCta)
						aAdd(aItem,{"D1_CONTA",cxItCta	,Nil})
					endif
					if !empty(cxCCost)
						aAdd(aItem,{"D1_CC"	,cxCCost	,Nil})
					endif
					if !empty(cxClasVal)
						aAdd(aItem,{"D1_CLVL"		,cxClasVal	,Nil})
					endif

					//Verifica que no utilice vinculo automatico de FE con proyecto vinculado a SC/PC
					/*If !Empty(cxItPed) .AND. (GetNewPar("MV_PMSIPC", 2) == 2)
					//aAdd(aItem,{"D1_PEDIDO"	,cxPedid	,Nil})
					//aAdd(aItem,{"D1_ITEMPC"	,cxItPed	,Nil})
					Endif*/

					aAdd(aLinha ,aItem)

					nX++

					If nX > Len(aTotCabs)
						Exit
					Endif
				EndDo

				nX--

				//				dBkpData 	:= dDataBase
				//				dDataBase	:= dxEmissao

				//MsExecAuto({|x,y,z| Mata101N(x,y,z)}, aCabec, aLinha, 3)  // 3 - Inclusao
				MSExecAuto({|x,y,z,a| MATA101N(x,y,z,a)},aCabec,aLinha,3)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso la Remisión tuviera ItemContable /Relaciona con el Proyecto/Tarea (F10) ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				//				dDataBase	:= dBkpData

				If lMSErroAuto
					RollBackSx8()
					DisarmTransaction()
					MostraErro()
				Else
					// nahim aumentando grava la SF3
					/*aAdd(aCabec,{"F1_FILIAL"	,cxFilial	})
					aAdd(aCabec,{"F1_DOC"		,cxDocumento})
					aAdd(aCabec,{"F1_NUMAUT"		,cxAutoriza})
					aAdd(aCabec,{"F1_CODCTR"		,cxCodctr})
					aAdd(aCabec,{"F1_SERIE"		,cxSerie	})
					aAdd(aCabec,{"F1_FORNECE"	,cxProveedor})
					aAdd(aCabec,{"F1_LOJA"		,cxTienda	})
					aAdd(aCabec,{"F1_EMISSAO"	,dxEmissao	})
					aAdd(aCabec,{"F1_MOEDA"		,nxMoeda	})
					aAdd(aCabec,{"F1_TXMOEDA"	,nxTxMoeda	})*/
					DbSelectArea("SF3")
					DbSetOrder(1)
					//					DbSeek(xFilial("SF3")+dFecha+cxSerie+cxProveedor+cxTienda)
					//					F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM, 5, 2)
//					F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM, 5, 2)
					cClaveSF1 := xfilial("SF1") +  PADR(cxDocumento,18) + cxSerie + PADR(cxProveedor,TamSX3("F1_CLIORI")[1])   + cxTienda + "N"
//					F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
					If SF1->(dbseek( cClaveSF1 ))
//						alert("Entra")
						//						While !SF3->(EOF()) .AND. F3_FILIAL+DTOS(SF3->F3_ENTRADA)+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+F3_LOJA == cClaveSF3
						RecLock("SF1",.F.)
						Replace F1_NUMAUT  With cxAutoriza
						Replace F1_CODCTR With cxCodctr
						MsUnlock()
//						SF1->(DbSkip())
						//						Enddo
					EndIf
					DbCloseArea("SF1")
					cClaveSF3 := xfilial("SF3") + DTOS(DDATABASE) + PADR(cxDocumento,18) + cxSerie + PADR(cxProveedor,TamSX3("F3_CLIEFOR")[1])   + cxTienda
					If SF3->(dbseek( cClaveSF3 ))
//						alert("Entra")
						//						While !SF3->(EOF()) .AND. F3_FILIAL+DTOS(SF3->F3_ENTRADA)+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+F3_LOJA == cClaveSF3
						RecLock("SF3",.F.)
						Replace F3_NUMAUT  With cxAutoriza
						Replace F3_CODCTR With cxCodctr
						MsUnlock()
//						SF3->(DbSkip())
						//						Enddo
					EndIf
					DbCloseArea("SF3")
					AutoGrLog( " - Remisión/Generada: " + cxDocumento + "/" + cxSerie )
				EndIf
			Next nX
		EndIf
	EndIf

	AutoGrLog( "  " )
	AutoGrLog( "Fecha Fin...........: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora Fin............: " + Time() )
	AutoGrLog( "Registros Procesados: " + cValToChar(nCantReg) )

	cFileLog := NomeAutoLog()

	If cFileLog <> ""
		nX := 1
		While .T.
			If File( Lower( cDirLog + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) ) // El directorio debe estar creado en el servidor bajo DATA
				nX++
				If nX == 999
					Exit
				EndIf
				Loop
			Else
				Exit
			EndIf
		EndDo
		__CopyFile( cPath + Alltrim( cFileLog ), Lower( cDirLog + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
		MostraErro(cPath,cFileLog)
		FErase( cFileLog )
	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³          ³ Autor ³                     ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Str2Array(cString,cSep)
	Local 	aReturn := { }		,;
	cAux    := cString	,;
	nPos    := 0

	While At( cSep, cAux ) > 0
		nPos  := At( cSep, cAux )
		cVal  := SubStr( cAux, 1, nPos-1 )
		Aadd( aReturn,  cVal )
		cAux  := SubStr( cAux, nPos+1 )
	EndDo

	Aadd(aReturn,cAux)
Return(aReturn)