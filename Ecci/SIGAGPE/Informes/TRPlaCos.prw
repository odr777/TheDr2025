#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

#Define NNAME	1
#Define NALIAS	2
#Define NTITULO	3

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRPlaCos ³ Autor ³ Denar Terrazas							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Planilla de costos									 		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRPlaCos()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Global														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³21/07/2020³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function TRPlaCos()
	Local oReport
	Private cPerg   := "TRPlaCos"   // elija el Nombre de la pregunta
	Private aCab	:= {}
	Private aDadoCab:= {}

	//Parametros
	Private cProcesso 	:= ""
	Private cPeriodo	:= ""
	Private cSemana		:= ""
	Private cFilDe   	:= ""
	Private cFilAte  	:= ""
	Private cMatDe   	:= ""
	Private cMatAte  	:= ""
	Private cCcDe    	:= ""
	Private cCcAte   	:= ""
	Private cSituacao  	:= ""
	Private cCategoria 	:= ""
	Private nOrdem		:= 0

	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.T.)

	cProcesso 	:= MV_PAR01
	cPeriodo	:= MV_PAR02
	cSemana		:= MV_PAR03
	cFilDe   	:= MV_PAR04
	cFilAte  	:= MV_PAR05
	cMatDe   	:= MV_PAR06
	cMatAte  	:= MV_PAR07
	cCcDe    	:= MV_PAR08
	cCcAte   	:= MV_PAR09
	cSituacao  	:= MV_PAR10
	cCategoria 	:= MV_PAR11
	nOrdem		:= MV_PAR12

	aCab	:= getCabPds()
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg	:= "Planilla de Costos"
	Local cTituloProg	:= "Planilla de Costos"
	Local cNomeArq		:= "Planilla-Costos-" + cPeriodo
	Local i

	oReport	 := TReport():New(cNomeArq,NombreProg,/*cPerg*/,{|oReport| PrintReport(oReport)},cTituloProg)

	oSection := TRSection():New(oReport,"Planilla de Costos",{"SRA"})

	oReport:SetTotalInLine(.F.)
	/*oReport:SetParam(cPerg)
	oReport:ShowParamPage()*/

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection, "RA_FILIAL", "SRA", "Sucursal")
	TRCell():New(oSection, "RA_MAT", "SRA", "Matricula")
	TRCell():New(oSection, "RA_RG", "SRA", "CI")
	TRCell():New(oSection, "RJ_DESC", "SRJ", "Cargo")
	TRCell():New(oSection, "RA_NOME", "SRA", "Nombre")
	TRCell():New(oSection, "CODCCUSTO", "", "Código Centro de Costo")
	TRCell():New(oSection, "CTT_DESC01", "CTT", "Centro de Costo")
	TRCell():New(oSection, "CODTRF", "", "Codigo Item Contable")
	TRCell():New(oSection, "CTD_DESC01", "CTD", "Item Contable")
	TRCell():New(oSection, "COD_CLVL", "", "Codigo Clase Valor")
	TRCell():New(oSection, "DESC_CLVL", "CTH", "Clase Valor")
	TRCell():New(oSection, "CL_VL2", "CTH", "Apunte/P.D.")
	TRCell():New(oSection, "PORCENTAJE", "", "Porcentaje")
	TRCell():New(oSection, "TOTAL_GANADO", "", "TOTAL GANADO")

	for i:= 1 to Len(aCab)
		TRCell():New(oSection, aCab[i][NNAME], aCab[i][NALIAS],aCab[i][NTITULO])
	next i

Return oReport

Static Function PrintReport(oReport)
	Local aArea		:= getArea()
	Local oSection	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	Local cValida	:= ""
	Local cSitQuery	:= ""
	Local cCatQuery	:= ""
	Local cOrdLan	:= ""
	Local nTotGan	:= 0//Utilzado para el Total Ganado
	Local nReg		:= 1

	If !Empty(cSituacao)
		For nReg:=1 to Len(cSituacao)
			cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cSituacao)
				cSitQuery += ","
			Endif
		Next nReg
		cSitQuery := "%" + cSitQuery + "%"
	EndIf

	cCatQuery	:= ""
	If !Empty(cSituacao)
		For nReg:=1 to Len(cCategoria)
			cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cCategoria)
				cCatQuery += ","
			Endif
		Next nReg
		cCatQuery := "%" + cCatQuery + "%"
	EndIf

	If(nOrdem == 1)
		cOrdLan	  := "% RA_FILIAL, RA_MAT, CODTRF, PORCENTAJE %"
	ElseIf(nOrdem == 2)
		cOrdLan   := "% RA_FILIAL, RA_CC, RA_MAT, CODTRF, PORCENTAJE %"
	else
		cOrdLan	  := "% RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME, CODTRF, PORCENTAJE %"
	EndIf

	#IFDEF TOP

	// consulta a la base de datos
		BeginSql Alias cAliasQry

		SELECT
			PLANILLA.RA_FILIAL,
			PLANILLA.RA_MAT,
			PLANILLA.RA_RG,
			PLANILLA.RA_ALFANUM,
			RA_UFCI,
			PLANILLA.RA_SEGUROS,
			PLANILLA.RA_CC,
			PLANILLA.RA_ITEM,
			PLANILLA.RA_PRISOBR,
			PLANILLA.RA_SECSOBR,
			PLANILLA.RA_PRINOME,
			PLANILLA.RA_SECNOME,
			PLANILLA.RA_NOME,
			PLANILLA.RA_CODFUNC,
			PLANILLA.RA_ADMISSA,
			PLANILLA.RA_DEMISSA,
			PLANILLA.RC_PD,
			PLANILLA.RC_HORAS,
			PLANILLA.RC_VALOR,
			PLANILLA.RC_ROTEIR,
			PLANILLA.RV_TIPOCOD,
			PLANILLA.RV_CODFOL,
			PROYECTO.CODPRJ,
			COALESCE(PROYECTO.PORCENTAJE,
			1) PORCENTAJE,
			COALESCE((PLANILLA.RC_VALOR * PROYECTO.PORCENTAJE),
			RC_VALOR) VALOR,
			COALESCE(PROYECTO.CODCCUSTO COLLATE LATIN1_GENERAL_CS_AI,
			PLANILLA.RA_CC) CODCCUSTO,
			CTT.CTT_DESC01,
			PROYECTO.CODTRF,
		CASE
				WHEN COALESCE(CLASE_VALOR,
				' ') = ' '
				AND PLANILLA.RA_CC = '00000000200' THEN (
				SELECT
					MAX(N3_CLVL)
				FROM
					%table:SN3% (NOLOCK)
				WHERE
					%notdel%
					AND N3_CBASE IN(
					SELECT
						TOP 1 SUBSTRING(T9_CODIMOB, 1, 10)
					FROM
						%table:ST9% s (NOLOCK),
						%table:TV1% t (NOLOCK)
					WHERE
						s.%notdel%
						AND t.%notdel%
						AND T9_CODBEM = TV1_CODBEM
						AND t.TV1_OPERAD = PLANILLA.RA_MAT
						AND SUBSTRING(TV1_DTSERV, 1, 6) = %exp:cPeriodo%
					GROUP BY
						SUBSTRING(T9_CODIMOB, 1, 10)
					ORDER BY
						COUNT(*) DESC
				))
		ELSE CLASE_VALOR
		END CLASE_VALOR,
			(
			SELECT
				TOP 1 CTH_DESC01
			FROM
				%table:CTH% CTH (NOLOCK)
			WHERE
				CTH.%notdel%
				AND CTH_FILIAL = %exp:xFilial('CTH')%
				AND CTH_CLVL =
	CASE
					WHEN COALESCE(CLASE_VALOR,
					' ') = ' '
						AND PLANILLA.RA_CC = '00000000200' THEN (
						SELECT
							MAX(N3_CLVL)
						FROM
							%table:SN3% (NOLOCK)
						WHERE
							%notdel%
							AND N3_CBASE IN(
							SELECT
								TOP 1 SUBSTRING(T9_CODIMOB, 1, 10)
							FROM
								%table:ST9% s (NOLOCK),
								%table:TV1% t (NOLOCK)
							WHERE
								s.%notdel%
								AND t.%notdel%
								AND T9_CODBEM = TV1_CODBEM
								AND t.TV1_OPERAD = PLANILLA.RA_MAT
								AND SUBSTRING(TV1_DTSERV, 1, 6) = %exp:cPeriodo%
							GROUP BY
								SUBSTRING(T9_CODIMOB, 1, 10)
							ORDER BY
								COUNT(*) DESC
									))
	ELSE CLASE_VALOR
	END
		)
		AS DESC_CLVL,
			COALESCE(AF9.AF9_ITEMCC,
			PLANILLA.RA_ITEM ) ITEM_CONTABLE,
			RV_UCONTA ,
			RV_UCONTA2 ,
			RV_UCONTA3,
			RV_DESC,
			CLASE_VALOR CL_VL2
		FROM
			(
			SELECT
				SRA.RA_FILIAL,
				SRA.RA_MAT,
				SRA.RA_RG,
				SRA.RA_ALFANUM,
				RA_UFCI,
				SRA.RA_SEGUROS,
				RC_CC RA_CC,
				SRA.RA_PRISOBR,
				SRA.RA_SECSOBR,
				SRA.RA_PRINOME,
				SRA.RA_SECNOME,
				SRA.RA_NOME,
				SRA.RA_CODFUNC,
				SRA.RA_ADMISSA,
				SRA.RA_DEMISSA,
				SRC.RC_PD,
				SRC.RC_HORAS,
				SRC.RC_VALOR,
				SRC.RC_ROTEIR,
				SRV.RV_TIPOCOD,
				SRV.RV_CODFOL,
				SRA.RA_ITEM,
				RV_UCONTA ,
				RV_UCONTA2 ,
				RV_UCONTA3,
				RV_DESC
			FROM
				%table:SRA% SRA (NOLOCK)
			JOIN
					%table:SRC% SRC (NOLOCK)
					ON
				SRA.RA_FILIAL = SRC.RC_FILIAL
				AND SRA.RA_MAT = SRC.RC_MAT
			JOIN
					%table:SRV% SRV (NOLOCK)
					ON
				SRV.RV_COD = SRC.RC_PD
			WHERE
				SRA.RA_FILIAL BETWEEN %exp:cFilDe% AND %exp:cFilAte%
				AND SRA.RA_MAT BETWEEN %exp:cMatDe% AND %exp:cMatAte%
				AND SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%)
					AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%)
						AND SRC.RC_PROCES = %exp:cProcesso%
						AND SRC.RC_PERIODO = %exp:cPeriodo%
						AND SRC.RC_SEMANA = %exp:cSemana%
						AND SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:cPeriodo%
							AND 
				(
					SRA.RA_DEMISSA = ''
								OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:cPeriodo%
				)
								AND 
				(
					SRV.RV_XPLACOS = 'S'
									OR SRV.RV_TIPOCOD = '1'
				)
								AND SRA.%notdel%
								AND SRC.%notdel%
								AND SRV.%notdel%
						UNION
							SELECT
								SRA.RA_FILIAL,
								SRA.RA_MAT,
								SRA.RA_RG,
								SRA.RA_ALFANUM,
								RA_UFCI,
								SRA.RA_SEGUROS,
								RD_CC RA_CC,
								SRA.RA_PRISOBR,
								SRA.RA_SECSOBR,
								SRA.RA_PRINOME,
								SRA.RA_SECNOME,
								SRA.RA_NOME,
								SRA.RA_CODFUNC,
								SRA.RA_ADMISSA,
								SRA.RA_DEMISSA,
								SRD.RD_PD,
								SRD.RD_HORAS,
								SRD.RD_VALOR,
								SRD.RD_ROTEIR,
								SRV.RV_TIPOCOD,
								SRV.RV_CODFOL,
								SRA.RA_ITEM,
								RV_UCONTA ,
								RV_UCONTA2 ,
								RV_UCONTA3,
								RV_DESC
							FROM
								%table:SRA% SRA (NOLOCK)
							JOIN
					%table:SRD% SRD (NOLOCK)
					ON
								SRA.RA_FILIAL = SRD.RD_FILIAL
								AND SRA.RA_MAT = SRD.RD_MAT
							JOIN
					%table:SRV% SRV (NOLOCK)
					ON
								SRV.RV_COD = SRD.RD_PD
							WHERE
								SRA.RA_FILIAL BETWEEN %exp:cFilDe% AND %exp:cFilAte%
								AND SRA.RA_MAT BETWEEN %exp:cMatDe% AND %exp:cMatAte%
								AND SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%)
									AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%)
										AND SRD.RD_PROCES = %exp:cProcesso%
										AND SRD.RD_PERIODO = %exp:cPeriodo%
										AND SRD.RD_SEMANA = %exp:cSemana%
										AND SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:cPeriodo%
											AND 
				(
					SRA.RA_DEMISSA = ''
												OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:cPeriodo%
				)
												AND 
				(
					SRV.RV_XPLACOS = 'S'
													OR SRV.RV_TIPOCOD = '1'
				)
												AND SRA.%notdel%
												AND SRD.%notdel%
												AND SRV.%notdel%
		)
		AS PLANILLA
		LEFT JOIN
			(
			SELECT
				APUNTES.CODPRJ,
				APUNTES.CODCCUSTO,
				APUNTES.CODTRF,
				APUNTES.CHAPA,
				COALESCE(CLASE_VALOR,
				'') AS CLASE_VALOR,
				SUM(QUANTIDADE) QUANTIDADE,
				SUM(TOTAL_HORAS) TOTAL_HORAS,
				SUM(PORCENTAJE) PORCENTAJE
			FROM
				(
				SELECT
					TOPPRJ.CODPRJ,
					TOPPRJ.CODCCUSTO,
					TAREAS.CODTRF,
					INSUMOS.CHAPA,
					INSUMOS.DATAAPROPRIACAO,
					CONVERT(VARCHAR(8),
					INSUMOS.DATAAPROPRIACAO,
					112) FECHA,
					CONVERT(VARCHAR(6),
					INSUMOS.DATAAPROPRIACAO,
					112) PERIODO,
					SUM(INSUMOS.QUANTIDADE) QUANTIDADE,
					(
					SELECT
						SUM(QUANTIDADE)
					FROM
						MISMAPROP (NOLOCK)
					WHERE
						ORIGEMAPROP IN(0, 1)
						AND CHAPA = INSUMOS.CHAPA
						AND CONVERT(VARCHAR(6),
						DATAAPROPRIACAO,
						112) = %exp:cPeriodo%
						)
						AS TOTAL_HORAS,
					(
							SUM(INSUMOS.QUANTIDADE) / (
					SELECT
						SUM(QUANTIDADE)
					FROM
						MISMAPROP (NOLOCK)
					WHERE
						ORIGEMAPROP IN(0, 1)
						AND CHAPA = INSUMOS.CHAPA
						AND CONVERT(VARCHAR(6),
						DATAAPROPRIACAO,
						112) = %exp:cPeriodo%)
						)
						PORCENTAJE,
					(
					SELECT
						TOP 1 SN3.N3_CLVLCON
					FROM
						%table:TV1% TV1 (NOLOCK)
					JOIN
								%table:ST9% ST9 (NOLOCK)
								ON
						ST9.T9_FILIAL = TV1.TV1_FILIAL
						AND ST9.T9_CODBEM = TV1.TV1_CODBEM
					LEFT JOIN
								%table:SN3% SN3 (NOLOCK)
								ON
						ST9.T9_CODIMOB = 
								(
									SN3.N3_CBASE + SN3.N3_ITEM
								)
							AND SN3.%notdel%
						WHERE
							TV1.TV1_DTSERV = CONVERT(VARCHAR(8),
							INSUMOS.DATAAPROPRIACAO,
							112)
								AND TV1.TV1_OPERAD COLLATE Latin1_General_CS_AI = INSUMOS.CHAPA
								AND TV1.%notdel% 
						)
						AS CLASE_VALOR
				FROM
					MISMAPROP INSUMOS (NOLOCK)
				JOIN
							MTAREFA TAREAS (NOLOCK)
							ON
					INSUMOS.IDPRJ = TAREAS.IDPRJ
					AND INSUMOS.IDTRF = TAREAS.IDTRF
				JOIN
							MPRJ TOPPRJ (NOLOCK)
							ON
					TOPPRJ.IDPRJ = INSUMOS.IDPRJ
				WHERE
					ORIGEMAPROP IN(0, 1)
					AND CONVERT(VARCHAR(6),
					INSUMOS.DATAAPROPRIACAO,
					112) = %exp:cPeriodo%
				GROUP BY
					TOPPRJ.CODPRJ,
					TOPPRJ.CODCCUSTO,
					TAREAS.CODTRF,
					INSUMOS.CHAPA,
					INSUMOS.DATAAPROPRIACAO 
					)
					AS APUNTES
			GROUP BY
				APUNTES.CODPRJ,
				APUNTES.CODCCUSTO,
				APUNTES.CODTRF,
				APUNTES.CHAPA,
				CLASE_VALOR 
			)
			AS PROYECTO 
			ON
			PROYECTO.CHAPA = PLANILLA.RA_MAT COLLATE Latin1_General_CS_AI
		LEFT JOIN
			CTT010 CTT (NOLOCK)
			ON
			CTT.CTT_CUSTO COLLATE Latin1_General_CS_AI = PROYECTO.CODCCUSTO
			AND CTT.%notdel%
			AND PROYECTO.CODCCUSTO BETWEEN %exp:cCcDe% AND %exp:cCcAte%
		LEFT JOIN AF9010 AF9 (NOLOCK)
			ON
			AF9_TAREFA COLLATE Latin1_General_CS_AI = CODTRF
			AND AF9_PROJET COLLATE Latin1_General_CS_AI = CODPRJ
			AND AF9.%notdel%
		ORDER BY
			RA_FILIAL,
			RA_MAT,
			CODTRF,
			PORCENTAJE

EndSql

//cQuery:=GetLastQuery()
//Aviso("query",cvaltochar(cQuery[2]`````),{"Ok"},,,,,.t.)//   usar este en esste caso cuando es BEGIN SQL

DbSelectArea(cAliasQry)
oSection:Init()
while (cAliasQry)->(!Eof())
	cValida	:= (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT + (cAliasQry)->CODCCUSTO + (cAliasQry)->CODTRF + cvaltochar((cAliasQry)->PORCENTAJE)
	cSuc	:= (cAliasQry)->RA_FILIAL
	cMat	:= (cAliasQry)->RA_MAT
	cCi		:= TRIM((cAliasQry)->RA_RG) + IIF(!EMPTY((cAliasQry)->RA_ALFANUM), "-" + TRIM((cAliasQry)->RA_ALFANUM), "") + " " + TRIM((cAliasQry)->RA_UFCI)
	cNome	:= (cAliasQry)->RA_NOME
	cCodFunc:= (cAliasQry)->RA_CODFUNC
	cCc		:= (cAliasQry)->CODCCUSTO
	cCcDesc	:= (cAliasQry)->CTT_DESC01

	If(Empty(cCcDesc))
		cCc		:= (cAliasQry)->RA_CC
		//CTT_FILIAL+CTT_CUSTO //1
		cCcDesc	:= GetAdvFVal("CTT", "CTT_DESC01", xFilial("CTT") + PadR( TRIM(cCc), tamSX3("RA_CC")[1]),1,"")
	EndIf

	//AF9_FILIAL+AF9_PROJET+AF9_TAREFA //5
	//cItemC	:= GetAdvFVal("AF9", "AF9_ITEMCC", xFilial("AF9") + PadR( TRIM((cAliasQry)->CODPRJ), tamSX3("AF9_PROJET")[1]) + PadR( TRIM((cAliasQry)->CODTRF), tamSX3("AF9_TAREFA")[1]),5,"")
	cItemC	:= (cAliasQry)->ITEM_CONTABLE
	//CTD_FILIAL+CTD_ITEM //1
	cItemCDesc:= GetAdvFVal("CTD", "CTD_DESC01", xFilial("CTD") + cItemC,1,"")

	cClVl		:= (cAliasQry)->CLASE_VALOR
	cClVlDesc	:= TRIM((cAliasQry)->DESC_CLVL)

	cApuntePD	:= "NO"
	if(!Empty(ALLTRIM((cAliasQry)->CL_VL2)))//Si hay valor, significa que realizaron Parte Diario y apunte de mano de obra asignado al funcionario en la misma fecha
		cApuntePD	:= "SI"
	EndIf

	nPercent:= ((cAliasQry)->PORCENTAJE * 100)
	nValor	:= (cAliasQry)->VALOR
	nPos	:= ASCAN(aDadoCab, (cAliasQry)->RC_PD)

	If( TRIM((cAliasQry)->RV_TIPOCOD) == '1' .AND. TRIM((cAliasQry)->RC_ROTEIR) == 'FOL' )//Si es Remuneración
		nTotGan+= nValor
	EndIf

	(cAliasQry)->(dbSkip())

	If(nPos > 0)
		oSection:Cell(aCab[nPos][NNAME]):SetValue( nValor )
	EndIf

	If(cValida <> (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT + (cAliasQry)->CODCCUSTO + (cAliasQry)->CODTRF + cvaltochar((cAliasQry)->PORCENTAJE) )

		oSection:Cell("RA_FILIAL"):SetValue( cSuc )
		oSection:Cell("RA_MAT"):SetValue( cMat )
		oSection:Cell("RA_RG"):SetValue( cCi )

		cFuncion:= fDesc("SRJ",cCodFunc,"RJ_DESC")
		oSection:Cell("RJ_DESC"):SetValue( cFuncion )
		oSection:Cell("RA_NOME"):SetValue( cNome )

		oSection:Cell("CODCCUSTO"):SetValue( cCc )
		oSection:Cell("CTT_DESC01"):SetValue( cCcDesc )

		oSection:Cell("CODTRF"):SetValue( cItemC )
		oSection:Cell("CTD_DESC01"):SetValue( cItemCDesc )

		oSection:Cell("COD_CLVL"):SetValue( cClVl )		//Codigo Clase Valor
		oSection:Cell("DESC_CLVL"):SetValue( cClVlDesc )//Descripcion Clase Valor

		oSection:Cell("CL_VL2"):SetValue( cApuntePD )

		oSection:Cell("PORCENTAJE"):SetValue( nPercent )

		oSection:Cell("TOTAL_GANADO"):SetValue( nTotGan )
		nTotGan:= 0

		oSection:PrintLine(,,,.T.)

			/*for i:= 1 to Len(aCab)
			oSection:Cell(aCab[i][NNAME]):SetValue("")
	next i*/

endIf
enddo

	oSection:Finish()

#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
#ENDIF
	(cAliasQry)->(dbCloseArea())
	restArea(aArea)
Return

/**
*
* @author: Denar Terrazas Parada
* @since: 21/07/2020
* @description: Funcion que devuelve los conceptos para la cabecera
*/
static function getCabPds()
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RV_COD, RV_CODFOL, RV_DESC, RV_TIPOCOD
		FROM %table:SRV% SRV
		WHERE SRV.RV_XPLACOS = 'S'
		AND SRV.%notdel%
		ORDER BY RV_COD, RV_TIPOCOD

	EndSql

	DbSelectArea(OrdenConsul)
	while (OrdenConsul)->(!Eof())
		AADD(aRet, { (OrdenConsul)->RV_COD, "SRV", (OrdenConsul)->RV_DESC })
		AADD(aDadoCab, (OrdenConsul)->RV_COD)
		(OrdenConsul)->(dbSkip())
	enddo
	(OrdenConsul)->(dbCloseArea())
	restArea(aArea)
return aRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSX1(cPerg,"01","¿Proceso?"	, "¿Proceso?"	,"¿Proceso?"	,"MV_CH1","C",05,0,0,"G","","RCJ","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿Periodo Competenc. (AAAAMM)?" 		, "¿Periodo Competenc. (AAAAMM)?"		,"¿Periodo Competenc. (AAAAMM)?"		,"MV_CH2","C",06,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿N° Pago?" 		, "¿N° Pago?"		,"¿N° Pago?"		,"MV_CH3","C",02,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿De Sucursal?"	, "¿De Sucursal?"	,"¿De Sucursal?"	,"MV_CH4","C",04,0,0,"G","","SM0","033","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿A Sucursal?" 	, "¿A Sucursal?"	,"¿A Sucursal?"		,"MV_CH5","C",04,0,0,"G","","SM0","033","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿De Matrícula?" , "¿De Matrícula?"	,"¿De Matrícula?"	,"MV_CH6","C",06,0,0,"G","","SRA","","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿A Matrícula?" 	, "¿A Matrícula?"	,"¿A Matrícula?"	,"MV_CH7","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿De Centro de costo?" , "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH8","C",11,0,0,"G","","CTT","004","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿A Centro de costo?" 	, "¿A Centro de costo?"	,"¿A Centro de costo?"	,"MV_CH9","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿Situaciones por imprimir?" , "¿Situaciones por imprimir?"	,"¿Situaciones por imprimir?"	,"MV_CHA","C",05,0,0,"G","fSituacao()","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿Categorías por imprimir?" 	, "¿Categorías por imprimir?"	,"¿Categorías por imprimir?"	,"MV_CHB","C",15,0,0,"G","fCategoria()","","","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"12","¿Orden?"		, "¿Orden?"			,"¿Orden?"			,"MV_CHC","N",01,0,0,"C","","","","","MV_PAR12","Sucursal+Matric.","Sucursal+Matric.","Sucursal+Matric.","","Sucursal+C.Costo","Sucursal+C.Costo","Sucursal+C.Costo"	,"Apellido Paterno","Apellido Paterno","Apellido Paterno")

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
