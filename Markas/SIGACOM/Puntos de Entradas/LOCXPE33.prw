#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³LOCXPE33  ºAuthor ³Jorge Saavedra           º Date ³  12/17/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Define  campos de que deben ser visuales o obligados       ³±±
±±³          ³ conforme la rutina ejecutada. Ej: MATA102N Campo Almacen como³±±
±±³          ³ visual..                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ BASE BOLIVIA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function LOCXPE33()

Local aCposNF := ParamIxb[1]
Local nTipo := ParamIxb[2]
Local aDetalles := {}
Local nNuevoElem := 0
Local nPosCpo := 0
Local nL

/*
If nTipo == 1 .and. Alltrim(Funname())="MATA467N" // Factura de Ventas
	//    Detalles,      Campo      Usado  Obligatorio  Visual
	AADD(aDetalles,{"F2_UAUTPRC"  ,  .T.      ,.F.      ,.F.   }) // Numero de Autorizaciòn para Producto Controlado
EndIf

iF nTipo == 64 //Transferencia entre Sucursales - Entrada                             
    // AADD(aDetalles,{"F1_UALMACE"  ,  .F.      ,.F.      ,.F.   }) 
//     AADD(aDetalles,{"F1_TXMOEDA"  ,  .F.      ,.F.      ,.F.   }) 
     //AADD(aDetalles,{"F1_DIACTB"  ,  .F.      ,.F.      ,.F.   })
     AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })      
End                   
*/                                                                
If nTipo == 54 //Transferencia entre Sucursales - Salida                             
   /*  AADD(aDetalles,{"F2_UALMACE"  ,  .T.      ,.T.      ,.F.   }) 
     AADD(aDetalles,{"F2_UALMDES"  ,  .T.      ,.T.      ,.F.   })  
//	 AADD(aDetalles,{"F2_REFTAXA"  ,  .F.      ,.F.      ,.F.   })  
     AADD(aDetalles,{"F2_REFMOED"  ,  .F.      ,.F.      ,.F.   })  
     AADD(aDetalles,{"F2_UTRANSP"  ,  .T.      ,.T.      ,.F.   })*/
     AADD(aDetalles,{"F2_USRREG "  ,  .T.      ,.F.      ,.T.   })
     
End   
/*
//If nTipo == 50 //Remito de Venta                             
     
//End                     

If nTipo == 60 .or. nTipo = 14 //Remito de Entrada o Conocimiento de Flete
    /*AADD(aDetalles,{"F1_UALMACE"  ,  .T.      ,.T.      ,.F.   }) 
     AADD(aDetalles,{"F1_UCORREL"  ,  .T.      ,.F.      ,.F.   })
     AADD(aDetalles,{"F1_SERIE"  ,  .T.      ,.T.      ,.F.   })
     AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
     AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
End

if  nTipo == 13 //Gastos de Importación 
//	  AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
//	  AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	  AADD(aDetalles,{"F1_HAWB"  ,  .T.      ,.F.      ,.F.   })
End

*/
If nTipo == 10 .or. nTipo == 13 //Factura de Entrada                             
/*
     AADD(aDetalles,{"F1_UNOMBRE"  ,  .T.      ,.F.      ,.F.   }) 
     AADD(aDetalles,{"F1_UNIT"  ,  .T.      ,.F.      ,.F.   })
	//AADD(aDetalles,{"F1_SERIE"  ,  .T.      ,.T.      ,.F.   }) 
	//AADD(aDetalles,{"F1_UDESCON"  ,  .T.      ,.F.      ,.F.   }) 
	AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
	AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	AADD(aDetalles,{"F1_UTPCOMP"  ,  .T.      ,.T.      ,.F.   })
	AADD(aDetalles,{"F1_UDUI"  ,  .T.      ,.F.      ,.F.   })
*/
	  AADD(aDetalles,{"F1_HAWB"  ,  .T.      ,.F.      ,.F.   })
End       

For nL := 1 To Len(aDetalles)
	If (nPosCpo := Ascan(aCposNF,{|x| x[2] == aDetalles[nL][1] })) > 0

		aCposNF[nPosCpo][13] := aDetalles[nL][3] 				   // Obligatorio
		If Len(aCposNF[nPosCpo]) == 16
			//aIns(aCposNF[nPosCpo],17)
			SX3->(DbSetOrder(2))
			SX3->(DbSeek(AllTrim(aDetalles[nL][1])))
			aCposNF[nPosCpo] := {X3Titulo(),X3_CAMPO,,,,,,,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.")}
		EndIf
		aCposNF[nPosCpo][17] := If(aDetalles[nL][4],".F.",".T.")   // Desabilita el campo
		If !aDetalles[nL][2]
			ADel(aCposNF,nPosCpo) 								   // Quita el campo
			ASize(aCposNF,Len(aCposNF)-1)                          // Ajusta Array
		EndIf
	Else
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek( aDetalles[nL][1] )
			nNuevoElem := Len(aCposNF)+1
			aCposNF := aSize(aCposNF,nNuevoElem)
			aIns(aCposNF,nNuevoElem)
			aCposNF[nNuevoElem] := {X3Titulo(),X3_CAMPO,,,,,,,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.")}
		EndIf
	EndIf
	
Next nL
   
Return( aCposNF )
