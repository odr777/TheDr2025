#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  TRANS2SAL  ºAutor  ³Nahim Terrazas        Fecha 20/04/2016º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ Nota de ingreso a inventario (salida) con lotes            º±±
±±º          ³ sin logo                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Union Agronegocios                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TRANS2SAL()
	Local cString  		:= "SF2"        // Alias do arquivo principal (Base)
	Local cDesc1   		:= "Este Informe tiene como Objetivo"
	Local cDesc2   		:= "Imprimir transacciones entre sucursal"
	Local cDesc3   		:= "de salida."
	Local aPerAberto	:= {}
	Local aPerFechado	:= {}
	Local aPerTodos		:= {}
	Local cSavAlias,nSavRec,nSavOrdem
	Local cQuery 		:= ""
	PRIVATE cPerg    := "TRANSSAL"
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
	PRIVATE titulo   := "TRANSFERENCIA DE STOCK (SALIDA)"
	PRIVATE tamanho  := "P"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oFont08, oFont08n, oFont09, oFont10n, oFont28n, oFont09n
	Private oPrint

	ValidPerg()	// CARGAMOS LAS PREGUNTAS POR CODIGO
	GraContPert()	 //ajusta la SX1

	If AllTrim(Funname()) == 'MATA462TN'
		Pergunte(cPerg,.F.)

		mv_par01 := SF2->F2_FILDEST
		mv_par02 := SF2->F2_FILIAL
		mv_par03 := SF2->F2_EMISSAO
		mv_par04 := SF2->F2_EMISSAO
		mv_par05 := SF2->F2_DOC
		mv_par06 := SF2->F2_DOC
		mv_par07 := SF2->F2_SERIE
		mv_par08 := SF2->F2_SERIE
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

	//		mv_par01 := SF2->F2_FILDEST
	//		mv_par02 := SF2->F2_FILDEST
	//		mv_par03 := SF2->F2_EMISSAO
	//		mv_par04 := SF2->F2_EMISSAO
	//		mv_par05 := SF2->F2_DOC
	//		mv_par06 := SF2->F2_DOC
	//		mv_par07 := SF2->F2_SERIE
	//		mv_par08 := SF2->F2_SERIE

	oPrint 	:= TMSPrinter():New("Transferencia de Stock")
	oPrint:SetPortrait()
	//oPrint:Setup()
	oPrint:SetPaperSize( DMPAPER_LETTER )
	wnRel:= "TRANSSAL"
	wnrel:=SetPrint(cString,wnrel,"",@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
	RptStatus({|lEnd| IMPREP(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)  //SE IMPRIME EL REPORTE
	oPrint:Preview() //se visualiza previamente la impresion

Static  Function IMPREP(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)

	cQuery := "SELECT F2_FILIAL,F2_DOC,F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_FILDEST,F2_UCOBS,B1_DESC,D2_LOTECTL,D2_CUSTO1,D2_UM,(D2_QUANT*D2_CUSTO1) as total,A1_NOME, max(A1_NOME) as cli1,min(A1_NOME) as cli2,"//c6_num,
	cQuery += "D2_ITEM,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_PEDIDO,D2_ITEMORI,D2_NUMLOTE,D2_DTVALID,D2_NFORI ,F2_MOEDA,NNR.NNR_DESCRI as almdes,D2_LOCDEST,F2_SERIE,D2_LOCAL,D2_LOTECTL,D2_LOCALIZ,D2_NUMSERI,F2_USRREG,B1_ESPECIF,B1_UESPEC2,B1_UMARCA,B1_UFABRIC B1_UCODFAB  "//B2_QATU,B2_CM1  "
	cQuery += "FROM " + RetSqlName("SF2") + " SF2 "
	cQuery += "JOIN " + RetSqlName("SD2") + " SD2 ON F2_DOC=D2_DOC AND F2_FILIAL=D2_FILIAL AND F2_SERIE=D2_SERIE AND D2_TIPODOC='54' AND SD2.D_E_L_E_T_=' '"
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD=D2_COD AND SB1.D_E_L_E_T_=' ' "
	cQuery += "JOIN " + RetSqlName("NNR") + " NNR ON NNR.NNR_CODIGO=D2_LOCAL AND F2_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' "
	cQuery += "LEFT JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD=F2_CLIENTE AND F2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_=' ' "
	cQuery += " WHERE SF2.D_E_L_E_T_=' '   "
	cQuery += " AND F2_FILDEST = '"+trim(mv_par01)+"' AND F2_FILIAL = '"+trim(mv_par02)+"'"
	cQuery += " AND F2_EMISSAO Between '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
	cQuery += " AND F2_DOC Between '"+trim(mv_par05)+"' AND '"+trim(mv_par06)+"'"
	cQuery += " AND F2_SERIE Between '"+trim(mv_par07)+"' AND '"+trim(mv_par08)+"'"
	cQuery += " GROUP BY F2_FILIAL,F2_DOC,F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_FILDEST,F2_UCOBS,B1_DESC,D2_CUSTO1,D2_UM,D2_ITEM,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_PEDIDO,D2_ITEMORI,D2_NUMLOTE,D2_DTVALID,D2_NFORI,F2_MOEDA,NNR.NNR_DESCRI,D2_PRCVEN,D2_TOTAL,A1_NOME,D2_LOCDEST,F2_SERIE,D2_LOCAL,D2_LOTECTL,D2_LOCALIZ,D2_NUMSERI,F2_USRREG,B1_ESPECIF,B1_UESPEC2,B1_UMARCA,B1_UFABRIC     "//,c6_num,
	cQuery += " ORDER BY D2_ITEM "

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	TCQUERY cQuery NEW ALIAS "OrdenesCom"
	fImpCab() // imprime la cabecera
	controlador := OrdenesCom->F2_DOC
	while 	OrdenesCom->(!EOF()) // mientras sigan existiendo items
		FImpItems()   // imprime items
		if(nNroLin > 2700 .OR. OrdenesCom->F2_DOC !=  controlador) // si los items superan el tamaño de la hoja o Nro de documento cambia
			fImpPie() // imprime el pie y salta de pagina
			fImpCab() // imprime cabecera de nuevo
			controlador = OrdenesCom->F2_DOC
		endif
		OrdenesCom->(dbSkip()) // avanza de registra
	enddo
	FImpFirmas() // imprime firmas
	fImpPie() // imprime pie de pagina
	OrdenesCom->(DbCloseArea())
Return

Static Function fImpCab()
	Local cFLogo := GetSrvProfString("Startpath","") + "logo_union.bmp"

	oPrint:StartPage() 			//Inicia uma nova pagina
	nNroCol 	:= 120
	nNroLin 	:= 60

	oPrint:SayBitmap(nNroLin,nNroCol-10,cFLogo,600,145)

	nNroLin += 60;	oPrint:Say(nNroLin,0850," TRANSFERENCIA DE STOCK (SALIDA)" ,oFontTitn)
	nNroLin	+= 80
	oPrint:Say( nNroLin, nNroCol-10,  OrdenesCom->F2_FILIAL  + " " + alltrim(SM0->M0_NOMECOM) , oFontSTitn)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"DOCUMENTO:" + OrdenesCom->F2_SERIE + " - "	+ OrdenesCom->F2_DOC,oFont10n)
	oPrint:Say(nNroLin,1400,"FECHA: "+ ffechalatin(OrdenesCom->F2_EMISSAO) 	,oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"SUCURSAL DE ORIGEN: " + OrdenesCom->F2_FILIAL + "-" + alltrim(GETADVFVAL("SM0","M0_FILIAL","01"+OrdenesCom->F2_FILIAL,1,"")) ,oFont10n)   ///GETADVFVAL("SM0","M0_FILIAL","01"+"0100",1,"erro")
	oPrint:Say(nNroLin,1400,"DEPOSITO DE ORIGEN: " + alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ OrdenesCom->D2_LOCAL,'NNR_DESCRI')) + " - " + alltrim(OrdenesCom->D2_LOCAL)	,oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"SUCURSAL DE DESTINO: "	+ OrdenesCom->F2_FILDEST + "-" + alltrim(GETADVFVAL("SM0","M0_FILIAL","01"+OrdenesCom->F2_FILDEST,1,"")),oFont10n)
	oPrint:Say(nNroLin,1400,"DEPOSITO DE DESTINO: " + 	alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ OrdenesCom->D2_LOCDEST,'NNR_DESCRI')) + " - " + OrdenesCom->D2_LOCDEST,oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"REGISTRADO POR: " +	upper(OrdenesCom->F2_USRREG ),oFont10n)
	oPrint:Say(nNroLin,1400,"IMPRESO POR: " + SUBSTR(CUSERNAME,1,15),oFont10n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"OBSERVACIONES: " +	SUBSTR(OrdenesCom->F2_UCOBS,1,40) ,oFont10n)
	oPrint:Say(nNroLin,01400,"FECHA DE IMPRESIÓN: " + ffechalatin(Dtos(date())),oFont10n)
	nNroLin	+= 80; oPrint:Say(nNroLin,0120,	SUBSTR(OrdenesCom->F2_UCOBS,40,120) ,oFont10n)
	nNroLin	+= 60

	//oPrint:Line(nNroLin, 120, nNroLin, 2450)

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
	//imprimir datos
	// Especifica	B1_ESPECIF B1_UESPEC2


	cProdu:= OrdenesCom->B1_DESC  // DESCRIPCION        
	

	oPrint:Say(nNroLin,0120,OrdenesCom->D2_COD,oFont09)
	oPrint:Say(nNroLin,0270, cProdu ,oFont09)
	oPrint:Say(nNroLin,1000,OrdenesCom->B1_UCODFAB,oFont09)
	oPrint:Say(nNroLin,1170,OrdenesCom->D2_UM,oFont09)
	oPrint:Say(nNroLin,1280,TRANSFORM(OrdenesCom->D2_QUANT,"@E 999,999.99"),oFont09)
	oPrint:Say(nNroLin,1580,OrdenesCom->D2_LOTECTL,oFont09)
	oPrint:Say(nNroLin,1800,OrdenesCom->D2_NUMLOTE,oFont09)
	oPrint:Say(nNroLin,2000,OrdenesCom->D2_LOCALIZ,oFont09)
	oPrint:Say(nNroLin,2250,DTOC(STOD(OrdenesCom->D2_DTVALID)),oFont09)

	nNroLin += 40


		

return
Static Function ValidPerg()

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
		SX1->X1_CNT01 := SF2->F2_FILDEST       //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"02"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SF2->F2_FILIAL          //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"03"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := dtoc(SF2->F2_EMISSAO)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"04"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := dtoc(SF2->F2_EMISSAO)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"05"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SF2->F2_DOC      //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"06"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SF2->F2_DOC        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"07"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SF2->F2_SERIE      //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"08"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SF2->F2_SERIE        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End
Return
Return
