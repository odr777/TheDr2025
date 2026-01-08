#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Fileio.ch"

#DEFINE CRLF Chr(13) + Chr(10)

User Function ConsoleLog( cTipo, cMsg, lAbreFecha, lCierraFecha, cArqTxt, cSeparador) // ConsoleLog( "Correlativo Correcto", cMsg, lAbreFecha, lCierraFecha, cArqTxt)

	Private nHdl := 0
	Private cLin := ""

	Default cArqTxt := "\BIBLog.TXT"
	Default lAbreFecha := .F.
	Default lCierraFecha := .F.
	Default cTipo := ""
	Default cMsg := ""

	cArqTxt := AllTrim(cArqTxt)
	If SubStr(cArqTxt,1,1)!="\"
		cArqTxt := "\" + cArqTxt
	EndIf

	//Verifica se o arquivo existe
	if !file(cArqTxt)
		nHdl := fCreate(cArqTxt)

		if nHdl == -1
			MsgAlert("El Archivo de Nombre " + cArqtxt + " no se encuentra ! Verifique los parametros.","Atención!") 
			Return

		Endif

		if nHdl <> -1		 
			ArmarMensaje( cTipo, cMsg, lAbreFecha, lCierraFecha, cSeparador)

			//Grava no arquivo texto
			if fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)

				if !MsgAlert( "Ocurrió un error en la gravacion del Archivo." + "Continuar!", "Atencion!!")
					Return(.F.)
				endif
			endif
		endif

	else
		// Abre o arquivo de Origem	 
		nHdl := fOpen(cArqTxt,1)

		// Testa a abertura do Arquivo
		If nHdl == -1
			MsgStop('Error al abrir origen. Ferror = ' +str(ferror(),4),'Erro')
			Return .F.
		Endif

		fSeek(nHdl,0,2)

		ArmarMensaje( cTipo, cMsg, lAbreFecha, lCierraFecha, cSeparador)

		//Grava no arquivo texto
		if fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			if !MsgAlert("Ocorreu um erro na gravacao do arquivo." + "Continua !","Atencao !")
				Return(.F.)
			endif
		endif

	endif

	//Cierra el archivo texto
	If !fClose(nHdl)
		Conout( "Erro ao fechar arquivo, erro numero: ", FERROR() )
	EndIf

Return(.T.)

Static Function ArmarMensaje( cTipo, cMsg, lAbreFecha, lCierraFecha, cSeparador)

	If !Empty(AllTrim(cSeparador))
		If !Empty(AllTrim(cMsg))
			cLin += cTipo + cSeparador + cMsg
		EndIf

		If lAbreFecha
			cLin += cSeparador + dtoc(date()) + cSeparador + time()
		EndIf

		If lCierraFecha
			cLin += cSeparador + dtoc(date()) + cSeparador + time()
		EndIf

		cLin += CRLF
	Else
		If lAbreFecha
			cLin += CRLF
			cLin += "----------------------------Log Eventos "+ dtoc(date()) + " as " + time() + "-------------------------------" + CRLF
		EndIf

		If !Empty(AllTrim(cTipo))
			cLin += cTipo + CRLF
		EndIf
		If !Empty(AllTrim(cMsg))
			cLin += cMsg + CRLF
		EndIf

		If lCierraFecha
			cLin += "----------------------------Finalizado "+ dtoc(date()) + " as " + time() + "--------------------------------" + CRLF
			cLin += CRLF
		EndIf
	EndIf
Return
