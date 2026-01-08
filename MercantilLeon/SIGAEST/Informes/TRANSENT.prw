#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"        

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  TRANSENT  ºAutor  ³Nahim Terrazas        Fecha 20/04/2016   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ Nota de ingreso a inventario (Entrada) con lotes           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil Leon                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TRANSENT()
Local cString  		:= "SF1"        // Alias do arquivo principal (Base)
Local cDesc1   		:= "Este Informe tiene como Objetivo"
Local cDesc2   		:= "Imprimir transacciones entre sucursal"
Local cDesc3   		:= "de Entrada."
Local aPerAberto	:= {}
Local aPerFechado	:= {}
Local aPerTodos		:= {}
Local cSavAlias,nSavRec,nSavOrdem
Local cQuery 		:= ""   
PRIVATE cPerg    := "TRANSENT"
Private nNroPag 	:= 0
Private nNroLin 	:= 60
Private nNroCol 	:= 120
Private nTamCar 	:= 15   //Tamaño del Caracter (Cantidad de Pixeles por Caracter)
Private NTotalGs 	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {"A rayas", 1,"Administracion", 1, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private nLastKey := 0
PRIVATE titulo   := "TRANSFERENCIA DE STOCK (ENTRADA)"
PRIVATE tamanho  := "P"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oFont08, oFont08n, oFont09, oFont10n, oFont28n, oFont09n
Private oPrint

ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO
GraContPert()	 //ajusta la SX1

 If AllTrim(Funname()) == 'MATA462TN'
 	Pergunte(cPerg,.F.)
 Else
 	Pergunte(cPerg,.T.)
 Endif
 
oFont09		:= TFont():New("Courier New",09,09,,.F.,,,,.T.,.F.)
oFont09n	:= TFont():New("Courier New",09,09,,.T.,,,,.T.,.F.)  //negrito
oFont28n	:= TFont():New("Times New Roman",28,28,,.T.,,,,.T.,.F.)    //Negrito
oFont08		:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFont08n	:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)		//Negrito
oFont10		:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont10n	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)     //negrito
oFont11		:= TFont():New("Courier New",11,11,,.F.,,,,.T.,.F.)
oFont11n	:= TFont():New("Courier New",11,11,,.T.,,,,.T.,.F.)		//negrito
oFont12		:= TFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)
oFont12n	:= TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)		//negrito
oFontSTit	:= TFont():New("Courier New",14,14,,.F.,,,,.T.,.F.)
oFontSTitn	:= TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)		//negrito
oFontTit	:= TFont():New("Courier New",17,17,,.F.,,,,.T.,.F.)
oFontTitn	:= TFont():New("Courier New",17,17,,.T.,,,,.T.,.F.)		//negrito


oPrint 	:= TMSPrinter():New("Transferencia de Stock")
oPrint:SetPortrait()
oPrint:Setup()  
oPrint:SetPaperSize( DMPAPER_LETTER )

 wnRel:= "TRANSENT"
 wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
 RptStatus({|lEnd| IMPREP(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)  //SE IMPRIME EL REPORTE	
 oPrint:Preview() //se visualiza previamente la impresion
 
 Static  Function IMPREP(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3) 
 	//Transaccion de ENTRADA Mercantil B1_UCODFABAB   15   B1_ESPECIF,B1_UESPEC2,B1_UMARCA,B1_UCODFAB
	cQuery := "select F1_DOC,F1_EMISSAO,F1_FILORIG,B1_DESC,D1_LOTECTL,D1_CUSTO,"
	cQuery += "D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_UM,D1_PEDIDO,D1_ITEMORI,D1_NFORI ,F1_MOEDA,NNR.NNR_DESCRI as almdes,D1_VUNIT,D1_TOTAL,F1_SERIE,D1_LOCAL,D1_LOTECTL,D1_LOCALIZ,D1_NUMSERI,D1_NFORI,D1_SERIORI,F1_USRREG,B1_ESPECIF,B1_UESPEC2,B1_UDESCMA,B1_UMARCA,B1_UCODFAB  "//B2_QATU,B2_CM1  "
	cQuery += "from " + RetSqlName("SF1") + " SF1 "     
	cQuery += "inner Join " + RetSqlName("SD1") + " SD1 on F1_DOC=D1_DOC and F1_FILIAL=D1_FILIAL and F1_SERIE=D1_SERIE and D1_TIPODOC='64' AND D1_FORNECE=F1_FORNECE" 
	cQuery += " and F1_FILORIG = '"+trim(mv_par01)+"' AND F1_FILIAL = '"+trim(mv_par02)+"'"
	cQuery += " and F1_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
	cQuery += " and F1_DOC Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
	cQuery += " and F1_SERIE Between '"+trim(mv_par07)+"' and '"+trim(mv_par08)+"'"
	cQuery += " AND SD1.D_E_L_E_T_!='*'"
	cQuery += "inner Join " + RetSqlName("SB1") + " SB1 on B1_COD=D1_COD AND SB1.D_E_L_E_T_!='*' "
	cQuery += "inner Join " + RetSqlName("NNR") + " NNR on NNR.NNR_CODIGO=D1_LOCAL and F1_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' AND SF1.D_E_L_E_T_!='*'"
	cQuery += " group by F1_DOC,F1_EMISSAO,F1_FILORIG,B1_DESC,D1_UM,D1_CUSTO,D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_PEDIDO,D1_ITEMORI,D1_NFORI,F1_MOEDA,NNR.NNR_DESCRI,D1_VUNIT,D1_TOTAL,F1_SERIE,D1_LOCAL,D1_LOTECTL,D1_LOCALIZ,D1_NUMSERI,D1_NFORI,D1_SERIORI,F1_USRREG,B1_ESPECIF,B1_UESPEC2,B1_UDESCMA,B1_UMARCA,B1_UCODFAB  "
	cQuery += " order by D1_ITEM " 
 TCQUERY cQuery NEW ALIAS "ORDENESENT" 
 
 fImpCab() // imprime la cabecera 
 numero := 0
 controlador := ORDENESENT->F1_DOC
 while 	ORDENESENT->(!EOF()) // mientras sigan existiendo items
 FImpItems()   // imprime items
 if(nNroLin > 2700 .OR. ORDENESENT->F1_DOC !=  controlador) // si los items superan el tamaño de la hoja
 fImpPie() // imprime el pie y salta de pagina
 fImpCab() // imprime cabecera de nuevo
 endif
 ORDENESENT->(dbSkip()) // avanza de registra
 enddo
 FImpFirmas() // imprime firmas
 fImpPie() // imprime pie de pagina
ORDENESENT->(DbCloseArea())
Return NIL
Return  

Static Function fImpCab() 
	pesototal := getpesototal() 
	oPrint:StartPage() 			//Inicia uma nova pagina
	nNroCol 	:= 120
	cFLogo 		:= GetSrvProfString("Startpath","") + "/logomercantil.bmp"
	nNroLin 	:= 60
	oPrint:SayBitmap(nNroLin,nNroCol-10,cFLogo,675,135)
	nNroLin += 60;	oPrint:Say(nNroLin,0850," TRANSFERENCIA DE STOCK (ENTRADA)" ,oFontTitn)
	nNroLin	+= 80
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"DOCUMENTO: TRF - "	+ ORDENESENT->F1_DOC,oFont10n)		
			
	oPrint:Say(nNroLin,1400,"FECHA: "+ ffechalatin(ORDENESENT->f1_EMISSAO) 	,oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"SUCURSAL DE ORIGEN: " + ORDENESENT->F1_FILORIG,oFont10n)			
	oPrint:Say(nNroLin,1400,"DEPOSITO DE ORIGEN: " + POSICIONE('NNR',1,XFILIAL('NNR')+ Posicione("SD2",3,ORDENESENT->F1_FILORIG+ORDENESENT->(D1_NFORI+D1_SERIORI),"D2_LOCAL"),'NNR_DESCRI')	,oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"SUCURSAL DE DESTINO: "	+ Right(CNUMEMP,2) ,oFont10n)			
	oPrint:Say(nNroLin,1400,"DEPOSITO DE DESTINO: " + 	POSICIONE('NNR',1,XFILIAL('NNR')+ ORDENESENT->D1_LOCAL,'NNR_DESCRI'))
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"ELABORADO POR: " +	upper(ORDENESENT->F1_USRREG ),oFont10n)			
	oPrint:Say(nNroLin,1400,"IMPRESO POR: " + SUBSTR(CUSERNAME,1,15),oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"FECHA DE IMPRESIÓN: " + ffechalatin(Dtos(date())),oFont10n)			
	oPrint:Say(nNroLin,1400,"PESO NETO: " + TRANSFORM(pesototal,"@E 999,999.99"),oFont10n)
	nNroLin	+= 80;
	
	oPrint:Box ( nNroLin, 0100, nNroLin+100, 2350) //recuadro cabecera
// lineas de separacion
	oPrint:Line( nNroLin, 0230, nNroLin+100, 0230) 
	oPrint:Line( nNroLin, 0550, nNroLin+100, 0550)
	oPrint:Line( nNroLin, 0870, nNroLin+100, 0870) //entre prov y descri original 0650 aumento 220
//	oPrint:Line( nNroLin, 1820, nNroLin+100, 1820)	
	oPrint:Line( nNroLin, 1950, nNroLin+100, 1950)
	oPrint:Line( nNroLin, 2050, nNroLin+100, 2050)
// aumenta 30 para imprimir el texto
	oPrint:Say(nNroLin+30,0130,"ITEM",oFont10n)	
	oPrint:Say(nNroLin+15,0280,"CODIGO",oFont10n)	
	oPrint:Say(nNroLin+60,0300,"ML",oFont10n)	
	oPrint:Say(nNroLin+15,0600,"CODIGO",oFont10n)	
	oPrint:Say(nNroLin+60,0560,"PROVEEDOR",oFont10n)	
	oPrint:Say(nNroLin+40,0980,"DESCRIPCION",oFont10n)	
//	oPrint:Say(nNroLin+40,1830,"MARCA",oFont10n)	
	oPrint:Say(nNroLin+40,1980,"UM",oFont10n)	
	oPrint:Say(nNroLin+40,2100,"CANTIDAD",oFont10n)
    nNroLin+=100	
return nil
	
return

Static Function fImpPie()
	
	NotaMercantil := "AV VIEDMA No 51 Z/CEMENTERIO GENERAL -SANTA CRUZ - BOLIVIA - TELEFS: (+591) 3 3326174 / 3 3331447 / 3 3364244 - FAX: 3 3368672"
	oPrint:Say(3120,0120, NotaMercantil ,oFont08)		
	oPrint:EndPage()
return nil
return
Static Function FImpFirmas()
	oPrint:Line( 2850, 0280, 2850, 0780)
	oPrint:Line( 2850, 1280, 2850, 1780)
	oPrint:Say(2900,0300,"RESP. ALMACEN SALIDA",oFont09n)
	oPrint:Say(2900,1300,"RESP. ALMACEN ENTRADA",oFont09n)			
return nil
return
Static Function FImpItems()
	nNroLinAnterior := nNroLin // para dibujar el contorno de los items
	Sprueba:= "Descripcion prueba hasta aqui llegara esto solo es una prueba para ver hasta donde llega"
//imprimir datos	
// Especifica	B1_ESPECIF B1_UESPEC2
	oPrint:Say(nNroLin,0130,ORDENESENT->D1_ITEM,oFont09)	
	oPrint:Say(nNroLin,0235,ORDENESENT->D1_COD,oFont09)	
	oPrint:Say(nNroLin,0560,ORDENESENT->B1_UCODFAB,oFont09)
//	oPrint:Say(nNroLin,1830,ORDENESENT->B1_UMARCA,oFont09)	
	oPrint:Say(nNroLin,1980,ORDENESENT->D1_UM,oFont09)	
	oPrint:Say(nNroLin,2100, TRANSFORM(ORDENESENT->D1_QUANT,"@E 999,999.99"),oFont09)
	oPrint:Say(nNroLin,0900,SUBSTR(ORDENESENT->B1_ESPECIF,1,45),oFont09)		
	if len(alltrim(ORDENESENT->B1_ESPECIF))>45  //ORDENESENT->B1_ESPECIF
	nNroLin+= 30
	oPrint:Say(nNroLin,0900,alltrim(SubStr(ORDENESENT->B1_ESPECIF,46,80)),oFont09)	
	endif
// Especifica2
	if !Empty(ORDENESENT->B1_UESPEC2) //ORDENESENT->B1_UESPEC2
		nNroLin+= 40
		oPrint:Say(nNroLin,0900,alltrim(SubStr(ORDENESENT->B1_UESPEC2,1,45)),oFont09)	
		if len(alltrim(ORDENESENT->B1_UESPEC2))>45
			nNroLin+= 30
			oPrint:Say(nNroLin,0900,alltrim(SubStr(ORDENESENT->B1_UESPEC2,46,80)),oFont09)	
		endif
	endif
// lote
	if !Empty(ORDENESENT->D1_LOTECTL)//ORDENESENT->D2_LOTECTL
	nNroLin += 40
	oPrint:Say(nNroLin,0900,ORDENESENT->D1_LOTECTL,oFont09)	
	endif
// marca
	if !Empty(ORDENESENT->B1_UMARCA)//Codigo de marca
	if !Empty(ORDENESENT->B1_UDESCMA)// Marca descripcion
	nNroLin += 40
	oPrint:Say(nNroLin,0900,ORDENESENT->B1_UMARCA + "   " + ORDENESENT->B1_UDESCMA,oFont09)	
	endif
	endif
	nNroLin += 40
	oPrint:Box ( nNroLinAnterior, 0100, nNroLin, 2350) //recuadro cabecera
// lineas de separacion
	oPrint:Line( nNroLinAnterior, 0230, nNroLin, 0230) 
	oPrint:Line( nNroLinAnterior, 0550, nNroLin, 0550)
	oPrint:Line( nNroLinAnterior, 0870, nNroLin, 0870)
//	oPrint:Line( nNroLinAnterior, 1820, nNroLin, 1820)	
	oPrint:Line( nNroLinAnterior, 1950, nNroLin, 1950)
	oPrint:Line( nNroLinAnterior, 2050, nNroLin, 2050)
return nil
return
Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{"01","De Sucursal Origen      :","mv_ch1","C",4,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,"SM0",""})
aAdd(aRegs,{"02","A Sucursal Destino      :","mv_ch2","C",4,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"SM0",""})
aAdd(aRegs,{"03","De Fecha de Emisión     :","mv_ch3","D",08,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"04","A Fecha de Emisión      :","mv_ch4","D",08,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"05","De Nro. Documento       :","mv_ch5","C",20,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"06","A Nro. Documento        :","mv_ch6","C",20,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"07","De Serie                :","mv_ch7","C",20,0,0,"G","mv_par07",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"08","A Serie                 :","mv_ch8","C",20,0,0,"G","mv_par08",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"09","De Proveedor            :","mv_ch9","C",20,0,0,"G","mv_par09",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"10","A Proveedor             :","mv_ch10","C",20,0,0,"G","mv_par10",""       ,""            ,""        ,""     ,"",""})

dbSelectArea("SX1")
dbSetOrder(1)
For i:=1 to Len(aRegs)
   dbSeek(cPerg+aRegs[i][1])
   If !Found()
      RecLock("SX1",!Found())
         SX1->X1_GRUPO    := cPerg
         SX1->X1_ORDEM    := aRegs[i][01]
         SX1->X1_PERSPA   := aRegs[i][02]
         SX1->X1_VARIAVL  := aRegs[i][03]
         SX1->X1_TIPO     := aRegs[i][04]
         SX1->X1_TAMANHO  := aRegs[i][05]
         SX1->X1_DECIMAL  := aRegs[i][06]
         SX1->X1_PRESEL   := aRegs[i][07]
         SX1->X1_GSC      := aRegs[i][08]
         SX1->X1_VAR01    := aRegs[i][09]
         SX1->X1_DEFSPA1    := aRegs[i][10]
         SX1->X1_DEFSPA2    := aRegs[i][11]
         SX1->X1_DEFSPA3    := aRegs[i][12]
         SX1->X1_DEFSPA4    := aRegs[i][13]
         SX1->X1_F3       := aRegs[i][14]
         SX1->X1_VALID    := aRegs[i][15]            
      MsUnlock()
   Endif
Next

Return    
  
Return

Static Function ffechalatin(sfechacorta)
     
Local ffechalatin:=""             
Local sdia:=substr(sfechacorta,7,2)
Local smes:=substr(sfechacorta,5,2)
Local sano:=substr(sfechacorta,0,4)
ffechalatin := sdia + "/" + smes + "/" + sano
Return(ffechalatin)    


Static Function GraContPert()

SX1->(DbSetOrder(1))
If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"01"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_FILORIG       //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_FILIAL          //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End               

If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SF1->F1_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SF1->F1_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
                                   
If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"05"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_DOC      //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"06"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_DOC        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End     

If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"07"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_SERIE      //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"08"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_SERIE        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
     
Return
Static function GetPesoTotal
local peso := 0
	cQuery := "select D1_PESO  "
	cQuery += "from " + RetSqlName("SF1") + " SF1 "     
	cQuery += "inner Join " + RetSqlName("SD1") + " SD1 on F1_DOC=D1_DOC and F1_FILIAL=D1_FILIAL and F1_SERIE=D1_SERIE and D1_TIPODOC='64' AND D1_FORNECE=F1_FORNECE" 
	cQuery += " and F1_FILORIG = '"+trim(mv_par01)+"' AND F1_FILIAL = '"+trim(mv_par02)+"'"
	cQuery += " and F1_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
	cQuery += " and F1_DOC Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
	cQuery += " and F1_SERIE Between '"+trim(mv_par07)+"' and '"+trim(mv_par08)+"'"
	cQuery += " AND SD1.D_E_L_E_T_!='*'"
	cQuery += "inner Join " + RetSqlName("SB1") + " SB1 on B1_COD=D1_COD AND SB1.D_E_L_E_T_!='*' "
	cQuery += "inner Join " + RetSqlName("NNR") + " NNR on NNR.NNR_CODIGO=D1_LOCAL and F1_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' AND SF1.D_E_L_E_T_!='*'"
	cQuery += " order by D1_ITEM " 
 TCQUERY cQuery NEW ALIAS "ORDENESPESO" 
  while 	OrdenesPeso->(!EOF()) // mientras sigan existiendo items
  peso +=	OrdenesPeso->D1_PESO
	OrdenesPeso->(dbSkip()) // avanza de registra
  enddo
OrdenesPeso->(DbCloseArea())
return peso
