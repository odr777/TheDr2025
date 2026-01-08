#include 'protheus.ch'
#include "Topconn.ch"



/*/{Protheus.doc} User Function RECCOSTOS
    Reclasificación de costos
    @type  Function
    @author Nahim Terrazzas
    @since 27/05/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RECCOSTOS()
    
    Local aArea 	 := GetArea()
    local cArquivo // := "TRB"
    local cPerg := "RECCOSTO"
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.T.)
	cProcesso 	:= MV_PAR01
	cPeriodo	:= MV_PAR02
	cSemana		:= '01'
	cFilDe   	:= xFilial("SRA")
	cFilAte  	:= xFilial("SRA")
	cMatDe   	:= MV_PAR03
	cMatAte  	:= MV_PAR04
	cCcDe    	:= MV_PAR05
	cCcAte   	:= MV_PAR06
	// cSituacao  	:= MV_PAR10
	// cCategoria 	:= MV_PAR11
	// nOrdem		:= MV_PAR12

// "01","¿Proceso?"	, "¿Proces
// "02","¿Periodo Competenc. (A
// "03","¿De Matrícula?" , "¿De
// "04","¿A Matrícula?" 	, "¿A 
// "05","¿De Centro de costo?" 
// "06","¿A Centro de costo?" 

    TRB	:= GetNextAlias()

    // consulta a la base de datos
    BeginSql Alias TRB
SELECT PL.RA_FILIAL,MAX(PL.RA_MAT) RA_MAT,MAX(PL.RA_RG) RA_RG,MAX(PL.RA_ALFANUM) RA_ALFANUM,MAX(RA_UFCI) RA_UFCI, 
MAX(PL.RA_SEGUROS) RA_SEGUROS,PL.RA_CC, PL.RA_ITEM, MAX(PL.RA_PRISOBR) RA_PRISOBR, MAX(PL.RA_SECSOBR) RA_SECSOBR,
MAX(PL.RA_PRINOME) RA_PRINOME,MAX(PL.RA_SECNOME) RA_SECNOME,MAX(PL.RA_NOME) RA_NOME,MAX(PL.RA_CODFUNC) RA_CODFUNC,
MAX(PL.RA_ADMISSA) RA_ADMISSA,MAX(PL.RA_DEMISSA) RA_DEMISSA,MAX(PL.RC_PD) RC_PD,SUM(PL.RC_HORAS) RC_HORAS, SUM(PL.RC_VALOR) RC_VALOR,
MAX(PL.RC_ROTEIR) RC_ROTEIR,MAX(PL.RV_TIPOCOD) RV_TIPOCOD,MAX(PL.RV_CODFOL) RV_CODFOL,MAX(PL.CODPRJ) CODPRJ,AVG(PL.PORCENTAJE) PORCENTAJE,
SUM(PL.VALOR) VALOR, CODCCUSTO,
PL.CTT_DESC01,PL.CODTRF, CLASE_VALOR, PL.DESC_CLVL, ITEM_CONTABLE, RV_UCONTA,RV_UCONTA2,RV_UCONTA3,CLASE_VALOR CLVL2 
FROM 
(
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
   COALESCE(PROYECTO.PORCENTAJE, 1) PORCENTAJE,
   COALESCE((PLANILLA.RC_VALOR * PROYECTO.PORCENTAJE), RC_VALOR) VALOR,
   ISNULL(PROYECTO.CODCCUSTO COLLATE Latin1_General_CS_AI, PLANILLA.RA_CC COLLATE Latin1_General_CS_AI)  CODCCUSTO,
   CTT.CTT_DESC01,
   PROYECTO.CODTRF,
   CASE WHEN ISNULL(CLASE_VALOR, ' ') = ' ' AND PLANILLA.RA_CC = '00000000200' THEN (SELECT MAX(N3_CLVL) FROM SN3010 WHERE D_E_L_E_T_ = ' ' AND N3_CBASE IN(
			SELECT TOP 1 SUBSTRING(T9_CODIMOB, 1, 10)
			FROM ST9010 s, TV1010 t WHERE s.D_E_L_E_T_ = ' ' AND t.D_E_L_E_T_ = ' '
			AND T9_CODBEM = TV1_CODBEM
			AND t.TV1_OPERAD = PLANILLA.RA_MAT
			AND SUBSTRING(TV1_DTSERV, 1, 6) = %exp:cPeriodo%
			GROUP BY SUBSTRING(T9_CODIMOB, 1, 10)
			ORDER BY COUNT(*) DESC
		))
	ELSE CLASE_VALOR
	END CLASE_VALOR,
   (
      SELECT
         TOP 1 CTH_DESC01 
      FROM
         CTH010 CTH 
      WHERE
         CTH.D_E_L_E_T_ = ' ' 
         AND CTH_FILIAL = '01  ' 
         AND CTH_CLVL = CASE WHEN ISNULL(CLASE_VALOR, ' ') = ' ' AND PLANILLA.RA_CC = '00000000200' THEN (SELECT MAX(N3_CLVL) FROM SN3010 WHERE D_E_L_E_T_ = ' ' AND N3_CBASE IN(
								SELECT TOP 1 SUBSTRING(T9_CODIMOB, 1, 10)
								FROM ST9010 s, TV1010 t WHERE s.D_E_L_E_T_ = ' ' AND t.D_E_L_E_T_ = ' '
								AND T9_CODBEM = TV1_CODBEM
								AND t.TV1_OPERAD = PLANILLA.RA_MAT
								AND SUBSTRING(TV1_DTSERV, 1, 6) = %exp:cPeriodo%
								GROUP BY SUBSTRING(T9_CODIMOB, 1, 10)
								ORDER BY COUNT(*) DESC
							))
						ELSE CLASE_VALOR
						END
   )
   AS DESC_CLVL,
   ISNULL(AF9.AF9_ITEMCC, PLANILLA.RA_ITEM ) ITEM_CONTABLE,
   RV_UCONTA , RV_UCONTA2 , RV_UCONTA3, CLASE_VALOR CLVL2
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
         SRA.RA_ITEM, RV_UCONTA , RV_UCONTA2 , RV_UCONTA3
      FROM
         SRA010 SRA 
         JOIN
            SRC010 SRC 
            ON SRA.RA_FILIAL = SRC.RC_FILIAL 
            AND SRA.RA_MAT = SRC.RC_MAT 
         JOIN
            SRV010 SRV 
            ON SRV.RV_COD = SRC.RC_PD 
      WHERE
        SRA.RA_FILIAL BETWEEN   %exp:cFilDe% AND %exp:cFilAte% 
        AND SRA.RA_MAT BETWEEN %exp:cMatDe% AND %exp:cMatAte%
         AND SRA.RA_SITFOLH IN 
         (
            ' ',
            'A',
            'D',
            'F',
            'T' 
         )
         AND SRA.RA_CATFUNC IN 
         (
            'A',
            'C',
            'D',
            'E',
            'G',
            'H',
            'I',
            'J',
            'M',
            'P',
            'S',
            'T',
            '*',
            '*',
            '*' 
         )
        AND SRC.RC_PROCES = %exp:cProcesso% 
        AND SRC.RC_PERIODO = %exp:cPeriodo% 
        AND SRC.RC_SEMANA = '01' 
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
         AND SRA.D_E_L_E_T_ = ' ' 
         AND SRC.D_E_L_E_T_ = ' ' 
         AND SRV.D_E_L_E_T_ = ' ' 
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
         SRA.RA_ITEM , RV_UCONTA , RV_UCONTA2 , RV_UCONTA3
      FROM
         SRA010 SRA 
         JOIN
            SRD010 SRD 
            ON SRA.RA_FILIAL = SRD.RD_FILIAL 
            AND SRA.RA_MAT = SRD.RD_MAT 
         JOIN
            SRV010 SRV 
            ON SRV.RV_COD = SRD.RD_PD 
      WHERE
         SRA.RA_FILIAL BETWEEN %exp:cFilDe% AND %exp:cFilAte% 
         AND SRA.RA_MAT BETWEEN %exp:cMatDe% AND %exp:cMatAte%
         AND SRA.RA_SITFOLH IN 
         (
            ' ',
            'A',
            'D',
            'F',
            'T' 
         )
         AND SRA.RA_CATFUNC IN 
         (
            'A',
            'C',
            'D',
            'E',
            'G',
            'H',
            'I',
            'J',
            'M',
            'P',
            'S',
            'T',
            '*',
            '*',
            '*' 
         )
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
         AND SRA.D_E_L_E_T_ = ' ' 
         AND SRD.D_E_L_E_T_ = ' ' 
         AND SRV.D_E_L_E_T_ = ' '
   )
   AS PLANILLA 
   LEFT JOIN
      (
         SELECT
            APUNTES.CODPRJ,
            APUNTES.CODCCUSTO,
            APUNTES.CODTRF,
            APUNTES.CHAPA,
            COALESCE(CLASE_VALOR, '') AS CLASE_VALOR,
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
                  CONVERT(VARCHAR(8), INSUMOS.DATAAPROPRIACAO, 112) FECHA,
                  CONVERT(VARCHAR(6), INSUMOS.DATAAPROPRIACAO, 112) PERIODO,
                  SUM(INSUMOS.QUANTIDADE) QUANTIDADE,
                  (
                     SELECT
                        SUM(QUANTIDADE) 
                     FROM
                        MISMAPROP 
                     WHERE
                        ORIGEMAPROP IN(0, 1) 
                        AND CHAPA = INSUMOS.CHAPA 
                        AND CONVERT(VARCHAR(6), DATAAPROPRIACAO, 112) = %exp:cPeriodo%
                  )
                  AS TOTAL_HORAS,
                  (
                     SUM(INSUMOS.QUANTIDADE) / (
                     SELECT
                        SUM(QUANTIDADE) 
                     FROM
                        MISMAPROP 
                     WHERE
                        ORIGEMAPROP IN(0, 1) 
                        AND CHAPA = INSUMOS.CHAPA 
                        AND CONVERT(VARCHAR(6), DATAAPROPRIACAO, 112) = %exp:cPeriodo%)
                  )
                  PORCENTAJE,
                  (
                     SELECT
                        TOP 1 SN3.N3_CLVLCON 
                     FROM
                        TV1010 TV1 
                        JOIN
                           ST9010 ST9 
                           ON ST9.T9_FILIAL = TV1.TV1_FILIAL 
                           AND ST9.T9_CODBEM = TV1.TV1_CODBEM 
                        LEFT JOIN
                           SN3010 SN3 
                           ON ST9.T9_CODIMOB = 
                           (
                              SN3.N3_CBASE + SN3.N3_ITEM
                           )
                           AND SN3.D_E_L_E_T_ = ' ' 
                     WHERE
                        TV1.TV1_DTSERV = CONVERT(VARCHAR(8), INSUMOS.DATAAPROPRIACAO, 112) 
                        AND TV1.TV1_OPERAD COLLATE Latin1_General_CS_AI = INSUMOS.CHAPA 
                        AND TV1.D_E_L_E_T_ = ' ' 
                  )
                  AS CLASE_VALOR 
               FROM
                  MISMAPROP INSUMOS 
                  JOIN
                     MTAREFA TAREAS 
                     ON INSUMOS.IDPRJ = TAREAS.IDPRJ 
                     AND INSUMOS.IDTRF = TAREAS.IDTRF 
                  JOIN
                     MPRJ TOPPRJ 
                     ON TOPPRJ.IDPRJ = INSUMOS.IDPRJ 
               WHERE
                  ORIGEMAPROP IN(0, 1) 
                    AND CONVERT(VARCHAR(6), INSUMOS.DATAAPROPRIACAO, 112) = %exp:cPeriodo%
                    AND INSUMOS.QUANTIDADE <> 0 
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
      ON PROYECTO.CHAPA = PLANILLA.RA_MAT COLLATE Latin1_General_CS_AI 
   LEFT JOIN
        %table:CTT% CTT 
        ON CTT.CTT_CUSTO COLLATE Latin1_General_CS_AI = PROYECTO.CODCCUSTO 
        AND CTT.D_E_L_E_T_ = ' ' 
        AND PROYECTO.CODCCUSTO BETWEEN %exp:cCcDe% AND %exp:cCcAte%
   LEFT JOIN AF9010 AF9 
   	  ON AF9_TAREFA COLLATE Latin1_General_CS_AI = CODTRF
   	  AND AF9_PROJET COLLATE Latin1_General_CS_AI = CODPRJ
      AND AF9.D_E_L_E_T_ = ' '
) AS PL
GROUP BY PL.RA_FILIAL, PL.RA_CC, PL.RA_ITEM, CODCCUSTO, PL.CTT_DESC01,
  PL.CODTRF, CLASE_VALOR, PL.DESC_CLVL, PL.ITEM_CONTABLE, RV_UCONTA,RV_UCONTA2,RV_UCONTA3
ORDER BY  RA_FILIAL, CODCCUSTO, RA_CC, ITEM_CONTABLE, RA_ITEM, CLASE_VALOR

/*ORDER BY RA_FILIAL, RA_MAT, CODTRF, PORCENTAJE*/

    EndSql

    cQuery:=GetLastQuery()
    Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL


    DbSelectArea(TRB)
        aRotina := {}
        nTotal    := 0
        lDigita   := .T.
        cLote     := "8840" 
        cPadrao   := "Z01" // CODIGO DO LANCAMENTO PADRAO CRIADO PARA ATENDER ESTA ROTINA
        nHdlPrv:= HeadProva(cLote,"RECCOST",Alltrim(cUserName),@cArquivo)

    If (TRB)->(!Eof()) // Encuentro
        // DbSelectArea("TRB")
        ProcRegua(RecCount())
        // (TRB)->(DbGoTop())
        Do While !(TRB)->(EOF())
            // IncTProc("Gerando Lançamento Contábil...")
            
            // nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CSTVEND",cLote)
            nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"RECCOST",cLote)
            // DbSelectArea("TRB")
            (TRB)->(DbSkip())
        EndDo
    ENDIF
    RodaProva(nHdlPrv,nTotal)

    // Envia para Lancamento Contabil
    /*
    CA100Incl( cArquivo, nHdlPrv, nOpcx, cLoteContabil, lDigita, lAglut, cOnLine, dData) 
    Onde: Arquivo -> Nome do arquivo 
    nHdlPrv -> Numero do Header 
    nOpcx -> Numero da Opcao escolhida 
    cLoteContabil -> Numero do Lote 
    lDigita -> Se Mostra ou nao 
    lAglut -> Se Aglutina ou não 
    cOnLine -> Determina se sera On Line ou pelo cProva
    */

    cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.T.) // Essa e a funcao do quadro dos lancamentos.

    restarea(aArea)

Return 




Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSX1(cPerg,"01","¿Proceso?"	, "¿Proceso?"	,"¿Proceso?"	,"MV_CH1","C",05,0,0,"G","","RCJ","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿Periodo Competenc. (AAAAMM)?" 		, "¿Periodo Competenc. (AAAAMM)?"		,"¿Periodo Competenc. (AAAAMM)?"		,"MV_CH2","C",06,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Matrícula?" , "¿De Matrícula?"	,"¿De Matrícula?"	,"MV_CH3","C",06,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Matrícula?" 	, "¿A Matrícula?"	,"¿A Matrícula?"	,"MV_CH4","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿De Centro de costo?" , "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH5","C",11,0,0,"G","","CTT","004","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿A Centro de costo?" 	, "¿A Centro de costo?"	,"¿A Centro de costo?"	,"MV_CH6","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")

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
