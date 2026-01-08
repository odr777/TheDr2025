#include 'protheus.ch'
#include "Topconn.ch"

/**
Nahim Terrazas 
08/04/2021
Programas Varioas para integración de 1. mantenimiento 
**/


/*
01/07/2020
Nahim Terrazas llama de la SN3 valores
*/
USER function getATF(cCvl,cFilla)
    Local cQuery	:= ""

    If Select("VW_CPX") > 0
        dbSelectArea("VW_CPX")
        dbCloseArea()
    Endif

	/*SELECT N3_FILIAL,N3_CBASE,N3_ITEM,N3_TIPO,N3_SEQ FROM SN3010
	WHERE N3_CLVL = 'CVLTESTE   '
	AND N3_FILIAL = '0101'*/

	cQuery := "	SELECT N3_FILIAL,N3_CBASE,N3_ITEM,N3_TIPO,N3_SEQ "
	cQuery += "  FROM " + RetSqlName("SN3") + " SN3 "
	cQuery += "  WHERE N3_CLVLCON = '" + cCvl + "' "
	cQuery += "  AND N3_FILIAL = '" + cFilla + "' AND SN3.D_E_L_E_T_ = '' "

	TCQuery cQuery New Alias "VW_CPX"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return


/*
Nahim Terrazas obtiene el producto por clase de valor 

*/


user function getProByCl(cCod)
    Local aArea 	 := GetArea()
    OrdenConsul	:= GetNextAlias()
    // consulta a la base de datos
    BeginSql Alias OrdenConsul
	
		SELECT B1_COD
		FROM  %Table:SB1% SB1 
		WHERE B1_CLVL = %exp:cCod%
        AND B1_TIPO = 'MO'
		AND SB1.%notdel%

    EndSql

    DbSelectArea(OrdenConsul)
    cSD3MaxDoc:= ''
    If (OrdenConsul)->(!Eof()) // Encuentro
        cSD3MaxDoc:= (OrdenConsul)->B1_COD
    endif
    DbCloseArea(OrdenConsul)
    restarea(aArea)
return cSD3MaxDoc




/*
20/07/2020
Nahim Terrazas obtiene el producto por clase de valor 
*/
user function getItemContable(cBien,cDataServ)
    Local aArea 	 := GetArea()
    consItemC	:= GetNextAlias()
    // consulta a la base de datos
    BeginSql Alias consItemC
            SELECT
            AF9_ITEMCC,AF9_TAREFA,AF9_DESCRI,AF9_PROJET
            FROM
            AF9010 AF9 
            WHERE
            AF9_TAREFA IN
            (
                SELECT
                    MAX(CODTRF) COLLATE Latin1_General_CS_AI 
                FROM
                    MTAREFA 
                WHERE
                    (
                        CAST(CODCOLIGADA AS VARCHAR) + CAST(IDPRJ AS VARCHAR) + CAST(IDTRF AS VARCHAR)
                    )
                    IN
                    (
                        SELECT
                        SUBSTRING(VALORRM, 1, 1) + SUBSTRING(VALORRM, 3, 3) + TV2_INTTSK COLLATE Latin1_General_CS_AI 
                        FROM
                        GEAIDEPARA GEA,
                        TV2010 TV2 
                        WHERE
                        D_E_L_E_T_ = ' ' 
                        AND VALOREXTERNO = TV2_EMPRES + '|' + TV2_FILIAL + '|' + TV2_EMPRES + '|' + TV2_CODBEM + '|' + TV2_DTSERV + '|' + TV2_SEQREL COLLATE Latin1_General_CS_AI 
                        AND TV2_CODBEM = %exp:cBien%
                        AND TV2_DTSERV = %exp:cDataServ%
                    )
            )
            AND AF9_PROJET IN
                           (
                                       SELECT TV2_UPROJE
                                       FROM
                                       %Table:TV2% TV2 
                                       WHERE
                                       D_E_L_E_T_ = ' ' 
                                           AND TV2_CODBEM = %exp:cBien% 
                                       AND TV2_DTSERV = %exp:cDataServ%
                           )
            AND AF9.D_E_L_E_T_ = ' ' 

    EndSql

    DbSelectArea(consItemC)
    cSD3MaxDoc:= ''
    If (consItemC)->(!Eof()) // Encuentro
        if !empty((consItemC)->AF9_ITEMCC)
            cSD3MaxDoc:= (consItemC)->AF9_ITEMCC
        else
            alert("La tarea:" + (consItemC)->AF9_TAREFA +" - " + (consItemC)->AF9_DESCRI +" del Proy: " + (consItemC)->AF9_PROJET +  " no está relacionada con ningun item contable, favor digitarlo en 'Tareas del proyecto'")
        endif
    ENDIF
    DbcloseArea(consItemC)
    restarea(aArea)
return cSD3MaxDoc



/*
20/07/2020
Nahim Terrazas obtiene el contador FInal / KM FINAL TOP
*/
user function getKMTOP(cBien,cDataServ)
    Local aArea 	 := GetArea()
    consItemC	:= GetNextAlias()
    // consulta a la base de datos
    BeginSql Alias consItemC
        SELECT
        HORIMETRO,
        HORIMETROFIM,
        QUILOMETRAGEM,
        QUILOMETRAGEMFIM,
        HORIMETROFIM
        FROM
        MAPONTEQUIPAMENTO 
        where
        (
            CAST(CODCOLIGADA AS VARCHAR) + CAST(IDPRJ AS VARCHAR) + CAST(IDAPONTAMENTO AS VARCHAR)
        )
        IN
        (
            SELECT
                SUBSTRING(VALORRM, 1, 1) + SUBSTRING(VALORRM, 3, 3) + SUBSTRING(VALORRM, 7, 3) 
            FROM
                GEAIDEPARA GEA,
                TV2010 TV2 
            WHERE
                D_E_L_E_T_ = ' ' 
                AND VALOREXTERNO = TV2_EMPRES + '|' + TV2_FILIAL + '|' + TV2_EMPRES + '|' + TV2_CODBEM + '|' + TV2_DTSERV + '|' + TV2_SEQREL COLLATE Latin1_General_CS_AI 
                AND TV2_CODBEM = %exp:cBien%
                AND TV2_DTSERV = %exp:cDataServ%
        )
    EndSql

    DbSelectArea(consItemC)
    cSD3MaxDoc:= ''
    If (consItemC)->(!Eof()) // Encuentro
        if !empty((consItemC)->QUILOMETRAGEMFIM)
            cSD3MaxDoc:= (consItemC)->QUILOMETRAGEMFIM
        else
            CONOUT("No encontró Relación QUILOMETRAGEMFIM ")
        endif
    ENDIF
    DbCloseArea(consItemC)
    restarea(aArea)
return cSD3MaxDoc





/*
Nahim Terrazas Verifica si existe el documento existe en la SD3 
*/

// U_isInSD3(cBemTv1,TV2->TV2_DTSERV,TV2->TV2_SEQREL)
user function isInSD3(cCodBem,cfechaServ,cSecuen)
    Local aArea 	 := GetArea()
    


    cbusqueda := "PT"+ alltrim(cCodBem) + SUBSTR(CVALTOCHAR(YEAR(cfechaServ)),3,2) + StrZero(MONTH(cfechaServ),2) + StrZero(day(cfechaServ),2) +"-"+ cSecuen

    cQrySD3	:= GetNextAlias()
    // cLlave := "PT" +  cCodBien + cAno + cMes +  cDay  + "-" + aInfoTV2[8] // LLAVE GENERADA
                // 2         18      2       2     2                3
    // consulta a la base de datos
    BeginSql Alias cQrySD3
        SELECT ISNULL(max(D3_DOC), '00') MAXIMO,D3_ESTORNO FROM SD3010 SD3  where 
        SD3.D_E_L_E_T_ LIKE ''
        AND D3_OBSERVA = %Exp:cbusqueda% 
        GROUP BY D3_ESTORNO ORDER BY 1 DESC
        
    EndSql


    cQuery:=GetLastQuery()
     aviso("",cQuery[2],{'ok'},,,,,.t.)

    DbSelectArea(cQrySD3)
    cSD3MaxDoc:= "00"
    If (cQrySD3)->(!Eof()) // Encuentro
        if (cQrySD3)->D3_ESTORNO <> "S" // no debe procesar porque ya fue generado el registro
            cSD3MaxDoc:= "XX" //(cQrySD3)->MAXIMO //
        else // PUEDE PROCESAR PORQUE NO HA SIDO GENERADO
            RIGHT((cQrySD3)->MAXIMO,2) 
        endif
    endif
    DbCloseArea(cQrySD3)
    restarea(aArea)
return cSD3MaxDoc
