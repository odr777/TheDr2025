#Include "Protheus.ch" 
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Modificar SF2ºAutor  ³Ariel Dominguez  ºFecha ³  24/10/22   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Modifica remitos de salida                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Union                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MkBrwRem() 
 
    Local aCpos      := {} 
    Local aCampos    := {} 
    private cArea1   := "" 
    private cArea2   := "" 
    private cArea3   := "" 
    private cArea4   := "" 
    Private aRotina  := {} 
    Private cCadastro:= "Facturas de Ventas"     
    Private aRecSel  := {}  
    Private cPerg    :="UMODSF2" 
    Private cFilSC1  :=""
    Private aStru    := {}

    ValidPerg()

    aAdd(aStru,{"FILIAL"        ,"C",04,0})
    aAdd(aStru,{"SERIE"         ,"C",03,0})
    aAdd(aStru,{"DOC"           ,"C",18,0})
    aAdd(aStru,{"CLIENTE"       ,"C",06,0})
    aAdd(aStru,{"LOJA"          ,"C",02,0})
    aAdd(aStru,{"NOMECLI"       ,"C",60,0})
    aAdd(aStru,{"EMISSAO"       ,"C",10,0})     
    aAdd(aStru,{"DTDIGIT"       ,"C",10,0})   
    aAdd(aStru,{"XTIPDOC"       ,"C",01,0})  // TIPO DE DOCUMENTO 
    aAdd(aStru,{"MODCONS"       ,"C",02,0})  // METODO DE PAGO  
    aAdd(aStru,{"UCNIT"         ,"C",12,0}) 
    aAdd(aStru,{"UCNOME"        ,"C",60,0}) 
    aAdd(aStru,{"XEMAIL"        ,"C",60,0})
    aAdd(aStru,{"MOK"     ,"C",02,0}) 

    _cArq := CriaTrab(aStru,.t.)
 
   
    AADD(aRotina,{"Visualizar"  ,"AxVisual"  ,0,2}) 
    AADD(aRotina,{"Modificar"   ,"U_VisFactura" ,0,4}) 
    
  


    If !Pergunte(cPerg)
        Return()
    Endif
    GetFact()

    DbUseArea(.T.,,_cArq,"TRB",.T.,.F.)
    While !(cArea1)->(Eof())   
    
        RecLock("TRB",.T.)            
        TRB->FILIAL         := (cArea1)->F2_FILIAL
        TRB->SERIE          := (cArea1)->F2_SERIE
        TRB->DOC            := (cArea1)->F2_DOC
        TRB->CLIENTE        := (cArea1)->F2_CLIENTE
        TRB->LOJA           := (cArea1)->F2_LOJA
        TRB->NOMECLI        := alltrim(GETADVFVAL("SA1","A1_NOME",XFILIAL("SA1")+(cArea1)->F2_CLIENTE+(cArea1)->F2_LOJA,1,"erro"))
        TRB->EMISSAO        := (cArea1)->F2_EMISSAO //dtoc((cArea1)->F2_EMISSAO)
        TRB->DTDIGIT        := (cArea1)->F2_DTDIGIT //dtoc((cArea1)->F2_DTDIGIT)  
        TRB->XTIPDOC        := (cArea1)->F2_XTIPDOC
        TRB->MODCONS        := (cArea1)->F2_MODCONS
        TRB->UCNIT          := (cArea1)->F2_UNITCLI
        TRB->UCNOME         := (cArea1)->F2_UNOMCLI
        TRB->XEMAIL         := (cArea1)->F2_XEMAIL
        
        TRB->MOK            := (cArea1)->F2_OK
        MsUnLock()
    
        (cArea1)->(dbSkip())

    End               
    (cArea1)->(DbCloseArea()) 

    AADD(aCpos, "MOK" ) 

    AADD(aCampos,{"MOK"         ,"" ,"OK"                   ,"@!"})                                 
    AADD(aCampos,{"FILIAL"      ,"" ,"Sucursal"             ,"@!"})
    AADD(aCampos,{"SERIE"       ,"" ,"Serie"                ,"@!"})
    AADD(aCampos,{"DOC"         ,"" ,"Numero"               ,"@!"})
    AADD(aCampos,{"CLIENTE"     ,"" ,"Cliente"              ,"@!"})
    AADD(aCampos,{"LOJA"        ,"" ,"Tienda"               ,"@!"})
    aAdd(aCampos,{"NOMECLI"     ,"" ,"Nom. Cliente"         ,"@!"})   
    AADD(aCampos,{"EMISSAO"     ,"" ,"F. Emision"           ,"@!"})
    aAdd(aCampos,{"DTDIGIT"     ,"" ,"F. Digitacion"        ,"@!"})   
    aAdd(aCampos,{"XTIPDOC"     ,"" ,"Tip. Documento"       ,"@!"})   
    aAdd(aCampos,{"UCNIT"       ,"" ,"NIT Fact."            ,"@!"}) 
    aAdd(aCampos,{"UCNOME"     ,"" ,"Nombre Factura"       ,"@!"})   
    aAdd(aCampos,{"XEMAIL"      ,"" ,"Correo"               ,"@!"})   



    MarkBrow("TRB" ,aCpos[1], ,aCampos,.F., GetMark(,"TRB","MOK") )
    TRB->(DbCloseArea())
    delTabTmp('TRB')
    dbClearAll()

Return Nil  


USER FUNCTION VisFactura() 
    Local cMarca := ThisMark() 
    Local lInvert := ThisInv() 
    Local oDlg          
    Local cFil
    Local cSerie
    Local cDoc 
    local cCliente
    local cLoja
    local cNomCli
    Local cEmissao
    local cXtipdoc
    local cModcons
    local cUNIT
    local cUNOME 
    Local cXemail
    local cNewXtipdoc
    local cNewModcons
    local cNewUNIT
    local cNewUNOME 
    local cNewXemail 

    DbSelectArea("TRB") 
    DbGoTop() 
    While ( TRB->(!EOF()))  
    IF TRB->MOK == cMarca .AND. !lInvert   
        cFil         := TRB->FILIAL
        cSerie          := TRB->SERIE
        cDoc            := TRB->DOC
        cCliente        := TRB->CLIENTE
        cLoja           := TRB->LOJA
        cNomCli         := TRB->NOMECLI
        cEmissao        := TRB->EMISSAO
        cXtipdoc        := TRB->XTIPDOC
        cModcons        := TRB->MODCONS
        cUNIT           := TRB->UCNIT
        cUNOME          := TRB->UCNOME
        cXemail         := TRB->XEMAIL
        cNewXtipdoc     := TRB->XTIPDOC
        cNewModcons     := TRB->MODCONS
        cNewUNIT        := TRB->UCNIT
        cNewUnome       := TRB->UCNOME
        cNewXemail      := TRB->XEMAIL

    
    ENDIF  
    TRB->(dbSkip()) 
    Enddo 	
    
    DEFINE MSDIALOG oDlg TITLE "Factura de Venta" From 000,000 TO 350,600 PIXEL 
        @  3,3     SAY "Numero"         SIZE 40,7    PIXEL OF oDlg
        @  2, 45   MSGET cDoc           When .F.     PICTURE "@!"  SIZE 60, 7 PIXEL OF oDlg
        
        @  3,100    SAY "Serie"          SIZE 40,7    PIXEL OF oDlg
        @  2, 135  MSGET cSerie         When .F.     PICTURE "@!"  SIZE 60, 7 PIXEL OF oDlg
        
        @  23,3    SAY "Cod. Cliente"     SIZE 40,7    PIXEL OF oDlg
        @  22, 45  MSGET cCliente        When .F.     PICTURE "@!"  SIZE 60, 7 PIXEL OF oDlg
                                    
        @  23,100   SAY "Nom. Factura"      SIZE 40,7    PIXEL OF oDlg
        @  22, 135 MSGET cUNOME     When .F.     PICTURE "@!"  SIZE 170, 7 PIXEL OF oDlg
        
        @  43,3    SAY "NIT Factura"     SIZE 40,7    PIXEL OF oDlg
        @  42, 45  MSGET cUNIT      When .F.     PICTURE "@!"  SIZE 60, 7 PIXEL OF oDlg
        
        @  43,100   SAY "Tipo Doc."       SIZE 40,7    PIXEL OF oDlg
        @  42, 135 MSGET cXtipdoc        When .F.     PICTURE "@!"  SIZE 60, 7 PIXEL OF oDlg
        
        @  63,3    SAY "Email"          SIZE 40,7    PIXEL OF oDlg
        @  62, 45  MSGET cXemail         When .F.     PICTURE "@&"  SIZE 260, 7 PIXEL OF oDlg
        
        @  83,3    SAY "Nuevo Tipo Doc"   SIZE 40,7    PIXEL OF oDlg
        @  82,45   MSGET cNewXtipdoc   PICTURE "@!" SIZE 60,7     PIXEL OF oDlg  
        
        @  83,100   SAY "Nuevo NIT"  SIZE 40,7    PIXEL OF oDlg
        @  82,135  MSGET cNewUNIT PICTURE "@!" SIZE 60,7     PIXEL OF oDlg  
        
        @  103,3   SAY "Nuevo Email"      SIZE 40,7    PIXEL OF oDlg
        @  102,45  MSGET cNewXemail    PICTURE "@&" SIZE 260,7     PIXEL OF oDlg  
    
        @ 160,120 BUTTON "Guardar"  SIZE 040,012 PIXEL of oDlg ACTION Actualizar(oDlg,cDoc,cSerie,cCliente,cNewXtipdoc,cNewUNIT,cNewXemail) 
        @ 160,165 BUTTON "Salir" SIZE 040,012 PIXEL of oDlg ACTION oDlg:End()
        
        //DEFINE SBUTTON  FROM 160,130 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL 
        
    ACTIVATE MSDIALOG oDlg CENTER    
    //CLOSEBROWSE()

RETURN  Nil
           
       
Static Function Actualizar(oDlg,cDoc,cSerie,cCliente,cNewXtipdoc,cNewUNIT,cNewXemail)

 local nvalor1 := 0 
 lOCAL aArea
 Local cMarca := ThisMark() 
 local nvalor2 := 0 

 
 nvalor1 := setActualizarF2(cDoc,cSerie,cCliente,cNewXtipdoc,cNewUNIT,cNewXemail)   

 nvalor2 := setActC5(cDoc,cSerie,cCliente,cNewXtipdoc,cNewUNIT,cNewXemail)   
 if  (nvalor1>=0  .AND. nvalor2>=0 )
 	
    aArea 					:= GetArea()
	dbSelectArea("TRB")
    TRB->(DbGoTop())
	
    While (! TRB->(EOF()))
	 	IF TRB->MOK == cMarca //.AND. !lInvert
            RecLock("TRB",.F.)
            TRB->XTIPDOC    := cNewXtipdoc
            TRB->UCNIT      := cNewUNIT
            TRB->XEMAIL     := cNewXemail
            TRB->(MsUnLock())
        EndIf
        TRB->(dbSkip()) 
    EndDo  
    RestArea(aArea)	

    
   
    MsgInfo("Actualizacion con Exito", "ACTUALIZACION DE DATOS")
 else                                   
  	alert("Error en la Actualizacion")
 endIf  
 

 oDlg:End()
  
return nil

Static Function GetFact()

	
	_cSQL := "SELECT F2_OK,F2_FILIAL,F2_SERIE,F2_DOC,F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_DTDIGIT,F2_XTIPDOC,F2_MODCONS,F2_UNITCLI,F2_UNOMCLI,F2_XEMAIL" 
   	_cSQL := _cSQL + " FROM " + RetSqlName("SF2") 
    _cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' "
    _cSQL := _cSQL + " AND F2_SERIE   BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
    _cSQL := _cSQL + " AND F2_EMISSAO BETWEEN '" + dtos(mv_par03) +"' AND '" + dtos(mv_par04) +"' "
	_cSQL := _cSQL + " AND F2_TIPODOC = '01' "
    _cSQL := _cSQL + " AND F2_FLFTEX IN ('1','4','5',' ') "
	_cSQL := _cSQL + " ORDER BY F2_EMISSAO,F2_SERIE,F2_DOC "
	_cSQL:= ChangeQuery(_cSQL)
	
    //aviso("SQL",_cSQL,{'Ok'},,,,,.t.)

	cArea1 := "SOLIC1"			
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL), cArea1 ,.T.,.T.)   
	dbSelectArea(cArea1)
	dbGoTop()
   
Return Nil 

Static Function setActualizarF2(cDoc,cSerie,cCliente,cNewXtipdoc,cNewUNIT,cNewXemail) 
    local _cSQL:=""
   
	_cSQL := "UPDATE " + RetSqlName("SF2") 
	_cSQL := _cSQL + " SET F2_XTIPDOC = '"      + cNewXtipdoc       +"',"
	_cSQL := _cSQL + " F2_UNITCLI ='"       + cNewUNIT          +"',"  
	_cSQL := _cSQL + " F2_XEMAIL ='"        + cNewXemail        +"'"
    _cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' AND F2_SERIE = '"  + cSerie            +"'" 
    _cSQL := _cSQL + " AND   F2_DOC   = '"  + cDoc              +"'" 
    _cSQL := _cSQL + " AND F2_FLFTEX IN ('1','4','5') "
    
    //aviso("SQL OUT",_cSQL,{'Ok'},,,,,.t.)

    nvalor:=TCSQLEXEC(_cSQL) 
	
Return nvalor  

Static Function setActC5(cDoc,cSerie,cCliente,cNewXtipdoc,cNewUNIT,cNewXemail) 
     local _cSQL:=""
	
    _cSQL := "UPDATE " + RetSqlName("SC5") 
	_cSQL := _cSQL + " SET C5_XTIPDOC = '"      + cNewXtipdoc       +"',"
	_cSQL := _cSQL + " C5_UNITCLI ='"       + cNewUNIT          +"',"  
	_cSQL := _cSQL + " C5_XEMAIL ='"        + cNewXemail        +"'"
    _cSQL := _cSQL + " WHERE D_E_L_E_T_ = ' ' AND C5_FILIAL+C5_NUM = ("  
    _cSQL := _cSQL + " SELECT TOP 1 D2_FILIAL+D2_PEDIDO FROM SD2010 WHERE D_E_L_E_T_ = ' ' "
    _cSQL := _cSQL + " AND D2_SERIE = '"  + cSerie            +"'" 
    _cSQL := _cSQL + " AND   D2_DOC   = '"  + cDoc              +"')" 

	 nvalor:=TCSQLEXEC(_cSQL)
	 
	
Return nvalor  

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{"01","De Serie :","mv_ch1","C",03,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,"",  ""}) 
aAdd(aRegs,{"02","A  Serie :","mv_ch2","C",03,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,"",  ""})
aAdd(aRegs,{"03","De F. Emision :","mv_ch3","D",08,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,""   ,"",  ""})
aAdd(aRegs,{"04","A  F. Emision  :","mv_ch4","D",08,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,""   ,"",  ""})


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
 

