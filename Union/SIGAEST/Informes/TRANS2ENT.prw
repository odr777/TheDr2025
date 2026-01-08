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
User Function TRANS2ENT()
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
		mv_par01 := SF1->F1_FILORIG
		mv_par02 := SF1->F1_FILIAL
		mv_par03 := SF1->F1_EMISSAO
		mv_par04 := SF1->F1_EMISSAO
		mv_par05 := SF1->F1_DOC
		mv_par06 := SF1->F1_DOC
		mv_par07 := SF1->F1_SERIE
		mv_par08 := SF1->F1_SERIE

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
	//oPrint:Setup()
	oPrint:SetPaperSize( DMPAPER_LETTER )

	wnRel:= "TRANSENT"
	wnrel:=SetPrint(cString,wnrel,"",@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
	RptStatus({|lEnd| IMPREP(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)  //SE IMPRIME EL REPORTE
	oPrint:Preview() //se visualiza previamente la impresion

Static  Function IMPREP(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)
	//Transaccion de ENTRADA Mercantil B1_UCODFABAB   15   B1_ESPECIF,B1_UESPEC2,B1_UMARCA,B1_UCODFAB
	cQuery := " SELECT F1_FILIAL,F1_DOC,F1_EMISSAO,F1_FORNECE,F1_LOJA,F1_FILORIG,F1_UCOBS,B1_DESC,D1_LOTECTL,D1_CUSTO,"
	cQuery += " D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_NUMSEQ,D1_UM,D1_PEDIDO,D1_ITEMORI,D1_NFORI ,F1_MOEDA,NNR.NNR_DESCRI as almdes,D1_VUNIT,D1_TOTAL,F1_SERIE,D1_LOCAL,D1_LOTECTL,D1_LOCALIZ,D1_NUMSERI,D1_NFORI,D1_SERIORI,F1_USRREG,B1_ESPECIF,B1_UESPEC2,B1_UMARCA,B1_UFABRIC B1_UCODFAB,D1_NUMLOTE ,D1_DTVALID  "//B2_QATU,B2_CM1  "
	cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
	cQuery += " JOIN " + RetSqlName("SD1") + " SD1 ON F1_DOC=D1_DOC AND F1_FILIAL=D1_FILIAL AND F1_SERIE=D1_SERIE AND D1_TIPODOC='64' AND D1_FORNECE=F1_FORNECE"
	cQuery += " AND SD1.D_E_L_E_T_!='*'"
	cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD=D1_COD AND SB1.D_E_L_E_T_!='*' "
	cQuery += " JOIN " + RetSqlName("NNR") + " NNR ON NNR.NNR_CODIGO=D1_LOCAL AND F1_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' "
	cQuery += " WHERE SF1.D_E_L_E_T_!='*'"
	cQuery += " AND F1_FILORIG = '"+trim(mv_par01)+"' AND F1_FILIAL = '"+trim(mv_par02)+"'"
	cQuery += " AND F1_EMISSAO Between '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
	cQuery += " AND F1_DOC Between '"+trim(mv_par05)+"' AND '"+trim(mv_par06)+"'"
	cQuery += " AND F1_SERIE Between '"+trim(mv_par07)+"' AND '"+trim(mv_par08)+"'"
	cQuery += " GROUP BY F1_FILIAL,F1_DOC,F1_EMISSAO,F1_FORNECE,F1_LOJA,F1_FILORIG,F1_UCOBS,B1_DESC,D1_UM,D1_CUSTO,D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_NUMSEQ,D1_PEDIDO,D1_ITEMORI,D1_NFORI,F1_MOEDA,NNR.NNR_DESCRI,D1_VUNIT,D1_TOTAL,F1_SERIE,D1_LOCAL,D1_LOTECTL,D1_LOCALIZ,D1_NUMSERI,D1_NFORI,D1_SERIORI,F1_USRREG,B1_ESPECIF,B1_UESPEC2,B1_UMARCA,B1_UFABRIC,D1_NUMLOTE,D1_DTVALID  "
	cQuery += " ORDER BY D1_ITEM "
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
	Local cFLogo := GetSrvProfString("Startpath","") + "logo_union.bmp"

	oPrint:StartPage()
	nNroCol 	:= 120
	nNroLin 	:= 60

	oPrint:SayBitmap(nNroLin,nNroCol-10,cFLogo,600,145)

	nNroLin += 60;	oPrint:Say(nNroLin,0850," TRANSFERENCIA DE STOCK (ENTRADA)" ,oFontTitn)
	nNroLin	+= 80
	oPrint:Say( nNroLin, nNroCol-10,  ORDENESENT->F1_FILIAL  + " " + alltrim(SM0->M0_NOMECOM) , oFontSTitn)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"DOCUMENTO:" + ORDENESENT->F1_SERIE + " - "	+ ORDENESENT->F1_DOC,oFont10n)

	oPrint:Say(nNroLin,1400,"FECHA: "+ ffechalatin(ORDENESENT->F1_EMISSAO) 	,oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"SUCURSAL DE ORIGEN: " + ORDENESENT->F1_FILORIG + "-" + alltrim(GETADVFVAL("SM0","M0_FILIAL","01"+ORDENESENT->F1_FILORIG,1,"")),oFont10n)
	oPrint:Say(nNroLin,1400,"DEPOSITO DE ORIGEN: " + alltrim(POSICIONE('NNR',1,ORDENESENT->F1_FILORIG+ Posicione("SD2",3,ORDENESENT->F1_FILORIG+ORDENESENT->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+D1_COD),"D2_LOCAL"),'NNR_DESCRI')) + " - " +alltrim(Posicione("SD2",3,ORDENESENT->F1_FILORIG+ORDENESENT->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+D1_COD),"D2_LOCAL")),oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"SUCURSAL DE DESTINO: "	+ ORDENESENT->F1_FILIAL + "-" + alltrim(GETADVFVAL("SM0","M0_FILIAL","01"+ORDENESENT->F1_FILIAL,1,"")),oFont10n)
	oPrint:Say(nNroLin,1400,"DEPOSITO DE DESTINO: " + 	alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ ORDENESENT->D1_LOCAL,'NNR_DESCRI')) + " - " +alltrim(ORDENESENT->D1_LOCAL)	,oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"REGISTRADO POR: " +	upper(ORDENESENT->F1_USRREG ),oFont10n)
	oPrint:Say(nNroLin,1400,"IMPRESO POR: " + SUBSTR(CUSERNAME,1,15),oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"OBSERVACIONES: " +	SUBSTR(ORDENESENT->F1_UCOBS,1,40) ,oFont10n)
	oPrint:Say(nNroLin,01400,"FECHA DE IMPRESIÓN: " + ffechalatin(Dtos(date())),oFont10n)
	nNroLin	+= 80; oPrint:Say(nNroLin,0120,	SUBSTR(ORDENESENT->F1_UCOBS,40,120) ,oFont10n)
	nNroLin	+= 60

	oPrint:Say(nNroLin+40,0120,"CODIGO",oFont10n)
	oPrint:Say(nNroLin+40,0270,"DESCRIPCION",oFont10n)
	oPrint:Say(nNroLin+40,1000,"FABR",oFont10n)
	oPrint:Say(nNroLin+40,1170,"UM",oFont10n)
	oPrint:Say(nNroLin+40,1280,"CANTIDAD",oFont10n)
	oPrint:Say(nNroLin+40,1580,"LOTE",oFont10n)
	oPrint:Say(nNroLin+40,1800,"SUBLOTE",oFont10n)
	oPrint:Say(nNroLin+40,2000,"UBICACION",oFont10n)
	oPrint:Say(nNroLin+40,2250,"VALIDEZ",oFont10n)
	nNroLin+=100
	oPrint:Line(nNroLin, 120, nNroLin, 2450)

return

Static Function fImpPie()

	//NotaMercantil := "AV VIEDMA No 51 Z/CEMENTERIO GENERAL -SANTA CRUZ - BOLIVIA - TELEFS: (+591) 3 3326174 / 3 3331447 / 3 3364244 - FAX: 3 3368672"
	//oPrint:Say(3120,0120, NotaMercantil ,oFont08)
	oPrint:EndPage()
return
Static Function FImpFirmas()
	nNroLin	+= 10
	oPrint:Line(nNroLin, 120, nNroLin, 2450)
	nNroLin	+= 280
	oPrint:Line( nNroLin, 0280, nNroLin, 0780)
	oPrint:Line( nNroLin, 1280, nNroLin, 1780)
	oPrint:Say(nNroLin+50,0300,CUSERNAME,oFont09n)
	oPrint:Say(nNroLin+50,1300,"Firma Autorizada",oFont09n)
return
Static Function FImpItems()
	nNroLinAnterior := nNroLin // para dibujar el contorno de los items

	oPrint:Say(nNroLin,0120,ORDENESENT->D1_COD,oFont09)
	oPrint:Say(nNroLin,0270,SubStr(ORDENESENT->B1_DESC,1,30),oFont09)
	oPrint:Say(nNroLin,1000,ORDENESENT->B1_UCODFAB,oFont09)
	oPrint:Say(nNroLin,1170,ORDENESENT->D1_UM,oFont09)
	oPrint:Say(nNroLin,1280, TRANSFORM(ORDENESENT->D1_QUANT,"@E 999,999.99"),oFont09)
	oPrint:Say(nNroLin,1580,ORDENESENT->D1_LOTECTL,oFont09)
	oPrint:Say(nNroLin,1800,ORDENESENT->D1_NUMLOTE,oFont09)
	oPrint:Say(nNroLin,2000,POSICIONE("SDB",1,ORDENESENT->F1_FILIAL+ORDENESENT->D1_COD+ORDENESENT->D1_LOCAL+ORDENESENT->D1_NUMSEQ+ORDENESENT->F1_DOC,"DB_LOCALIZ"),oFont09)
	oPrint:Say(nNroLin,2250,DTOC(STOD(ORDENESENT->D1_DTVALID)),oFont09)

	/*
	oPrint:Say(nNroLin,0120,ORDENESENT->D2_COD,oFont09)
	oPrint:Say(nNroLin,0270, SubStr(ORDENESENT->B1_DESC,1,30) ,oFont09)
	oPrint:Say(nNroLin,1000,ORDENESENT->B1_UCODFAB,oFont09)
	oPrint:Say(nNroLin,1170,ORDENESENT->D2_UM,oFont09)
	oPrint:Say(nNroLin,1280,TRANSFORM(ORDENESENT->D2_QUANT,"@E 999,999.99"),oFont09)
	oPrint:Say(nNroLin,1580,ORDENESENT->D2_LOTECTL,oFont09)
	oPrint:Say(nNroLin,1800,ORDENESENT->D2_NUMLOTE,oFont09)
	oPrint:Say(nNroLin,2000,ORDENESENT->D2_LOCALIZ,oFont09)
	oPrint:Say(nNroLin,2250,DTOC(STOD(ORDENESENT->D2_DTVALID)),oFont09)
	*/
	nNroLin += 40

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