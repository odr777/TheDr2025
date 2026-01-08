#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  IMPKARFI  ºAutor  ³Erick Etcheverry    Fecha 07/11/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ Reporte Grafico Kardex Mod.Activo            			  º±±
±±º          ³ QUERY   Erick Etcheverry                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia                                             		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPKARFI(cCodbem,cFillal)
	Local cString  		:= "SF2"        // Alias do arquivo principal (Base)
	Local cDesc1   		:= "Este Informe tiene como Objetivo"
	Local cDesc2   		:= "Imprimir Kardex de Activo fijo (Bolivia)"
	Local cDesc3   		:= "."
	Local aPerAberto	:= {}
	Local aPerFechado	:= {}
	Local aPerTodos		:= {}
	Local cSavAlias,nSavRec,nSavOrdem
	Local cQuery 		:= ""
	PRIVATE cPerg    	:= nil
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
	PRIVATE titulo   := "Kardex Activo fijo"
	PRIVATE tamanho  := "P"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oFont07n, oFont08, oFont08n, oFont10, oFont10n, oFont28n, oFont10n
	Private oPrint

	//ValidPerg(cperg)	// CARGAMOS LAS PREGUNTAS POR CODIGO

	//	Pergunte(cPerg,.F.)
	//alert(cCodbem)
	//alert(cFillal)
	oFont07n 	:= TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)  //negrito
	oFont10		:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	oFont10n	:= TFont():New("Courier New",09,09,,.T.,,,,.T.,.F.)  //negrito
	oFont28n	:= TFont():New("Times New Roman",28,28,,.T.,,,,.T.,.F.)
	oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.,.T.)
	oFont08n	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)		//Negrito
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
	//oFontTitle  := TFont():New("Engravers MT",16,16,,.T.,,,,.T.,.F.)    // negro
	//oFont8Aite	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.T.);
		oFontTitle	:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.);

	oPrint 	:= TMSPrinter():New("TMSPrinter")
	oPrint:SetPortrait()
	oPrint:Setup()
	oPrint:SetPaperSize( DMPAPER_LETTER )
	wnRel:= "IMPKARFI"
	wnrel:=SetPrint(cString,wnrel,nil,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
	RptStatus({|lEnd| IMPREP(cCodbem,cFillal)},Titulo)  //SE IMPRIME EL REPORTE
	oPrint:Preview() //se visualiza previamente la impresion

return

Static  Function IMPREP(cCodbem,cFillal)

	cQuery := " SELECT N1_FILIAL,N1_BITMAP,T9_CODBEM,T9_NOME,T9_MODELO,T9_SERIE,T9_STATUS,T9_LOCAL,A2_NOME,T7_NOME,N1_PROJETO,N1_APOLICE,N1_CHASSIS,T9_FABRICA,"
	cQuery += " N1_GRUPO,NG_DESCRIC,T9_VALCPA,T9_DTCOMPR,T9_ANOMOD,T9_ANOFAB,T9_BITMAP,N1_CODBEM,A2_NOME,"
	cQuery += " ISNULL(CONVERT(VARCHAR(500), CONVERT(VARCHAR(500), T9_DESCRIC)),'') AS T9_DESCRIC ,"
	cQuery += " N1_CHAPA,N1_FORNEC,N1_LOJA,N1_PLACA,N1_CBASE,STB.TB_CARACTE,TPR.TPR_NOME,STB.TB_DETALHE"
	cQuery += " FROM "+ RetSqlName("ST9") + " ST9"
	cQuery += " LEFT JOIN "+ RetSqlName("ST7") + " ST7 ON (T9_FABRICA = T7_FABRICA AND T9_FILIAL = T7_FILIAL)"
	cQuery += " LEFT JOIN "+ RetSqlName("SA2") + " SA2 ON (T9_FORNECE = A2_COD)"
	cQuery += " JOIN "+ RetSqlName("SN1") + " SN1 ON RTRIM(LTRIM(T9_CODBEM)) = RTRIM(LTRIM(N1_CODBEM))"
	cQuery += " LEFT JOIN "+ RetSqlName("SNG") + " SNG ON (N1_FILIAL = NG_FILIAL AND N1_GRUPO = NG_GRUPO)"
	cQuery += " LEFT JOIN "+ RetSqlName("STB") + " STB ON (STB.TB_CODBEM = ST9.T9_CODBEM)"
	cQuery += " LEFT JOIN "+ RetSqlName("TPR") + " TPR ON (TPR.TPR_CODCAR = STB.TB_CARACTE)"
	cQuery += " WHERE T9_FILIAL = '" + cFillal + "'"
	cQuery += " AND T9_CODBEM = '" + cCodbem + "'"

	//Aviso("cQuery1",cQuery,{"OK"},,,,,.T.)

	TCQUERY cQuery NEW ALIAS "OrdenesCom"
	fImpCab()	// imprime la cabecera

	FImpItems()	// imprime items

	OrdenesCom->(DbCloseArea())

	fImpPie()
Return

Static Function fImpCab()// modifica mi cabecera
	Local cStartPath:= GetSrvProfString("Startpath","")
	oPrint:StartPage() 			//Inicia una nueva pagina
	nNroCol 	:= 220
	cFLogo 		:= cStartPath + "lgrl" + TRIM(SM0->M0_CODFIL) + ".bmp" // imprime logo
	nNroLin 	:= 100

	oPrint:SayBitmap(nNroLin+20,nNroCol-10,cFLogo,500,130)

	nNroLin += 60;oPrint:Say(nNroLin,0850," Sistema de Activos Fijos" ,oFontTitle)
	nNroLin	+= 70
	oPrint:Say(nNroLin,0910,"Fecha del Reporte:  " + ffechalatin(DTOS(dDatabase)),oFont08) //DTOC(dDatabase)

	nNroLin	+= 50
	oPrint:Line( nNroLin,300,nNroLin,2100)
	nNroLin	+= 10
	oPrint:Say(nNroLin,925,"KARDEX DE ACTIVO FIJO" ,oFont08n)
	nNroLin	+= 50
	oPrint:Line( nNroLin,300,nNroLin,2100)
	//alert(oPrint:nVertRes())

	oPrint:Say(nNroLin,0600,OrdenesCom->T9_CODBEM,oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_CODBEM")),oFont07n)
	cFile := RepositArq()//trae imagen repositorio
	c()
	oPrint:SayBitmap(nNroLin-45,01230,cFile,770,700)//dibuja imagen repositorio
	oPrint:Say(nNroLin,0600,OrdenesCom->N1_CHAPA,oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("N1_CHAPA")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,OrdenesCom->T9_SERIE,oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_SERIE")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,OrdenesCom->N1_GRUPO,oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("N1_GRUPO")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,OrdenesCom->NG_DESCRIC,oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("NG_DESCRIC")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,OrdenesCom->N1_PROJETO,oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("N1_PROJETO")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,OrdenesCom->T9_STATUS,oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_STATUS")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,ffechabarra(OrdenesCom->T9_DTCOMPR),oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_DTCOMPR")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,ALLTRIM(TRANSFORM(OrdenesCom->T9_VALCPA,"@E 999,999,999,999")),oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_VALCPA")),oFont07n)
	c()
	/*oPrint:Say(nNroLin,0600,"C-",oFont07n)
	oPrint:Say(nNroLin,0310,"DOCUMENTO*:",oFont07n)//FALTA
	c()*/
	oPrint:Say(nNroLin,0600,(OrdenesCom->T7_NOME),oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T7_NOME")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,(OrdenesCom->T9_FABRICA),oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_FABRICA")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,(OrdenesCom->T9_MODELO),oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_MODELO")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,(OrdenesCom->T9_LOCAL),oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_LOCAL")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,(OrdenesCom->N1_PLACA),oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("N1_PLACA")),oFont07n)
	c()
	oPrint:Say(nNroLin,0600,(OrdenesCom->T9_NOME),oFont07n)
	oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_NOME")),oFont07n)
	c()
	/*oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("T9_DESCRIC")),oFont07n)
	CAMPMEMO()*/
	aHistor:= getHistor((OrdenesCom->N1_FILIAL), (OrdenesCom->N1_CBASE))
	if(Len(aHistor) > 0)
		oPrint:Say(nNroLin,0310,ALLTRIM(nomeCampo("N2_HISTOR")),oFont07n)
		for i := 1 to Len(aHistor)
			oPrint:Say(nNroLin,0600,aHistor[i],oFont07n)
			c()
		next i
	EndIf
return

Static Function fImpPie()
	Nota := "Pag. 1/1"
	oPrint:Say(3105,1100, Nota ,oFont08)
	oPrint:EndPage()
return

Static Function FImpItems()
	Local nAuxNroLin	:= 0
	nNroLin	+= 150
	oPrint:Line( nNroLin,300,nNroLin,2100)
	oBrush := TBrush():New( , CLR_HGRAY )
	oPrint:FillRect({nNroLin, 300, (nNroLin) + 50, 2100}, oBrush)
	oPrint:Say(nNroLin,925,"DETALLE MAQUINARIA" ,oFont08n)
	nNroLin	+= 50
	oPrint:Line( nNroLin,300,nNroLin,2100)
	c()
	nAuxNroLin	:= nNroLin
	oPrint:Say(nNroLin,0310,nomeCampo("T9_ANOFAB"),oFont07n)
	oPrint:Say(nNroLin,0600,OrdenesCom->T9_ANOFAB,oFont07n)
	c()
	oPrint:Say(nNroLin,0310,alltrim(nomeCampo("N1_APOLICE")),oFont07n)
	oPrint:Say(nNroLin,0600,OrdenesCom->N1_APOLICE,oFont07n)
	c()
	oPrint:Say(nNroLin,0310,alltrim(nomeCampo("N1_CHASSIS")),oFont07n)
	oPrint:Say(nNroLin,0600,OrdenesCom->N1_CHASSIS,oFont07n)
	c()
	oPrint:Say(nNroLin,0310,alltrim(nomeCampo("T9_SERIE")),oFont07n)
	oPrint:Say(nNroLin,0600,OrdenesCom->T9_SERIE,oFont07n)
	c()
	oPrint:Say(nNroLin,0310,"PROVEEDOR",oFont07n)
	oPrint:Say(nNroLin,0600,OrdenesCom->(N1_FORNEC + N1_LOJA),oFont07n)
	c()
	cCombustible:= getCombustible((OrdenesCom->N1_FILIAL), (OrdenesCom->N1_CODBEM))
	if(!Empty(cCombustible))
		oPrint:Say(nNroLin,0310,"COMBUSTIBLE",oFont07n)
		oPrint:Say(nNroLin,0600,cCombustible,oFont07n)
	EndIf
	
	//nNroLin -= 550
	nNroLin := nAuxNroLin
	while OrdenesCom->(!Eof())
		oPrint:Say(nNroLin,1080,ALLTRIM(OrdenesCom->TPR_NOME),oFont07n)
		oPrint:Say(nNroLin,1670,ALLTRIM(OrdenesCom->TB_DETALHE),oFont07n)
		c()
		OrdenesCom->(DBSkip())
	enddo

return

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  RepositArq  ºAutor  ³Erick Etcheverry    Fecha 07/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ EXTRAE IMAGEN REPOSITORIO		            			  º±±
±±º          ³ 				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GLOBAL                                             		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC function RepositArq()

	cFile := ""//"IMAGEN20temp.bmp"
	If RepExtract(alltrim(OrdenesCom->N1_BITMAP),cFile) //CAMPO BITMAP Q CONTIENE BINARIO IMAGEN RUTA DONDE GUARDAR
		// If RepExtract(OrdenesCom->T9_BITMAP,cFile) //CAMPO BITMAP Q CONTIENE BINARIO IMAGEN RUTA DONDE GUARDAR
		//alert("Extração realizada")
	Else
		//alert("Extração nao realizada")
	EndIF
Return cFile

static Function CAMPMEMO()

	cPeds := OrdenesCom->T9_DESCRIC
	_nLinhas := MlCount(cPeds,75,,.F.)

	For _nX := 1 To _nLinhas
		If(!Empty(memoline(cPeds,75,_nX,,.F.)))
			oPrint:Say(nNroLin,0600,memoline(cPeds,75,_nX,,.F.),oFont07n)
			c()
		ENDIF
		//	++li
	Next _nX
return

/********************************************
 *FUNCION QUE TRAE TITULO CAMPO SX3	 ERICK.E*
 ********************************************/
static function nomeCampo(cNomeCampo)
	Local aArea		:= getArea()
	Local cTitulo	:= ""
	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek(cNomeCampo)
		cTitulo := X3Titulo()
	EndIf
	restArea(aArea)
return UPPER(cTitulo)

//espacio entre registros
static function c()
	nNroLin += 50
return

Static Function ffechalatin(sfechacorta)

	Local ffechalatin:=""
	Local sdia:=substr(sfechacorta,7,2)
	Local smes:=substr(sfechacorta,5,2)
	Local sano:=substr(sfechacorta,0,4)

	ffechalatin := sano + "/" + smes + "/" + sdia

Return(ffechalatin)

Static Function ffechabarra(sfechacorta)

	Local ffechalatin:=""
	Local sdia:=substr(sfechacorta,7,2)
	Local smes:=substr(sfechacorta,5,2)
	Local sano:=substr(sfechacorta,0,4)

	ffechalatin := sano + "-" + smes + "-" + sdia

Return(ffechalatin)     

static Function testeFont(cteste)
	DEFINE DIALOG oDlg TITLE "HOLA" FROM 180,180 TO 550,700 PIXEL

	// TFont
	oTFont := TFont():New(cTeste,08,08,,.T.,,,,.T.,.T.);

	// Aplica Font em um TSay
	oTSay := TSay():New( 01, 01,{||'TSay para teste do TFont (usado Courier new)'},oDlg;
	,,oTFont,.T.,.F.,.F.,.T.,0,,250,20,.F.,.T.,.F.,.F.,.F.,.F. )

	Name      := oTFont:Name
	nWidth    := oTFont:nWidth
	nHeigh    := oTFont:nHeight
	Bold      := oTFont:Bold
	Italic    := oTFont:Italic
	Underline := oTFont:Underline
	ACTIVATE DIALOG oDlg CENTERED
Return

/**
* @author: Denar Terrazas Parada
* @since: 15/07/2020
* @description: Funcion que devuelve el detalle de la tabla SN2 (N2_HISTOR)
*/
Static Function getHistor(cFillal, cBase)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local cHistor		:= ""
	Local OrdenConsul	:= GetNextAlias()
	Local nCount		:= 0
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT SN2.N2_HISTOR
		FROM %table:SN2% SN2
		WHERE N2_FILIAL = %exp:cFillal%
		AND N2_CBASE = %exp:cBase%
		AND SN2.%notdel%
		ORDER BY N2_SEQUENC

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		while (OrdenConsul)->(!Eof())
			cHistor+= (OrdenConsul)->N2_HISTOR
			nCount++
			If(nCount == 3)//Para hacer salto de linea cada 3 registros en la SN2
				AADD(aRet, cHistor)
				cHistor	:= ""
				nCount	:= 0
			EndIf
			(OrdenConsul)->(DbSkip())
		enddo
		if(!Empty(cHistor))
			AADD(aRet, cHistor)
		EndIf
	endIf

	restArea(aArea)
return aRet

/**
* @author: Denar Terrazas Parada
* @since: 15/07/2020
* @description: Funcion que retorna la descripción del combustible de la tabla TT8
*/
Static Function getCombustible(cFillal, cCodbem)
	Local aArea			:= getArea()
	Local cRet			:= ""
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT TQM.TQM_NOMCOM
		FROM %table:TT8% TT8
		JOIN %table:TQM% TQM ON TQM.TQM_FILIAL = TT8.TT8_FILIAL AND TQM.TQM_CODCOM = TT8.TT8_CODCOM
		WHERE TT8.TT8_FILIAL = %exp:cFillal%
		AND TT8.TT8_CODBEM = %exp:cCodbem%
		AND TT8.%notdel%
		AND TQM.%notdel%

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		while (OrdenConsul)->(!Eof())
			cRet+= AllTrim((OrdenConsul)->TQM_NOMCOM) + ", "
			(OrdenConsul)->(DbSkip())
		enddo
		cRet:= substr(cRet, 1, Len(cRet) - 2)
	endIf

	restArea(aArea)
return cRet
