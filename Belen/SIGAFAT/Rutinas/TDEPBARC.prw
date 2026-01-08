#include "TOTVS.CH" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TPANEL() ³ Autor ³			: Erick Etcheverry				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Crea un panel adiciona QR E IMPRIME EN BMP					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TPANEL ()	                                                ³±±
±± Retorno   ³ Ruta donde fue creado el archivo								³±±	
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Global														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³       ³16/02/2017³														³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function TDEPBARC(cTexto)
	local cFile := ""
	// oPanel1 := TPaintPanel():new(0,0,480,480)
	// FwQrCode():New({25,25,800,800},oPanel1,cTexto)
	// oPanel1:Hide()
	// cFile = u_TDEPSMPA() + "\tdepBArCode" + cUserName;
	//  + __CUSERID + ALLTRIM(SUBSTR(CMONTH(DATE()), 1, 3)) + ALLTRIM(STR(DAY(DATE())));
	//  + ALLTRIM(STR(YEAR(DATE()))) + alltrim(SUBSTR(TIME(), 1, 2))+ alltrim(SUBSTR(TIME(), 4, 2));
	//  + alltrim(SUBSTR(TIME(), 7, 2)) + ".BMP"
	
	// oPanel1:SaveAsBMP(cFile)

	Local oBar := zBarCode128():New()
	Local aSeq, oBmp
	// Gera a sequencia de valores em array 
	aSeq := oBar:Generate(cTexto)
	// Monta o bitmap usando os valores
	oBmp := oBar:BuildBmp(aSeq)
	cFile = u_TDEPSMPA() + "\tdepBArCode" + cUserName;
	 + __CUSERID + ALLTRIM(SUBSTR(CMONTH(DATE()), 1, 3)) + ALLTRIM(STR(DAY(DATE())));
	 + ALLTRIM(STR(YEAR(DATE()))) + alltrim(SUBSTR(TIME(), 1, 2))+ alltrim(SUBSTR(TIME(), 4, 2));
	 + alltrim(SUBSTR(TIME(), 7, 2)) + ".bmp"
	//  Aviso("",cFile,{'ok'},,,,,.t.)
	// cFile = '\barcode.bmp'
	// alert()
	// Salva a imagem em disco 
	oBmp:SaveToBMP(cFile)
	// oBmp:SaveToPNG(cFile)

Return cFile


User Function PocBAR128()

Local oBar := zBarCode128():New()
Local aSeq, oBmp

// Gera a sequencia de valores em array 
aSeq := oBar:Generate('https://siga0984.wordpress.com')

// Monta o bitmap usando os valores
oBmp := oBar:BuildBmp(aSeq)

// Salva a imagem em disco 
oBmp:SaveToBMP('\barcode.bmp')

Return
