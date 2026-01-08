#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103IPC  ºAutor  ³TdeP º Data ³  05/03/17                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³Punto de entrada para Actualizar campos en el Remito de Entrada º±±
±±º      ³despues de seleccionar Pedidos de Compras 					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP11BIB	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103IPC()
	Local nPosItemCta	:= 0
	Local nItem			:= ParamIxB[1]
	_nPosDesc 	:= Ascan(aHeader, {|x|Alltrim(x[2])=="D1_UDESC"})
	_nPosCod 	:= Ascan(aHeader, {|x|Alltrim(x[2])=="D1_COD"})
	nX = PARAMIXB[1]

	_cProd:= aCols[nX][_nPosCod]

	_cDesc	:= Posicione("SB1",1,xFilial("SB1")+ _cProd,"B1_DESC")
	aCols[nX][_nPosDesc] := _cDesc

	If UPPER(FUNNAME())=='MATA102N'
		If !Empty(M->F1_UALMACE)
			nX := PARAMIXB[1]
			_nPosLocal	:= Ascan(aHeader, {|x|Alltrim(x[2])=="D1_LOCAL"})
			aCols[nX][_nPosLocal]:=M->F1_UALMACE
			//alert(aCols[nX][_nPosLocal])
		Endif

		/* No aplica para el proyecto Belen - wico2k_20220815
		nPosItemCta   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"})
		If nPosItemCta > 0
			If !Empty(aCols[nItem][nPosItemCta])
				U_GetProyecto(nItem)
			Endif
		Endif
		*/
	Endif

	If UPPER(FUNNAME())=='MATA101N'

		nPosTot   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"})
		nPosVuni   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"})
		If nPosTot > 0
			aCols[nItem][nPosTot]:= SC7->C7_TOTAL
			aCols[nItem][nPosVuni]:= SC7->C7_TOTAL / SC7->C7_QUANT
		Endif
	Endif
Return Nil
