#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPMSPreRe   บAutor  ณErickEtcheverry    บ Data ณ 27/02/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. Funcion que retorna un  										  บฑฑ
ฑฑฬ			vector con previsto											  นฑฑ
ฑฑบUso       ณ Global				                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function PMSPreRe(cFillal,cProjeto,cTarefa,cProduto,nCant,cItemCont,cAviso)
	Local nQuant := 0
	Local nVetor := {"","",""}

/*	
	If Empty(cProjeto) .and. Empty(cItemCont)
		cFillal  := "01"
		cProjeto := "NUEVO NT"
		cTarefa  := "01.01"
		cProduto := "TENI0004"
	EndIf
*/
	
	If Empty(cProjeto)
		cProjeto := ItemCtoProy(cItemCont)[1]
		cTarefa := ItemCtoProy(cItemCont)[2]
	EndIf
	
	nCantPr := previstoAFA(cFillal,cProjeto,cTarefa,cProduto)
	nCantD3 := realSD3(cFillal,cProjeto,cTarefa,cProduto)
	nCantD1 := realSD1(cFillal,cProjeto,cTarefa,cProduto)
	
	nQuant = nCantD3 + nCantD1

	nVetor[1] = nQuant //lo real registrado
	
	nVetor[2] = nCantPr // Previsto del proyecto
	
	nVetor[3] = nCantPr - (nCant + nQuant) // positivo que falta por comprar / negativo que se esta pasando   
	
	If cAviso = 'S' .and. nVetor[3] < 0 .and. !Empty(cProjeto)
		Aviso("Inf. de Proyecto","La Cantidad solicitada sobrepasa la Cantidad Prevista en la Tarea, Debe Consultar con el Gerente de Proyectos:"+cProjeto+"."+CHR(13)+CHR(10)+;
		" Cantidad Prevista:"+TRANSFORM(nVetor[2],"@E 999,999,9999.99")+CHR(13)+CHR(10)+;
		" Cantidad Utilizada:"+TRANSFORM(nVetor[1],"@E 999,999,9999.99"),{'ok'},,,,,.t.)
	EndIf
	
	/*retorna la diferencia de lo que se quiere comprar con lo que existe haciendo referencia al proyecto*/
return nVetor

static function ItemCtoProy(cItemCont)
Local nVetorPry := {"",""}
Local cAliasPMS		:= GetNextAlias()

	BeginSql Alias cAliasPMS
				
		SELECT  AF8_PROJET,AF9_TAREFA,AF8_REVISA FROM 
		%table:AF9% AF9
		INNER JOIN
		%table:AF8% AF8 
		ON AF9_PROJET=AF8_PROJET AND AF9_REVISA=AF8_REVISA
		WHERE 
		AF9_FILIAL = %xFilial:AF9%
		AND AF8_FILIAL = %xFilial:AF8%
		AND AF9.%NotDel%           	
		AND AF8.%NotDel%
		AND AF9_ITEMCC=%Exp:cItemCont%
		AND AF9_ITEMCC <> ' '
	EndSQL		
	
	nVetorPry [1] := (cAliasPMS)->AF8_PROJET 
	nVetorPry [2] := (cAliasPMS)->AF9_TAREFA
	
return nVetorPry

static function previstoAFA(cFillal,cProjeto,cTarefa,cProduto)
	Local _cQuery
	Local nQuant := 0
	
	//Previsto
	_cQuery := "SELECT AFA_QUANT "
	_cQuery += " From " + RetSqlName("AF9") + " AF9"
	_cQuery += " JOIN " + RetSqlName("AFA") + " AFA"
	_cQuery += " ON (AF9_FILIAL=AFA_FILIAL AND AF9_PROJET=AFA_PROJET AND AF9_TAREFA=AFA_TAREFA AND AFA_REVISA=AF9_REVISA)"
	_cQuery += " WHERE AF9_FILIAL = '" + xFilial("AF9")+ "' "
	_cQuery += " And AF9_PROJET = '" + cProjeto + "' "
	_cQuery += " And AF9_TAREFA = '" + cTarefa + "' "
	_cQuery += " And AF9_REVISA IN(SELECT MAX(AF9_REVISA) FROM AF9010 WHERE AF9_PROJET = '" + cProjeto + "')"
	_cQuery += " And AFA_PRODUT = '" + cProduto + "' "
	_cQuery += " And AFA.D_E_L_E_T_ <> '*' "
	_cQuery += " And AF9.D_E_L_E_T_ <> '*' "

//	Aviso("",_cQuery,{'ok'},,,,,.t.)

	If Select("StrSQL") > 0  //En uso
		StrSQL->(DbCloseArea())
	End

	TcQuery _cQuery New Alias "StrSQL"

	nQuant = StrSql->AFA_QUANT
	
return nQuant

static function realSD3(cFillal,cProjeto,cTarefa,cProduto)
	Local nQuantD3 := 0
	Local _cQueryR
	
	_cQueryR := "SELECT DISTINCT 'REAL' 'TIPO', AFC_PROJET 'PROYECTO', AFC_REVISA 'REVISIำN', AFC_EDT 'COD. EDT',D3_TASKPMS 'COD. TAREA', "
	_cQueryR += " RTRIM(AFC_DESCRI) 'DESCRIPCIำN EDT', RTRIM(AF9_DESCRI) 'DESCRIPCIำN TAREA',D3_COD 'COD. PRODUCTO',"
	_cQueryR +=	"B1_DESC 'DESCRIPCIำN PRODUCTO', ' ' 'COD. RECURSO',' ' 'DESCRIPCIำN RECURSO',B1_DESC 'DESC. PROD/RECUR',"
	_cQueryR +=	"' ' 'TIPO RECURSO', 1 'MONEDA', D3_CUSTO2/D3_QUANT 'COSTO ESTANDAR',"
	_cQueryR +=	"CASE WHEN D3_TM > '500' THEN ISNULL(D3_QUANT, 0) ELSE ISNULL(D3_QUANT, 0)*-1 END CANTIDAD_USO,"
	_cQueryR +=	"CASE WHEN D3_TM > '500' THEN ISNULL(D3_CUSTO1, 0) ELSE ISNULL(D3_CUSTO1, 0)*-1 END MONTO_USO_M1,"
	_cQueryR +=	"CASE WHEN D3_TM > '500' THEN ISNULL(D3_CUSTO2, 0) ELSE ISNULL(D3_CUSTO2, 0)*-1 END MONTO_USO_M2,"
	_cQueryR += "B1_TIPO 'SUB-TIPO', B1_UM 'UNIDAD', B1_GRUPO 'GRUPO PROD'"
	_cQueryR += " From " + RetSqlName("AFC") + " AFC," + RetSqlName("AF9") +" AF9," + RetSqlName("SD3") + " SD3"
	_cQueryR += " LEFT JOIN " + RetSqlName("SM2") + " SM2 ON (M2_DATA = convert(char, getdate(), 112))"
	_cQueryR += " JOIN " + RetSqlName("SB1") + " SB1 ON (D3_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ')"
	_cQueryR += " WHERE AFC.D_E_L_E_T_ = ' ' AND AF9.D_E_L_E_T_ = ' ' AND SD3.D_E_L_E_T_ = ' '"
	_cQueryR += " AND AFC_PROJET = AF9_PROJET AND AFC_REVISA = AF9_REVISA AND AFC_EDT = AF9_EDTPAI"
	_cQueryR += " AND AFC_PROJET = D3_PROJPMS AND AF9_TAREFA = D3_TASKPMS AND D3_CF IN('RE6','DE6') "
	_cQueryR += " AND AFC_PROJET BETWEEN '" + cProjeto + "' AND '" + cProjeto + "'"
	_cQueryR += " AND AFC_REVISA IN(SELECT MAX(AF9_REVISA) FROM AF9010 WHERE AF9_PROJET = '" + cProjeto + "')"
	_cQueryR += " AND AF9_TAREFA='" + cTarefa + "'"
	_cQueryR += " AND D3_COD='" + cProduto + "'"
	_cQueryR += " AND D3_FILIAL='" + cFillal + "'"

//	Aviso("",_cQueryR,{'ok'},,,,,.t.)

	If Select("SRSQL") > 0  //En uso
		SRSQL->(DbCloseArea())
	End

	TcQuery _cQueryR New Alias "SRSQL"

	nQuantD3 = SRSQL->CANTIDAD_USO

return nQuantD3

static function realSD1(cFillal,cProjeto,cTarefa,cProduto)
	Local nQuantD1 := 0
	Local _cQueryRD
	
	_cQueryRD := "SELECT DISTINCT 'REAL' 'TIPO', AFC_PROJET 'PROYECTO', AFC_REVISA 'REVISIำN', AFC_EDT 'COD. EDT',"
	_cQueryRD += "AFN_TAREFA 'COD. TAREA', RTRIM(AFC_DESCRI) 'DESCRIPCIำN EDT', RTRIM(AF9_DESCRI) 'DESCRIPCIำN TAREA',"
	_cQueryRD +=	"AFN_COD 'COD. PRODUCTO', B1_DESC 'DESCRIPCIำN PRODUCTO',1 'MONEDA',"
	_cQueryRD +=	"D1_CUSTO2/CASE WHEN D1_QUANT=0 THEN 1 ELSE D1_QUANT END 'COSTO ESTANDAR',ISNULL(D1_DTDIGIT, '19000101') FECHA_USO,"
	_cQueryRD +=	"SUBSTRING(ISNULL(D1_DTDIGIT, '19000101'), 1,4)+'-'+SUBSTRING(ISNULL(D1_DTDIGIT, '19000101'), 5,2) 'MES-AัO',"
	_cQueryRD +=	"ISNULL(D1_QUANT, 0) CANTIDAD_USO,ISNULL(D1_CUSTO, 0) MONTO_USO_M1,ISNULL(D1_CUSTO2, 0) MONTO_USO_M2,"
	_cQueryRD +=	"B1_TIPO 'SUB-TIPO', B1_UM 'UNIDAD', B1_GRUPO 'GRUPO PROD',D1_DOC+'-'+D1_SERIE+'-'+D1_FORNECE+'-'+D1_ITEM  'DOC-ITEM'"
	_cQueryRD += " From " + RetSqlName("AFC") + " AFC," + RetSqlName("AF9") +" AF9," + RetSqlName("AFN") + " AFN," + RetSqlName("SD1") + " SD1"
	_cQueryRD += " LEFT JOIN " + RetSqlName("SM2") + " SM2 ON (M2_DATA = convert(char, getdate(), 112))"
	_cQueryRD += " JOIN " + RetSqlName("SB1") + " SB1 ON (D1_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ')"
	_cQueryRD += " WHERE AFC.D_E_L_E_T_ = ' ' AND AF9.D_E_L_E_T_ = ' ' AND SD1.D_E_L_E_T_ = ' ' AND AFN.D_E_L_E_T_ = ' '"
	_cQueryRD += " AND AFC_PROJET = AF9_PROJET AND AFC_REVISA = AF9_REVISA AND AFC_EDT = AF9_EDTPAI"
	_cQueryRD += " AND AFC_PROJET = AFN_PROJET AND AF9_TAREFA = AFN_TAREFA "
	_cQueryRD += " AND AF9_REVISA = AFN_REVISA  AND AFN_DOC = D1_DOC AND AFN_SERIE = D1_SERIE AND AFN_FORNEC = D1_FORNECE"
	_cQueryRD += " AND AFN_LOJA = D1_LOJA AND AFN_ITEM = D1_ITEM "
	_cQueryRD += " AND AFC_PROJET BETWEEN '" + cProjeto + "' AND '" + cProjeto + "'"
	_cQueryRD += " AND AFC_REVISA IN(SELECT MAX(AF9_REVISA) FROM AF9010 WHERE AF9_PROJET = '" + cProjeto + "')"
	_cQueryRD += " AND AF9_TAREFA='" + cTarefa + "'"
	_cQueryRD += " AND D1_COD='" + cProduto + "'"
	_cQueryRD += " AND D1_FILIAL='" + cFillal + "'"


//	Aviso("",_cQueryRD,{'ok'},,,,,.t.)

	If Select("SRDSQL") > 0  //En uso
		SRDSQL->(DbCloseArea())
	End

	TcQuery _cQueryRD New Alias "SRDSQL"

	nQuantD1 = SRDSQL->CANTIDAD_USO
	
return nQuantD1 