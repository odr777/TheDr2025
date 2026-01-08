#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ ConvValir ³ Autor ³ Rodrigo Pilewski     ³ Data ³ 03/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Retorna valor para el asiento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Microsiga Argentina....                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

/*
VALORES DE LOS PARAMETROS QUE RECIBE LA RUTINA -----------------------------------------------

nMoneda = Moneda en la cual se quiere obteber el valor
nValor = Valor a convertir 
nMonOri = Moneda de origen de nValor
dFecha = Fecha en la cual se debe tomar la tasa de conversion
nTxMonDoc = tasa de la moneda de origen con respecto la moneda 1
*/

User Function ConvValor(nMoneda, nValor, nMonOri, dFecha, nTxMonDoc)

Local nValRet	 := 0

If nTxMonDoc == 0
	nTxMonDoc := 1
Endif
If nMonOri == 1 // Cuando el documento es en moneda 1
	If nMoneda == 1
		nValRet := nValor
	ElseIf nMoneda == 2
		                    //, nValor,        dDataOri,   nMoeOri,        nMoneda, nVerTasa, nTxMoeda )            
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),2     ,2,        0)		
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),6     ,6,        0)										
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),7     ,7,        0)										
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),8     ,8,        0)										
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),9     ,9,        0)										
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),10     ,10,        0)										
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),11     ,11,        0)										
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor,dFecha,MAX(nMonOri,1),12     ,12,        0)										
	Endif
ElseIf nMonOri == 2
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := nValor
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif			
ElseIf nMonOri == 3
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := nValor 
	Elseif nMoneda == 4
		nValRet :=  U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif			
ElseIf nMonOri == 4
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := nValor 
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif					
ElseIf nMonOri == 5
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := nValor 
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif					
ElseIf nMonOri == 6
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := nValor 
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif					
ElseIf nMonOri == 7
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := nValor 
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif					
ElseIf nMonOri == 8
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := nValor 
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif					
ElseIf nMonOri == 9
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := nValor 
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif					
ElseIf nMonOri == 10
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := nValor 
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif					
ElseIf nMonOri == 11
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := nValor 
	Elseif nMoneda == 12
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,12     ,12,        0)				
	Endif					
ElseIf nMonOri == 12
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Elseif nMoneda == 6
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Elseif nMoneda == 7
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,7     ,7,        0)				
	Elseif nMoneda == 8
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,8     ,8,        0)				
	Elseif nMoneda == 9
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,9     ,9,        0)				
	Elseif nMoneda == 10
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,10     ,10,        0)				
	Elseif nMoneda == 11
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,11     ,11,        0)				
	Elseif nMoneda == 12
		nValRet := nValor 
	Endif					
Else
	If nMoneda == 1
		nValRet := nValor * nTxMonDoc
	ElseIf nMoneda == 2
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,2     ,2,        0)				
	Elseif nMoneda == 3
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,3     ,3,        0)				
	Elseif nMoneda == 4
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,4     ,4,        0)				
	Elseif nMoneda == 5
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,5     ,5,        0)				
	Else
		nValRet := U_xVALOR(nValor * nTxMonDoc,dFecha,1,6     ,6,        0)				
	Endif						
Endif

Return( nValRet )

//--------------------------------------------------------------------------
User Function TraeMoneda(nMoneda)

Local nTxRet

Do Case
	Case nMoneda == 1
		nTxRet := 1
	Case nMoneda == 2
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA2")
	Case nMoneda == 3
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA3")
	Case nMoneda == 4
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA4")
	Case nMoneda == 5
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA5")
	Case nMoneda == 6
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA6")
	Case nMoneda == 7
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA7")
	Case nMoneda == 8
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA8")
	Case nMoneda == 9
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA9")
	Case nMoneda == 10
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA10")
	Case nMoneda == 11
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA11")
	Case nMoneda == 12
		nTxRet := Posicione("SM2",1,dDatabase,"M2_MOEDA12")
EndCase
Return(nTxRet)

//-----------------------------------------------------------------------

User Function TotDifRec(nMoneda)

Local dDataAnt := dDatabase
Local nRet     := 0

Do case
	Case nMoneda == 1
	    dDatabase := SEL->EL_DTDIGIT                                                                                                          
		nRet:= U_ConvValor(1,SEL->EL_DESCONT-SEL->EL_MULTA,VAL(SEL->EL_MOEDA),SEL->EL_DTDIGIT,U_TraeMoneda(VAL(SEL->EL_MOEDA)))
	    dDatabase:=dDataAnt
		Return ( nRet )
	Case nMoneda == 2   
	    dDatabase := SEL->EL_DTDIGIT                                                                                                          
	    nRet:=U_ConvValor(2,SEL->EL_DESCONT-SEL->EL_MULTA,VAL(SEL->EL_MOEDA),SEL->EL_DTDIGIT,U_TraeMoneda(VAL(SEL->EL_MOEDA)))
	    dDatabase:=dDataAnt
		Return ( nRet )
Endcase

Return(0)

//--------------------------------------------------
// USADA EN REVERSION LINEA 576 DE MULTA
//-------------------------------------------------             
User Function MCFDIFR(nMoneda)

Local dDataAnt := dDatabase
Local nRet     := 0

Do case
	Case nMoneda == 1
	    dDatabase := SEL->EL_DTDIGIT                                                                                                          
		nRet:= U_ConvValor(1,ABS(SEL->EL_MULTA),VAL(SEL->EL_MOEDA),SEL->EL_DTDIGIT,U_TraeMoneda(VAL(SEL->EL_MOEDA)))
	    dDatabase:=dDataAnt
		Return ( nRet )
	Case nMoneda == 2   
	    dDatabase := SEL->EL_DTDIGIT                                                                                                          
	    nRet:=U_ConvValor(2,ABS(SEL->EL_MULTA),VAL(SEL->EL_MOEDA),SEL->EL_DTDIGIT,U_TraeMoneda(VAL(SEL->EL_MOEDA)))
	    dDatabase:=dDataAnt
		Return ( nRet )
Endcase

Return(0)

//--------------------------------------------------
// USADA EN REVERSION LINEA 576 DE COMISIONES
//-------------------------------------------------             
User Function MCFCOMR(nMoneda)

Local dDataAnt := dDatabase
Local nRet     := 0

Do case
	Case nMoneda == 1
	    dDatabase := SEL->EL_DTDIGIT                                                                                                          
		nRet:= U_ConvValor(1,ABS(SEL->EL_DESCONT),VAL(SEL->EL_MOEDA),SEL->EL_DTDIGIT,U_TraeMoneda(VAL(SEL->EL_MOEDA)))
	    dDatabase:=dDataAnt
		Return ( nRet )
	Case nMoneda == 2   
	    dDatabase := SEL->EL_DTDIGIT                                                                                                          
	    nRet:=U_ConvValor(2,ABS(SEL->EL_DESCONT),VAL(SEL->EL_MOEDA),SEL->EL_DTDIGIT,U_TraeMoneda(VAL(SEL->EL_MOEDA)))
	    dDatabase:=dDataAnt
		Return ( nRet )
Endcase

Return(0)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ MCESADUA  ³ Autor ³ Francisco Lagatta    ³ Data ³ 27/11/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Verifica si el proveedor es aduana 						³±±
±±³          ³                                                  		  ³±±
±±³          ³              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MCESADUA(cTabla,cValEst)
// Si cValEst <> "1" valida tambien si genera financiero la TES

Local cMCADUA := " "                 
Local lValest := .T.
Default cValEst := "1"
         
If cTabla == "SF1"
 	cMCADUA := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_MCADUA")
	lValEst := U_MCTESST(SD1->D1_TES,5) 	
ElseIf cTabla == "SF2"
 	cMCADUA := Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_MCADUA")
 	lValEst := U_MCTESST(SD2->D2_TES,5)
Endif 	                                                                                

If cMCADUA == "1"
	If cValEst == "1"
		Return(.T.)
	Else
		Return(lValEst) 
	Endif
Else
	Return(.F.)
Endif


