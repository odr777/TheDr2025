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

User Function DESTM02
	Private oDlg
	@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importacion de mano de obra")

	@ 003,003 TO 058,188
	@ 010,018 Say "Este programa tiene como objetivo importar una o mas "
	@ 018,018 Say "manos de obra desde un archivo *.csv"

	@ 040,128 BMPBUTTON TYPE 01 ACTION MsAguarde({|| Importar(),"Procesando. Hora de inicio: " + Time()})
	@ 040,158 BMPBUTTON TYPE 02 ACTION oDlg:End()

	Activate Dialog oDlg Centered
Return

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
				_atotitem:={}
				_cDoc	:=	NextNumero("SD3",2,"D3_DOC",.T.)

				nPosCod := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_COD"	})
				nPosQuant := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_QUANT"	})
				nPosLoca := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_LOCAL"	})
				nPosLote := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_LOTECTL"})
				nPosDtVen := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_DTVALID"})
				/*nPosCus1 := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_CUSTO1"	})
				nPosCus2 := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_CUSTO2"})*/
				nPosEmisa := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_EMISSAO"})
				/*nPosCus3 := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_CUSTO3"})
				nPosCus4 := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_CUSTO4"})
				nPosCus5 := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_CUSTO5"})*/
				nPosLoliz := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_LOCALIZ"})
				nPosCcc := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_CC"})
				nPosTipm := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_TM"})
				//nPosFila := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_FILIAL"})
				nPosProj := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_PROJPMS"})
				nPosTask := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_TASKPMS"})
				nPosIcta := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_ITEMCTA"})
				nPosConta := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_CONTA"})
				nPosMat := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_UMAT"})
				nPosCLVL :=  aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_CLVL"})
				nPosObserv :=  aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "D3_OBSERVA"})
				//asignando valores
				cxCod		:= If(nPosCod > 0	,aTotCabs[nX,nPosCod][2]	, ""	)
				nxQuant  	:= If(nPosQuant > 0	,aTotCabs[nX,nPosQuant][2]	, 0	)
				cxLocal		:= If(nPosLoca > 0	,aTotCabs[nX,nPosLoca][2]	, ""	)
				cxLote		:= If(nPosLote > 0	,aTotCabs[nX,nPosLote][2]	, ""	)
				dxDtVen		:= If(nPosDtVen > 0	,aTotCabs[nX,nPosDtVen][2]	, dDataBase)
				/*nxCosto		:= If(nPosCus1 > 0	,aTotCabs[nX,nPosCus1][2]	, 0)
				nxCosto2	:= If(nPosCus2 > 0	,aTotCabs[nX,nPosCus2][2]	, 0		)*/
				dxEmiss		:= If(nPosEmisa > 0	,aTotCabs[nX,nPosEmisa][2]	, dDataBase	)
				/*nxCusto3	:= If(nPosCus3 > 0	,aTotCabs[nX,nPosCus3][2]	, 0		)
				nxCusto4	:= If(nPosCus4 > 0	,aTotCabs[nX,nPosCus4][2]	, 0		)
				nxCusto5	:= If(nPosCus5 > 0	,aTotCabs[nX,nPosCus5][2]	, 0		)*/
				cxLocliz	:= If(nPosLoliz > 0	,aTotCabs[nX,nPosLoliz][2]	, ""	)
				cxCC		:= If(nPosCcc > 0	,aTotCabs[nX,nPosCcc][2]	, ""	)
				cxTipM		:= If(nPosTipm > 0	,aTotCabs[nX,nPosTipm][2]	, ""	)
				//cxFilal		:= If(nPosFila > 0	,aTotCabs[nX,nPosFila][2]	, xFilial("SD3")	)
				cxProjet	:= If(nPosProj > 0	,aTotCabs[nX,nPosProj][2]	, ""	)
				cxTask		:= If(nPosTask > 0	,aTotCabs[nX,nPosTask][2]	, ""	)
				cxItmcta	:= If(nPosIcta > 0	,aTotCabs[nX,nPosIcta][2]	, ""	)
				cxConta		:= If(nPosConta > 0	,aTotCabs[nX,nPosConta][2]	, ""	)
				cxMatGPE	:= If(nPosMat > 0	,aTotCabs[nX,nPosMat][2]	, ""	)
				cxCLVL	:= If(nPosCLVL > 0	,aTotCabs[nX,nPosCLVL][2]	, ""	)
				cxObserv	:= If(nPosObserv > 0	,aTotCabs[nX,nPosObserv][2]	, ""	)
				

				SB1->( DbSetOrder(1) )
				SB1->( DbSeek( xFilial('SB1') + cxCod ) )

				If !(SB1->B1_RASTRO $ 'LS')
					cxLote	:=	Space(TamSX3("D3_LOTECTL")[1])
					dxDtVen	:=	Ctod("")
				Endif

				Begin Transaction
					aMov:= {}
					aMov:= {{"D3_COD"		,cxCod			,Nil},;
					{"D3_QUANT"  	,nxQuant				,Nil},;
					{"D3_UM"     	,SB1->B1_UM      	,Nil},;
					{"D3_LOCAL"  	,cxLocal          	,Nil},;
					{"D3_EMISSAO"	,dxEmiss        	,Nil},;
					{"D3_SEGUM"  	,SB1->B1_SEGUM   	,Nil},;
					{"D3_LOTECTL"	,cxLote        	,Nil},;
					{"D3_GRUPO"  	,SB1->B1_GRUPO   	,Nil},;
					{"D3_ITEMCTA"	,cxItmcta			,Nil},;
					{"D3_DTVALID"	,dxDtVen        	,Nil},;
					{"D3_LOCALIZ"	,cxLocliz         	,Nil},;
					{"D3_CONTA"		,cxConta		 	,Nil},;
					{"D3_CLVL"	,cxCLVL        	 	,Nil},;
					{"D3_OBSERVA"	,cxObserv        	,Nil},;
					{"D3_UMAT"		,cxMatGPE			,Nil}}
					/*{"D3_CUSTO1"	,nxCosto        	 	,Nil},;
					{"D3_CUSTO2"	,nxCosto2        	 	,Nil},;
					{"D3_CUSTO3"	,nxCusto3        	 	,Nil},;
					{"D3_CUSTO4"	,nxCusto4        	 	,Nil},;
					{"D3_CUSTO5"	,nxCusto5        	 	,Nil},;*/
					

					xAutoCab:= {}
					xAutoCab:= {{"D3_DOC"    ,_cDoc  	,Nil},;
					{"D3_TM"     ,cxTipM       ,Nil},;
					{"D3_CC"     ,cxCC ,Nil},;
					{"D3_EMISSAO",dxEmiss  ,Nil}}

					aadd(_atotitem,aMov)
					lMSErroAuto := .F.

					MsExecAuto({|x,y| Mata241(x,y)},xAutoCab,_atotitem )

					If lMsErroAuto
						MostraErro() // Sempre que o micro comeca a apitar esta ocorrendo um erro desta forma
						AutoGrLog( " No se pudo importar : " + cxCod + " - Matricula: " + cxMatGPE + " Doc: " +_cDoc)
						DisarmTransaction()
						Break
					Else
						AutoGrLog( " Movimiento ingresado: " + cxCod + " - Matricula: " + cxMatGPE + " Doc: " +_cDoc)
					EndIf

				End Transaction
				SB1->( DbCloseArea())

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
