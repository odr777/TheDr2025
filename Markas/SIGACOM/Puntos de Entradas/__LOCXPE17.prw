#include 'protheus.ch'
#include 'parmtype.ch'

     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³LOCXPE17  ºAuthor ³Jorge Saavedra      º Date ³  01/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada para la Validacion de las Lineas de los    º±±
±±º          ³Documentos de Entrada y Salida                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ BASE BOLIVIA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER FUNCTION LOCXPE17
Local nPosCOD	 
Local nPosLote
Local nPosTES
Local nPosItem
Local lRet := .T.

	//Hace un Refresh al MSGETDADOS en las Transferencias entre Sucursales de Salida
	If FUNNAME()== 'MATA462TN' .AND. AllTrim(cEspecie) $ 'RTS'.and.!GdDeleted()
		nPosCOD	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D2_COD"})
		nPosTES	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D2_TES"})
		nPosLote	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D2_LOTECTL"})
		nPosItem	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D2_ITEM"})
		//Valida que las Transferencias Entre Sucursales de Salida Utilicen la TES correcta (701)
		If aCols[n][nPosTES] != '701'
			Alert("El Item:" + AllTrim(aCols[n][nPosItem]) +" del Producto: " + AllTrim(aCols[n][nPosCOD]) + " NO tiene Asignado el Tipo de Salida 701")
			lRet := .F.
		EndIF
		If GetAdvFVal("SB1","B1_RASTRO",xFilial("SB1")+aCols[n][nPosCOD],1,"") $'L'.AND. empty(AllTrim(aCols[n][nPosLote]))
			Alert("El Item:" + AllTrim(aCols[n][nPosItem]) +" del Producto: " + AllTrim(aCols[n][nPosCOD]) + " NO tiene Asignado un Lote")
			lRet := .F.
		end
		oGetDados:oBrowse:Refresh()
	EndIf
	
	//Hace un Refresh al MSGETDADOS en las Transferencias entre Sucursales de Entrada
	If FUNNAME()== 'MATA462TN' .AND. AllTrim(cEspecie) $ 'RTE'.and.!GdDeleted()
		nPosCOD	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_COD"})
		nPosUbic	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_LOCALIZ"})
		nPosItem1	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_ITEM"})
		nPosTES1	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_TES"})
		//Valida que las Transferencias Entre Sucursales de Entrada Utilicen la TES correcta (301)
		If aCols[n][nPosTES1] != '301'
			Alert("El Item:" + AllTrim(aCols[n][nPosItem1]) +" del Producto: " + AllTrim(aCols[n][nPosCOD]) + " NO tiene Asignado el Tipo de Salida 301")
			lRet := .F.
		EndIF
		/*If GetAdvFVal("SB1","B1_LOCALIZ",xFilial("SB1")+aCols[n][nPosCOD],1,"") $'S'.AND. empty(AllTrim(aCols[n][nPosUbic]))
			Alert("El Item:" + AllTrim(aCols[n][nPosItem1]) +" del Producto: " + AllTrim(aCols[n][nPosCOD]) + " NO tiene Asignado una Ubicación")
			lRet := .F.
		EndIF*/
		
		oGetDados:oBrowse:Refresh()
	EndIf

	//Valida que los Productos que Controlan Lote,tengan uno Asignado	
	If FUNNAME()== 'MATA102N'.and.!GdDeleted()
		nPosCOD	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_COD"})
		nPosLote	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_LOTECTL"})
		nPosTES	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_TES"})
		nPosLocal	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_LOCAL"})
				
		IF Posicione("SB1",1,xFilial("SB1")+aCols[n][nPosCOD],"B1_RASTRO") == 'L' .AND. Empty(aCols[n][nPosLote])  
			Alert("Producto: " + AllTrim(aCols[n][nPosCOD]) + " NO tiene Asignado un Lote")
			lRet := .F.
		EndIf
		/*IF !EMPTY(M->F1_UALMACE)
			aCols[n][nPosLocal]:= M->F1_UALMACE
			oGetDados:oBrowse:Refresh()
		eNDIF
		*/
	EndIf
	
	//NT Punto de Entrada para validar que sólo se ingrese remitos con PC
	/*IF alltrim(FunName()) $ "MATA102N" .AND. M->F1_SERIE $ "REM/CER"
	nPosPedido	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_PEDIDO'     } )
		IF empty(aCols[n][nPosPedido])
			alert("No puede ingresar Remito/Certificación sin Pedido de Compras")
			lRet := .F.
		EndIf
	EndIf
	*/
	//NT Punto de Entrada para validar que la cantidad del remitos no sea mayor que el PC
	IF alltrim(FunName()) $ "MATA102N"
		If SF1->F1_ESPECIE $"RCN"
			nPosPedido	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_PEDIDO'     } )
			nPosItemPC	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_ITEMPC'     } )
			nPosQuant  := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_QUANT'     } )
			IF !empty(aCols[n][nPosPedido])
				aSC7 := GetAdvFVal("SC7",{"C7_QUJE", "C7_QUANT"},xFilial("SC7")+aCols[n][nPosPedido]+aCols[n][nPosItemPC],1,{"",""})
				IF aCols[n][nPosQuant] > aSC7[2]-aSC7[1]
					alert("No puede ingresar cantidad mayor al saldo del Pedido de Compra")
					lRet := .F.
				Endif
			EndIf
		ENDIF
	EndIf
	
return lRet 