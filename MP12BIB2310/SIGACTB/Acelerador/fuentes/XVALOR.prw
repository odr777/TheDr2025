#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PegaTasa ³ Autor ³ Diego Fernando Rivero ³ Data ³ 26/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Retorna la tasa de un d¡a determinado                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Microsiga Argentina....                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
NValor: Valor en moneda orginal
dDataOri: Fecha del tipo de cambio que se quiere tomar
nMoeOri: que tipo de cambio de que moneda se va a utilizar para obtener el resultado
nMoneda: en que moneda se quiere obtener el resultado que se pasa
nVerTasa: 1= Calcula en base a la tasa de cambio actual 0= calcula en base al tipo de cambio historico.
nTxMoeda: Siempre 0, salvo que se quiera indicar una Tasa especifica que se quiere tomar para convertir el valor "Nvalor"

/*/
User Function xValor( nValor, dDataOri, nMoeOri, nMoneda, nVerTasa, nTxMoeda )
Local aArea    := GetArea(),;
aSM2     := SM2->(GetArea()) ,;
nTipoMov := 2,;
nTasaOri := 0.00 ,;
nTasaDes := 0.00 ,;
cCampoOri:= 'M2_MOEDA' + Alltrim( Str( nMoeOri, 1, 0 ) ) ,;
cCampoDes:= 'M2_MOEDA' + Alltrim( Str( nMoneda, 1, 0 ) ) ,;
nValRet  := 0.00

If ValType( nMoeOri ) != 'N' .or. nMoeOri < 1 .or. nMoeOri > moedfin()
	MsgAlert( 'Alguna de las Moneda es incorrecta!', 'Verificar Datos' )
	Return( 0 ) 
EndIf
                                     

SM2->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Si la moneda del documento es la misma que la pedida en el   ³
//³ informe, o si el Tipo de Movimiento pedido es Solo Movi-     ³
//³ mientos en moneda...                                         ³
//³ Retorno el mismo valor del Documento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Round( nMoeOri, 0 ) == Round( nMoneda, 0 ) ) .or. ( nTipoMov == 1 )
	RestArea( aSM2 )
	RestArea( aArea )
	Return( nValor )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Si la moneda del Documento es 1, dejo establezco que la tasa ³
//³ es 1, sino, busco la tasa teniendo en cuenta si es Hist¢rica ³
//³ o Actual                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Round( nMoeOri, 0 ) == 1
	nTasaOri := 1
Else
	If !Empty( nTxMoeda ) .and. nVerTasa == 2
		nTasaOri := nTxMoeda
	Else
		SM2->(DbSeek( Iif( nVerTasa == 1, dDataBase, dDataOri ), .T. ))
		If !SM2->(Found())
			SM2->(DbSkip(-1))
		EndIf
		nTasaOri := SM2->( FieldGet( FieldPos( cCampoOri ) ) )
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Si la moneda del Informe es 1, dejo establezco que la tasa   ³
//³ es 1, sino, busco la tasa teniendo en cuenta si es Hist¢rica ³
//³ o Actual                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Round( nMoneda, 0 ) == 1
	nTasaDes := 1
Else
   If !Empty( nTxMoeda ) .and. nVerTasa == 2
      nTasaDes := nTxMoeda
   Else
      SM2->(DbSeek( Iif( nVerTasa == 1, dDataBase, dDataOri ), .T. ))
      If !SM2->(Found())
         SM2->(DbSkip(-1))
      EndIf
      nTasaDes := SM2->( FieldGet( FieldPos( cCampoDes ) ) )
   EndIf
EndIf

If nTasaDes != 0
	nValRet  := Round( nTasaOri * nValor / nTasaDes, 2 )
EndIf

RestArea( aSM2 )
RestArea( aArea )  
Return( nValRet )          
