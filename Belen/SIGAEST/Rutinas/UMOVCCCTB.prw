#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'TOPCONN.CH'

/*
    Informe de Movimientos Internos
    Jorge Saavedra
    31/05/2021
*/

user function UMOVCCCTB()
  Local oReport := nil
  Local cPerg:= Padr("MOVCCCTB",10)

   AjustaSX1(cPerg)    
   Pergunte(cPerg,.F.)              
        
   oReport := RptDef(cPerg)
   oReport:PrintDialog()
return

Static Function RptDef(cNome)
    Local oReport := Nil
    Local oSection1:= Nil
    Local oSection2:= Nil
    Local oSection3:= Nil

    oReport := TReport():New(cNome,"Movimientos por Centro Costo y Cuenta Contable",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)

    oSection1:= TRSection():New(oReport, "CENTRO_COSTO", {"CTT"}, , .F., .T.)
    TRCell():New(oSection1,"CTT_CUSTO"  ,"TRBMOV","CENTRO COSTO"          ,"@!",20,,,,,,,,,,,.T.)
    TRCell():New(oSection1,"CTT_DESC01" ,"TRBMOV","DESCRIPCION"    ,"@!",60,,,,,,,,,,,.T.)

    oSection2:= TRSection():New(oSection1, "CUENTA_CONTABLE", {"CT1"}, , .F., .T.)
    TRCell():New(oSection2,"CT1_CONTA"   ,"TRBMOV","CUENTA CONTABLE"          ,"@!",20,,,,,,,,,,,.T.)
    TRCell():New(oSection2,"CT1_DESC01"  ,"TRBMOV","DESCRIPCION"    ,"@!",60,,,,,,,,,,,.T.)
    oSection2:SetTotalInLine(.F.)

    oSection3:= TRSection():New(oSection2, "MOVIMIENTOS", {"SD3","SB1"}, NIL, .F., .T.)
    TRCell():New(oSection3,"D3_EMISSAO" ,"TRBMOV","Fecha"        ,"@!",10)
    TRCell():New(oSection3,"D3_TM"      ,"TRBMOV","Tipo Mov."        ,"@!",5)
    TRCell():New(oSection3,"D3_DOC"      ,"TRBMOV","Documento"        ,"@!",15)
    // TRCell():New(oSection3,"D3_ITEM"      ,"TRBMOV","Item"        ,"@!",5)
    TRCell():New(oSection3,"D3_COD"      ,"TRBMOV","Codigo"    ,"@!",15)
    TRCell():New(oSection3,"B1_DESC"    ,"TRBMOV","Descripcion"    ,"@!",50)    
    TRCell():New(oSection3,"D3_LOCAL"    ,"TRBMOV","Almacen"            ,"@!",5)  
    TRCell():New(oSection3,"D3_QUANT"    ,"TRBMOV","Cantidad"            ,PesqPictQt("D3_QUANT",17),12)  
    TRCell():New(oSection3,"D3_UM"    ,"TRBMOV","UM."            ,"@!",5)  
    TRCell():New(oSection3,"D3_CUSTO1"    ,"TRBMOV","Costo"            ,PesqPict("SD3", "D3_CUSTO1",17),12)  
    oSection3:SetTotalInLine(.F.)
    oReport:SetTotalInLine(.F.)
    
    oSection4:= TRSection():New(oSection3, " ", {"SD3","SB1"}, NIL, .F., .T.)
    TRCell():New(oSection4,"D3_EMISSAO" ,"TRBMOV","Fecha"        ,"@!",20,,,,,,,,,,,.T.)
    TRCell():New(oSection4,"D3_DOC"      ,"TRBMOV","Documento"        ,"@!",15)
    // TRCell():New(oSection4,"D3_ITEM"      ,"TRBMOV","Item"        ,"@!",5)
    TRCell():New(oSection4,"D3_COD"      ,"TRBMOV","Codigo"    ,"@!",15)
    TRCell():New(oSection4,"B1_DESC"    ,"TRBMOV","Descripcion"    ,"@!",50)    
    TRCell():New(oSection4,"D3_LOCAL"    ,"TRBMOV","Almacen"            ,"@!",5)  
    TRCell():New(oSection4,"D3_QUANT"    ,"TRBMOV","Cantidad"            ,PesqPictQt("D3_QUANT",17),12,,,,,,,,,,,.T.) 
    TRCell():New(oSection4,"D3_UM"    ,"TRBMOV","UM."            ,"@!",5)  
    TRCell():New(oSection4,"D3_CUSTO1"    ,"TRBMOV","Costo"            ,PesqPict("SD3", "D3_CUSTO1",17),12,,,,,,,,,,,.T.) 
    oSection4:SetTotalInLine(.F.)
    oSection4:SetHeaderPage()
              
Return(oReport)

Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(1):Section(1)    
    Local oSection3 := oReport:Section(1):Section(1) :Section(1)    
    Local oSection4 := oReport:Section(1):Section(1) :Section(1):Section(1)   
    Local cCC := ""
    Local cCuenta := ""
    Local nTotalQtdCC :=0
    Local nTotalCosCC :=0

    oSection3:SetTotalText("TOTAL CUENTA CONTABLE ") 
    TRFunction():New(oSection3:Cell("D3_QUANT"),NIL,"SUM",,,PesqPictQt("D3_QUANT",17),,.T.,.T.,,oSection3)
    TRFunction():New(oSection3:Cell("D3_CUSTO1"),NIL,"SUM",,,PesqPict("SD3", "D3_CUSTO1",17),,.T.,.T.,,oSection3)

    cQuery := "    SELECT CTT_CUSTO,CTT_DESC01,CT1_CONTA,CT1_DESC01,D3_EMISSAO,D3_TM,D3_COD,B1_DESC, "
    cQuery += "    D3_LOCAL,D3_QUANT,D3_CUSTO1,D3_ITEM,D3_DOC,D3_UM "
    cQuery += "    FROM "+RETSQLNAME("SD3")+" SD3 "
    cQuery += "    INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON  B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D3_COD "
    cQuery += "    INNER JOIN "+RETSQLNAME("CTT")+" CTT ON  CTT_FILIAL='"+xFilial("CTT")+"' AND CTT_CUSTO=D3_CC "
    cQuery += "    INNER JOIN "+RETSQLNAME("CT1")+" CT1 ON  CT1_FILIAL='"+xFilial("CT1")+"' AND CT1_CONTA=D3_CONTA "
    cQuery += "    WHERE SD3.D_E_L_E_T_=' ' "
    cQuery += "    AND SB1.D_E_L_E_T_=' ' "
    cQuery += "    AND CTT.D_E_L_E_T_=' ' "
    cQuery += "    AND CT1.D_E_L_E_T_=' ' "
    cQuery += "    AND D3_FILIAL='"+xFilial("SD3")+"' "
    cQuery += "    AND D3_CC BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"'"
    cQuery += "    AND D3_EMISSAO BETWEEN '"+ DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
    cQuery += "    AND D3_CONTA BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"'"
    cQuery += "    AND D3_COD BETWEEN '"+ mv_par07 +"' AND '"+ mv_par08 +"'"
    cQuery += "    ORDER BY CTT_CUSTO,CT1_CONTA "

    IF Select("TRBMOV") <> 0
        DbSelectArea("TRBMOV")
        DbCloseArea()
    ENDIF
    
    TCQUERY cQuery NEW ALIAS "TRBMOV"   
    dbSelectArea("TRBMOV")
    TRBMOV->(dbGoTop())
    
    oReport:SetMeter(TRBMOV->(LastRec()))  

     While !Eof()
        
        If oReport:Cancel()
            Exit
        EndIf
    
        If cCC <> TRBMOV->CTT_CUSTO                       
            oSection3:Finish()
            if cCC <> ""

                oSection4:Init()
                oSection4:Cell("D3_EMISSAO"):SetValue('TOTAL CENTRO COSTO')                
                oSection4:Cell("D3_DOC"):SetValue(space(15))   
                // oSection4:Cell("D3_ITEM"):SetValue(space(5))   
                oSection4:Cell("D3_COD"):SetValue(space(5))            
                oSection4:Cell("B1_DESC"):SetValue(space(15))            
                oSection4:Cell("B1_DESC"):SetValue(space(50))            
                oSection4:Cell("D3_LOCAL"):SetValue(SPACE(5))            
                oSection4:Cell("D3_QUANT"):SetValue(nTotalQtdCC)            
                oSection4:Cell("D3_UM"):SetValue(space(5))   
                oSection4:Cell("D3_CUSTO1"):SetValue(nTotalCosCC)  
                nTotalQtdCC := 0
                nTotalCosCC := 0    
                oSection4:Printline() 
                oSection4:Finish()          
            EndIf
            
            oSection1:Init()

            cCC     := TRBMOV->CTT_CUSTO                      
            oSection1:Cell("CTT_CUSTO"):SetValue(TRBMOV->CTT_CUSTO)
            oSection1:Cell("CTT_DESC01"):SetValue(TRBMOV->CTT_DESC01)                
            oSection1:Printline()
            oSection1:Finish()
        END
        
        If cCuenta <> TRBMOV->CT1_CONTA
            oSection3:Finish()
            oSection2:Init()
                   
            cCuenta  := TRBMOV->CT1_CONTA                   
            oSection2:Cell("CT1_CONTA"):SetValue(TRBMOV->CT1_CONTA)
            oSection2:Cell("CT1_DESC01"):SetValue(TRBMOV->CT1_DESC01)                
            oSection2:Printline()
            oSection2:Finish()
        END

        oSection3:init()
        oSection3:Cell("D3_EMISSAO"):SetValue(DTOC(STOD(TRBMOV->D3_EMISSAO)))
        oSection3:Cell("D3_TM"):SetValue(TRBMOV->D3_TM)
        oSection3:Cell("D3_DOC"):SetValue(U_zTiraZeros(TRBMOV->D3_DOC))
        // oSection3:Cell("D3_ITEM"):SetValue(TRBMOV->D3_ITEM)
        oSection3:Cell("D3_COD"):SetValue(TRBMOV->D3_COD)            
        oSection3:Cell("B1_DESC"):SetValue(TRBMOV->B1_DESC)            
        oSection3:Cell("B1_DESC"):SetValue(TRBMOV->B1_DESC)            
        oSection3:Cell("D3_LOCAL"):SetValue(TRBMOV->D3_LOCAL)            
        oSection3:Cell("D3_QUANT"):SetValue(TRBMOV->D3_QUANT)  
        oSection3:Cell("D3_UM"):SetValue(TRBMOV->D3_UM)            
        oSection3:Cell("D3_CUSTO1"):SetValue(TRBMOV->D3_CUSTO1)    
        nTotalQtdCC +=  TRBMOV->D3_QUANT
        nTotalCosCC +=  TRBMOV->D3_CUSTO1
        oSection3:Printline()                
      
        
        TRBMOV->(dbSkip())      
    Enddo
    oSection3:Finish()
Return

static function ajustaSx1(cPerg)
    //Creacion de Preguntas
    putSx1(cPerg, "01", "Centro Costo Inicial"      , "", "", "mv_ch1", "C", tamSx3("D3_CC")[1], 0, 0, "G", "", "CTT", "", "", "mv_par01")
    putSx1(cPerg, "02", "Centro Costo Final  "      , "", "", "mv_ch2", "C", tamSx3("D3_CC")[1], 0, 0, "G", "", "CTT", "", "", "mv_par02")
    putSx1(cPerg, "03", "Fecha Inicial       "      , "", "", "mv_ch3", "D", tamSx3("D3_EMISSAO")[1], 0, 0, "G", "", "", "", "", "mv_par03")
    putSx1(cPerg, "04", "Fecha Final         "      , "", "", "mv_ch4", "D", tamSx3("D3_EMISSAO")[1], 0, 0, "G", "", "", "", "", "mv_par04")
    putSx1(cPerg, "05", "Cuenta Inicial      "      , "", "", "mv_ch5", "C", tamSx3("D3_CONTA")[1], 0, 0, "G", "", "CT1", "", "", "mv_par05")
    putSx1(cPerg, "06", "Cuenta Final        "      , "", "", "mv_ch6", "C", tamSx3("D3_CONTA")[1], 0, 0, "G", "", "CT1", "", "", "mv_par06")
    putSx1(cPerg, "07", "Producto Inicial    "      , "", "", "mv_ch7", "C", tamSx3("D3_COD")[1], 0, 0, "G", "", "SB1", "", "", "mv_par07")
    putSx1(cPerg, "08", "Producto Final      "      , "", "", "mv_ch8", "C", tamSx3("D3_COD")[1], 0, 0, "G", "", "SB1", "", "", "mv_par08")
return
