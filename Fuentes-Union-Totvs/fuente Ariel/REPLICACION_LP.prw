#Include "Protheus.ch" 
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Replicar LP ºAutor  ³Ariel Dominguez   ºFecha ³  05/09/22   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Replicar listas de precios                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Union                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION ReplicaLP() 
    Local aCampos   := {} 
    Local i         := 1

    Private cArea1   := "" 
    Private cPerg    :="UREPLP" 
 
    ValidPerg()

    If !Pergunte(cPerg)
        Return()
    Endif

    //ADV: Obtiene el arreglo de incrementos
    aCampos    := GetIncremento()

    //ADV: Obtiene los productos a replicar
    GetProd()

    While !(cArea1)->(Eof())   

        For i:=1 to Len(aCampos)
            If ExisteLP01(aCampos[i][01],(cArea1)->DA1_CODTAB)
                If ExisteLP02(aCampos[i][01],(cArea1)->DA1_CODTAB,(cArea1)->DA1_CODPRO)
                    Actualizar(aCampos[i][01],(cArea1)->DA1_CODTAB,(cArea1)->DA1_CODPRO,(cArea1)->DA1_PRCVEN,aCampos[i][02])
                Else
                    Insertar(aCampos[i][01],(cArea1)->DA1_CODTAB,(cArea1)->DA1_CODPRO,(cArea1)->DA1_PRCVEN,aCampos[i][02])
                Endif
            EndIF
        Next
        
        
        (cArea1)->(dbSkip())

    End               
    (cArea1)->(DbCloseArea()) 
    
    Aviso("REPLICACION DE LP","Proceso concluido de manera satisfactoria")

Return Nil  

Static Function ExisteLP02(cSuc,cTabla,cProd)
    local _cSQL     := ""
    Local cAreaAnt  := GetArea()
    Local cAreaINC  := GetNextAlias()
    Local lExiste   := .F.

	_cSQL := "SELECT R_E_C_N_O_ " 
   	_cSQL := _cSQL + " FROM " + RetSqlName("DA1") 
    _cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' "
    _cSQL := _cSQL + " AND DA1_FILIAL  = '" + cSuc   +"'"
    _cSQL := _cSQL + " AND DA1_CODTAB  = '" + cTabla +"'"
    _cSQL := _cSQL + " AND DA1_CODPRO  = '" + cProd  +"'"
    _cSQL:= ChangeQuery(_cSQL)
	
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL), cAreaINC ,.T.,.T.)   
	dbSelectArea(cAreaINC)
	dbGoTop()
    
    If !(Eof()) 
        lExiste := .T.
    End               
    (cAreaINC)->(DbCloseArea()) 
    RestArea(cAreaAnt)

Return lExiste

Static Function ExisteLP01(cSuc,cTabla)
    local _cSQL     := ""
    Local cAreaAnt  := GetArea()
    Local cAreaINC  := GetNextAlias()
    Local lExiste   := .F.

	_cSQL := "SELECT top 1 R_E_C_N_O_ " 
   	_cSQL := _cSQL + " FROM " + RetSqlName("DA1") 
    _cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' "
    _cSQL := _cSQL + " AND DA1_FILIAL  = '" + cSuc   +"'"
    _cSQL := _cSQL + " AND DA1_CODTAB  = '" + cTabla +"'"
    _cSQL:= ChangeQuery(_cSQL)
	
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL), cAreaINC ,.T.,.T.)   
	dbSelectArea(cAreaINC)
	dbGoTop()
    
    If !(Eof()) 
        lExiste := .T.
    End               
    (cAreaINC)->(DbCloseArea()) 
    RestArea(cAreaAnt)

Return lExiste

Static Function Insertar(cSuc,cTabla,cProd,nPrecio,nInc)
    Local _cSQL     := ""
    Local cItem     := GetNextItem(cSuc,cTabla)
    Local nRec      := GetNextRec()


	_cSQL := "INSERT INTO " + RetSqlName("DA1") + " VALUES (" 
	_cSQL := _cSQL + " '" + cSuc + "', "    // DA1_FILIAL
	_cSQL := _cSQL + " '" + cItem + "', "   // DA1_ITEM
    _cSQL := _cSQL + " '" + cTabla + "', "  // DA1_CODTAB
    _cSQL := _cSQL + " '" + cProd + "', "   // D1_CODPROD
    _cSQL := _cSQL + " '" +        " ', "  // DA1_GRUPO
    _cSQL := _cSQL + " '" +        " ', "  // DA1_UESPEC
    _cSQL := _cSQL + " '" +        " ', "  // DA1_REFGRD
    _cSQL := _cSQL + "  " + STR((ROUND(nPrecio*(nInc/100),2))+nPrecio) + ", " // DA1_PRCVEN
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        "1', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + " '" +        "4', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + "  " +        "999999.99, "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + "  " +        "2, "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + " '" +        " ', "
    _cSQL := _cSQL + "  " +  str(nRec) + ", " //recno
    _cSQL := _cSQL + "  " +        "0, "
    _cSQL := _cSQL + " '" +        " ') "
   
    //aviso("SQL OUT",_cSQL,{'Ok'},,,,,.t.)
    nvalor:=TCSQLEXEC(_cSQL) 
Return Nil

Static Function GetNextItem(cSuc,cTabla)
    local _cSQL     := ""
    Local cAreaAnt  := GetArea()
    Local cAreaINC  := GetNextAlias()
    Local cItem      := "0001"

	_cSQL := "SELECT MAX(DA1_ITEM) AS DA1_ITEM " 
   	_cSQL := _cSQL + " FROM " + RetSqlName("DA1") 
    _cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' "
    _cSQL := _cSQL + " AND DA1_FILIAL  = '" + cSuc   +"'"
    _cSQL := _cSQL + " AND DA1_CODTAB  = '" + cTabla +"'"
	_cSQL:= ChangeQuery(_cSQL)
	
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL), cAreaINC ,.T.,.T.)   
	dbSelectArea(cAreaINC)
	dbGoTop()
    
    If !(Eof()) 
        cItem := Soma1(DA1_ITEM)            
    End               
    (cAreaINC)->(DbCloseArea()) 
    RestArea(cAreaAnt)

Return cItem

Static Function GetNextRec()
    local _cSQL     := ""
    Local cAreaAnt  := GetArea()
    Local cAreaINC  := GetNextAlias()
    Local nRec      := 1

	_cSQL := "SELECT MAX(R_E_C_N_O_) AS RECNO " 
   	_cSQL := _cSQL + " FROM " + RetSqlName("DA1") 
    _cSQL:= ChangeQuery(_cSQL)
	
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL), cAreaINC ,.T.,.T.)   
	dbSelectArea(cAreaINC)
	dbGoTop()
    
    If !(Eof()) 
        nRec := RECNO + 1       
    End               
    (cAreaINC)->(DbCloseArea()) 
    RestArea(cAreaAnt)

Return nRec

Static Function Actualizar(cSuc,cTabla,cProd,nPrecio,nInc)
    local _cSQL:=""
	_cSQL := "UPDATE " + RetSqlName("DA1") 
	_cSQL := _cSQL + " SET DA1_PRCVEN = " + STR(nPrecio) + " + ROUND(" + str(nPrecio) + "*(" + str(nInc/100) + "),2)"
	_cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' "  
	_cSQL := _cSQL + " AND DA1_FILIAL = '"  + cSuc        + "'"
    _cSQL := _cSQL + " AND DA1_CODTAB = '"  + cTabla      + "'" 
    _cSQL := _cSQL + " AND DA1_CODPRO = '"  + cProd       + "'" 
    
    //aviso("SQL OUT",_cSQL,{'Ok'},,,,,.t.)
    nvalor:=TCSQLEXEC(_cSQL) 
Return Nil


Static Function GetProd()
    	
	_cSQL := "SELECT DA1_FILIAL,DA1_ITEM,DA1_CODTAB,DA1_CODPRO,DA1_PRCVEN " 
   	_cSQL := _cSQL + " FROM " + RetSqlName("DA1") 
    _cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' "
    _cSQL := _cSQL + " AND DA1_CODTAB    BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
    _cSQL := _cSQL + " AND DA1_CODPRO    BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	_cSQL := _cSQL + " AND DA1_FILIAL    = '0105' "
    _cSQL := _cSQL + " ORDER BY DA1_FILIAL, DA1_CODPRO,DA1_CODTAB "
	_cSQL:= ChangeQuery(_cSQL)
	
    cArea1 := "SOLIC1"			
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL), cArea1 ,.T.,.T.)   
	dbSelectArea(cArea1)
	dbGoTop()
   
Return Nil 

Static Function GetIncremento()
    Local aCamposR    := {}

    aAdd(aCamposR,{"0100",1.5}) //BENI
    aAdd(aCamposR,{"0102",0.6}) //MONT
    aAdd(aCamposR,{"0107",1.4}) //CBBA
    aAdd(aCamposR,{"0108",2.0}) //LPZ
    aAdd(aCamposR,{"0112",1.3}) //SIV

    /*
    aAdd(aCamposR,{"0100",0}) //BENI
    aAdd(aCamposR,{"0102",0}) //MONT
    aAdd(aCamposR,{"0107",0}) //CBBA
    aAdd(aCamposR,{"0108",0}) //LPZ
    aAdd(aCamposR,{"0112",0}) //SIV
    */

    /*Local cAreaINC  := GetNextAlias()

	_cSQL := "SELECT Z30_SUC,Z30_PRCINC " 
   	_cSQL := _cSQL + " FROM " + RetSqlName("Z30") 
    _cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' "
    _cSQL := _cSQL + " AND DA1_FILIAL   <> '0105' "
    _cSQL := _cSQL + " ORDER BY Z30_SUC "
	_cSQL:= ChangeQuery(_cSQL)
	
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL), cAreaINC ,.T.,.T.)   
	dbSelectArea(cAreaINC)
	dbGoTop()
    
    While !(cAreaINC)->(Eof()) 
        aAdd(aCamposR,{(cAreaINC)->Z30_SUC,(cAreaINC)->Z30_PRCINC})    
        (cAreaINC)->(dbSkip())
    End               
    (cAreaINC)->(DbCloseArea()) 
    */
   
Return aCamposR



  






Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{"01","De lista de precios :","mv_ch1","C",03,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,"",  ""}) 
aAdd(aRegs,{"02","A  lista de precios :","mv_ch2","C",03,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,"",  ""})
aAdd(aRegs,{"03","De producto :","mv_ch3","C",03,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,"",  ""}) 
aAdd(aRegs,{"04","A  producto :","mv_ch4","C",03,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,"",  ""})
aAdd(aRegs,{"05","De sucursal :","mv_ch5","C",03,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,"",  ""}) 
aAdd(aRegs,{"06","A  sucursal :","mv_ch6","C",03,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,"",  ""})


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
         SX1->X1_DEF01    := aRegs[i][10]
         SX1->X1_DEF02    := aRegs[i][11]
         SX1->X1_DEF03    := aRegs[i][12]
         SX1->X1_DEF04    := aRegs[i][13]
         SX1->X1_F3       := aRegs[i][14]
         SX1->X1_VALID    := aRegs[i][15]   
         
      MsUnlock()
   Endif
Next

Return                            
 

