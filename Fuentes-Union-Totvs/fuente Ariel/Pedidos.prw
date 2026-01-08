#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*

?
Program     AFATR304        Autor  Luis Fernando Ibarra               
?
?
AUTOR        Luis Fernando Ibarra Ortuno                              
?
Descripcion Rutina que integra las ventas realizada en aplicacion     
            externa DUAL POINT.Esta rutina integra lo siguientes:      
            Pedido de venta                                           
            Cliente                                                   
?
Version      V.001                                                    
?

      
*/
User Function AFATR30EL() //U_AFATR304()
    Local   aArea       := GetArea()
    Local   NextArea    := GetNextAlias()
    Local   cxFch       := ""
    Local   cSql        := ""
    Local   bSw         := .T.
    Local   cXDptAx     := ""
    Local   aDtsDsfs		:= {}  //Carga Todas las Dosificaciones en Base a DDATABASE
    Local   aDtsDsf     := {}  //Carga la Dosificacion de la Factura que se esta integrando
    Local   cxSre       := ""
    Local   cXCndPgo    := ""
    Local   cXNroPdo    := ""
    Local   cNroFat     := ""
    Local   cXNroDual   := 0
    Local   cXNroRmt    := ""
    Local   nXTmCrl     := 15
    Local   cXCodCtr    := ""
    Local   cXNroNit    := ""
    Local   cXNroAuto   := ""
    Local   cxNmbFat    := ""
    Local   aTest       :=&( GETMV("BAG_POTEST"))
    Local   aDtsInt     := {}
    Local   nEstado     := 0
 
    Local nPosDosi := 0
    Local   cXCC := ""
    Local   cXCiudad := ""
    Private nValFat     := 0
    Private   cXSeg       := "" 
    Private cEspecie := 'NF'
   
    cSql				:= cSql + " SELECT SUCURSAL, ZH_ALM,ZH_UTPCLI,CODIGOVENTA,CODIGOCLIENTE,TO_CHAR(FECHAEMISION,'DD/MM/YYYY') AS FECHA,  "
    cSql				:= cSql + " MONEDA,CONDICION_PAGO,NOMBREFACTURA,NITFACTURA,IMPORTE,NROFACTURA , ZH_SERIREM, "
    cSql				:= cSql + " NROAUTORIZACION,ESTADO,ZH_PROVIN,IDVENDEDOR,CODIGOCONTROL,CODIGOSEGMENTO,ZH_TPSEG, "
    cSql				:= cSql + " CV0_CODIGO, CODIGOCIUDAD, CODIGO_RECEP, TP_DOC_CLIENTE, METODO_PAGO,DOC_SECTOR "
    cSql				:= cSql + " FROM   VENTA VTN "
    //cSql				:= cSql + " INNER JOIN "
    //cSql				:= cSql + " SFP300 SFP ON VTN.NROAUTORIZACION = SFP.FP_NUMAUT"
    cSql				:= cSql + " INNER JOIN "
    cSql				:= cSql + " SZH300 SZH ON VTN.IDVENDEDOR = RTRIM(SZH.ZH_UVENDP)"
    cSql				:= cSql + " INNER JOIN "
    cSql				:= cSql + " CV0300 CV0 ON VTN.CODIGOCIUDAD = CV0.CV0_UINTBI"
    cSql				:= cSql + " WHERE  VTN.INTEGRADOPEDIDO = 'N'  "
    //cSql				:= cSql + " AND SFP.D_E_L_E_T_ = ' ' "
    cSql				:= cSql + " AND SZH.D_E_L_E_T_ = ' ' "
    cSql				:= cSql + " AND SZH.ZH_INTEG = 'T' "
    //cSql				:= cSql + " AND SUCURSAL = '" + CFILANT + "' "
    cSql				:= cSql + " AND TO_CHAR(VTN.FECHAEMISION,'YYYYMMDD') = '" + DToS(DDataBase) + "'"

    cSql				:= cSql + " AND NOT EXISTS (SELECT SF2.F2_SERIE||SF2.F2_DOC "
    cSql				:= cSql + " 	FROM SF2300 SF2 "
    cSql				:= cSql + "  	WHERE SF2.D_E_L_E_T_ = ' ' "
    cSql				:= cSql + "  	AND SF2.F2_CODDOC  = VTN.NROAUTORIZACION  "
    cSql				:= cSql + "  	AND SF2.F2_EMISSAO = TO_CHAR(VTN.FECHAEMISION,'YYYYMMDD')) "
    cSql				:= cSql + " ORDER BY 	ZH_ALM,CODIGOVENTA ASC "
//Aviso("Atenção",cSql,{"Ok"},,,,,.T.)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    ProcRegua((NextArea)->(RecCount()))
    dbSelectArea(NextArea)
    dbGoTop()

    While ((!Eof()) .And. bSw)
        IncProc()
        //NROFACTURA,NROAUTORIZACION
        aTest       :=&( GETMV("BAG_POTEST"))
        lExisteFactura  := .F.
        bSw             := .F.
        nValFat         := 0
        cXCndPgo        := CONDICION_PAGO
        cXNroNit        := NITFACTURA
        cXNroAuto       := ALLTRIM(NROAUTORIZACION)
        nEstado         := ESTADO
        cxFch           := Substr(FECHA,7,4) +  Substr(FECHA,4,2) + Substr(FECHA,1,2)
        cXNroDual       := CODIGOVENTA
        cNroFat         := PADL(AllTrim(NROFACTURA),nXTmCrl,"0")
        cxNmbFat        := AllTrim(NOMBREFACTURA)
        cXCodCtr	:= alltrim(CODIGOCONTROL)
        cXCiudad := CV0_CODIGO
        cMetodoPago := METODO_PAGO
        cDocSector := DOC_SECTOR
        //If ZH_PROVIN == "T"
        //  cXSeg := '06'
        //Else
        //    cXSeg := '01'
        //EndIf
        iF ALLTRIM(ZH_TPSEG) $ 'D'
            cXSeg := ZH_UTPCLI
        ELSE
            cXSeg := STR(CODIGOSEGMENTO)
        END

        cXCC := ALLTRIM(GetCC(cXSeg,ZH_TPSEG))
        //aDtsDsf     := GetDsf(cxSre,cxFch,cXNroAuto)
        aDtsDsf := GetDsfs(IDVENDEDOR)
        /*nPosDosi := aScan(aDtsDsfs,{|x| AllTrim(x[2])==alltrim(cXNroAuto)}) //JS: BUSCAMOS LA DOSIFICACION
        If nPosDosi > 0
            aDtsDsf := 	aDtsDsfs[nPosDosi]
        END*/
        If (cXDptAx     != AllTrim((ZH_ALM)))
            cXDptAx     := AllTrim((ZH_ALM))
            //cxSre       := AllTrim(GetRmt(cXDptAx))
            cxSre		:= alltrim(ZH_SERIREM)      //JS: Se Obtiene este valor desde el query principal

            //aDtsDsf[01]-> FP_SERIE
            //aDtsDsf[02]-> FP_NUMAUT
            //aDtsDsf[03]-> FP_DTAVAL
        EndIf
        CONOUT(cNroFat + '-'+ cxNmbFat +'-' + cXDptAx)
        lExisteFactura := EtFat(NROAUTORIZACION,SUCURSAL )


        If ( (cxSre != "") .And. (Len(aDtsDsf) > 0 ) ) .AND. !lExisteFactura
            aItens          := GtDtlle(CODIGOVENTA,SUCURSAL,ZH_ALM,ALLTRIM(NROFACTURA),ALLTRIM(cXNroAuto))         //Obtiene Datos De Los Productos De Factura
            aDtClt          := GetClte(NOMBREFACTURA,NITFACTURA,TP_DOC_CLIENTE,CODIGOCLIENTE)    //Obtiene Datos Del Cliente
            dbSelectArea(NextArea)
            Begin Transaction
                If (Len(aDtClt) != 3 )
                    bSw     := CrearClt(NOMBREFACTURA,NITFACTURA,TP_DOC_CLIENTE,CODIGOCLIENTE)
                    aDtClt      := GetClte(NOMBREFACTURA,NITFACTURA,TP_DOC_CLIENTE,CODIGOCLIENTE)
                EndIf
                dbSelectArea(NextArea)
                //aDtClt[01]->A1_COD)
                //aDtClt[02]->A1_LOJA)
                //aDtClt[03]->A1_NOME)
                If (Len(aDtClt) == 3 )
                    cXNroPdo := GetSxeNum("SC5","C5_NUM")
                    cXNroRmt := GtNxtFat(cxSre       , "01" , nXTmCrl )
                    IF cxFch >= GETNEWPAR('BAG_FECINI','20200617')
                        If len(aItens)>0
                            If substr(ALLTRIM(aItens[1][2]),1,4) $ 'PA01'
                                aTest := &( GETMV("BAG_POTEAL"))
                            END
                        End
                    END

                    //PREGUNTA POR EL ESTADO PARA SOLO GENERAR LAS FACTURAS PARA LUEGO SER ANULADAS
                    If nEstado == 0

                        If ( CrearPdo(cXNroPdo,aDtClt[01],aDtClt[02],cXCndPgo,cxFch,1,aItens,aTest[2],cXNroDual,cXSeg,cXNroNit,cxNmbFat,cMetodoPago,cDocSector) == .T.)
                           If ( CrearRmt(aDtClt[01],aDtClt[02],cxSre,cXNroRmt,cXCndPgo,cxFch,1,aDtsDsf[02],aDtsDsf[03],aItens,"RFN",aTest[2],"50",cXCC,cXCiudad,cXNroNit,cxNmbFat,cMetodoPago,cDocSector) == .T.)
                                If (CrearFct(aDtClt[01],aDtClt[02],aDtsDsf[01],cNroFat,cXCndPgo,cxFch,1,aDtsDsf[02],aDtsDsf[03],aItens,"NF",aTest[1],"01",cXCC,cXCiudad,cXNroNit,cxNmbFat,cMetodoPago,cDocSector) == .T. )
                                    // cXCodCtr    := GtCCtrl(cNroFat,cXNroNit,cxFch,nValFat,xFilial("SF2"),aDtsDsf[1])
                                    If  ( UpdInt(cNroFat,aDtsDsf[01],cXNroRmt,cxSre   ,xFilial("SF2"),cXNroPdo,cXNroDual,nXTmCrl,cXCodCtr,cXNroAuto) == .T. )
                                        bSw := .T.
                                        aAdd(aDtsInt,{cXNroDual,cNroFat,cxNmbFat,cXDptAx,cXNroAuto,cXNroPdo,cXNroRmt,cNroFat,cXCodCtr})
                                    Else
                                        DisarmTransaction()
                                        MsgAlert("UpdInt")
                                    EndIf
                                Else
                                    DisarmTransaction()
                                    MsgAlert("CrearFct")
                                EndIf
                            Else
                                DisarmTransaction()
                                MsgAlert("CrearRmt")
                            EndIf
                        Else
                            DisarmTransaction()
                            MsgAlert("CrearPdo")
                        EndIf

                    Else

                        If (CrearFct(aDtClt[01],aDtClt[02],aDtsDsf[01],cNroFat,cXCndPgo,cxFch,1,aDtsDsf[02],aDtsDsf[03],aItens,"NF",aTest[1],"01",cXCC,cXCiudad,cXNroNit,cxNmbFat,cMetodoPago,cDocSector) == .T. )
                            //cXCodCtr    := GtCCtrl(cNroFat,cXNroNit,cxFch,nValFat,xFilial("SF2"),aDtsDsf[1])
                            If  ( UpdInt(cNroFat,aDtsDsf[01],cXNroRmt,cxSre   ,xFilial("SF2"),cXNroPdo,cXNroDual,nXTmCrl,cXCodCtr,cXNroAuto) == .T. )
                                bSw := .T.
                                aAdd(aDtsInt,{cXNroDual,cNroFat,cxNmbFat,cXDptAx,cXNroAuto,cXNroPdo,cXNroRmt,cNroFat,cXCodCtr})
                            Else
                                DisarmTransaction()
                                MsgAlert("UpdInt_Del")
                            EndIf
                        Else
                            DisarmTransaction()
                            MsgAlert("CrearFct_Del")
                        EndIf

                    EndIf

                Else
                    bSw := .F.
                    MsgAlert("No encuentra cliente")
                EndIf
            End Transaction
        ELSE
            IF lExisteFactura
                UpdtPoint(cXNroDual,SUCURSAL,cXNroAuto)
                bSw := .T.
                //  COUNT('FACTURA YA EXISTE:'+ (cNroFat) + ' NRO.DUAL:' + STR(cXNroDual) + ' AUTORIZACION:'+ STR(cXNroAuto))
            End
        EndIf
        dbSelectArea(NextArea)
        DbSkip()
    EndDo
    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
    If (bSw==.F.)
        MsgAlert("El Proceso De Integracion.No Se Pudo Completar Favor Revisar Los Datos.")
    Else
        MsgInfo ("Integracion Finalizada En Forma Sastifactoria")
    EndIf
    ImpDts(aDtsInt)
Return Nil
Static Function CrearFct(cClt,cTda,cSre,cNroFat,cCndPg,cFchFat,cMda,cNroAut,cFhaLmt,aDtsDet,cEspc,cTes,cTpDoc,cCC,cCiudad,NITFACTURA,NOMBREFACTURA,cMetodoPago,cDocSector)
    Local bSw           := .T.
    Local aDts          := {}
    Local aArea         := GetArea()
    Private lMsErroAuto := .F.
    aDts                := GetFat(cClt,cTda,cSre,cNroFat,cCndPg,cFchFat,cMda,cNroAut,cFhaLmt,aDtsDet,cEspc,cTes,cTpDoc,cCC,cCiudad,NITFACTURA,NOMBREFACTURA,cMetodoPago,cDocSector)
    MSExecAuto( { |x,y,z| Mata467n(x,y,z) }, aDts[1][1],aDts[1][2], 3 )
    If lMsErroAuto
        bSw             := .F.
        MsgStop("Se Produjo Un Error Al Momento de Grabar La Factura")
        MostraErro()
    EndIf
    RestArea(aArea)
Return  bSw

Static Function CrearRmt(cClt,cTda,cSre,cNroRmt,cCndPg,cFchFat,cMda,cNroAut,cFhaLmt,aDtsDet,cEspc,cTes,cTpDoc,cCC,cCiudad,NITFACTURA,NOMBREFACTURA,cMetodoPago,cDocSector)
    Local bSw           := .T.
    Local aDts          := {}
    Local aArea         := GetArea()
    Private lMsErroAuto := .F.
    aDts                := GetFat(cClt,cTda,cSre,cNroRmt,cCndPg,cFchFat,cMda,cNroAut,cFhaLmt,aDtsDet,cEspc,cTes,cTpDoc,cCC,cCiudad,NITFACTURA,NOMBREFACTURA,cMetodoPago,cDocSector)
    MSExecAuto( { |x,y,z| Mata467n(x,y,z) }, aDts[1][1],aDts[1][2], 3 )
    //MostraErro()
    If lMsErroAuto
        bSw             := .F.
        MsgStop("Se Produjo Un Error Al Momento de Grabar El Remito")
        MostraErro()
    EndIf
    RestArea(aArea)
Return bSw
//CrearPdo(cXNroPdo,aDtClt[01],aDtClt[02],cXCndPgo,cxFch,1,aItens,aTest[2],cXNroDual,cXSeg)

Static Function CrearPdo(cXNroPdo,cClt,cTda,cCndPg,cFchFat,cMda,aDtsDet,cTes,cXNroDual,cXNroRmt,cXSre,cXSeg,NITFACTURA,NOMBREFACTURA,cMetodoPago,cDocSector)
    Local   bSw         := .T.
    Local   aDts        := GetPdo(cXNroPdo,cClt,cTda,cCndPg,cFchFat,cMda,aDtsDet,cTes,cXNroDual,cXNroRmt,cXSre,cXSeg,NITFACTURA,NOMBREFACTURA,cMetodoPago,cDocSector)
    Private lMsErroAuto := .F.
    //RollBAckSx8()
    MSExecAuto({|x,y,z|Mata410(x,y,z)},aDts[1][1],aDts[1][2],3)
    //MostraErro()
    If lMsErroAuto
        bSw:= .F.
        MostraErro()
    EndIf
Return bSw

Static Function GtDtlle(cNroPdo,cSucr,cAlmac,cNroFactura,cNroAutorizacion)
    Local aDatos    := {}
    Local aItms     := {}
    Local cSql      := ""
    Local aArea     := GetArea()
    Local NextArea  := GetNextAlias()
    cSql            := cSql+ " Select  SUCURSAL,CODIGOALMACEN,ITEM,B1_COD,NOMBREPRODUCTO,UM,CANTIDAD,PRECIOUNITARIO,PRECIOUNITARIO As PRECIOLISTA,IMPORTE,TOTAL,DESCUENTOPOR,DESCUENTOMONTO,B1_CONV,B1_TIPCONV "
    cSql            := cSql+ " From DETALLEVENTA INNER JOIN SB1300 SB1 ON TRIM(CODPRODUCTO) = TRIM(B1_CODINT) "
    cSql            := cSql+ " Where INTEGRADOPEDIDO = 'N' And  SB1.D_E_L_E_T_=' ' AND "
    cSql            := cSql+ " NROFACTURA = '" +(cNroFactura) + "' And  NROAUTORIZACION = '" +cNroAutorizacion + "' AND "
    cSql            := cSql+ " CODIGOVENTA = " +Str(cNroPdo) + " And  SUCURSAL = '" +cSucr + "' ORDER BY ITEM"
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    dbSelectArea(NextArea)
    dbGoTop()
    While (!Eof())
        aItms      :={}
        aadd(aItms , ITEM                       )
        aadd(aItms , B1_COD                )
        aadd(aItms , CANTIDAD                   )
        nPrecio := PRECIOUNITARIO
        IF SUBSTR(ALLTRIM(B1_COD),1,4) $ 'PA01' .AND.  DDATABASE >= STOD(GETNEWPAR('BAG_FECINI','20200617'))
            nImpuesto := GetAdvFVal("SFF","FF_ALIQ",xFilial("SFF")+GETNEWPAR('MV_XCODPAR','2208901000')+GETNEWPAR('MV_XCODFIS','511'),16,0)
            iF nImpuesto > 0
               
                    nPrecio -=  B1_CONV *  nImpuesto
               
            ELSE
                aDatos    := {}
                EXIT
            END
        END

        aadd(aItms , nPrecio             )
        aadd(aItms , PRECIOLISTA                )
        aadd(aItms , TOTAL					  	)
        aadd(aItms , " "                        )
        aadd(aItms , cAlmac                     )
        aadd(aItms , CANTIDAD                   )
        aadd(aItms , UM                         )
        aadd(aItms , DESCUENTOPOR               )
        aadd(aItms , DESCUENTOMONTO             )
        aadd(aItms , DESCUENTOMONTO/(PRECIOUNITARIO*CANTIDAD)*100  ) // Proc. Descuento calculado
        aAdd(aDatos,aItms)
        nValFat :=  nValFat + (PRECIOUNITARIO*CANTIDAD)
        DbSkip()
    EndDo
    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
Return aDatos
Static Function GetClte(cXNomFac1,cXNitFac1,cTipoDoc,nCodCliente)
    Local aDts      := {}
    Local cSql      := ""
    Local aArea     := GetArea()
    Local NextArea  := GetNextAlias()
    cSql            := cSql+ " Select A1_COD,A1_LOJA,A1_NOME "
    cSql            := cSql+ " From   SA1300 SA1 "
    cSql            := cSql+ " Where  SA1.D_E_L_E_T_ = ' ' And "
    cSql            := cSql+ " A1_CGC ='" + ALLTRIM(cXNitFac1) + "'"
    cSql          := cSql+ " and A1_NOME=q'{" + ALLTRIM(cXNomFac1) + "}'"
    If !Empty(alltrim(cTipoDoc))
        cSql            := cSql+ " AND A1_UPOINT =" + STR(nCodCliente) 
    END
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    dbSelectArea(NextArea)
    dbGoTop()
    If (!Eof())
        Aadd(aDts,A1_COD)
        Aadd(aDts,A1_LOJA)
        Aadd(aDts,A1_NOME)
    EndIf
    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
Return aDts
Static Function CrearClt(cNmb,cNit,cTipoDoc,cCodigoCli)
    //Local cCod            := GETSXENUM("SA1","A1_COD") //U_AFATR102()   // GETSXENUM("SA1","A1_COD")
    Local aArea1        := GetArea()
    Local aDts          := {}
    Local bSw           := .T.
    Local sTipoDocumento := "4"
    LOCAL nCodigoCliente :=0
    Private lMsErroAuto   := .F.
    //IncCV0(cCod,ALLTRIM(cNmb))

    IF !EMPTY(ALLTRIM(cTipoDoc))
        sTipoDocumento := cTipoDoc
        nCodigoCliente :=cCodigoCli
    else        
        Do CASE
            CASE  LEN(ALLTRIM(cNit))>5 .AND. LEN(ALLTRIM(cNit))<=8
                sTipoDocumento := "1"  //Carnet de Identidad
            CASE LEN(ALLTRIM(cNit))>8
                sTipoDocumento := "5"   //NIT
            OtherWise 
                sTipoDocumento := "4"   //OTRO
        ENDCASE
    END
    //aDts:={ {"A1_COD"       , cCod                            , Nil},; // Codigo
    aDts:={ {"A1_LOJA"      , "01"                          , Nil},; // Loja
    {"A1_NOME"      , ALLTRIM(cNmb)                 , Nil},; // Nome
    {"A1_END"       , "XX"                          , Nil},; // Endereco
    {"A1_NREDUZ"    , ALLTRIM(SUBSTRING(cNmb,1,20)), Nil},; // Nome reduz.
    {"A1_TIPO"      , "1"                           , Nil},; // Tipo
    {"A1_EST"       , "SC"                          , Nil},; // Estado
    {"A1_MUN"       , "SANTA CRUZ"                  , Nil},; // Estado
    {"A1_CGC"       , ALLTRIM(cNit)                 , Nil},; // Loja
    {"A1_CONTA"     , "11220001"                    , Nil},; // Estado
    {"A1_UTPCLI"    , "01"                          , Nil},;   // Cidade
    {"A1_TIPDOC"    , sTipoDocumento                         , Nil},;  // Cidade
    {"A1_UPOINT"    , nCodigoCliente                         , Nil}}  // Cidade
  
     
    BEGIN TRANSACTION
        MSExecAuto({|x,y| Mata030(x,y)},aDts,3)                  //3- Incluso, 4- Alterao, 5- Excluso
        If lMsErroAuto
            Mostraerror()
            bSw := .F.
            Return()
        Else
            //ConfirmSX8(.T.)
        Endif
    END TRANSACTION
    RestArea(aArea1)
Return bSw
Static Function UpdInt(cXFat,cSreFat,cRmt,cSreRmt,cAgn,cNroPdo,cXNroDul,nTamFN,cCodCtr,cNroAtu)
    Local bSw   := .F.
    If (UpdPdo(cRmt,cSreRmt,cAgn,cNroPdo))
        If (UpdRmt(cRmt,cSreRmt,cAgn,cNroPdo))
            If(UpdFat(cXFat,cSreFat,cRmt,cSreRmt,cAgn,cCodCtr,cNroAtu))
                If (UpdtPoint(cXNroDul,cAgn,cNroAtu))
                    cRmt     := PADL( AllTrim(Str((Val(cRmt)+1))) ,nTamFN,"0")
                    If (UpdNrFct(cRmt,cSreRmt,"01"))        //Actualiza Correlativo Remito De Venta
                        cXFat := PADL( AllTrim(Str((Val(cXFat)+1))) ,nTamFN,"0")
                        bSw  :=UpdNrFct(cXFat,cSreFat,"01") //Actualiza Correlativo Factura De Venta
                    Else
                        MsgAlert("UpdNrFct")
                    EndIf
                Else
                    MsgAlert("UpdPoint")
                EndIf
            Else
                MsgAlert("UpdFac_Datos")
            EndIf
        Else
            MsgAlert("UpdRmt_Datos")
        EndIf
    Else
        MsgAlert("UpdPdo_Datos")
    EndIf
Return bSw

Static Function UpdtUM()
    Local bSw   := .F.
    Local cSql  := "UPDATE DETALLEVENTA "
    cSql        :=  cSql + " SET UM = 'PQ' "
    cSql        :=  cSql + " WHERE UM = 'PAQ' "
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023831' WHERE CODPRODUCTO IN ('25')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023832' WHERE CODPRODUCTO IN ('26')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023833' WHERE CODPRODUCTO IN ('27')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023613' WHERE CODPRODUCTO IN ('22')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023834' WHERE CODPRODUCTO IN ('29')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023835' WHERE CODPRODUCTO IN ('30')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023614' WHERE CODPRODUCTO IN ('23')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023615' WHERE CODPRODUCTO IN ('24')"
    bSw         := Abm(cSql)



    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023122' WHERE CODPRODUCTO IN ('21')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023121' WHERE CODPRODUCTO IN ('3')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023311' WHERE CODPRODUCTO IN ('4')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023411' WHERE CODPRODUCTO IN ('5')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023524' WHERE CODPRODUCTO IN ('7')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023829' WHERE CODPRODUCTO IN ('19')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023525' WHERE CODPRODUCTO IN ('28')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023836' WHERE CODPRODUCTO IN ('34')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023314' WHERE CODPRODUCTO IN ('32')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023313' WHERE CODPRODUCTO IN ('31')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023821' WHERE CODPRODUCTO IN ('14')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023211' WHERE CODPRODUCTO IN ('35')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023838' WHERE CODPRODUCTO IN ('38')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023837' WHERE CODPRODUCTO IN ('37')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023316' WHERE CODPRODUCTO IN ('36')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023839' WHERE CODPRODUCTO IN ('39')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA020004' WHERE CODPRODUCTO IN ('40')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023315' WHERE CODPRODUCTO IN ('33')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023123' WHERE CODPRODUCTO IN ('41')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023526' WHERE CODPRODUCTO IN ('42')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023840' WHERE CODPRODUCTO IN ('43')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023841' WHERE CODPRODUCTO IN ('44')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023842' WHERE CODPRODUCTO IN ('45')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023825' WHERE CODPRODUCTO IN ('15')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023826' WHERE CODPRODUCTO IN ('16')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023412' WHERE CODPRODUCTO IN ('51')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023124' WHERE CODPRODUCTO IN ('50')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023312' WHERE CODPRODUCTO IN ('52')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023317' WHERE CODPRODUCTO IN ('47')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023318' WHERE CODPRODUCTO IN ('48')"
    bSw         := Abm(cSql)

    cSql        := "UPDATE DETALLEVENTA SET CODPRODUCTO = 'PA023711' WHERE CODPRODUCTO IN ('53')"
    bSw         := Abm(cSql)

Return bSw

Static Function UpdtVend()
    Local bSw   := .F.
    Local cSql  := "UPDATE VENTA "
    cSql        :=  cSql + " SET IDVENDEDOR = '24' "
    cSql        :=  cSql + " WHERE IDVENDEDOR = '25' "
    bSw         := Abm(cSql)
Return bSw


Static Function UpdtPoint(cXNroPdo,cXScr,cNumAutorizacion)
    Local bSw   := .F.
    Local cSql  := " Update VENTA Set "
    cSql        :=  cSql + " INTEGRADOPEDIDO = 'S' "
    cSql        :=  cSql + " Where  SUCURSAL ='" + cXScr +"' And CODIGOVENTA =" + Str(cXNroPdo) +""
    cSql        :=  cSql + "   AND NROAUTORIZACION ='" + cNumAutorizacion +"' "
    bSw         := Abm(cSql)
Return bSw
Static Function UpdtClt(cNmb,cNit,cXScr)
    Local bSw   := .T.
    Local cSql  := " Update CLIENTE Set "
    cSql        := cSql + " INTEGRADO = 'S' "
    cSql        := cSql + " Where  SUCURSAL = '" + cXScr +"' And NOMBRE ='" + cNmb + "' And NIT = '" + cNit + "'"
    bSw         := Abm(cSql)
Return bSw
Static Function UpdPdo(cRmt,cSreRmt,cAgn,cNroPdo)
    Local bSw   := .T.
    Local cSql  := ""
    //Actualizacion Cabezera Pedido De Venta
    cSql        := "  Update SC5300 SC5 Set "
    cSql        := cSql + " C5_NOTA  = '" + cRmt     + "',"
    cSql        := cSql + " C5_SERIE = '" + cSreRmt  + "' "
    cSql        := cSql + " Where C5_FILIAL = '" + cAgn +"' And C5_NUM ='" + cNroPdo + "' And SC5.D_E_L_E_T_ = ' ' "
    bSw         := Abm(cSql)
    //Actualizacion Detalle Pedido De Venta
    cSql        := " Update SC6300 SC6 Set "
    cSql        := cSql + " C6_NOTA   = '" + cRmt     + "',"
    cSql        := cSql + " C6_SERIE  = '" + cSreRmt  + "',"
    cSql        := cSql + " C6_QTDENT = C6_QTDVEN "
    cSql        := cSql + " Where C6_FILIAL = '" + cAgn +"' And C6_NUM ='" + cNroPdo + "' And SC6.D_E_L_E_T_ = ' ' "
    bSw         := Abm(cSql)
Return bSw
Static Function UpdRmt(cRmt,cSreRmt,cAgn,cNroPdo)
    Local bSw   := .T.
    Local cSql  := " Update SD2300 SD2 Set "
    cSql        := cSql + " D2_PEDIDO   = '" + cNroPdo +   "',"
    cSql        := cSql + " D2_ITEMPV   = D2_ITEM            ,"
    cSql        := cSql + " D2_QTDEFAT  = D2_QUANT           "
    cSql        := cSql + " Where  D2_FILIAL = '" + cAgn + "' And D2_DOC ='" +  cRmt+ "' And D2_SERIE = '" + cSreRmt + "' And D2_ESPECIE = 'RFN' And SD2.D_E_L_E_T_ = ' ' "
    bSw         := Abm(cSql)
Return bSw
Static Function UpdFat(cXFat,cSreFat,cRmt,cSreRmt,cAgn,cCodCtr,cNroAtu)
    Local bSw       := .T.
    Local cSql      := " Update SD2300 SD2 Set "
    cSql            := cSql + " D2_REMITO    = '" + cRmt    + "',"
    cSql            := cSql + " D2_SERIREM   = '" + cSreRmt + "',"
    cSql            := cSql + " D2_ITEMREM   = D2_ITEM "
    cSql            := cSql + " Where  D2_FILIAL = '" + cAgn + "' And D2_DOC ='" +  cXFat+ "' And D2_SERIE = '" + cSreFat + "' And D2_ESPECIE = 'NF' And SD2.D_E_L_E_T_ = ' ' "
    bSw             := Abm(cSql)
    If (bSw)
        cSql        :=   " Update SF2300 SF2 Set "
        cSql        := cSql + " F2_CODCTR  = '" + cCodCtr  + "',"
     //   cSql        := cSql + " F2_NUMAUT  = '" + cNroAtu  + "',"
        cSql        := cSql + " F2_CODDOC  = '" + cNroAtu  + "'"
        cSql        := cSql + " Where  F2_FILIAL = '" + cAgn + "' And F2_DOC ='" +  cXFat+ "' And F2_SERIE = '" + cSreFat + "' And F2_ESPECIE = 'NF' And SF2.D_E_L_E_T_ = ' ' "
        bSw         := Abm(cSql)
    EndIf
    If (bSw)
        cSql        :=  " Update SF3300 SF3 Set "
        cSql        := cSql + " F3_UCUF  = '" + cNroAtu  + "',"
        cSql        := cSql + " F3_CODCTR  = '" + cCodCtr  + "'"
      //  cSql        := cSql + " F3_NUMAUT  = '" + cNroAtu  + "'"
        cSql        := cSql + " Where  F3_FILIAL = '" + cAgn + "' And F3_NFISCAL ='" +  cXFat+ "' And F3_SERIE = '" + cSreFat + "' And F3_ESPECIE = 'NF' And F3_TIPOMOV = 'V' And SF3.D_E_L_E_T_ = ' '"
        bSw         := Abm(cSql)
    EndIf
Return bSw
Static Function UpdNrFct(cxNroFct,cXSre,cxTbl)
    Local bSw   := .F.
    Local cSql  := " Update SX5300 Set "
    cSql        := cSql + " X5_DESCRI  = '" + cxNroFct  + "', "
    cSql        := cSql + " X5_DESCSPA = '" + cxNroFct  + "', "
    cSql        := cSql + " X5_DESCENG = '" + cxNroFct  + "'"
    cSql        := cSql + " Where  X5_CHAVE  ='" + cXSre  + "' And "
    cSql        := cSql + " X5_TABELA   = '" + cxTbl + "'"
    //MsgAlert(cSql)
    nSql        := TCSQLExec(cSql)
    If ( nSql >= 0 )
        bSw     := .T.
    EndIf
Return  bSw
Static Function Abm(cSql)
    Local bSw   := .F.
    Local nSql	:= 0
    nSql:=TCSQLExec(cSql)
    If ( nSql >= 0 )
        bSw:=.T.
    EndIf
Return  bSw
Static Function IncCV0(Codigo,Nome)
    Local _cCodigo  := Codigo
    Local _cNome        := Nome
    Local _lRet     := .T.
    Local _aArea        := GetArea()
    DbSelectArea("CV0")
    DbSetOrder(2)
    DbSeek(xFilial("CV0")+_cCodigo)
    If !EoF()
        Return(_lRet)
    Else
        RecLock("CV0",.T.)
        CV0->CV0_FILIAL     := xFilial("CV0")
        CV0->CV0_PLANO      := "05" // Ente05
        CV0->CV0_ITEM       := GetSXENum("CV0","CV0_ITEM")
        CV0->CV0_CODIGO     := _cCodigo
        CV0->CV0_DESC       := _cNome
        CV0->CV0_CLASSE     := "2" //Analitico
        CV0->CV0_NORMAL     := "1" //Debito
        CV0->CV0_ENTSUP     := "0" //Persona
        CV0->CV0_DTIEXI     := dDataBase
        MsUnlock()
        _lRet := .T.
    EndIf
    RestArea(_aArea)
Return(_lRet)
//GetPdo(cXNroPdo,cClt,cTda,cCndPg,cFchFat,cMda,aDtsDet,cTes,cXNroDual,cXNroRmt,cXSre,cXSeg)          
Static Function GetPdo(cXNroPdo,cClt,cTda,cCndPg,cFchFat,cMda,aDtsDet,cTes,cXNroDual,cXSeg,NITFACTURA,NOMBREFACTURA,cMetodoPago,cDocSector)
    Local nI     := 1
    Local nDim   := Len(aDtsDet)
    Local aDts   := {}
    Local aCab   := {}
    Local aItms  := {}
    Local aDatos := {}
    Local cXDoc  := ""
    aAdd(aCab,{"C5_NUM"      , cXNroPdo      , Nil})
    aAdd(aCab,{"C5_TIPO"     , "N"           , Nil})
    aAdd(aCab,{"C5_EMISSAO"  , STOD(cFchFat) , Nil})
    aAdd(aCab,{"C5_CLIENTE"  , cClt          , Nil})
    aadd(aCab,{"C5_LOJACLI"  , cTda          , Nil})
    aAdd(aCab,{"C5_LOJAENT"  , cTda          , Nil})
    aAdd(aCab,{"C5_CONDPAG"  , cCndPg        , Nil})
    aAdd(aCab,{"C5_UTPCLI"   , "01"          , Nil})
    aAdd(aCab,{"C5_UPOINT"   , cXNroDual     , Nil})
    aAdd(aCab,{"C5_DOCGER"   , "2"           , Nil})
    aAdd(aCab,{"C5_MOEDA"    , 1             , Nil})
    aAdd(aCab,{"C5_UTPCLI"   , strzero(val(cXSeg),2)         , Nil})
    aAdd(aCab,{"C5_UNIT"   , NITFACTURA          , Nil})
    aAdd(aCab,{"C5_UNOME"    , NOMBREFACTURA            , Nil})
    iF !EMPTY(ALLTRIM(cMetodoPago))
        aAdd(aCab,{"C5_CODMPAG"    , cMetodoPago            , Nil})
    END
    iF !EMPTY(ALLTRIM(cDocSector))
        aAdd(aCab,{"C5_TPDOCSE"    , cDocSector            , Nil})
    END

    //aDtsDet[01] -> ITEM
    //aDtsDet[02] -> CODPRODUCTO
    //aDtsDet[03] -> CANTIDAD
    //aDtsDet[04] -> PRECIOUNITARIO
    //aDtsDet[05] -> PRECIOLISTA
    //aDtsDet[06] -> (PRECIOUNITARIO*CANTIDAD)
    //aDtsDet[07] -> "501"
    //aDtsDet[08] -> CODIGOALMACEN
    //aDtsDet[09] -> CANTIDAD
    //aDtsDet[10] -> UM
    //aDtsDet[11] -> DESCUENTOPOR
    For nI := 1 To nDim
        aItms      :={}
        //aadd(aItms,{"C6_NUM" , cXNroPdo                   ,Nil })
        //aadd(aItms,{"C6_ITEM"    , aDtsDet[nI][01]                        ,Nil })
        aadd(aItms,{"C6_ITEM"    , PADL(AllTrim(aDtsDet[nI][01]),2,"0") ,Nil })
        aadd(aItms,{"C6_PRODUTO" , aDtsDet[nI][02]                      ,Nil })
        aadd(aItms,{"C6_QTDVEN"  , aDtsDet[nI][03]                      ,Nil })
        aadd(aItms,{"C6_PRCVEN"  , aDtsDet[nI][04]                      ,Nil })
        //aadd(aItms,{"C6_VALOR"   , round(aDtsDet[nI][03]*aDtsDet[nI][04],2)      ,Nil })
        aadd(aItms,{"C6_DESCONT" , aDtsDet[nI][11]                      ,Nil })
//            aadd(aItms,{"C6_DESCONT" , aDtsDet[nI][13]                      ,Nil })
//            aadd(aItms,{"C6_VALDES"  , aDtsDet[nI][12]                      ,Nil })
//            aadd(aItms,{"C6_PRUNIT"  , aDtsDet[nI][04]                      ,Nil })
        If substr(ALLTRIM(aDtsDet[nI][02]),1,4) $ 'PA01'
            aTest := &( GETMV("BAG_POTEAL"))
        ELSE
            aTest  :=&( GETMV("BAG_POTEST"))
        END
        aadd(aItms,{"C6_TES"     , aTest[2]                                 ,Nil })
        aadd(aItms,{"C6_LOCAL"   , aDtsDet[nI][08]                      ,Nil })
        aadd(aItms,{"C6_QTDLIB"  , 0                                    ,Nil })
        aAdd(aDatos,aItms)
    Next nI
    Aadd(aDts,{aCab,aDatos})
Return aDts
Static Function GetFat(cClt,cTda,cSre,cNroFat,cCndPg,cFchFat,cMda,cNroAut,cFhaLmt,aItms,cEsp,cTes,cTpDoc,cCC,cCiudad,NITFACTURA,NOMBREFACTURA,cMetodoPago,cDocSector)
    Local aDtsFat   := {}
    Local aCab      := {}
    Local aItens    := {}
    Local aLinha    := {}
    Local nDim      := Len(aItms)
    Local nI        := 0
    AAdd( aCab, { "F2_CLIENTE"  , cClt          , Nil } )
    AAdd( aCab, { "F2_LOJA"     , cTda          , Nil } )
    AAdd( aCab, { "F2_SERIE"    , cSre          , Nil } )
    AAdd( aCab, { "F2_DOC"      , cNroFat       , Nil } )
    AAdd( aCab, { "F2_COND"     , cCndPg        , Nil } )
    AAdd( aCab, { "F2_EMISSAO"  , cFchFat       , Nil } )
    AAdd( aCab, { "F2_DTDIGIT"  , cFchFat       , Nil } )
    AAdd( aCab, { "F2_EST"      , "01"          , Nil } )
    AAdd( aCab, { "F2_TIPO"     , "N"           , Nil } )
    AAdd( aCab, { "F2_ESPECIE"  , cEsp          , Nil } )
    AAdd( aCab, { "F2_PREFIXO"  , ""            , Nil } )
    AAdd( aCab, { "F2_MOEDA"    , cMda          , Nil } )
    AAdd( aCab, { "F2_TXMOEDA"  , 1             , Nil } )
    AAdd( aCab, { "F2_FORMUL"   , "S"           , Nil } )
    AAdd( aCab, { "F2_TIPODOC"  , cTpDoc        , Nil } )
    //AAdd( aCab, { "F2_FRETE"    , 0             , Nil } )
    //AAdd( aCab, { "F2_DESPESA"  , 0             , Nil } )
    //AAdd( aCab, { "F2_SEGURO"   , 0             , Nil } )
    AAdd( aCab, { "F2_NUMAUT"   , cNroAut       , Nil } )
    AAdd( aCab, { "F2_CODDOC"   , cNroAut       , Nil } )
    AAdd( aCab, { "F2_LIMEMIS"  , cFhaLmt       , Nil } )
    aAdd(aCab,{"F2_UNIT"   , NITFACTURA          , Nil})
    aAdd(aCab,{"F2_UNOME"    , NOMBREFACTURA            , Nil})
    iF !EMPTY(ALLTRIM(cMetodoPago))
        aAdd(aCab,{"F2_MODCONS"    , cMetodoPago            , Nil})
    END
    iF !EMPTY(ALLTRIM(cDocSector))
        aAdd(aCab,{"F2_TPDOC"    , cDocSector            , Nil})
    END
    //aItms[01] -> ITEM
    //aItms[02] -> CODPRODUCTO
    //aItms[03] -> CANTIDAD
    //aItms[04] -> PRECIOUNITARIO
    //aItms[05] -> PRECIOLISTA
    //aItms[06] -> (PRECIOUNITARIO*CANTIDAD)
    //aItms[07] -> "501"
    //aItms[08] -> CODIGOALMACEN
    //aItms[09] -> CANTIDAD
    //aItms[10] -> UM
    //aItms[11] -> DESCUENTOPOR
    //aItms[12] -> DESCUENTOPOR
    For  nI := 1 To nDim
        aLinha :={}
        AAdd( aLinha, { "D2_ITEM"   , PADL(AllTrim(aItms[nI][1]),2,"0")                         , Nil } )
        AAdd( aLinha, { "D2_COD"    , aItms[nI][2]                                              , Nil } )
        AAdd( aLinha, { "D2_QUANT"  , Round(aItms[nI][3],2)                                     , Nil } )
        AAdd( aLinha, { "D2_PRCVEN" , Round(aItms[nI][4],4)                                     , Nil } )
        //AAdd( aLinha, { "D2_TOTAL"  , aItms[nI][6]												, Nil } )
        
        AAdd( aLinha, { "D2_TOTAL"  , Round(( Round(aItms[nI][3],2)* Round(aItms[nI][4],4)),2)  , Nil } )

        If substr(ALLTRIM(aItms[nI][2]  ),1,4) $ 'PA01'
            aTest := &( GETMV("BAG_POTEAL"))
        ELSE
            aTest  :=&( GETMV("BAG_POTEST"))
        END

        IF cEsp  $ 'NF'
            AAdd( aLinha, { "D2_TES"    , aTest [1]                                                     , Nil } )
        ELSE
            AAdd( aLinha, { "D2_TES"    , aTest [2]                                                     , Nil } )
        END
        
        AAdd( aLinha, { "D2_LOCAL"  , aItms[nI][8]                                              , Nil } )
        If ALLTRIM(aItms[nI][10]) $ 'PAQ'
            AAdd( aLinha, { "D2_UM"     , 'PQ'                                             , Nil } )
        ELSE
            AAdd( aLinha, { "D2_UM"     , aItms[nI][10]                                             , Nil } )
        END
        AAdd( aLinha, { "D2_PRUNIT" , Round(aItms[nI][4],4)                                     , Nil } )
        AAdd( aLinha, { "D2_DESC"   , aItms[nI][11]                                             , Nil } )
        //AAdd( aLinha, { "D2_DESC"   , aItms[nI][13]                                             , Nil } )
        AAdd( aLinha, { "D2_DESCON" , Round(aItms[nI][12],2)                                    , Nil } )
        AAdd( aLinha, { "D2_ESPECIE", cEsp                                                      , Nil } )
        If (substr(alltrim(aItms[nI][2]) ,1,4) $ 'PA01')
            AAdd( aLinha, { "D2_CLVL"   , "001"                                                     , Nil } )
        else
            AAdd( aLinha, { "D2_CLVL"   , "002"                                                     , Nil } )
        end
        AAdd( aLinha, { "D2_SERIE"  , cSre                                                      , Nil } )
        AAdd( aLinha, { "D2_CCUSTO"  , cCC                                                      , Nil } )
        AAdd( aLinha, { "D2_EC05DB"  , cCiudad                                                      , Nil } )
        AAdd( aItens, aLinha)
    Next nI
    Aadd(aDtsFat , {aCab,aItens} )
Return aDtsFat
Static Function GetRmt(cCodAlm)
    Local cSre      := ""
    Local cSql      := ""
    Local aArea     := GetArea()
    Local NextArea  := GetNextAlias()
    cSql            := cSql+ " select ZH_SERIREM "
    cSql            := cSql+ " from SZH300 SZH "
    cSql            := cSql+ " WHERE D_E_L_E_T_ = ' ' "
    cSql            := cSql+ " AND ZH_ALM = '" + cCodAlm + "'"
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    dbSelectArea(NextArea)
    dbGoTop()
    If (!Eof())
        cSre := ZH_SERIREM
    else
        cSre := "R"
    EndIf
    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
Return cSre
/*Static Function GetDsf(cSre,cFch,cXNroAuto)
    Local axDtsDsf  := {}
    Local cSql      := ""
    Local NextArea  := GetNextAlias()      
    Local aArea     := GetArea()
    cSql            := cSql + " Select FP_SERIE FP_DSF,FP_NUMAUT , FP_DTAVAL "
    cSql            := cSql + " From   SFP300 SFP "
    cSql            := cSql + " Where  SFP.D_E_L_E_T_  =  ' '                 And "
    cSql            := cSql +        " FP_NUMAUT       =  '" + cXNroAuto +"'  And "
    cSql            := cSql +        " FP_DTAVAL       >= '" + cFch      + "' And "
    cSql            := cSql +        " FP_ESPECIE      = '1' "
    cSql            := cSql +        " Order By FP_DTAVAL Asc "
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    dbSelectArea(NextArea)
    dbGoTop()
    If (!Eof())
        aAdd(axDtsDsf , FP_DSF    )
        aAdd(axDtsDsf , FP_NUMAUT )
        aAdd(axDtsDsf , FP_DTAVAL )
    EndIf
    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
Return axDtsDsf  */
Static Function GetDsfs(idVendedor)
	Local axDtsDsf	:= {}
	Local cSql		:= ""
	Local NextArea  := GetNextAlias()      
	Local aArea		:= GetArea()
	cSql			:= cSql + " Select FP_SERIE FP_DSF,FP_NUMAUT , FP_DTAVAL "
 	cSql			:= cSql + " From   SFP300 SFP "
 	cSql			:= cSql + " Where  SFP.D_E_L_E_T_  =  ' '  		     	  And "
	cSql			:= cSql + " FP_FILUSO ='"  + cfilant  +  "' AND " 	 
   	//cSql			:= cSql +	 	 " FP_NUMAUT	   =  '" + cXNroAuto +"'  And "
	cSql			:= cSql +	 	 " FP_UCODVEN       = '" + idVendedor 	 + "' And "
	cSql			:= cSql +	 	 " FP_ESPECIE 	   = '1' "
	cSql			:= cSql +	 	 " Order By FP_DTAVAL Asc "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
    While (!Eof())
		aAdd(axDtsDsf , FP_DSF)
        aAdd(axDtsDsf , FP_NUMAUT )
        aAdd(axDtsDsf , FP_DTAVAL )
		DBSKIP()
    End
    #IFDEF TOP
		dBCloseArea(NextArea)
    #ENDIF
	RestArea(aArea)
Return axDtsDsf              
Static Function GtNxtFat(cSerie,cTbla,nTamFN)
    Local   cXNroFct    := ""   
    Local   NextArea    := GetNextAlias()
    Local   cSql        := ""
    aArea               := GetArea()        
    cSql                := cSql + " Select X5_DESCSPA "
    cSql                := cSql + " From   SX5300 "
    cSql                := cSql + " Where  X5_TABELA = '" + cTbla  + "' And "
    cSql                := cSql +       "  X5_CHAVE  = '" + cSerie + "' And "
    cSql                := cSql +       "  SX5300.D_E_L_E_T_= ' '  "
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
    dbSelectArea(NextArea)
    dbGoTop()
    If ( !Eof() )
        cXNroFct        := PADL(AllTrim(X5_DESCSPA),nTamFN,"0")         
    EndIf
    #IFDEF TOP
        (NextArea)->(dBCloseArea(NextArea))
    #ENDIF
    RestArea(aArea)                 
Return cXNroFct      
Static Function NrFatVld (cxNroFat,cXSre,cXFilAgn)
    Local bSw   := .T.
    If ( EtFat(cxNroFat, cXSre,cXFilAgn)==.F.)  //Valida Que No Exita Una Factura Con Este Numero.
        bSw     := .F.
        MsgInfo("Ya Se Registro Una Factura Con Este Numero:(" + cxNroFat + ").Favor Actualizar La Dosificacion.Presupuesto No Efectivizado")
    EndIf
Return bSw 
Static Function EtFat(NROAUTORIZACION,cXFilVta )
    Local bSw       := .F.
    Local NextArea  := GetNextAlias()
    Local cSql      := ""
    aArea           := GetArea()
    If (AllTrim(NROAUTORIZACION) != "" )
        cSql        := cSql + " Select Distinct F2_DOC "
        cSql        := cSql + " From   SF2300 "
        cSql        := cSql + " Where  F2_CODDOC      = '" + NROAUTORIZACION   +"' And "        
        cSql        := cSql +        " F2_FILIAL  = '" + cXFilVta   +"' And "
        cSql        := cSql +        " F2_ESPECIE = 'NF' And "  
        cSql        := cSql +        " SF2300.D_E_L_E_T_ = ' ' "
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
        dbSelectArea(NextArea)
        dbGoTop()
        If ( !Eof() )
            bSw:= .T.
        EndIf
        #IFDEF TOP
            (NextArea)->(dBCloseArea(NextArea))
        #ENDIF
    EndIf
    RestArea(aArea)
Return bSw      
Static Function GetCC(_cXSeg,cTipo)
    Local cCC       := ""
    Local NextArea  := GetNextAlias()
    Local cSql      := ""
    aArea           := GetArea()
    If (AllTrim(cXSeg) != "" )
        cSql        := cSql + " Select Distinct ZG_CC,ZG_CODIGO "
        cSql        := cSql + " From   SZG300 "
        If alltrim(cTipo) $ 'D'
            cSql        := cSql + " Where  ZG_CODIGO     = '" + _cXSeg   +"' And "
        else
            cSql        := cSql + " Where  ZG_SEGDB     = '" + ALLTRIM(_cXSeg)   +"' And "
        end
        cSql        := cSql + " SZG300.D_E_L_E_T_ = ' ' "
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
        dbSelectArea(NextArea)
        dbGoTop()
        If ( !Eof() )
            cCC   := ZG_CC
            cXSeg := ZG_CODIGO
        EndIf
        #IFDEF TOP
            (NextArea)->(dBCloseArea(NextArea))
        #ENDIF
    EndIf
    RestArea(aArea)
Return cCC         
Static Function GtCCtrl(cNroFat,cNroNitCl,cFhcFat,nValFat,cXFilFat,cSerie)
    Local   cXCdCtrl    := ""
    Local   aRetCF      := {} 
    Local   aDatos      := {" "," ",0," ",0," "}    
    aDatos[1]           := cSerie                           // Nro Serie    
    aDatos[2]           := "NF"                             // Tipo Documento
    aDatos[3]           := AllTrim(Str(Val(cNroFat)))       // Nro Factura
    aDatos[4]           := cNroNitCl                        // Nro NIT
    aDatos[5]           := cFhcFat                          // Fecha
    aDatos[6]           := nValFat  
    aRetCF              := RetCF(aDatos,cXFilFat)
    If ( Len(aRetCF[2]) >= 2 )
        cXCdCtrl:=aRetCF[2]
    EndIf
Return cXCdCtrl                    
//Imprimir Datos De La Integracion
Static Function ImpDts(aDtsInt)
    Private cxUsrAgu    := USRFULLNAME(RETCODUSR())  
    Private bImprimir   := .F.                                  
    Private nNroPag     := 1
    Private nLin        := 300
    Private nFinHoja    := 3150  
    Private nCol        := 75
    Private nCol1       := 1300  
    Private nLin1       := 0080 
    Private nLin2       := 0140
    Private nLin3       := 0200      
    Private nLin4       := 0255
    MsgRun("Aguarde por favor .....", "Generando el Reporte...", ;
          { || ImpInt(aDtsInt) } )      
Return Nil  
Static Function ImpInt(aDts)
    Local   nDim        := Len(aDts)
    Local   nI          := 1                              
    oPrn                := TMSPrinter():New("INTEGRACION DUAL BIZ VS ERP PROTHEUS")
    Define FONT oFont1 NAME "Arial"           BOLD  SIZE 0,11 OF oPrn
    Define FONT oFont2 NAME "Times New Roman" BOLD  SIZE 0,11 OF oPrn
    Define FONT oFont3 NAME "Times New Roman"       SIZE 0,10 OF oPrn
    Define FONT oFont4 NAME "Times New Roman"       SIZE 0,08 OF oPrn  
    Define FONT oFont5 NAME "Times New Roman"       SIZE 0,09 OF oPrn  
    oPrn:Setup()
    oPrn:SetCurrentPrinterInUse()   
    oPrn:SetPortrait()          
    LogoGLA(nNroPag)
    For  nI := 1 To  nDim
               //cNroDual   , cNroFat     , cNmb        , cDpt        , cNroAuto    , cPdo        , cRmt        , cFatPro     , cCodCtr
        ImpMvto(aDts[nI][1] , aDts[nI][2] , aDts[nI][3] , aDts[nI][4] , aDts[nI][5] , aDts[nI][6] , aDts[nI][7] , aDts[nI][8] , aDts[nI][9]) 
    Next nI
        ImpUsu()
    oPrn:Refresh()
    If bImprimir
        oPrn:Print()
    Else
        oPrn:Preview()
    EndIf
    oPrn:End()
Return Nil
Static Function ImpMvto(cNroDual,cNroFat,cNmb,cDpt,cNroAuto,cPdo,cRmt,cFatPro,cCodCtr)
    NuevaLin()
    oPrn:Say(nLin,100   , AllTrim(Str(cNroDual))        , oFont3 )
    oPrn:Say(nLin,300   , AllTrim(Str(Val(cNroFat)))    , oFont3 )
    oPrn:Say(nLin,500   , cNmb                          , oFont5 )
    oPrn:Say(nLin,1100  , cDpt                          , oFont3 )
    oPrn:Say(nLin,1250  , cNroAuto                      , oFont5 )
    oPrn:Say(nLin,1550  , cPdo                          , oFont3 )
    oPrn:Say(nLin,1750  , AllTrim(Str(Val(cRmt)))       , oFont3 ) 
    oPrn:Say(nLin,1950  , AllTrim(Str(Val(cFatPro)))    , oFont3 ) 
    oPrn:Say(nLin,2150  , cCodCtr                       , oFont3 )      
Return Nil
Static Function ImpCbz()
    oPrn:Say(nLin,100   , "Nro.DUAL"                    , oFont2 )
    oPrn:Say(nLin,300   , "Nro.FAT"                     , oFont2 )
    oPrn:Say(nLin,500   , "Nombre"                      , oFont2 )
    oPrn:Say(nLin,1100  , "Local"                       , oFont2 )
    oPrn:Say(nLin,1250  , "Nro.AUTO"                    , oFont2 )
    oPrn:Say(nLin,1550  , "Pedido"                      , oFont2 )
    oPrn:Say(nLin,1750  , "Remito"                      , oFont2 ) 
    oPrn:Say(nLin,1950  , "Factura"                     , oFont2 ) 
    oPrn:Say(nLin,2150  , "Cod.Ctrl"                    , oFont2 ) 
Return Nil
Static Function NuevaLin()
    nLin:=nLin+50  
    If (nLin>=nFinHoja)
        oPrn:Line(nLin,nCol,nLin,2900)                                          
        oPrn:EndPage()
        oPrn:StartPage()
        nLin := 0300
        nNroPag:=nNroPag+1
        LogoGLA(nNroPag)
        nLin:=nLin+50  
    EndIf
Return Nil
Static Function LogoGLA(nNroPag)
    oPrn:Say(nLin1 , nCol1 - 650 , "INTEGRACION DUAL BIZ VS ERP PROTHEUS "                  , oFont1 )  
    oPrn:Say(nLin2 , nCol1 - 450 , "AGUAI S.A."                                             , oFont1 )
    oPrn:Say(nLin4 , nCol1 + 600 , "Pag:"+TRANSFORM(nNroPag,"@E 99999")                     , oFont1 )
    nLin:=nLin+50   
    ImpCbz()
    nLin:=nLin+50   
Return Nil                                               
Static Function ImpUsu()
    NuevaLin()
    oPrn:Say(nLin, nCol,Dtoc(Date()) + " - " + Time() + " - " + "Usuario Actual: " + cxUsrAgu , oFont4)
Return Nil
