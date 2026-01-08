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
±±ºPrograma  ³MigraSE1  ºAutor  ³EDUAR ANDIA   		 ºFecha ³  08/09/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa Importação de Remisão de entrada         	  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\Inesco                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ImportRem
Private oDlg

@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importación de Remisiones/OwnerShip")
@ 003,003 TO 058,188
@ 010,018 Say "Este programa tiene como objetivo importar una o mas "
@ 018,018 Say "Remisiones/OwnerShip desde un archivo *.csv"

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
Local cCposCab		:= "F1_DOC|F1_SERIE|F1_FORNECE|F1_LOJA|F1_EMISSAO|F1_MOEDA|F1_TXMOEDA|D1_COD|D1_QUANT|D1_VUNIT|D1_TOTAL|D1_TES|D1_LOCAL"
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
					lError	:= Len(xValor) > SX3->X3_TAMANHO										
					If lError
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
				nPosSeri := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_SERIE"	})
				nPosForn := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_FORNECE"})
				nPosLoja := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_LOJA"	})
				nPosEmis := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_EMISSAO"})
				nPosDtDg := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_DTDIGIT"})
				nPosMoed := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_MOEDA"	})
				nPosTxMo := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "F1_TXMOEDA"})
				
				//cxLlave	 := aTotCabs[nX,nPosDocu] + aTotCabs[nX,nPosSeri] +aTotCabs[nX,nPosForn] +aTotCabs[nX,nPosLoja]
			
				cxFilial	:= xFilial("SF1")
				cxDocumento	:= If(nPosDocu > 0	,aTotCabs[nX,nPosDocu][2]	, ""	)
				cxSerie		:= If(nPosSeri > 0	,aTotCabs[nX,nPosSeri][2]	, "   "	)
				cxProveedor	:= If(nPosForn > 0	,aTotCabs[nX,nPosForn][2]	, ""	)
				cxTienda	:= If(nPosLoja > 0	,aTotCabs[nX,nPosLoja][2]	, " "	)
				dxEmissao	:= If(nPosEmis > 0	,aTotCabs[nX,nPosEmis][2]	, dDataBase)
				dxDtDigit	:= If(nPosDtDg > 0	,aTotCabs[nX,nPosDtDg][2]	, dDataBase)
				nxMoeda		:= If(nPosMoed > 0	,aTotCabs[nX,nPosMoed][2]	, 1		)
				nxTxMoeda	:= 1
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
			 		AutoGrLog( "El Remito: " + cxDocumento + "/" + cxSerie + " ya existe" )			 		
			 		MostraErro()
			 		Return
				Endif
				
				aCabec := {}
				aAdd(aCabec,{"F1_FILIAL"	,cxFilial	})
				aAdd(aCabec,{"F1_DOC"		,cxDocumento})
				aAdd(aCabec,{"F1_SERIE"		,cxSerie	})
				aAdd(aCabec,{"F1_FORNECE"	,cxProveedor})
				aAdd(aCabec,{"F1_LOJA"		,cxTienda	})
				aAdd(aCabec,{"F1_TIPO"		,"N"		})
				aAdd(aCabec,{"F1_FORMUL"	,"N"		})
				aAdd(aCabec,{"F1_EMISSAO"	,dxEmissao	}) 
				aAdd(aCabec,{"F1_DTDIGIT"	,dxDtDigit	})
				aAdd(aCabec,{"F1_MOEDA"		,nxMoeda	})
				aAdd(aCabec,{"F1_TXMOEDA"	,nxTxMoeda	}) 
				aAdd(aCabec,{"F1_TIPODOC"	,"60"		})
				
				/*** Campos especificos para Inesco ***/
				/*
				aAdd(aCabec,{"F1_DIACTB"	,"02"		})
				aAdd(aCabec,{"F1_UALMACE"	,"01"		})
				*/
				
				lPmsF10	:= .F.
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
					nPosItUhin 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_UHRINIE"	})
					nPosItUhfi 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_UHRFINE"	})
					nPosItUhra 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_UHORAEQ"	})
					nPosItUPtd 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_UNROPTD"	})
					nPosItUOpe	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_UOPERPT"	})
					nPosItTipo 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_TIPO" 	})
					nPosItLocal := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_LOCAL"	})
					nPosItItCta := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_ITEMCTA"	})  
					nPosItPed	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_PEDIDO"	})
					nPosItIPC 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_ITEMPC"	})
					nPosItCC 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_CC"		})
					nPosItCLVL 	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D1_CLVL"	})
					
					cxProd	:= If(nPosItProd	> 0, aTotCabs[nX,nPosItProd ][2]	,	"")
					nxQuant	:= If(nPosItQuant	> 0, aTotCabs[nX,nPosItQuant][2]	,	0 )
					nxVlUni	:= If(nPosItVlUni	> 0, aTotCabs[nX,nPosItVlUni][2]	,	0 )
					nxTotal	:= If(nPosItTotal	> 0, aTotCabs[nX,nPosItTotal][2]	,	nxQuant * nxVlUni)
					cxTes	:= If(nPosItTes		> 0, aTotCabs[nX,nPosItTes  ][2]	,	"001")
					nxUhin	:= If(nPosItUhin	> 0, aTotCabs[nX,nPosItUhin ][2]	,	0)
					nxUhfi	:= If(nPosItUhfi	> 0, aTotCabs[nX,nPosItUhfi ][2]	,	0)
					nxUhra	:= If(nPosItUhra	> 0, aTotCabs[nX,nPosItUhra ][2]	,	0)
					cxUPtd	:= If(nPosItUPtd	> 0, aTotCabs[nX,nPosItUPtd ][2]	,	"000001")
					cxUOpe	:= If(nPosItUOpe	> 0, aTotCabs[nX,nPosItUOpe ][2]	,	"000001")
					cxLocal	:= If(nPosItLocal	> 0, aTotCabs[nX,nPosItLocal][2]	,	"01" )
					cxItCta	:= If(nPosItItCta	> 0, aTotCabs[nX,nPosItItCta][2]	,	"" )
					cxPedid	:= If(nPosItPed		> 0, aTotCabs[nX,nPosItPed	][2]	,	"" )
					cxItPed	:= If(nPosItIPC		> 0, aTotCabs[nX,nPosItIPC	][2]	,	"" )
					cxCCost := If(nPosItCC		> 0, aTotCabs[nX,nPosItCC	][2]	,	"" )
					cxClVl	:= If(nPosItCLVL	> 0, aTotCabs[nX,nPosItCLVL][2]	,	"" )
					
					aAdd(aItem,{"D1_COD"	,cxProd		,Nil})
					aAdd(aItem,{"D1_QUANT"	,nxQuant	,Nil})
					aAdd(aItem,{"D1_VUNIT"	,nxVlUni	,Nil})
					aAdd(aItem,{"D1_TOTAL"	,nxTotal	,Nil})
					aAdd(aItem,{"D1_TES"	,cxTes		,Nil})
					aAdd(aItem,{"D1_UHRINIE",nxUhin		,Nil})
					aAdd(aItem,{"D1_UHRFINE",nxUhfi		,Nil})
					aAdd(aItem,{"D1_UHORAEQ",nxUhra		,Nil})
					aAdd(aItem,{"D1_UNROPTD",cxUPtd		,Nil})
					aAdd(aItem,{"D1_UOPERPT",cxUOpe		,Nil})
					aAdd(aItem,{"D1_TIPO"	,"N"		,Nil})
					aAdd(aItem,{"D1_LOCAL"	,cxLocal	,Nil})
					aAdd(aItem,{"D1_ITEMCTA",cxItCta	,Nil})
					aAdd(aItem,{"D1_CC"		,cxCCost	,Nil})
					aAdd(aItem,{"D1_CLVL"	,cxClVl	,Nil})
					                                                         
					//Verifica que no utilice vinculo automatico de FE con proyecto vinculado a SC/PC
					If !Empty(cxItPed) .AND. (GetNewPar("MV_PMSIPC", 2) == 2)
					aAdd(aItem,{"D1_PEDIDO"	,cxPedid	,Nil})
					aAdd(aItem,{"D1_ITEMPC"	,cxItPed	,Nil})
					Endif
				
					aAdd(aLinha ,aItem)
					
					nX++
					If !Empty(cxItCta)
						lPmsF10 := .T.
					Endif
					
					If nX > Len(aTotCabs)
						Exit
					Endif				
				EndDo
				
				nX--
				
				dBkpData 	:= dDataBase				
				dDataBase	:= dxEmissao
				
				MsExecAuto({|x,y,z| Mata102N(x,y,z)}, aCabec, aLinha, 3)  // 3 - Inclusao
				
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso la Remisión tuviera ItemContable /Relaciona con el Proyecto/Tarea (F10) ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lPmsF10 .AND. !lMSErroAuto .AND. (SuperGetMv("MV_INTPMS") == "S")
					If Len(aLinha) > 1	//Si el Remito tiene 1 solo item el F10 ya lo ejecuta el disparador.
						AtuProjetoF10(aCabec, aLinha)
					Endif
				Endif
				
				dDataBase	:= dBkpData
				
				If lMSErroAuto
					RollBackSx8()
					DisarmTransaction()
					MostraErro()
				Else
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


Static Function AtuProjetoF10(aCabec, aLinha)
Local nPosDocu 		:= aScan(aCabec,{|x| Upper(AllTrim(x[1])) == "F1_DOC"	})
Local nPosSeri 		:= aScan(aCabec,{|x| Upper(AllTrim(x[1])) == "F1_SERIE"	})
Local nPosForn 		:= aScan(aCabec,{|x| Upper(AllTrim(x[1])) == "F1_FORNECE"})
Local nPosLoja 		:= aScan(aCabec,{|x| Upper(AllTrim(x[1])) == "F1_LOJA"	})
Local cxDocumento	:= If(nPosDocu > 0	,aCabec[nPosDocu,2]	, ""	)
Local cxSerie		:= If(nPosSeri > 0	,aCabec[nPosSeri,2]	, "   "	)
Local cxProveedor	:= If(nPosForn > 0	,aCabec[nPosForn,2]	, ""	)
Local cxTienda		:= If(nPosLoja > 0	,aCabec[nPosLoja,2]	, " "	)
Local cAliasPMS		:= GetNextAlias()
Local cxItemCta		:= ""
Local lPreNota		:= .F.
Local lRet			:= .F.
Local nEvento		:= 1
Local cxQuant		:= 0

DbSelectArea("SF1")
SF1->(DbSetOrder(1))
If SF1->(DbSeek(xFilial("SD1")+cxDocumento+cxSerie+cxProveedor+cxTienda))

	DbSelectArea("SD1")
	SD1->(DbGoTop())
	SD1->(DbSetOrder(1))
	If SD1->(DbSeek(xFilial("SD1")+cxDocumento+cxSerie+cxProveedor+cxTienda))		
		While SD1->(!Eof()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == cxDocumento .AND. SD1->D1_SERIE==cxSerie .AND. SD1->D1_FORNECE==cxProveedor .AND. SD1->D1_LOJA==cxTienda				
		
			cxItemCta 	:= SD1->D1_ITEMCTA 		
			lAtuStk 	:= GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SD1->D1_TES,1,"")=="S"
			cxQuant		:= SD1->D1_QUANT
			
			If !Empty(cxItemCta) .AND. !lAtuStk
				
				If Select("cAliasPMS") > 0  //En uso
					(cAliasPMS)->(DbCloseArea())
				Endif
				
				cAliasPMS		:= GetNextAlias()
				
				BeginSql Alias cAliasPMS				
				SELECT  AF8_PROJET,AF9_TAREFA,AF8_REVISA FROM 
				%table:AF9% AF9
				INNER JOIN
				%table:AF8% AF8 
				ON AF9_PROJET=AF8_PROJET AND AF9_REVISA=AF8_REVISA
				WHERE 
				AF9_FILIAL = %xFilial:AF9%
				AND AF8_FILIAL = %xFilial:AF8%
				AND AF9.%NotDel%           	
				AND AF8.%NotDel%
				AND AF9_ITEMCC=%Exp:cxItemCta%		
				EndSQL
				
				If !Empty((cAliasPMS)->AF8_PROJET) .AND. !Empty((cAliasPMS)->AF9_TAREFA)
					
					/*
					Indice:1 - AFN_FILIAL+AFN_PROJET+AFN_REVISA+AFN_TAREFA+AFN_DOC+AFN_SERIE+AFN_FORNEC+AFN_LOJA+AFN_ITEM
					Indice:2 - AFN_FILIAL+AFN_DOC+AFN_SERIE+AFN_FORNEC+AFN_LOJA+AFN_ITEM
					
					DbSelectArea('AFN')
					AFN->(DbSetOrder(1))					
					If AFN->(DbSeek(xFilial("AFN")+(cAliasPMS)->AF8_PROJET + (cAliasPMS)->AF8_REVISA + (cAliasPMS)->AF9_TAREFA +cxDocumento+cxSerie+cxProveedor+cxTienda+SD1->D1_ITEM))
					*/
					
					AFN->(DbSetOrder(2))					
					If AFN->(DbSeek(xFilial("AFN")+cxDocumento+cxSerie+cxProveedor+cxTienda+SD1->D1_ITEM))
						//If SD1->D1_ITEM == "0001"
							RecLock('AFN',.F.)	//Modificando el item Grabado por el Disparador
							AFN->AFN_QUANT	:= SD1->D1_QUANT
							AFN->AFN_ITEM   := SD1->D1_ITEM
							AFN->AFN_TIPONF := SD1->D1_TIPO
							AFN->AFN_COD    := SD1->D1_COD
							AFN->AFN_PROJET	:= (cAliasPMS)->AF8_PROJET
							AFN->AFN_TAREFA	:= (cAliasPMS)->AF9_TAREFA
							AFN->AFN_REVISA := (cAliasPMS)->AF8_REVISA
							AFN->(MsUnlock())
						//Endif
					Else
						RecLock('AFN',.T.)												
						AFN->AFN_FILIAL := xFilial("AFN")
						AFN->AFN_PROJET	:= (cAliasPMS)->AF8_PROJET
						AFN->AFN_TAREFA	:= (cAliasPMS)->AF9_TAREFA
						AFN->AFN_REVISA := (cAliasPMS)->AF8_REVISA
						AFN->AFN_ESTOQU	:= "1"
						AFN->AFN_QUANT	:= SD1->D1_QUANT
						AFN->AFN_DOC    := SD1->D1_DOC
						AFN->AFN_SERIE  := SD1->D1_SERIE
						AFN->AFN_FORNEC := SD1->D1_FORNECE
						AFN->AFN_LOJA   := SD1->D1_LOJA
						AFN->AFN_ITEM   := SD1->D1_ITEM
						AFN->AFN_TIPONF := SD1->D1_TIPO
						AFN->AFN_COD    := SD1->D1_COD
						
						If AFN->(FieldPos("AFN_ID")) > 0 .And. SF1->(FieldPos("F1_MSIDENT")) > 0 
							AFN->AFN_ID     := SF1->F1_MSIDENT
						Endif
						If !Empty(SD1->D1_NUMCQ) .And. AFN->(FieldPos('AFN_SALDCQ')) > 0
							AFN->AFN_SALDCQ	:=	AFN->AFN_QUANT
						EndIf				
						AFN->(MsUnlock())
						
						(cAliasPMS)->(DbCloseArea())
					Endif	
				Endif		
			Else
				//Borra el Item (AFN) en caso de que el disparador lo haya creado.
				If Empty(cxItemCta)
					
					AFN->(DbSetOrder(2))					
					If AFN->(DbSeek(xFilial("AFN")+cxDocumento+cxSerie+cxProveedor+cxTienda+SD1->D1_ITEM))
						RecLock("AFN",.F.,.T.)
						DbDelete()
						MsUnLock()
					Endif
				Endif
			Endif
			
			SD1->(DbSkip())
		EndDo
	Endif	
Endif
Return
