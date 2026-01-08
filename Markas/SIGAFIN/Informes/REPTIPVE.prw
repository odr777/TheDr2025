#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPTIPVE ³ Autor Nahim Terrazas								³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ REPORTE DE VENTAS CONS.							    		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ REPTIPVE()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Global														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³26/12/2018³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/



User Function REPTIPVE()
Local oReport
PRIVATE cPerg   := "REPTIPVE"   // elija el Nombre de la pregunta 
CriaSX1(cPerg)	// Si no esta creada la crea

Pergunte(cPerg,.F.) 
oReport := ReportDef()
oReport:PrintDialog()	

Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local NombreProg := "VENTAS CONSOLIDADAS"

oReport	 := TReport():New("REPTIPVE",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"VENTAS CONSOLIDADAS")
// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

oSection := TRSection():New(oReport,"VENTAS CONSOLIDADAS MARKAS",{"SF2","SEL"})
oReport:SetTotalInLine(.F.)


/*                                                 
TRCell():New(oSection,"D2_COD"		,"SD2","Prod.",,10)
TRCell():New(oSection,"A3_NOME"		,"SA3","Vended.",,10) 
*/
//		Comienzan a elegir los campos que desean Mostrar
 
// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

// SF2_HIST, SF2_DATA, SF2_HAGLUT, SEL_DOC, SEL_LINHA, SEL_VALOR, 




// TRCell():New(oSection,"EK_VALORFIN" ,"SEK")
TRCell():New(oSection,"TIPO"	,"SF2")
//TRCell():New(oSection,"ANHO"	,"SF2",,"@!")
TRCell():New(oSection,"F2_FILIAL","SF2")
//TRCell():New(oSection,"FILIAL"   ,"SF2",	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,{|| FWFilialName(SubStr(F2_FILIAL,1,2),SubStr(F2_FILIAL,3,2))})
TRCell():New(oSection,"FILIAL"   ,"SF2",	,/*Picture*/,20/*Tamanho*/,/*lPixel*/,{|| FWFilialName(SubStr(F2_FILIAL,1,2),F2_FILIAL,1)})
TRCell():New(oSection,"ENERO"	,"SF2")
TRCell():New(oSection,"FEBRERO"	,"SF2")
TRCell():New(oSection,"MARZO"	,"SF2")
TRCell():New(oSection,"ABRIL"	,"SF2")
TRCell():New(oSection,"MAYO"	,"SF2")
TRCell():New(oSection,"JUNIO"	,"SF2")
TRCell():New(oSection,"JULIO"	,"SEL")
TRCell():New(oSection,"AGOSTO"	,"SEL")
TRCell():New(oSection,"SEPTIEMBRE"	,"SEL")
TRCell():New(oSection,"OCTUBRE"	,"SEL")
TRCell():New(oSection,"NOVIEMBRE"	,"SEL")
TRCell():New(oSection,"DICIEMBRE"	,"SEL")
//		
 oBreak = TRBreak():New(oSection,oSection:Cell("TIPO"),"Sub Total")
 TRFunction():New(oSection:Cell("ENERO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("FEBRERO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("MARZO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("ABRIL") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("MAYO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("JUNIO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("JULIO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("AGOSTO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("SEPTIEMBRE") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("OCTUBRE") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("NOVIEMBRE") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
 TRFunction():New(oSection:Cell("DICIEMBRE") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
// Imprime una linea Segun la condicion (totalizadora)
// TRFunction():New(oSection:Cell("B1_VENTAS") ,NIL,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/{|| "" },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/,)


//TRFunction():New(oSection:Cell("VALVENGR")	,NIL,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return oReport

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cFiltro  := ""
Local cTipe :=""
Local cCont :=""


#IFDEF TOP
// Query
//  AND CT2.CT2_DATA >= %Exp:mv_par01% AND CT2.CT2_DATA <= %Exp:mv_par02%
//  AND F2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%

	if mv_par05 == 1  // bs
	
	oSection:BeginQuery()
	BeginSql alias "QRYSA1"


    select
	TIPO,ANHO,
	F2_FILIAL
	,SUM(ENERO     )ENERO     
	,SUM(FEBRERO   )FEBRERO   
	,SUM(MARZO     )MARZO     
	,SUM(ABRIL     )ABRIL     
	,SUM(MAYO      )MAYO      
	,SUM(JUNIO     )JUNIO     
	,SUM(JULIO     )JULIO     
	,SUM(AGOSTO    )AGOSTO    
	,SUM(SEPTIEMBRE)SEPTIEMBRE
	,SUM(OCTUBRE   )OCTUBRE   
	,SUM(NOVIEMBRE )NOVIEMBRE 
	,SUM(DICIEMBRE )DICIEMBRE 
	 FROM 
	(
		SELECT TIPO,ANHO,
	F2_FILIAL
	,isnull(sum(case when MES = 1 then SUMA end), 0) ENERO
	  ,isnull(sum(case when MES = 2 then SUMA end), 0) FEBRERO 
	  ,isnull(sum(case when MES = 3 then SUMA end), 0) MARZO
	  ,isnull(sum(case when MES = 4 then SUMA end), 0) ABRIL
	  ,isnull(sum(case when MES = 5 then SUMA end), 0) MAYO
	  ,isnull(sum(case when MES = 6 then SUMA end), 0) JUNIO
	  ,isnull(sum(case when MES = 7 then SUMA end), 0) JULIO
	  ,isnull(sum(case when MES = 8 then SUMA end), 0) AGOSTO
	  ,isnull(sum(case when MES = 9 then SUMA end), 0) SEPTIEMBRE
	  ,isnull(sum(case when MES = 10 then SUMA end), 0) OCTUBRE
	  ,isnull(sum(case when MES = 11 then SUMA end), 0) NOVIEMBRE
	  ,isnull(sum(case when MES = 12 then SUMA end), 0) DICIEMBRE
	  FROM 
	(
	
	SELECT 'TARJETA' TIPO,ROUND(SUM(SUMAFX),2) SUMA,MES ,ANHO, F2_FILIAL
	FROM (
		select 
		datepart(MM, F2_EMISSAO) MES,year(F2_EMISSAO) ANHO, F2_FILIAL,
		case when F2_MOEDA = '1' then SUM(F2_VALBRUT) else SUM(F2_VALBRUT*F2_TXMOEDA) end SUMAFX
		from 
		SF2010
		where F2_ESPECIE = 'NF'
		AND D_E_L_E_T_ = ' '
		and F2_COND = 2
		AND F2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		and F2_FILIAL BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND (F2_FILIAL+F2_DOC) IN (SELECT (EL_FILIAL + F2_DOC) fili
	FROM
	SEL010 SEL2 
	JOIN (
		SELECT F2_VALBRUT,F2_DOC, EL_RECIBO,F2_SERIE,F2_CLIENTE,EL_BANCO,EL_TIPO,EL_PREFIXO EL_PREFIXO2 FROM SF2010 SF2
		JOIN SEL010 SEL
		ON F2_DOC = EL_NUMERO
		AND F2_CLIENTE = EL_CLIORIG
		AND SEL.D_E_L_E_T_ = ' '
		WHERE F2_COND = '002'
		AND SF2.D_E_L_E_T_ = ' '
		AND F2_ESPECIE = 'NF') RES
		ON SEL2.EL_RECIBO = RES.EL_RECIBO 
		AND SEL2.EL_BANCO = 'ATC' 
		WHERE SEL2.D_E_L_E_T_ = ' ')
		group by 
		datepart(MM, F2_EMISSAO) ,year(F2_EMISSAO), F2_FILIAL,F2_MOEDA
	) FINA
	GROUP BY ANHO, MES,F2_FILIAL
	
	UNION 
	
	SELECT 'CREDITO' TIPO, ROUND(SUM(SUMAFX),2) SUMA,MES ,ANHO, F2_FILIAL
	FROM (
		select 
		datepart(MM, F2_EMISSAO) MES,year(F2_EMISSAO) ANHO, F2_FILIAL,
		case when F2_MOEDA = '1' then SUM(F2_VALBRUT) else SUM(F2_VALBRUT*F2_TXMOEDA) end 
		 SUMAFX,
		'CONTADO DL' TIPOTS from 
		SF2010
		where F2_ESPECIE = 'NF'
		AND D_E_L_E_T_ = ' '
		and F2_COND <> 2
		AND F2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		and F2_FILIAL BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		group by 
		datepart(MM, F2_EMISSAO) ,year(F2_EMISSAO), F2_FILIAL,F2_MOEDA
	) FINA
	GROUP BY ANHO, MES,F2_FILIAL
	
	UNION
	
	SELECT CASE WHEN F2_FILIAL='0101' THEN 'CREDITO' ELSE 'CONTADO' END TIPO, ROUND(SUM(SUMAFX),2) SUMA,MES ,ANHO, F2_FILIAL
	FROM (
		select 
		datepart(MM, F2_EMISSAO) MES,year(F2_EMISSAO) ANHO, F2_FILIAL,
		case when F2_MOEDA = '1' then SUM(F2_VALBRUT) else SUM(F2_VALBRUT*F2_TXMOEDA) end SUMAFX
		 from 
		SF2010
		where F2_ESPECIE = 'NF'
		AND D_E_L_E_T_ = ' '
		and F2_COND = 2
		AND F2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		and F2_FILIAL BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND (F2_FILIAL+F2_DOC) IN (SELECT (EL_FILIAL + F2_DOC) fili
		FROM
		SEL010 SEL2 
		JOIN (
		SELECT F2_VALBRUT,F2_DOC, EL_RECIBO,F2_SERIE,F2_CLIENTE,EL_BANCO,EL_TIPO,EL_PREFIXO EL_PREFIXO2 FROM SF2010 SF2
		JOIN SEL010 SEL
		ON F2_DOC = EL_NUMERO
		AND F2_CLIENTE = EL_CLIORIG
		AND SEL.D_E_L_E_T_ = ' '
		WHERE F2_COND = '002'
		AND SF2.D_E_L_E_T_ = ' '
		AND F2_ESPECIE = 'NF') RES
		ON SEL2.EL_RECIBO = RES.EL_RECIBO 
		AND SEL2.EL_BANCO <> 'ATC'
		AND SEL2.EL_NATUREZ = 'COBRO'
		WHERE SEL2.D_E_L_E_T_ = ' ')
		group by 
		datepart(MM, F2_EMISSAO) ,year(F2_EMISSAO), F2_FILIAL,F2_MOEDA
	) FINA
	GROUP BY ANHO, MES,F2_FILIAL
	) meses
	GROUP BY 
	TIPO,ANHO, F2_FILIAL
	 UNION 
	 		SELECT
	 	'CREDITO'TIPO,%Exp:SubStr(DTOS(mv_par01), 1,4)% ANHO,
		F2_FILIAL
		,0 ENERO
		,0 FEBRERO 
		,0 MARZO
		,0 ABRIL
		,0 MAYO
		,0 JUNIO
		,0 JULIO
		,0 AGOSTO
		,0 SEPTIEMBRE
		,0 OCTUBRE
		,0 NOVIEMBRE,
		0 DICIEMBRE
		  FROM SF2010
		  GROUP BY F2_FILIAL
		
		UNION
	 	
	 		SELECT
	 	'CONTADO'TIPO,%Exp:SubStr(DTOS(mv_par01), 1,4)% ANHO,
		F2_FILIAL
		,0 ENERO
		,0 FEBRERO 
		,0 MARZO
		,0 ABRIL
		,0 MAYO
		,0 JUNIO
		,0 JULIO
		,0 AGOSTO
		,0 SEPTIEMBRE
		,0 OCTUBRE
		,0 NOVIEMBRE,
		0 DICIEMBRE
		  FROM SF2010
		  GROUP BY F2_FILIAL
		 UNION
	 		SELECT
	 	'TARJETA'TIPO,%Exp:SubStr(DTOS(mv_par01), 1,4)% ANHO,
		F2_FILIAL
		,0 ENERO
		,0 FEBRERO 
		,0 MARZO
		,0 ABRIL
		,0 MAYO
		,0 JUNIO
		,0 JULIO
		,0 AGOSTO
		,0 SEPTIEMBRE
		,0 OCTUBRE
		,0 NOVIEMBRE,
		0 DICIEMBRE
		  FROM SF2010
		  GROUP BY F2_FILIAL
	) sal
	 GROUP BY TIPO,ANHO,
	F2_FILIAL
 	ORDER BY ANHO,TIPO,F2_FILIAL
 	
	EndSql
	
	oSection:EndQuery()
	
	else // Dólares
	
	oSection:BeginQuery()
	BeginSql alias "QRYSA1"
	
    select
	TIPO,ANHO,
	F2_FILIAL
	,SUM(ENERO     )ENERO     
	,SUM(FEBRERO   )FEBRERO   
	,SUM(MARZO     )MARZO     
	,SUM(ABRIL     )ABRIL     
	,SUM(MAYO      )MAYO      
	,SUM(JUNIO     )JUNIO     
	,SUM(JULIO     )JULIO     
	,SUM(AGOSTO    )AGOSTO    
	,SUM(SEPTIEMBRE)SEPTIEMBRE
	,SUM(OCTUBRE   )OCTUBRE   
	,SUM(NOVIEMBRE )NOVIEMBRE 
	,SUM(DICIEMBRE )DICIEMBRE 
	 FROM 
	(
		SELECT TIPO,ANHO,
	F2_FILIAL
	,isnull(sum(case when MES = 1 then SUMA end), 0) ENERO
	  ,isnull(sum(case when MES = 2 then SUMA end), 0) FEBRERO 
	  ,isnull(sum(case when MES = 3 then SUMA end), 0) MARZO
	  ,isnull(sum(case when MES = 4 then SUMA end), 0) ABRIL
	  ,isnull(sum(case when MES = 5 then SUMA end), 0) MAYO
	  ,isnull(sum(case when MES = 6 then SUMA end), 0) JUNIO
	  ,isnull(sum(case when MES = 7 then SUMA end), 0) JULIO
	  ,isnull(sum(case when MES = 8 then SUMA end), 0) AGOSTO
	  ,isnull(sum(case when MES = 9 then SUMA end), 0) SEPTIEMBRE
	  ,isnull(sum(case when MES = 10 then SUMA end), 0) OCTUBRE
	  ,isnull(sum(case when MES = 11 then SUMA end), 0) NOVIEMBRE
	  ,isnull(sum(case when MES = 12 then SUMA end), 0) DICIEMBRE
	  FROM 
	(
	
	SELECT 'TARJETA' TIPO,ROUND(SUM(SUMAFX),2) SUMA,MES ,ANHO, F2_FILIAL
	FROM (
		select 
		datepart(MM, F2_EMISSAO) MES,year(F2_EMISSAO) ANHO, F2_FILIAL,
		case when F2_MOEDA = '2' then SUM(F2_VALBRUT) else SUM(F2_VALBRUT/6.97) end SUMAFX
		from 
		SF2010
		where F2_ESPECIE = 'NF'
		AND D_E_L_E_T_ = ' '
		and F2_COND = 2
		AND F2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		and F2_FILIAL BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND (F2_FILIAL+F2_DOC) IN (SELECT (EL_FILIAL + F2_DOC) fili
	FROM
	SEL010 SEL2 
	JOIN (
		SELECT F2_VALBRUT,F2_DOC, EL_RECIBO,F2_SERIE,F2_CLIENTE,EL_BANCO,EL_TIPO,EL_PREFIXO EL_PREFIXO2 FROM SF2010 SF2
		JOIN SEL010 SEL
		ON F2_DOC = EL_NUMERO
		AND F2_CLIENTE = EL_CLIORIG
		AND SEL.D_E_L_E_T_ = ' '
		WHERE F2_COND = '002'
		AND SF2.D_E_L_E_T_ = ' '
		AND F2_ESPECIE = 'NF') RES
		ON SEL2.EL_RECIBO = RES.EL_RECIBO 
		AND SEL2.EL_BANCO = 'ATC' 
		WHERE SEL2.D_E_L_E_T_ = ' ')
		group by 
		datepart(MM, F2_EMISSAO) ,year(F2_EMISSAO), F2_FILIAL,F2_MOEDA
	) FINA
	GROUP BY ANHO, MES,F2_FILIAL
	
	UNION 
	
	SELECT 'CREDITO' TIPO, ROUND(SUM(SUMAFX),2) SUMA,MES ,ANHO, F2_FILIAL
	FROM (
		select 
		datepart(MM, F2_EMISSAO) MES,year(F2_EMISSAO) ANHO, F2_FILIAL,
		case when F2_MOEDA = '2' then SUM(F2_VALBRUT) else SUM(F2_VALBRUT/6.97) end 
		 SUMAFX,
		'CONTADO DL' TIPOTS from 
		SF2010
		where F2_ESPECIE = 'NF'
		AND D_E_L_E_T_ = ' '
		and F2_COND <> 2
		AND F2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		and F2_FILIAL BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		group by 
		datepart(MM, F2_EMISSAO) ,year(F2_EMISSAO), F2_FILIAL,F2_MOEDA
	) FINA
	GROUP BY ANHO, MES,F2_FILIAL
	
	UNION
	
	SELECT CASE WHEN F2_FILIAL='0101' THEN 'CREDITO' ELSE 'CONTADO' END TIPO, ROUND(SUM(SUMAFX),2) SUMA,MES ,ANHO, F2_FILIAL
	FROM (
		select 
		datepart(MM, F2_EMISSAO) MES,year(F2_EMISSAO) ANHO, F2_FILIAL,
		case when F2_MOEDA = '2' then SUM(F2_VALBRUT) else SUM(F2_VALBRUT/6.97) end SUMAFX
		 from 
		SF2010
		where F2_ESPECIE = 'NF'
		AND D_E_L_E_T_ = ' '
		and F2_COND = 2
		AND F2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		and F2_FILIAL BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND (F2_FILIAL+F2_DOC) IN (SELECT (EL_FILIAL + F2_DOC) fili
		FROM
		SEL010 SEL2 
		JOIN (
		SELECT F2_VALBRUT,F2_DOC, EL_RECIBO,F2_SERIE,F2_CLIENTE,EL_BANCO,EL_TIPO,EL_PREFIXO EL_PREFIXO2 FROM SF2010 SF2
		JOIN SEL010 SEL
		ON F2_DOC = EL_NUMERO
		AND F2_CLIENTE = EL_CLIORIG
		AND SEL.D_E_L_E_T_ = ' '
		WHERE F2_COND = '002'
		AND SF2.D_E_L_E_T_ = ' '
		AND F2_ESPECIE = 'NF') RES
		ON SEL2.EL_RECIBO = RES.EL_RECIBO 
		AND SEL2.EL_BANCO <> 'ATC'
		AND SEL2.EL_NATUREZ = 'COBRO'
		WHERE SEL2.D_E_L_E_T_ = ' ')
		group by 
		datepart(MM, F2_EMISSAO) ,year(F2_EMISSAO), F2_FILIAL,F2_MOEDA
	) FINA
	GROUP BY ANHO, MES,F2_FILIAL
	) meses
	GROUP BY 
	TIPO,ANHO, F2_FILIAL
	 UNION 
	 		SELECT
	 	'CREDITO'TIPO,%Exp:SubStr(DTOS(mv_par01), 1,4)% ANHO,
		F2_FILIAL
		,0 ENERO
		,0 FEBRERO 
		,0 MARZO
		,0 ABRIL
		,0 MAYO
		,0 JUNIO
		,0 JULIO
		,0 AGOSTO
		,0 SEPTIEMBRE
		,0 OCTUBRE
		,0 NOVIEMBRE,
		0 DICIEMBRE
		  FROM SF2010
		  GROUP BY F2_FILIAL
		
		UNION
	 	
	 		SELECT
	 	'CONTADO'TIPO,%Exp:SubStr(DTOS(mv_par01), 1,4)% ANHO,
		F2_FILIAL
		,0 ENERO
		,0 FEBRERO 
		,0 MARZO
		,0 ABRIL
		,0 MAYO
		,0 JUNIO
		,0 JULIO
		,0 AGOSTO
		,0 SEPTIEMBRE
		,0 OCTUBRE
		,0 NOVIEMBRE,
		0 DICIEMBRE
		  FROM SF2010
		  GROUP BY F2_FILIAL
		 UNION
	 		SELECT
	 	'TARJETA'TIPO,%Exp:SubStr(DTOS(mv_par01), 1,4)% ANHO,
		F2_FILIAL
		,0 ENERO
		,0 FEBRERO 
		,0 MARZO
		,0 ABRIL
		,0 MAYO
		,0 JUNIO
		,0 JULIO
		,0 AGOSTO
		,0 SEPTIEMBRE
		,0 OCTUBRE
		,0 NOVIEMBRE,
		0 DICIEMBRE
		  FROM SF2010
		  GROUP BY F2_FILIAL
	) sal
	 GROUP BY TIPO,ANHO,
	F2_FILIAL
 	ORDER BY ANHO,TIPO,F2_FILIAL
 	
 	
 	
	EndSql
	
	oSection:EndQuery()	
	endif
	
	
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery),{"si"})
	
#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
#ENDIF

oSection:Print()

 
// MemoWrite("\query_ocp.sql",cQuery) esta funcion te crea un archivo con el nombre que pongas en el parametro
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas 

/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
especificaciones, 
*/
// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado


xPutSx1(cPerg,"01","¿De Fecha?" , "¿De Fecha?","¿De Fecha?","MV_CH2","D",08,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")     
xPutSx1(cPerg,"02","¿A Fecha?" , "¿A Fecha?","¿A Fecha?","MV_CH2","D",08,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
xPutSx1(cPerg,"03","¿De Sucursal?" 	, "¿De Sucursal?"  ,"¿De Sucursal?"	 ,"MV_CH3","C",4 ,0,0,"G","","SM0"	,""	,""	,"MV_PAR03",""       ,""            ,""        ,""     ,,"")     
xPutSx1(cPerg,"04","¿A Sucursal?" 	, "¿A Sucursal?"   ,"¿A Sucursal?"	 ,"MV_CH4","C",4 ,0,0,"G","","SM0"	,""	,""	,"MV_PAR04",""       ,""            ,""        ,""     ,,"")
xPutSX1(cPerg,"05","¿Moneda de impresión?", "¿Moneda de impresión?"  ,"¿Moneda de impresión?" ,"MV_CH5","N",1,0,0,"C","","","","","mv_par05","Bs","Bs","Bs","Dólares","Dólares","Dólares")
//xPutSX1(cPerg,"05","¿Moneda de impresión?" , "¿Moneda de impresión?","¿Moneda de impresión?","MV_CH5","C",5,0,0,"C","",""		,""	,""	,"MV_PAR05","SI" ,"SI","SI","NO","NO","NO","TODAS","TODAS","TODAS",,,)
//PutSX1(cPerg,"05","¿De Tipo?" 		, "¿De Tipo?"	   ,"¿De Tipo?"		 ,"MV_CH5","C",3 ,0,0,"G","","42" 	,""	,""	,"MV_PAR05",""       ,""            ,""        ,""     ,,"")     
//PutSX1(cPerg,"06","¿A Tipo?" 		, "¿A Tipo?"	   ,"¿A Tipo?"		 ,"MV_CH6","C",3 ,0,0,"G","","42" 	,""	,""	,"MV_PAR06",""       ,""            ,""        ,""     ,,"")
//PutSX1(cPerg,"08","¿Tipo9?" , "¿Tipo9?","¿Tipo9?","MV_CH8","C",5,0,0,"C","",""		,""	,""	,"MV_PAR08","SI" ,"SI","SI","NO","NO","NO","TODAS","TODAS","TODAS",,,)

return







Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return