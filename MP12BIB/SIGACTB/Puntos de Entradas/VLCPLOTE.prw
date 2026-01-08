#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VLCPLOTE   บAutor  ณEDUAR ANDIA 	  	  บ Data ณ 04/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE ้ utilizado para verificar se o lan็amento poderแ ser   บฑฑ
ฑฑบDesc.     ณ Alterado ou nใo / Valida Lote do Lan็amento				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Teledifusora S.A.\Argentina                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VLCPLOTE
Local dDataLanc   := ParamIxb[1]
Local cLote 	  := ParamIxb[2]
Local cSubLote 	  := ParamIxb[3]
Local cDoc 		  := ParamIxb[4]
Local nOpc 		  := ParamIxb[5]
Local l102Inclui  := (nOpc==3)
Local l102Copia   := (nOpc==7)
Local cLoteManual := AllTrim(GETNEWPAR("MV_XLOTMAN","MANUAL"))
Local lRet		  := .T.

If Funname() $ "CTBA102"
	If l102Inclui .OR. l102Copia		
		If AllTrim(cLote) <> cLoteManual 
			Aviso("VLCPLOTE - Aviso","Lote invalido, solo estแ permitido usar el lote: '" + cLoteManual + "'",{"OK"})
			lRet := .F.
		Endif
		
		If Len(AllTrim(cDoc)) <> TamSX3('CT2_DOC')[1]
			Aviso("VLCPLOTE - Aviso","Documento invalido, el tama๑o del Doc. es de " + AllTrim(Str(TamSX3('CT2_DOC')[1])) + " caracteres",{"OK"})
			lRet := .F.
		Endif
	Endif
Endif

If Funname() $ "CTBA102"
	If l102Inclui .OR. l102Copia		
		If AllTrim(cLote) <> cLoteManual 
			Aviso("VLCPLOTE - Aviso","Lote invalido, solo estแ permitido usar el lote: '" + cLoteManual + "'",{"OK"})
			lRet := .F.
		Endif
		
		If Len(AllTrim(cDoc)) <> TamSX3('CT2_DOC')[1]
			Aviso("VLCPLOTE - Aviso","Documento invalido, el tama๑o del Doc. es de " + AllTrim(Str(TamSX3('CT2_DOC')[1])) + " caracteres",{"OK"})
			lRet := .F.
		Endif
	Endif
Endif

Return(lRet)
