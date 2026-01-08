#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ CHIMPOR ³				Erick Etcheverry	 º Data ³ 01/04/19º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emision de Cheque						                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Emision de Cheque CCG				                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CCG														  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CHIMPOR(aSef,nLinInicial)
	
	lOkImp := CHELocal('Impresion de cheques',.F.,aSef,nLinInicial)
Return lOkImp

Static function CHELocal(cTitulo,bImprimir,aSef,nLinInicial)
	Private oPrn    := NIL
	Private oFont10  := NIL
	Private nTotPags := 1
	private lFis
	private nLinInicial := 0

	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetCurrentPrinterInUse()
	oPrn:SetPortrait()
	oPrn:setPaperSize(DMPAPER_LETTER)

	DEFINE FONT oFont08 NAME "Arial" SIZE 0,08 OF oPrn
	DEFINE FONT oFont08N NAME "Arial" SIZE 0,08 Bold OF oPrn
	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 OF oPrn
	DEFINE FONT oFont09N NAME "Arial" SIZE 0,09 Bold OF oPrn
	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oFont10N NAME "Arial" SIZE 0,10 Bold  OF oPrn
	DEFINE FONT oFont105N NAME "Arial" SIZE 0,10.5 Bold  OF oPrn
	DEFINE FONT oFont11N NAME "Arial" SIZE 0,11 Bold  OF oPrn
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
	DEFINE FONT oFont12N NAME "Arial" SIZE 0,12 Bold  OF oPrn
	lOkChe := CHEMat(aSef,cTitulo,bImprimir,1,nLinInicial) //Impresion de factura
return lOkChe

static function CHEMat(aSef,cTitulo,bImprimir,nCopia,nLinInicial)
	Local nCantReg := 0
	lOkImat := .f.

	nCantReg := len(aSef)

	//Acumula para sacar el total de paginas Erick
	for var:= 1 to nCantReg
		if nCantReg >= 1
			nCantReg = nCantReg - 1
			//	alert(nCantReg)
			nTotPags ++
		endif
	next

	for b:= 1 to len(aSef)
		lOkImat := cheImp(cTitulo,bImprimir,aSef[b],nLinInicial)    	//Imprimir Factura
		oPrn:Refresh()
	next b

	If bImprimir
		oPrn:Print()
	Else
		oPrn:Preview()
	End If

	oPrn:End()//Fin de la impresion

return lOkImat

static function cheImp(cTitulo,bImprimir,aSef,nLinInicial)
	lTudCe := chedetFact(nLinInicial,aSef)
	oPrn:EndPage()
return lTudCe

Static Function chedetFact(nLinInicial,aMaestro)
	lRetFa := .f.
	oPrn:StartPage()
	cBanco = aMaestro[1,8]
	cBanco := Posicione("SA6",1,xFilial("SA6")+cBanco, "A6_NOME" )
	//alert(cBanco)
	do case
		case "BISA" $ cBanco //"001|002|003|004|005|006|007|008|009|010|011|012|013|014|015" // bisa
		oPrn:Say( nLinInicial + 150, 810, aMaestro[1,1] ,oFont10N )//LUGAR
		oPrn:Say( nLinInicial + 150, 1220, aMaestro[1,2] ,oFont10N )//DIA
		oPrn:Say( nLinInicial + 150, 1365, aMaestro[1,3] ,oFont10N )//MES
		oPrn:Say( nLinInicial + 150, 1745, aMaestro[1,4] ,oFont10N )//AÑO
		oPrn:Say( nLinInicial + 235, 300, aMaestro[1,5] ,oFont10N )//para quien
		
		aExtenso := TexToArray(ALLTRIM(aMaestro[1,6]),65)
		for i := 1 to len(aExtenso)
			if i <= 1
				oPrn:Say( nLinInicial + 295, 300, ALLTRIM(aExtenso[i]) ,oFont10N )//EXTENSO
			else
				oPrn:Say( nLinInicial + 350, 100, ALLTRIM(aExtenso[i]) ,oFont10N )//EXTENSO
			endif
		next i
		oPrn:Say( nLinInicial + 75, 1340, TRANSFORM(aMaestro[1,7],"@E 99,999,999.99")+ ".-" ,oFont10N )//MONTO
		
		CASE "GANADERO" $ cBanco //"016|017|018|019|020|021" //ganadero
		oPrn:Say( nLinInicial + 150, 480, aMaestro[1,1] ,oFont10N )//LUGAR
		oPrn:Say( nLinInicial + 150, 870, aMaestro[1,2] ,oFont10N )//DIA
		oPrn:Say( nLinInicial + 150, 970, aMaestro[1,3] ,oFont10N )//MES
		oPrn:Say( nLinInicial + 150, 1255, SUBSTR(aMaestro[1,4],3,2) ,oFont10N )//AÑO
		oPrn:Say( nLinInicial + 230, 470, aMaestro[1,5] ,oFont10N )//para quien
		aExtenso := TexToArray(ALLTRIM(aMaestro[1,6]),65)
		for i := 1 to len(aExtenso)
			if i <= 1
				oPrn:Say( nLinInicial + 300, 450, ALLTRIM(aExtenso[i]) ,oFont10N )//EXTENSO
			else
				oPrn:Say( nLinInicial + 360, 100, ALLTRIM(aExtenso[i]) ,oFont10N )// EXTENSO
			endif
		next i
		oPrn:Say( nLinInicial + 150, 1460, TRANSFORM(aMaestro[1,7],"@E 99,999,999.99")+ ".-" ,oFont10N )//MONTO
		
		
		CASE "UNION" $ cBanco  //"022" // union
		oPrn:Say( nLinInicial + 60, 640, aMaestro[1,1] + " " + aMaestro[1][2] + " de " + aMaestro[1][3] + " de " + aMaestro[1][4] ,oFont10N )
		oPrn:Say( nLinInicial + 180, 245, aMaestro[1,5] ,oFont10N )//A QUIEN
		aExtenso := TexToArray(ALLTRIM(aMaestro[1,6]),65)
		for i := 1 to len(aExtenso)
			if i <= 1
				oPrn:Say( nLinInicial + 255, 245, ALLTRIM(aExtenso[i]) ,oFont10N )// EXTENSO
			else
				oPrn:Say( nLinInicial + 310, 50, ALLTRIM(aExtenso[i]) ,oFont10N )// EXTENSO
			endif
		next i
		oPrn:Say( nLinInicial + 90, 1470, TRANSFORM(aMaestro[1,7],"@E 99,999,999.99")+ ".-" ,oFont10N )
		
		
		CASE "MERCANTIL" $ cBanco //"028|029|030|031|032|033|034|035"//mercantil
		//alert("Entra impresion")
		aExtenso := TexToArray(ALLTRIM(aMaestro[1,6]),65)
		for i := 1 to len(aExtenso)
			if i <= 1
				oPrn:Say( nLinInicial + 300, 215, ALLTRIM(aExtenso[i]) ,oFont10N )//EXTENSO
			else
				oPrn:Say( nLinInicial + 350, 50, ALLTRIM(aExtenso[i]) ,oFont10N )//EXTENSO
			endif
		next i
		oPrn:Say( nLinInicial + 90, 910, aMaestro[1,1] ,oFont10N )//LUGAR
		oPrn:Say( nLinInicial + 90, 1210, aMaestro[1,2] ,oFont10N )//DIA
		oPrn:Say( nLinInicial + 90, 1350, aMaestro[1,3] ,oFont10N )//MES
		oPrn:Say( nLinInicial + 90, 1660, aMaestro[1,4] ,oFont10N )//AÑO
		oPrn:Say( nLinInicial + 240, 215, aMaestro[1,5] ,oFont10N )//QUIEN
		oPrn:Say( nLinInicial + 180, 1400, TRANSFORM(aMaestro[1,7],"@E 99,999,999.99")+ ".-" ,oFont10N )
		

		CASE "BCP" $ cBanco //"036|037" //bcp
		oPrn:Say( nLinInicial + 90, 720, aMaestro[1,1] ,oFont10N )//LUGAR
		oPrn:Say( nLinInicial + 90, 1130, aMaestro[1,9] ,oFont10N )//DIA
		oPrn:Say( nLinInicial + 90, 1195, aMaestro[1,10] ,oFont10N )//MES
		oPrn:Say( nLinInicial + 90, 1270, aMaestro[1,11] ,oFont10N )//AÑO
		oPrn:Say( nLinInicial + 235, 300, aMaestro[1,5] ,oFont10N )//QUIEN
		oPrn:Say( nLinInicial + 335, 70, aMaestro[1,6] ,oFont09N )//EXTENSO
		oPrn:Say( nLinInicial + 90, 1460, TRANSFORM(aMaestro[1,7],"@E 99,999,999.99")+ ".-" ,oFont10N )//MONTO
	ENDCASE

	lRetFa := .t.
Return lRetFa

Static Function TexToArray(cTexto,nTamLine)
	Local aTexto	:= {}
	Local aText2	:= {}
	Local cToken	:= " "
	Local nX
	Local nTam		:= 0
	Local cAux		:= ""

	aTexto := STRTOKARR ( cTexto , cToken )

	For nX := 1 To Len(aTexto)
		nTam := Len(cAux) + Len(aTexto[nX])
		If nTam <= nTamLine
			cAux += aTexto[nX] + IIF((nTam+1) <= nTamLine, cToken,"")
		Else
			AADD(aText2,cAux)
			cAux := aTexto[nX] + cToken
		Endif
	Next nX

	If !Empty(cAux)
		AADD(aText2,cAux)
	Endif

Return(aText2)