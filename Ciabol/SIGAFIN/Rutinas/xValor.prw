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
/*/                
//nvalor (valor a convertir), dDataori (fecha del movimiento)
//nMoeori (Moneda del Movimiento)  nMoneda (moneda a la que se quiere convertir)
//ntxMoeda (tasa de la operacion ) nVertasa (1,usa la tasa de la tabla SM2 buscando 
//con fecha=ddatabse / 2,usa como tasa ntxMoeda) 

User Function xValor( nValor, dDataOri, nMoeOri, nMoneda,nTxMoeda, nVerTasa)

Local aArea    := GetArea(),;
      aSM2     := SM2->(GetArea()) ,;
      nTipoMov := 2,;
      nTasaOri := 0.00 ,;
      nTasaDes := 0.00 ,;
      cCampoOri:= 'M2_MOEDA' + Alltrim( Str( nMoeOri, 1, 0 ) ) ,;
      cCampoDes:= 'M2_MOEDA' + Alltrim( Str( nMoneda, 1, 0 ) ) ,;
      nValRet  := 0.00      
     
   
     //msgstop("Entro a xvalor")
     //msgstop("nValor:" + str(nValor))
     //msgstop("dDataOri:" + dtos(dDataOri))
     //msgstop("nMoeOri:" + str(nMoeOri))
     //msgstop("nMoneda:"+ str(nMoneda))
     //msgstop("nTxMoeda:"+str(nTxMoeda))
     //msgstop("nVerTasa:"+str(nVertasa))
      
 

If ValType( nMoeOri ) != 'N' .or. nMoeOri < 1 .or. nMoeOri > 5
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
	SM2->(DbSeek( Iif( nVerTasa == 1, dDataBase, dDataOri ), .T. ))
   If !SM2->(Found())
      SM2->(DbSkip(-1))
   EndIf
 	nTasaDes := SM2->( FieldGet( FieldPos( cCampoDes ) ) )
EndIf

If nTasaDes != 0
   nValRet  := Round( nTasaOri * nValor / nTasaDes, 2 )
EndIf

RestArea( aSM2 )
RestArea( aArea )

Return( nValRet )
