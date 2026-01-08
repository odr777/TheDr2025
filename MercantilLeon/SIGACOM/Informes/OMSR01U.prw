#INCLUDE "OMSR010.CH" 
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  OMSR01U   ³ Autor ³ Erick Etcheverry 	    ³ Data ³09.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Lista de Precos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function OMSR01U()

Local oReport
Local cAliasSB1 := "SB1"
Local cAliasDA0 := "DA0"
Local cAliasDA1 := "DA1"

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef(@cAliasSB1,@cAliasDA0,@cAliasDA1)
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf	
	oReport:PrintDialog()
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Eduardo Riera          ³ Data ³08.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³ExpC1: Alias da tabela de produto                           ³±±
±±³          ³ExpC2: Alias da tabela de preco                             ³±±
±±³          ³ExpC3: Alias da tabela de itens da tabela de preco          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(cAliasSB1,cAliasDA0,cAliasDA1)

Local oReport
Local oTabPrc
Local oItemTab
Local oTabBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("OMSR01U",STR0024,"OMR01U",{|oReport| ReportPrint(oReport,@cAliasSB1,@cAliasDA0,@cAliasDA1)},STR0025)	// "Listagem de Precos"###"Este relatorio ira imprimir as tabelas de precos de acordo com os parametros informados pelo usuario."
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTabPrc := TRSection():New(oReport,STR0026,{"DA0"},{STR0027,STR0028,STR0029,STR0030},.F.,.F.)	// "Tabela de Preço"###"Tipo"###"Grupo"###"Descrição de produto"###"Código de produto"
TRCell():New(oTabPrc,"DA0_CODTAB","DA0",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA0)->DA0_CODTAB})
TRCell():New(oTabPrc,"DA0_DESCRI","DA0",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA0)->DA0_DESCRI})
TRCell():New(oTabPrc,"DA0_DATDE","DA0",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/ ,{|| (cAliasDA0)->DA0_DATDE})
TRCell():New(oTabPrc,"DA0_HORADE","DA0",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA0)->DA0_HORADE})
TRCell():New(oTabPrc,"DA0_DATATE","DA0",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA0)->DA0_DATATE})
TRCell():New(oTabPrc,"DA0_HORATE","DA0",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA0)->DA0_HORATE})

oItemTab := TRSection():New(oTabPrc,STR0031,{"DA1","SB1"},/*aOrdem*/,.F.,.F.)	// "Produtos da tabela de preço"
TRCell():New(oItemTab,"DA1_CODPRO","DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIf((cAliasSB1)->B1_GRADE == "S",Substr((cAliasDA1)->DA1_CODPRO,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2))),(cAliasDA1)->DA1_CODPRO)})
TRCell():New(oItemTab,"B1_DESC"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIf(MV_PAR12 == 1.And.(cAliasSB1)->B1_GRADE=="S",SB4->B4_DESC,(cAliasSB1)->B1_DESC)})
TRCell():New(oItemTab,"B1_UM"     ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSB1)->B1_UM})
TRCell():New(oItemTab,"DA1_QTDLOT","DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA1)->DA1_QTDLOT})
TRCell():New(oItemTab,"DA1_PRCBAS","DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSB1)->B1_PRV1})
TRCell():New(oItemTab,"DA1_PRCVEN","DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA1)->DA1_PRCVEN})
TRCell():New(oItemTab,"DA1_MOEDA" ,"DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA1)->DA1_MOEDA})
TRCell():New(oItemTab,"DA1_VLRDES","DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA1)->DA1_VLRDES})
TRCell():New(oItemTab,"DA1_PERDES","DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA1)->DA1_PERDES})
TRCell():New(oItemTab,"DA1_ESTADO","DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDA1)->DA1_ESTADO})
TRCell():New(oItemTab,"DA1_TPOPER","DA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| X3Combo("DA1_TPOPER",(cAliasDA1)->DA1_TPOPER)})

oTabBase := TRSection():New(oReport,STR0032,{"SB1"},{STR0027,STR0028,STR0029,STR0030},.F.,.F.)	// "Lista de Preços ( Base )"###"Tipo"###"Grupo"###"Descrição de produto"###"Código de produto"
TRCell():New(oTabBase,"B1_TIPO"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSB1)->B1_TIPO})
TRCell():New(oTabBase,"B1_GRUPO"  ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSB1)->B1_GRUPO})
TRCell():New(oTabBase,"B1_COD"    ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIF((cAliasSB1)->B1_GRADE == "S",Substr((cAliasSB1)->B1_COD,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2))),(cAliasSB1)->B1_COD)})
TRCell():New(oTabBase,"B1_DESC"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIF((cAliasSB1)->B1_GRADE == "S" .And. MV_PAR12 == 1,Substr((cAliasSB1)->B1_COD,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2))),(cAliasSB1)->B1_DESC)})
TRCell():New(oTabBase,"B1_UM"     ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSB1)->B1_UM})
TRCell():New(oTabBase,"B1_QE"     ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| RetFldProd((cAliasSB1)->B1_COD,"B1_QE",cAliasSB1)})
TRCell():New(oTabBase,"B1_PRV1"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSB1)->B1_PRV1})

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Eduardo Riera          ³ Data ³08.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³ExpC2: Alias da tabela de produto                           ³±±
±±³          ³ExpC3: Alias da tabela de preco                             ³±±
±±³          ³ExpC4: Alias da tabela de itens da tabela de preco          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSB1,cAliasDA0,cAliasDA1)

Local cTabAnt   := ""
Local cProdRef  := ""
Local lNotGrade := .T.
Local cOrderBy  := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam/*Nome da Pergunte*/)
If ( MV_PAR11 == 2 )  ///no
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()		
	Do Case
    	Case oReport:Section(1):nOrder == 1
		    cOrderBy := "%DA0_FILIAL,DA0_CODTAB,B1_TIPO%"
		Case oReport:Section(1):nOrder == 2
			cOrderBy :=  "%DA0_FILIAL,DA0_CODTAB,B1_GRUPO%"
		Case oReport:Section(1):nOrder == 3
			cOrderBy :=  "%DA0_FILIAL,DA0_CODTAB,B1_DESC%"
		Case oReport:Section(1):nOrder == 4
			cOrderBy :=  "%DA0_FILIAL,DA0_CODTAB,DA1_CODPRO%"
	EndCase

	cAtivo := Iif(Str(mv_par13,1) $ ("1/2") ,Str(mv_par13,1),"'1','2'") 
	If (Str(mv_par13,1) <> "3")
	   cAtivo := "'" + cAtivo + "'"  
	Endif
	cAtivo := "(" + cAtivo + ")"
	cAtivo := "% " + cAtivo + " %" 
	
	cAliasDA0 := GetNextAlias()
	cAliasDA1 := cAliasDA0
	cAliasSB1 := cAliasDA1
	

	/*SELECT DA0_CODTAB,DA0_DESCRI,DA0_DATDE,DA0_DATATE,DA0_HORADE,DA0_HORATE,
						DA1_FILIAL,DA1_CODTAB,DA1_CODPRO,DA1_QTDLOT,DA1_PRCVEN,DA1_MOEDA,DA1_VLRDES,DA1_PERDES,DA1_ESTADO,DA1_TPOPER,DA1_ATIVO,
						B1_TIPO,B1_GRUPO,B1_DESC,B1_UM,B1_GRADE,B1_PRV1
	FROM SD1010 SD1
	JOIN SF1010 SF1 ON 
	( F1_DOC = D1_DOC AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_FILIAL = F1_FILIAL AND 
	F1_HAWB BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZ' AND F1_TIPODOC = '10' AND F1_HAWB <> '' AND F1_ESPECIE = 'NF' AND SF1.D_E_L_E_T_ = '')
	OR
	(F1_DOC = D1_DOC AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_FILIAL = F1_FILIAL 
	AND F1_ESPECIE = 'RCN' AND F1_TIPODOC = '60' AND SF1.D_E_L_E_T_ = '')
	JOIN SB1010 SB1 ON SB1.B1_FILIAL = '0101' AND 
						SB1.B1_COD   =  D1_COD AND                                                                               
						SB1.D_E_L_E_T_ = ''        			
			JOIN DA0010 DA0        
			JOIN DA1010 DA1 
	WHERE
			SD1.D_E_L_E_T_ = '' AND
			SD1.D1_COD   >= '' AND SD1.D1_COD   <= 'ZZZZZZZZZZZZZZZ' AND
			SD1.D1_GRUPO >= '' AND SD1.D1_GRUPO <= 'ZZZZ' AND
			SD1.D1_TP  >= 'ME' AND
						SD1.D1_TP  <= 'ME'

	*/

	BeginSql Alias cAliasDA0
	SELECT DA0_CODTAB,DA0_DESCRI,DA0_DATDE,DA0_DATATE,DA0_HORADE,DA0_HORATE,
                    DA1_FILIAL,DA1_CODTAB,DA1_CODPRO,DA1_QTDLOT,DA1_PRCVEN,DA1_MOEDA,DA1_VLRDES,DA1_PERDES,DA1_ESTADO,DA1_TPOPER,DA1_ATIVO,
                    B1_TIPO,B1_GRUPO,B1_DESC,B1_UM,B1_GRADE,B1_PRV1
        FROM %table:SD1% SD1
		JOIN %table:SF1% SF1 ON
		( F1_DOC = D1_DOC AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_FILIAL = F1_FILIAL AND 
		F1_HAWB BETWEEN %Exp:mv_par14% AND %Exp:mv_par15% AND F1_TIPODOC = '10' AND F1_HAWB <> '' AND F1_ESPECIE = 'NF' AND SF1.%NotDel%)
		OR
		(F1_DOC = D1_DOC AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_FILIAL = F1_FILIAL AND
		F1_DOC BETWEEN %Exp:mv_par16% AND %Exp:mv_par17% AND F1_ESPECIE = 'RCN' AND F1_TIPODOC = '60' AND SF1.%NotDel%)
		JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xFilial:SB1% AND SB1.B1_COD   =  D1_COD AND SB1.%NotDel%
		JOIN %table:DA0% DA0 ON DA0.DA0_FILIAL = %xFilial:DA0% AND DA0.DA0_CODTAB >= %Exp:mv_par01% AND DA0.DA0_CODTAB <= %Exp:mv_par02% AND DA0.%NotDel% 
		JOIN %table:DA1% DA1 ON DA1.DA1_FILIAL = %xFilial:DA1% AND 
						DA1.DA1_CODTAB = DA0.DA0_CODTAB AND
						SB1.B1_COD   =  DA1.DA1_CODPRO AND
						DA1.DA1_ATIVO IN %Exp:cAtivo% AND
						DA1.%NotDel%
		WHERE
			SD1.%NotDel% AND
			SD1.D1_COD   >= %Exp:mv_par07% AND SD1.D1_COD   <= %Exp:mv_par08% AND
			SD1.D1_GRUPO >= %Exp:mv_par05% AND SD1.D1_GRUPO <= %Exp:mv_par06% AND
			SD1.D1_TP  >= %Exp:mv_par03% AND SD1.D1_TP  <= %Exp:mv_par04%

        	ORDER BY %Exp:cOrderBy%
    EndSql 

	If __CUSERID = '000000'
		aLastQuery    := GetLastQuery()
		cLastQuery    := aLastQuery[2]
		aviso("",cLastQuery,{'ok'},,,,,.t.)
    EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*ExpA1*/)
	oReport:Section(1):Section(1):SetParentQuery()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 2                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(2):BeginQuery()	
	Do Case
    	Case oReport:Section(1):nOrder == 1
		    cOrderBy := "%B1_FILIAL,B1_TIPO,B1_COD%"
		Case oReport:Section(1):nOrder == 2
			cOrderBy :=  "%B1_FILIAL,B1_GRUPO,B1_COD%"
		Case oReport:Section(1):nOrder == 3
			cOrderBy :=  "%B1_FILIAL,B1_DESC%"
		Case oReport:Section(1):nOrder == 4
			cOrderBy :=  "%B1_FILIAL,B1_COD%"
	EndCase

	cAliasDA0 := GetNextAlias()
	cAliasDA1 := cAliasDA0
	cAliasSB1 := cAliasDA1

    BeginSql Alias cAliasSB1
        SELECT B1_TIPO,B1_GRUPO,B1_COD,B1_DESC,B1_UM,B1_GRADE,B1_PRV1,B1_QE
        FROM %table:SB1% SB1
        WHERE SB1.B1_FILIAL = %xFilial:SB1% AND 
              SB1.B1_TIPO  >= %Exp:mv_par03% AND
              SB1.B1_TIPO  <= %Exp:mv_par04% AND
              SB1.B1_GRUPO >= %Exp:mv_par05% AND
              SB1.B1_GRUPO <= %Exp:mv_par06% AND
              SB1.B1_COD   >= %Exp:mv_par07% AND
              SB1.B1_COD   <= %Exp:mv_par08% AND
              SB1.%NotDel%
        ORDER BY %Exp:cOrderBy%
    EndSql
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(2):EndQuery(/*ExpA1*/)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oReport:Section(1):Section(1),"SB1",1,{|| xFilial("SB1")+(cAliasDA1)->DA1_CODPRO})
TRPosition():New(oReport:Section(1):Section(1),"SB4",1,{|| xFilial("SB4")+Substr((cAliasDA1)->DA1_CODPRO,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2)))})
TRPosition():New(oReport:Section(2),"SB4",1,{|| xFilial("SB4")+Substr((cAliasSB1)->B1_COD,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2)))})
If ( MV_PAR11 == 2 ) ////no
	oReport:SetMeter(DA0->(LastRec()))
	
	
	dbSelectArea(cAliasDA0)
	While !Eof() .And. !oReport:Cancel()	               
      oReport:Section(1):Init()
		oReport:Section(1):PrintLine()
		oReport:Section(1):Section(1):Init()
		        
		lNotGrade := .T.
		cTabAnt   := (cAliasDA0)->DA0_CODTAB
			
		dbSelectArea(cAliasDA1)			
		While !oReport:Cancel() .And. !Eof() .And. (cAliasDA1)->DA1_FILIAL == xFilial("DA1") .And. (cAliasDA1)->DA1_CODTAB == cTabAnt
		
			If ValidMasc((cAliasDA1)->DA1_CODPRO,MV_PAR09)
				If MV_PAR12 == 1
					lNotGrade := .T.							
					If (cAliasSB1)->B1_GRADE == "S" .And. !Empty(cProdRef) .And. cProdRef == Substr((cAliasDA1)->DA1_CODPRO,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2)))
						lNotGrade := .F.
					EndIf
				EndIf

				If lNotGrade
					oReport:Section(1):Section(1):PrintLine()
    			EndIf
			EndIf
			cProdRef := Substr((cAliasDA1)->DA1_CODPRO,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2)))
 		
 			dbSelectarea(cAliasDA1)
			dbSkip()
						
		EndDo
		oReport:Section(1):Section(1):Finish()
		If mv_par10 == 1
			oReport:Section(1):SetPageBreak(.T.)
		Else			
			oReport:SkipLine()
			oReport:SkipLine()
		EndIf
		
		oReport:Section(1):Finish()
		oReport:IncMeter()
		
	EndDo
	
Else			
	oReport:SetMeter(SB1->(LastRec()))
	
	dbSelectArea(cAliasSB1)
	dbGotop()

	While !oReport:Cancel() .And. !(cAliasSB1)->(Eof())		
		lNotGrade := .T.
		oReport:Section(2):Init()			
		While !oReport:Cancel() .And. !(cAliasSB1)->(Eof())
			If ValidMasc((cAliasSB1)->B1_COD,MV_PAR09)
				If MV_PAR12 == 1      
					lNotGrade := .T.
					If (cAliasSB1)->B1_GRADE == "S" .And. !Empty(cProdRef) .And. cProdRef == Substr((cAliasSB1)->B1_COD,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2)))
						lNotGrade := .F.
					EndIf
				EndIf
				If lNotGrade			        
					oReport:Section(2):PrintLine()					
    			EndIf
			EndIf
			cProdRef := Substr((cAliasSB1)->B1_COD,1,Val(Substr(SuperGetMv("MV_MASCGRD",.F.),1,2)))
			dbSelectArea(cAliasSB1)
			dbSkip()		
		EndDo
		oReport:Section(2):Finish()		
	EndDo
EndIf
	If Select(cAliasDA0)  > 0 
		DbSelectArea(cAliasDA0) 
		DbCloseArea()
	EndIf
	If Select(cAliasDA1)  > 0 
		DbSelectArea(cAliasDA1) 
		DbCloseArea()
	EndIf
	If Select(cAliasSB1)  > 0 
		DbSelectArea(cAliasSB1) 
		DbCloseArea()
	EndIf
Return
