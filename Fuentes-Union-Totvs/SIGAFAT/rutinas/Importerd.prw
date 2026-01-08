#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Tbiconn.ch"
#include "Topconn.ch"
#Include "FileIO.ch"

#Define ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMigraSE1  บAutor  ณEdson  		 บFecha ณ  26/11/2019     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa Importa็ใo de regla de descuento         	  	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia\Union Agronegocios                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Importerd()
	Private oDlg

	@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importaci๓n de reglas de descuento")
	@ 003,003 TO 058,188
	@ 010,018 Say "Este programa tiene como objetivo importar una o mas "
	@ 018,018 Say "reglas de una regla de descuentos desde un archivo *.csv"
	//.xlsx

	@ 040,128 BMPBUTTON TYPE 01 ACTION MsAguarde({|| Importar(),"Procesando. Hora de inicio: " + Time()})
	@ 040,158 BMPBUTTON TYPE 02 ACTION oDlg:End()

	Activate Dialog oDlg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImportar  บAutor  ณEdson 		         บFecha ณ  16/11/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11.3                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Importar()

	Local nX			:= 1
	Local cTitulo1  	:= "Seleccione Archivo"
	Local cExtens   	:= "Archivo | "
	Local cFile 		:= ""
	Local cLinea		:= ""
	Local cCampo		:= ""
	Local aValores		:= {}
	Local aCpos			:= {}
	Local cFileLog		:= ""
	Local cDirLog		:= ""
	Local cPath			:= ""
	Local lError		:= .F.
	Local nCantReg		:= 0
	Local lFin			:= .F.
	Local aArray		:= {}
	Local aTotCabs		:= {}
	Local xValor

//	Private lMSHelpAuto := .T. //.F. // Para nao mostrar os erro na tela
	Private lMSErroAuto := .F. //.F. // Inicializa como falso, se voltar verdadeiro e' que deu erro

	/***
	* _________________________________________________________
	* cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
	* ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
	* <ExpC1> - Expressao de filtro
	* <ExpC2> - Titulo da janela
	* <ExpN1> - Numero de mascara default 1 para *.Exe
	* <ExpC3> - Diret๓rio inicial se necessแrio
	* <ExpL1> - .F. botใo salvar - .T. botใo abrir
	* <ExpN2> - Mascara de bits para escolher as op็๕es de visualiza็ใo do objeto (prconst.ch)
	*/

	cExtens += "*.csv"
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

								if alltrim(cCampo) == "ACP_PERDES"
									xValor := Val(xValor)
								else
									if xValor $ ","
										xValor := StrTran( cString, ",", "." )
									else
										xValor := Val(xValor)
									endif
								endif

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


			aAdd(aTotCabs,aArray)
			aArray 	:= {}

			FT_FSkip()
		EndDo

		If !lError
			For nX := 1 To Len(aTotCabs)
				lMSErroAuto := .F.

				nPosCodpro := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACP_CODPRO" })
				nPosPerDes := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACP_PERDES" })

				cxCodpro	:= If(nPosCodpro > 0	,aTotCabs[nX,nPosCodpro][2]	, ""	)
				cxPrecio	:= If(nPosPerDes > 0	,aTotCabs[nX,nPosPerDes][2]	, " "	)

				impArcExcel(cxCodpro,cxPrecio)
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
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFunciขn     ณ          ณ Autor ณ                     ณ Data ณ          ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescripciขn ณ                                                          ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ Uso        ณ                                                          ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

static Function impArcExcel(codigoPro, cxPrecio)

	// busco posiciones de producto
	nPosProducto := Ascan(aHeader,{|x| AllTrim(x[2]) == "ACP_CODPRO"})
	nPosDesItem := Ascan(aHeader,{|x| AllTrim(x[2]) == "ACP_PERDES"})
	nItem := Ascan(aHeader,{|x| AllTrim(x[2]) == "ACP_ITEM"})

	// if the first row is empty, replace
	if Trim(Acols[1][nPosProducto]) == ""
		Acols[1][nPosProducto] := codigoPro
		Acols[1][nPosDesItem] := cxPrecio

		return
	end If

	aadd(Acols,AClone(Acols[1]))

	Acols[Len(Acols)][nItem] := PadL(len(Acols), 3, "0")
	Acols[Len(Acols)][nPosProducto] := codigoPro//StrZero(1,Len(ACP->ACP_ITEM))
	Acols[Len(Acols)][nPosDesItem] := cxPrecio

return

