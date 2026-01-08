#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ MayorDescuento ³ Autor ³ Widen Gonzales					  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Coloca el Mayor descuento entre Cliente y Regla de descuento³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410LIOK
Local nPprcven   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPValor	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPDescon	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"}) 
Local nPValdesc	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nQtdVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local cXModesc  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XMODESC"})
Local cOPER	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})
Local nDescCab:=0
Local nDesconto:=0

/*Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })
Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
*/
//aCols[1][nPPrcVen] := 2 //A410Arred(FtDescCab(aCols[n][nPPrUnit],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,valdesc4})*(1-(aCols[n][nPDescon]/100)),"C6_PRCVEN")
//aCols[1][nPValor]  := 6//A410Arred(aCols[n][nPPrcVen]*nQtdVen,"C6_VALOR",If(cPaisLoc=="CHI" .And. lPrcdec,M->C5_MOEDA,NIL))
//IF empty(aCols[n][nPMotiv])
//IF (M->C5_DESC4 + M->C5_DESC1) >= aCols[n][nPDescon]

nDescCab:= M->C5_DESC1 + M->C5_DESC4
//if M->C5_MOEDA=2
	//IF (M->C5_DESC4) > 0
	IF (nDescCab) > 0		
		IF aCols[n][nPDescon] > nDescCab 
			
			if Empty(aCols[n][cXModesc])
				//ALERT('Es mayor')
				//MSGINFO( 'Descuento por Item: '+ alltrim(str(aCols[n][nPDescon])) +' , Nuevo Descuento por Item: '+ (aCols[n][nPDescon]- nDescCab) , "No aplica Descuento Sobre descuento" )
				//MSGINFO( 'Anterior Descuento/Item: '+alltrim(str(aCols[n][nPDescon]))+' , Nuevo Descuento/Item: '+alltrim(str(aCols[n][nPDescon]- nDescCab)), "No aplica Descuento Sobre Descuento" )			
				MSGINFO( 'NO APLICA Descuento x Cabecera: '+ alltrim(str(nDescCab)) +' , SI APLICA Descuento x Item: '+alltrim(str(aCols[n][nPDescon])), "No aplica Descuento Sobre Descuento" )
				aCols[n][cXModesc]:=AllTrim(Str(aCols[n][nPDescon]))
				//aCols[n][nPDescon]:=aCols[n][nPDescon]- nDescCab
				//aCols[n][cXModesc]:='S'
			endif
			//aCols[n][nPValdesc]:=0
			//aCols[n][nPValdesc]:= a410Arred((aCols[n][nPPrUnit]-aCols[n][nPPrcVen])*IIf(aCols[n][nPQuant]==0,1,aCols[n][nPQuant]),"C6_VALDESC")
			
			//aCols[n][nPPrcVen] := A410Arred(FtDescCab(aCols[n][nPPrUnit],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})*(1-(aCols[n][nPDescon]/100)),"C6_PRCVEN")
			aCols[n][nPPrcVen] := A410Arred(FtDescCab(aCols[n][nPPrUnit],{0})*(1-(aCols[n][nPDescon]/100)),"C6_PRCVEN")
			aCols[n][nPValor]  := A410Arred(aCols[n][nPPrcVen]*aCols[n][nQtdVen],"C6_VALOR",If(cPaisLoc=="CHI" .And. lPrcdec,M->C5_MOEDA,NIL))
			// Utiliza nPPrcVen
			aCols[n][nPValdesc]:= a410Arred((aCols[n][nPPrUnit]-aCols[n][nPPrcVen])*IIf(aCols[n][nQtdVen]==0,1,aCols[n][nQtdVen]),"C6_VALDESC")
		else
			IF Empty(aCols[n][cXModesc])	
				//Alert('Es Menor o igual')
				aCols[n][cXModesc]:=AllTrim(Str(aCols[n][nPDescon]))
				aCols[n][nPDescon]:=0
				aCols[n][nPValdesc]:=0
				
				MSGINFO( 'SI APLICA solo Descuento x Cabecera: '+ alltrim(str(nDescCab)) +' , NO APLICA Descuento x Item: '+alltrim(str(aCols[n][nPDescon])), "No aplica Descuento Sobre Descuento" )
				
				aCols[n][nPPrcVen] := A410Arred(FtDescCab(aCols[n][nPPrUnit],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})*(1-(aCols[n][nPDescon]/100)),"C6_PRCVEN")
				aCols[n][nPValor]  := A410Arred(aCols[n][nPPrcVen]*aCols[n][nQtdVen],"C6_VALOR",If(cPaisLoc=="CHI" .And. lPrcdec,M->C5_MOEDA,NIL))
				//aCols[n][nPValdesc]:= A410Arred((aCols[n][nPPrUnit]-aCols[n][nPPrcVen])*IIf(aCols[n][nQtdVen]==0,1,aCols[n][nQtdVen]),"C6_VALDESC")
			ENDIF
		endIF
		
	ENDIF
/*
ELSE
	//alert('bs')
	aCols[n][nPDescon]:=0
	aCols[n][nPValdesc]:=0
	//M->C5_DESC1:=0
	//M->C5_DESC4:=0
	aCols[n][nPPrcVen] := A410Arred(FtDescCab(aCols[n][nPPrUnit],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})*(1-(aCols[n][nPDescon]/100)),"C6_PRCVEN")
	aCols[n][nPValor]  := A410Arred(aCols[n][nPPrcVen]*aCols[n][nQtdVen],"C6_VALOR",If(cPaisLoc=="CHI" .And. lPrcdec,M->C5_MOEDA,NIL))	
	//aCols[n][nPDescon]:=0
	//aCols[n][nPValdesc]:=0
	//Ma410Rodap(oGetDad,aCols[n][nPValor],0)
ENDIF 
*/

/*Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })
Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
*/

Return(.T.)
