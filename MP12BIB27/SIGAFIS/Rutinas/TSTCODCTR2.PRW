#Include "Protheus.Ch"
#INCLUDE "LOCXFUN.ch"

/*
???????????????????????????????????????
??rograma  ?stCodCtr ?utor  ?arcello Gabriel    ?echa ?17/02/2009  ??
???????????????????????????????????????
??esc.     ?ermite a entrada manual dos dados para geracao do codigo de??
??         ?ontrole para o sistema de faturacao computadorizada.       ??
??         ?sta rotina foi desenvolvida para validar a funcao de gera- ??
??         ?ao do codigo de controle perante o orgao fiscal boliviano. ??
??         16/07/2020  |Omar Delgadillo |Personalización.              ??
???????????????????????????????????????
??so       ?Bolivia                                                    ??
???????????????????????????????????????*/
User Function TSTCODCTR2()
    Local cCodCtr	:= ""
    Local cNrAut	:= ""
    Local cChvDos	:= ""
    Local cNIT		:= ""
    Local cFatura	:= ""
    Local dEmissao	:= Ctod("//")
    Local nValor	:= 0
    Local oDlg
    Local oPnlGet
    Local oPnlSepar
    // Local oPnlTop
    Local oPnlBase
    Local oPnlDir
    Local oPnlEsq
    Local oCodCtr,oPnlCtr
    Local oNrAut,oPnlRAut,oPnlAut,oPnlTAut
    Local oFatura,oPnlRFat,oPnlFat,oPnlTFat
    Local oNIT,oPnlRNIT,oPnlNIT,oPnlTNIT
    Local oEmissao,oPnlREmis,oPnlEmis,oPnlTEmis,oPnlAEmis
    Local oValor,oPnlRVlr,oPnlVlr,oPnlTVlr,oPnlAVlr
    Local oChvDos,oPnlRDos,oPnlDos,oPnlTDos
    Local oBtnOk
    Local oFonteB
    Local oFonte
    Local bCodCtr	:= {||  (oPnlRAut:cCaption := oNrAut:cText),;
                            (oPnlRFat:cCaption := oFatura:cText),;
                            (oPnlRNIT:cCaption := oNIT:cText),;            
                            (oPnlREmis:cCaption := Dtoc(oEmissao:cText)),;
                            (oPnlRVlr:cCaption := AllTrim(Transform	(oValor:cText,PesqPict("SF2","F2_VALBRUT")))),;
                            (oPnlRDos:cCaption := AllTrim(oChvDos:cText)),;
                            (cCodCtr  := GerCodCtr({"","",Alltrim(cFatura),AllTrim(cNIT),Dtos(dEmissao),nValor,AllTrim(cNrAut),Alltrim(cChvDos)})),;
                            (cNrAut   := cNrAut),;
                            (cChvDos  := cChvDos),;
                            (cNIT     := cNIT),;
                            (cFatura  := cFatura),;
                            (dEmissao := dEmissao),;
                            (nValor   := nValor),;
                            (oNrAut:SetFocus())}
                            /*(cNrAut   := Space(Len(SFP->FP_NUMAUT))),;
                            (cChvDos  := Space(Len(SFP->FP_CHAVE))),;
                            (cNIT     := Space(Len(SA1->A1_CGC))),;
                            (cFatura  := Space(Len(SF2->F2_DOC))),;
                            (dEmissao := Ctod("//")),;
                            (nValor   := 0),;*/
    oFonteB := TFont():New("Arial",16,,,.T.,,,,.T.,,,,,,,)
    oFonte   := TFont():New("Arial",,,,.T.,,,,.T.,,,,,,,)
    /* inicializacao das variaveis */
    cNrAut   := Space(Len(SFP->FP_NUMAUT))
    cChvDos  := Space(Len(SFP->FP_CHAVE))
    cNIT     := Space(Len(SA1->A1_CGC))
    cFatura  := Space(Len(SF2->F2_DOC))
    dEmissao := Ctod("//")
    nValor   := 0
    cCodCtr  := Space(Len(SF2->F2_CODCTR))
    oDlg:=TDialog():New(0,0,400,500,STR0142 + " - " + STR0143,,,,,,,,,.T.,,,,,)
        oDlg:lCentered := .T.
        oDlg:bInit := {|| oNrAut:SetFocus()}
        oPnlTopo := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,15,.F.,.F.)
            oPnlTopo:Align   := CONTROL_ALIGN_TOP
            oPnlTopo:nHeight := 5
        oPnlEsq := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,15,.F.,.F.)
            oPnlEsq:Align  := CONTROL_ALIGN_LEFT
            oPnlEsq:nWidth := 5
        oPnlDir := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),5,15,.F.,.F.)
            oPnlDir:Align  := CONTROL_ALIGN_RIGHT
            oPnlDir:nWidth := 5
        oPnlBase := TPanel():New(01,01,,oDlg,,,,,RGB(200,200,200),5,15,.F.,.F.)
            oPnlBase:Align   := CONTROL_ALIGN_BOTTOM
            oPnlBase:nHeight := 150
            // Codigo de controle
            oPnlCtr := TPanel():New(01,01,,oPnlBase,oFonteB,.T.,,CLR_RED,RGB(200,200,200),5,15,.F.,.F.)
                oPnlCtr:Align := CONTROL_ALIGN_TOP
                oPnlCtr:nHeight := 20
                oBtnOk := SButton():New(10,00,1,bCodCtr,oPnlCtr,.T.,,)
                    oBtnOk:Align := CONTROL_ALIGN_RIGHT
                @01,01 MsGet oCodCtr Var cCodCtr Size 005,05 Pixel Of oPnlCtr Font oFonteB NoBorder READONLY Color CLR_RED,RGB(200,200,200) CENTER
                    oCodCtr:bSetGet := {|u| if(PCount()>0,cCodCtr:=u,cCodCtr)}
                    oCodCtr:Align := CONTROL_ALIGN_ALLCLIENT
        oPnlSepar := TPanel():New(01,01,,oDlg,,,,,CLR_BLACK,5,15,.F.,.F.)
            oPnlSepar:Align   := CONTROL_ALIGN_BOTTOM
            oPnlSepar:nHeight := 3
        oPnlGet := TPanel():New(01,01,,oDlg,,,,,RGB(221,221,221),oDlg:nWidth,15,.F.,.F.)
            oPnlGet:Align   := CONTROL_ALIGN_ALLCLIENT
            //Numero de autorizacao
            oPnlRAut := TPanel():New(01,01,,oPnlBase,oFonte,,,,RGB(200,200,200),5,15,.F.,.F.)
                oPnlRAut:Align := CONTROL_ALIGN_TOP
                oPnlRAut:nHeight := 20
            oPnlAut := TPanel():New(01,01,,oPnlGet,,,,,RGB(221,221,221),5,15,.F.,.F.)
                oPnlAut:Align := CONTROL_ALIGN_TOP
                oPnlAut:nHeight := 35
                oPnlTAut := TPanel():New(01,01,RetTitle("FP_NUMAUT"),oPnlAut,,,,,RGB(221,221,221),50,15,.F.,.F.)
                    oPnlTAut:Align := CONTROL_ALIGN_TOP
                    oPnlTAut:nHeight := 15
                @01,01 MsGet oNrAut Var cNrAut Size 100,05 Pixel Of oPnlAut
                    oNrAut:bSetGet := {|u| if(PCount()>0,cNrAut:=u,cNrAut)}
                    oNrAut:Align := CONTROL_ALIGN_LEFT
                    oNrAut:nHeight := 20
            //Numero da fatura
            oPnlRFat := TPanel():New(01,01,,oPnlBase,oFonte,,,,RGB(200,200,200),5,15,.F.,.F.)
                oPnlRFat:Align := CONTROL_ALIGN_TOP
                oPnlRFat:nHeight := 20
            oPnlFat := TPanel():New(01,01,,oPnlGet,,,,,RGB(221,221,221),5,15,.F.,.F.)
                oPnlFat:Align := CONTROL_ALIGN_TOP
                oPnlFat:nHeight := 35
                oPnlTFat := TPanel():New(01,01,RetTitle("F2_DOC"),oPnlFat,,,,,RGB(221,221,221),50,15,.F.,.F.)
                    oPnlTFat:Align := CONTROL_ALIGN_TOP
                    oPnlTFat:nHeight := 15
                @01,01 MsGet oFatura Var cFatura Size 100,05 Pixel Of oPnlFat
                    oFatura:bSetGet := {|u| if(PCount()>0,cFatura:=u,cFatura)}
                    oFatura:Align := CONTROL_ALIGN_LEFT
                    oFatura:nHeight := 20
            //NIT 
            oPnlRNIT := TPanel():New(01,01,,oPnlBase,oFonte,,,,RGB(200,200,200),5,15,.F.,.F.)
                oPnlRNIT:Align := CONTROL_ALIGN_TOP
                oPnlRNIT:nHeight := 20
            oPnlNIT := TPanel():New(01,01,,oPnlGet,,,,,RGB(221,221,221),5,15,.F.,.F.)
                oPnlNIT:Align := CONTROL_ALIGN_TOP
                oPnlNIT:nHeight := 35
                oPnlTNIT := TPanel():New(01,01,RetTitle("A1_CGC"),oPnlNIT,,,,,RGB(221,221,221),50,15,.F.,.F.)
                    oPnlTNIT:Align := CONTROL_ALIGN_TOP
                    oPnlTNIT:nHeight := 15
                @01,01 MsGet oNIT Var cNIT Size 100,05 Pixel Of oPnlNIT Picture PesqPict("SA1","A1_CGC")
                    oNIT:bSetGet := {|u| if(PCount()>0,cNIT:=u,cNIT)}
                    oNIT:Align := CONTROL_ALIGN_LEFT
                    oNIT:nHeight := 20
            //Data da transacao
            oPnlREmis := TPanel():New(01,01,,oPnlBase,oFonte,,,,RGB(200,200,200),5,15,.F.,.F.)
                oPnlREmis:Align := CONTROL_ALIGN_TOP
                oPnlREmis:nHeight := 20
            oPnlEmis := TPanel():New(01,01,,oPnlGet,,,,,RGB(221,221,221),5,15,.F.,.F.)
                oPnlEmis:Align := CONTROL_ALIGN_TOP
                oPnlEmis:nHeight := 35
                oPnlTEmis := TPanel():New(01,01,RetTitle("F2_EMISSAO"),oPnlEmis,,,,,RGB(221,221,221),50,15,.F.,.F.)
                    oPnlTEmis:Align := CONTROL_ALIGN_TOP
                    oPnlTEmis:nHeight := 15
                oPnlAEmis := TPanel():New(01,01,,oPnlEmis,,,,,RGB(221,221,221),50,15,.F.,.F.)
                    oPnlAEmis:Align := CONTROL_ALIGN_TOP
                    oPnlAEmis:nHeight := 20
                @00,00 MsGet oEmissao Var dEmissao Size 80,8 Pixel Of oPnlAEmis
                    oEmissao:bSetGet := {|u| if(PCount()>0,dEmissao:=u,dEmissao)}
            //Valor da transacao 
            oPnlRVlr := TPanel():New(01,01,,oPnlBase,oFonte,,,,RGB(200,200,200),5,15,.F.,.F.)
                oPnlRVlr:Align := CONTROL_ALIGN_TOP
                oPnlRVlr:nHeight := 20
            oPnlVlr := TPanel():New(01,01,,oPnlGet,,,,,RGB(221,221,221),5,15,.F.,.F.)
                oPnlVlr:Align := CONTROL_ALIGN_TOP
                oPnlVlr:nHeight := 35
                oPnlTVlr := TPanel():New(01,01,RetTitle("F2_VALBRUT"),oPnlVlr,,,,,RGB(221,221,221),50,15,.F.,.F.)
                    oPnlTVlr:Align := CONTROL_ALIGN_TOP
                    oPnlTVlr:nHeight := 15
                oPnlAVlr := TPanel():New(01,01,,oPnlVlr,,,,,RGB(221,221,221),50,15,.F.,.F.)
                    oPnlAVlr:Align := CONTROL_ALIGN_TOP
                    oPnlAVlr:nHeight := 20
                @00,00 MsGet oValor Var nValor Size 80,8 Pixel Of oPnlAVlr Picture PesqPict("SF2","F2_VALBRUT")
                    oValor:bSetGet := {|u| if(PCount()>0,nValor:=u,nValor)}
            //Chave de doseficacao 
            oPnlRDos := TPanel():New(01,01,,oPnlBase,oFonte,,,,RGB(200,200,200),5,15,.F.,.F.)
                oPnlRDos:Align := CONTROL_ALIGN_TOP
                oPnlRDos:nHeight := 20
            oPnlDos := TPanel():New(01,01,,oPnlGet,,,,,RGB(221,221,221),5,15,.F.,.F.)
                oPnlDos:Align := CONTROL_ALIGN_TOP
                oPnlDos:nHeight := 40
                oPnlTDos := TPanel():New(01,01,RetTitle("FP_CHAVE"),oPnlDos,,,,,RGB(221,221,221),50,15,.F.,.F.)
                    oPnlTDos:Align := CONTROL_ALIGN_TOP
                    oPnlTDos:nHeight := 15
                @01,01 MsGet oChvDos Var cChvDos Size 100,05 Pixel Of oPnlDos
                    oChvDos:bSetGet := {|u| if(PCount()>0,cChvDos:=u,cChvDos)}
                    oChvDos:Align := CONTROL_ALIGN_TOP
                    oChvDos:nHeight := 20
    oDlg:Activate()
Return(cCodCtr)

/*/
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?erCodCtr  ?Autor ?Sergio S. Fuzinaka   | Data ?11.07.07 ??
???????????????????????????????????????
??escricao ?era o Codigo de Controle Automatico                        ??
??         ?                                                           ??
???????????????????????????????????????
??intaxe   ?etCodCtr( ExpA2 )                                          ??
???????????????????????????????????????
??arametros?xpA2[1] = Serie                							  ??
??         ?xpA2[2] = Especie              							  ??
??         ?xpA2[3] = Nota Fiscal                                      ??
??         ?xpA2[4] = NIT/CI (CNPJ/RG)                                 ??
??         ?xpA2[5] = Data de Emissao                                  ??
??         ?xpA2[6] = Valor Bruto                                      ??
??         ?xpA2[7] = Numero de Autorizacao                            ??
??         ?xpA2[8] = Llave(Chave) Dosificacion                        ??
??         ?                               							  ??
???????????????????????????????????????
??etorno   ?xpC1 = Codigo de Controle                                  ??
??         ?                                                           ??
???????????????????????????????????????
??so       ?ENERICO                                                    ??
???????????????????????????????????????
/*/
Static Function GerCodCtr( aDados )
    Local aDigito	:= array(5)
    Local aDigP2	:= array(5)
    Local aSP		:= {0,0,0,0,0}
    Local cNumAut	:= Alltrim(aDados[7]) // Numero de autorizacao
    Local cNFiscal	:= ""
    Local cNFisAux	:= Alltrim(aDados[3]) // Nota Fiscal
    Local cNIT		:= IIF(!Empty(Alltrim(aDados[4])),Alltrim(aDados[4]),"0") // NIT/CI (CNPJ/RG)
    Local cDtLim	:= Alltrim(aDados[5]) // Data de Emissao   
    Local cValBrut	:= Alltrim(str(Round(aDados[6],0))) // Valor Bruto 
    Local cLlave	:= Alltrim(aDados[8])
    Local cMontoAux	:= ""
    Local cNumAut1	:= ""
    Local cNFiscal1	:= ""
    Local cNITCI	:= ""
    Local cFecha	:= ""
    Local cMonto	:= ""
    Local cMonto1	:= ""
    Local cCadConc	:= ""
    Local cCodCtr1	:= ""
    Local cCodCtr	:= ""
    Local cBase64	:= ""
    Local cDigito   := ""
    Local nST		:= 0
    Local nST1		:= 0
    Local nST2		:= 0
    Local nST3		:= 0
    Local nST4		:= 0
    Local nST5		:= 0
    Local n			:= 0
    Local i			:= 0

    cNFiscal := AllTrim(Str(Val(cNFisAux)))
    // Passo 1
    // Gerar dois digitos verificadores (NF, NIT/CI, Dt Emissao, Valor Total NF)
    For n := 1 to 2
        cNFiscal  := (cNFiscal)+( Verhoeff(cNFiscal))	// Nota Fiscal
        cNIT  := (cNIT)+( Verhoeff(cNIT))	// NIT / CI	
        cDtLim  := (cDtLim)+( Verhoeff(cDtLim))	// Dt Emissao
        cValBrut  := (cValBrut)+( Verhoeff(cValBrut))	// Valor Total NF
    Next
    cMontoAux :=Alltrim(str(Val(cNFiscal)+Val(cNIT)+Val(cDtLim)+Val(cValBrut)))// Somatoria das informacoes ja com os digitos
    //Gerar cinco digitos verificadores da somatoria 
    For n := 1 to 5
        cMonto := ( Verhoeff (cMontoAux))
        aDigito[n] := cMonto
        cMontoAux  := cMontoAux+cMonto
        aDigP2[n] := Alltrim(str(Val(aDigito[n])+1)) // Utilizado no passo 2
    Next
    cDigito := aDigito[1]+aDigito[2]+aDigito[3]+aDigito[4]+aDigito[5]
    // Passo 2 
    // Separacao da Chave de Dosificacion para cada informacao
    cNumAut1 := (substr(cLlave,1,Val(aDigP2[1])))
    cNFiscal1:= (substr(cLlave,Val(aDigP2[1])+1,Val(aDigP2[2])))
    cNITCI	 := (substr(cLlave,Val(aDigP2[1])+1+Val(aDigP2[2]),Val(aDigP2[3])))
    cFecha   := (substr(cLlave,Val(aDigP2[1])+1+Val(aDigP2[2])+Val(aDigP2[3]),Val(aDigP2[4])))
    cMonto1	 := (substr(cLlave,Val(aDigP2[1])+1+Val(aDigP2[2])+Val(aDigP2[3])+Val(aDigP2[4]),Val(aDigP2[5])))
    // Passo 3
    // Chave Concatenada 
    cCadConc := cNumAut+cNumAut1+cNFiscal+cNFiscal1+cNIT+cNITCI+cDtLim+cFecha+cValBrut+cMonto1
    // Criptografia simetrica - Alleged RC4
    cCodCtr1 := STRTRAN(ARC4(cCadConc,cLlave+cDigito),"-", "")
    // Passo 4
    // Somar cada digito da chave concatenada em ASCII
    For n := 1 to (len(cCodCtr1))
        nST += Asc(substr(cCodCtr1,n,1))
    Next
    // Somar cada digito da chave concatenada em ASCII de cinco em cinco.
    // aSP[1] - Primeira parcial partindo do primeiro digito
    // aSP[2] - Segunda parcial partindo do Segundo digito
    // aSP[3] - Terceira parcial partindo do Terceiro digito
    // aSP[4] - Quarta parcial partindo do Quarto digito
    // aSP[5] - Quinta parcial partindo do Quinto digito
    For i := 1 to 5
        For n := i to (len(cCodCtr1)) step 5
            aSP[i] +=  Asc(substr(cCodCtr1,n,1))
        Next
    Next
    // Passo 5 
    // Multiplicar a somatoria do passo 4 nST com cada somatoria parcial aSP[n] e dividir pelo digito verificador
    // do total do passo 1 
    nST1 := NoRound(nST*aSP[1]/Val(aDigP2[1]),0)
    nST2 := NoRound(nST*aSP[2]/Val(aDigP2[2]),0)
    nST3 := NoRound(nST*aSP[3]/Val(aDigP2[3]),0)
    nST4 := NoRound(nST*aSP[4]/Val(aDigP2[4]),0)
    nST5 := NoRound(nST*aSP[5]/Val(aDigP2[5]),0)
    // Gerar a base 64
    cBase64	:= NToB64(nST1+nST2+nST3+nST4+nST5)
    //Passo 6
    // Gerar o codigo de controle
    cCodCtr := ARC4(cBase64,cLlave+cDigito)
Return(cCodCtr)
