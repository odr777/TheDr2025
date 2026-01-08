/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³cosPartDi ºAuthor Nahim  Terrazas      º Date ³  05/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función Que ejecuta el costo del parte diario de Mant.     º±±
±±º          ³ mediante la rutina Mata241 (mov. internos modelo 2)        º±±
±±º          ³ Con esto Genera la SD3 y se puede contabilizar             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER FUNCTION cosParDi(_cDoc,cTM,aArrayPTd)
// USER FUNCTION cosParDi(_cDoc,cCodigo,nQUant,dEmissao,cCusto,cTM,cAccount)

    Local _aCab1 := {}
    Local _aItem := {}
    Local _atotitem:={}
    Local cCodigoTM:="503"
    Local cCodProd:="PRODUTO "
    Local cUnid:="PC "
    Local _atotitem:={}

    Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
    Private lMsErroAuto := .f. //necessario a criacao
    cCodigo  :=aArrayPTd[1][1]
    nQUant   :=aArrayPTd[1][2]
    dEmissao :=aArrayPTd[1][3]
    cCusto   :=aArrayPTd[1][4]
    cClasValC :=aArrayPTd[1][5] // clase de valor contable
    xAutoCab:= {{"D3_DOC"    ,_cDoc  	,Nil},;
        {"D3_TM"     ,cTM       ,Nil},;
        {"D3_CC"     ,cCusto ,Nil},;
        {"D3_CLVL"     ,cClasValC ,Nil},;
        {"D3_EMISSAO",dEmissao  ,Nil}}

    For nI := 1 To Len(aArrayPTd)
        aInfoTV2 := aArrayPTd[nI]
        dbSelectArea("SB1")
        dbSetOrder(1) // obtengo el indice
        dbSeek(xFilial("SB1")+aInfoTV2[1]) // me posiciono en la SB1

        aMovItems:= {{"D3_COD"		,aInfoTV2[1],Nil},;
            {"D3_UM"     	,SB1->B1_UM     ,Nil},;
            {"D3_QUANT"  	,aInfoTV2[2]	,Nil},;
            {"D3_DTVALID"	,dEmissao       ,Nil},;
            {"D3_ITEMCTA"	,aInfoTV2[7]    ,Nil},;
            {"D3_CUSTO1"	,0   ,Nil},;
            {"D3_CUSTO2"	,0   ,Nil},;
            {"D3_CONTA"		,SB1->B1_UCTAPRO    ,Nil}}
        Aadd( _atotitem,aMovItems)
    next nI
    //    {"D3_LOCAL"  	,"01"           ,Nil},; // Local no importa Nahim 18/06/2020
    //  {"D3_SEGUM"  	,SB1->B1_SEGUM  ,Nil},;
        // {"D3_GRUPO"  	,SB1->B1_GRUPO  ,Nil},;

    lMSErroAuto := .F.
    // MsExecAuto({|x,y,z| Mata241(x,y)},xAutoCab,aMov )
    MSExecAuto({|x,y,z| MATA241(x,y,z)},xAutoCab,_atotitem,3)
    If lMsErroAuto
        MostraErro() // Sempre que o micro comeca a apitar esta ocorrendo um erro desta forma
        AutoGrLog( " No se pudo importar : " + cCodigo  )
        DisarmTransaction()
        Break
    Else
        AutoGrLog( " Movimiento ingresado: " + cCodigo )
    EndIf


return
