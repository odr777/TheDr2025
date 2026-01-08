#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³M113MONT    ³ Autor ³Nahim Terrazas³ Data ³30.03.2020		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ponto de Entrada para Manipular la grid de inclusión/mod de Solicitud. ³±±
±± de importación														  Ù±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M113MONT()

	if funname() == 'MATA113' // adición de funname
		nUM := aScan(aHeader,{|x| Trim(x[2])=="C1_UM"}) // cambiando Unidad de Medida
		nDescrip := aScan(aHeader,{|x| Trim(x[2])=="C1_DESCRI"}) // Por la descripción
		aBack := aHeader[nUM]
		aHeader[nUM] := aHeader[nDescrip]
		aHeader[nDescrip] := aBack
		for i:= 1 to len(acols)
			cValUM := ACOLS[i][nUM]
			ACOLS[i][nUM] :=  ACOLS[i][nDescrip]
			ACOLS[i][nDescrip] := cValUM
		Next i
	endif
return