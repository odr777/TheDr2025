#Include "RwMake.ch"
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  PickGraf  ºAutor  ³Mauricio Salazar      º
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion de Pick-List Grafico                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PickGraf(aPRs)

Private cPerg	:= "NOPED"

 ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO		 
 
 GraContPert()
   
 If funname() == 'MATA410'
	Pergunte(cPerg,.F.)   
 Else
	Pergunte(cPerg,.T.)         
 Endif

If aPRs == Nil
	If Pergunte(cPerg,.t.)
		Processa({|| fImpPres(aPRs)},"Impressão (1) de aPRs ","Imprimindo aPRs...")
	Else
		Return
	Endif
Else
	Processa({|| fImpPres(aPRs)},"Impressão (2) de aPRs ","Imprimindo aPRs...")
Endif

Return
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function fImpPres(aPRs)

Local lPrint	:= .f.
Local nVias		:= 1
Local nLin		:= 00.0
Local cQuery   
Local consulta 
Local nTotal    := 00.0      
Local nDesc    := 00.0
Local nRecargo := 00.0
Local aDtHr		:= {}
Local _aEtiq :={}
Private nPag	:= 1
Private Bruto := SC5->C5_PBRUTO
Private Lote := SC6->C6_LOTECTL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as fontes a serem utilizadas na impressao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFont10T  := TFont():New("Times New Roman",10,10,,.f.)
oFont12T  := TFont():New("Times New Roman",12,12,,.f.)
oFont14T  := TFont():New("Times New Roman",14,14,,.f.)
oFont16T  := TFont():New("Times New Roman",16,16,,.f.)
oFont18T  := TFont():New("Times New Roman",18,18,,.f.)

oFont10TN  := TFont():New("Times New Roman",10,10,,.t.)
oFont12TN  := TFont():New("Times New Roman",12,12,,.t.)
oFont14TN  := TFont():New("Times New Roman",14,14,,.t.)
oFont16TN  := TFont():New("Times New Roman",16,16,,.t.)
oFont18TN  := TFont():New("Times New Roman",18,18,,.t.)

oFont10C  := TFont():New("Courier New",09,09,,.f.)
oFont12C  := TFont():New("Courier New",12,12,,.f.)
oFont14C  := TFont():New("Courier New",14,14,,.f.)
oFont16C  := TFont():New("Courier New",16,16,,.f.)
oFont18C  := TFont():New("Courier New",18,18,,.f.)

oFont09CN  := TFont():New("Courier New",09,09,,.t.)
oFont10CN  := TFont():New("Courier New",10,10,,.t.)
oFont12CN  := TFont():New("Courier New",12,12,,.t.)
oFont14CN  := TFont():New("Courier New",14,14,,.t.)
oFont16CN  := TFont():New("Courier New",16,16,,.t.)
oFont18CN  := TFont():New("Courier New",18,18,,.t.,,,,,.t.)
oFont20CN  := TFont():New("Courier New",20,20,,.t.)
oFont22CN  := TFont():New("Courier New",22,22,,.t.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia o uso da classe ...                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:= TMSPrinter():New("Proforma")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define pagina no formato paisagem ...        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrn:SetPortrait()

oPrn:Setup()       
                                                         
cQuery := "SELECT DISTINCT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_FECENT,C5_CONDPAG,C5_DESC1,C5_UNOMCLI,C5_UNITCLI,C5_ULUGENT,"
cQuery += "C5_UTPOENT,C5_UNUCOCL,C5_PBRUTO,C5_TRANSP,C5_COTACAO,C5_UOBSERV,C5_USRREG,A3_NOME,"
cQuery += "C6_ENTREG,C6_ITEM,B1_UCODFAB,C6_PRODUTO,C6_LOCAL,NNR_DESCRI,NNR_UDIREC, B1_UESPEC2, C6_UM, C6_QTDVEN,C6_PRCVEN,C6_VALOR, C6_LOTECTL, C6_CODFAB, "
cQuery += "A1_NOME,A1_CGC,A1_END,C6_DESCRI,C6_UESPECI ,C5_TXMOEDA,C5_MOEDA,E4_DESCRI,A1_COD,A1_LOJA,C5_VEND1,B1_DESC, B1_UMARCA, B1_UCODFAB " 
cQuery += " ,(SELECT (DSCTO/TOTAL) * 100.00 PDESC FROM (SELECT SUM(C6_VALOR) + SUM(C6_VALDESC) TOTAL, SUM(C6_VALDESC) DSCTO FROM "+RetSqlName("SC6")+" SC61 "
cQuery += " WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) C5_PDESC "
cQuery += "FROM " + RetSqlName("SC5") + " SC5 "     
cQuery += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON C5_NUM=C6_NUM AND C5_FILIAL=C6_FILIAL  "   
cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD=C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_<>'*' "  
cQuery += "LEFT JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD=C5_VEND1 " 
cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD=C6_PRODUTO "   
cQuery += "INNER JOIN " + RetSqlName("SE4") + " SE4 ON E4_CODIGO=C5_CONDPAG "
cQuery += "INNER JOIN " + RetSqlName("NNR") + " NNR ON NNR_CODIGO=C6_LOCAL " 
cQuery += " WHERE C5_FILIAL BETWEEN '"+trim(XFILIAL("SC5"))+"' AND '"+trim(XFILIAL("SC5"))+"'"
cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
cQuery += " AND C5_NUM BETWEEN '"+trim(mv_par05)+"' AND '"+trim(mv_par06)+"'"
cQuery += " AND SC5.D_E_L_E_T_=' ' AND SC6.D_E_L_E_T_=' ' AND E4_FILIAL='"+ xfilial('SE4') +"' "
cQuery += " AND SB1.D_E_L_E_T_=' ' AND SA3.D_E_L_E_T_=' '" 


//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aviso("",cQuery,{'ok'},,,,,.t.)
				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³ Caso area de trabalho estiver aberta, fecha... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
If !Empty(Select("TRB"))
	dbSelectArea("TRB")
	dbCloseArea()
Endif
				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³ Executa query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
TcQuery cQuery New Alias "TRB"
dbSelectArea("TRB")
dbGoTop()
				
    nLindet := 06.1             				
	nPag := 1
	cNroProforma:=""
	nMoneda:=0
	dfecha:=""
	While !EOF()    
		nMoneda:=C5_MOEDA
		dfecha:= C5_EMISSAO
	If nPag == 1 .and. C5_NUM <> cNroProforma .and.cNroProforma==""
		cNroProforma :=C5_NUM      
		oPrn:StartPage() 
	elseif C5_NUM <> cNroProforma  
		cNroProforma :=C5_NUM
		      
		nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha)         
		nPag++	
		oPrn:EndPage()
		oPrn:StartPage()   
		nLin := 01.0
	    nLin := fImpCabec(nLin)
		oPrn:Say( Tpix(26.0), Tpix(18.0), "Página : "+Transform(nPag,"999"), oFont10C)
		nLindet := 06.1   
		nTotal    := 00.0      
		nDesc    := 00.0
		nRecargo := 00.0							
	end	

   	IF nLindet == 06.1 .AND. nPag == 1
      nLin := 01.0
	  nLin := fImpCabec(nLin)
	ENDIF       
	nLindetcab := 06.1
	nLindetcab := fImpItemCab(nLindetcab) 
  //	YA_DESCR
    nLinha := MlCount(B1_DESC,40)   
    
    nLinha2 := " "//MlCount(_cProcedencia,20) 
	 nLindet := fImpItem(nLindet)
	 
    nTotal:=nTotal+C6_VALOR 
     
	//oPrn:Say( Tpix(25.4), Tpix(01.0),PADC("Contacto: " + AllTrim(CJ_USRREG) + "   |   E-Mail: " + UsrRetMail(cCodUser(CJ_USRREG)),115), oFont10C)
 	oPrn:Say( Tpix(25.5), Tpix(01.0), "_______________________________________________________________________________________________________________"	, oFont12C) 
    oPrn:Say( Tpix(26.0), Tpix(01.0), PADC("Av.Viedma No 51 Z/Cementerio General - Telfs: 3 3326174 / 3 3331447 / 3 3364244 - Fax: 3 3368672",100), oFont10C)
    oPrn:Say( Tpix(26.0), Tpix(18.0), "Página : "+Transform(nPag,"999"), oFont10C)
    //oPrn:Line( Tpix(nLin),Tpix(01.5) ,Tpix(nLin),Tpix(01.5))
	If nLindet > 22   
		nPag+=1
		oPrn:EndPage()
		oPrn:StartPage()   
		nLin := 01.0
	    nLin := fImpCabec(nLin)
		oPrn:Say( Tpix(26.0), Tpix(18.0), "Página : "+Transform(nPag,"999"), oFont10C)
		nLindet := 06.1 							
	Endif
	dbSkip()

    //oPrn:EndPage()
End 
	//oPrn:Say( Tpix(nLindet+2.8), Tpix(01.0), "NOTA.- AL MOMENTO DE HACER SU COMPRA POR FAVOR EXIGIR SU FACTURA", oFont10C)
     
    oPrn:Say( Tpix(nLindet+1.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
    nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha)                                    
    //oPrn:Say( Tpix(26.0), Tpix(02.0),"query : " + consulta, oFont12C)



oPrn:EndPage()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se visualiza ou imprime ...         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lPrint
	
	While lPrint
		nDef := Aviso("Impressão de Pick-List", "Confirma Impressão da Pick-List?", {"Preview","Setup","Cancela","Ok"},,)
		If nDef == 1
			oPrn:Preview()
		ElseIf nDef == 2
			oPrn:Setup()
		ElseIf nDef == 3
			Return
		ElseIf nDef == 4
			lPrint := .f.
		EndIf
	End
	oPrn:Print()
Else
	oPrn:Preview()
EndIf

TRB->(dbCloseArea())


RETURN  


Static Function fImpItemCab(nLin)
         
// ARTICULO	NOMBRE	PROCEDENCIA	UNIDAD	CANTIDAD	PRECIO	MONTO
                                                                                       
	oPrn:Say( Tpix(nLin+00.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "IT", oFont10C)   
	
	 	                      
	oPrn:Say( Tpix(nLin+00.5), Tpix(02.5), "CODIGO", oFont10C)
	oPrn:Say( Tpix(nLin+00.7), Tpix(02.6), "ML", oFont10C)
	
	oPrn:Say( Tpix(nLin+00.5), Tpix(04.4), "CODIGO", oFont10C)
	oPrn:Say( Tpix(nLin+00.7), Tpix(04.2), "PROVEEDOR", oFont10C)
	
	oPrn:Say( Tpix(nLin+00.5), Tpix(06.2), "DESCRIPCION", oFont10C)

	oPrn:Say( Tpix(nLin+00.5), Tpix(15.4), "MARCA", oFont10C)
	
	oPrn:Say( Tpix(nLin+00.5), Tpix(17.6), "UNID.", oFont10C)
	
	oPrn:Say( Tpix(nLin+00.5), Tpix(18.8), "CANTIDAD", oFont10C)
	oPrn:Say( Tpix(nLin+00.9), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
			
	//oPrn:Say( Tpix(nLin+00.5), Tpix(20.0), "PRECIO", oFont10C)
	 oPrn:Line( Tpix(06.5),Tpix(1.0) ,Tpix(nLindet+2.5),Tpix(1.0))
 	  oPrn:Line( Tpix(06.5),Tpix(01.5) ,Tpix(nLindet+2.5),Tpix(01.5))
 	  oPrn:Line( Tpix(06.5),Tpix(04.0) ,Tpix(nLindet+2.5),Tpix(04.0))
 	  oPrn:Line( Tpix(06.5),Tpix(06.0) ,Tpix(nLindet+2.5),Tpix(06.0))
 	  oPrn:Line( Tpix(06.5),Tpix(15.0) ,Tpix(nLindet+2.5),Tpix(15.0))
 	  oPrn:Line( Tpix(06.5),Tpix(17.0) ,Tpix(nLindet+2.5),Tpix(17.0))
 	  oPrn:Line( Tpix(06.5),Tpix(18.5) ,Tpix(nLindet+2.5),Tpix(18.5))
	//oPrn:Say( Tpix(nLin+00.9), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
			
Return(nLin+03.0)

Static Function fImpItem(nLin)
	
	
//         oPrn:Say( Tpix(nLin+01.5), Tpix(05.2), Right(C6_DESCRI,10), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), C6_ITEM, oFont10C)                                                  
	oPrn:Say( Tpix(nLin+01.5), Tpix(02.2), C6_PRODUTO, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(4.2), B1_UCODFAB, oFont10C)
	oPrn:Say(Tpix(nLin+01.5), Tpix(15.4), B1_UMARCA)
	oPrn:Say( Tpix(nLin+01.5), Tpix(17.6), C6_UM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(19.2), cValToChar(C6_QTDVEN), oFont10C)
	//oPrn:Say( Tpix(nLin+01.5), Tpix(20.0), cValToChar(C6_PRCVEN), oFont10C)
	If !empty(Lote)
		If Len(AllTrim(C6_UESPECI)) > 50
		oPrn:Say( Tpix(nLin+01.5), Tpix(06.2), C6_UESPECI, oFont10C)
		oPrn:Say(Tpix(nLin+01.8), Tpix(06.2), B1_UESPEC2, oFont10C)
		nLin:= nLin+00.5
		oPrn:Say(Tpix(nLin+01.8), Tpix(06.2), C6_LOTECTL)
		//oPrn:Say( Tpix(nLin+02.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)	
			nLin:= nLin+00.5
		Else		
			oPrn:Say( Tpix(nLin+01.5), Tpix(06.2), C6_UESPECI, oFont10C)
			oPrn:Say(Tpix(nLin+01.8), Tpix(06.2), B1_UESPEC2, oFont10C)
			nLin:= nLin+00.5
			oPrn:Say(Tpix(nLin+01.8), Tpix(06.2), C6_LOTECTL, oFont10C)
			//oPrn:Say( Tpix(nLin+02.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
			
			nLin:= nLin+00.5
		EndIf
	Else
		If Len(AllTrim(C6_UESPECI)) > 50
			oPrn:Say( Tpix(nLin+01.5), Tpix(06.2), C6_UESPECI, oFont10C)
			oPrn:Say( Tpix(nLin+01.8), Tpix(06.2), B1_UESPEC2, oFont10C)
			//oPrn:Say( Tpix(nLin+02.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)	
			nLin:= nLin+00.5
		Else		
			oPrn:Say( Tpix(nLin+01.5), Tpix(06.2), C6_UESPECI, oFont10C)
			oPrn:Say(Tpix(nLin+01.8), Tpix(06.2), B1_UESPEC2, oFont10C)
			//oPrn:Say( Tpix(nLin+02.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
				
			nLin:= nLin+00.5
		EndIf
	EndIf
	
		

	nLin:= nLin+00.3	

Return(nLin)     

Static Function TPix(nTam,cBorder,cTipo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desconta area nao imprimivel (Lexmark Optra T) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cBorder == "lb"			// Left Border
	nTam := nTam - 0.40
ElseIf cBorder == "tb" 		// Top Border
	nTam := nTam - 0.60
EndIf

nPix := nTam * 120

Return(nPix)     


Static Function fImpCabec(nLin)

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecera ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ      
local diasfin :=0
local diasini :=0  
local direccion:=""
local tel:=""

//diasfin:=DateDiffDay(CTOD(CJ_VALIDA),CTOD(CJ_EMISSAO))  //substr(CJ_VALIDA,8,2)

If SM0->(Eof())                                
	SM0->( MsSeek( cEmpAnt + C5_FILIAL , .T. ))
Endif
tel:= SM0->M0_TEL 
direccion:=SM0->M0_ENDENT    
//cFLogo := GetSrvProfString("Startpath","") + "logo1.bmp"
//oPrn:Say(Tpix(nLin+00.1),Tpix(01.0), "MERCANTIL LEON",,730,150)       
oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "MERCANTIL LEON SRL", oFont14CN)
oPrn:Say( Tpix(nLin+00.9), Tpix(08.0), "Pick List", oFont18CN)  
    
oPrn:Say( Tpix(nLin+01.8), Tpix(01.0), "Sucursal: "+ SM0->M0_FILIAL, oFont10CN) // CJ_EMISSAO  
oPrn:Say( Tpix(nLin+01.8), Tpix(12.0), "Pedido de Venta: "+C5_NUM, oFont10CN)

nLargo := 40
	cNombre := ALLTRIM(A1_NOME)
	nLen := LEN(ALLTRIM(cNombre))
If nLen>nLargo
cNombre1 := AllTrim(TextoCompleto(cNombre,nLargo))
oPrn:Say( Tpix(nLin+02.2), Tpix(01.0), "Cliente: "+ A1_COD +'/'+ A1_LOJA +' - '+ cNombre1, oFont10CN)
oPrn:Say( Tpix(nLin+02.6), Tpix(01.0), ALLTRIM(Substr(cNombre, Len(cNombre1)+1, nLen)),oFont10CN)
oPrn:Say( Tpix(nLin+02.2), Tpix(12.0), "Fecha: "+ ffechalarga(C5_EMISSAO), oFont10CN) // CJ_EMISSAO

nLin:= nLin+00.4
Else
oPrn:Say( Tpix(nLin+02.2), Tpix(01.0), "Cliente: "+ A1_COD +'/'+ A1_LOJA +' - '+ ALLTRIM(A1_NOME), oFont10CN)
oPrn:Say( Tpix(nLin+02.2), Tpix(12.0), "Fecha: "+ ffechalarga(C5_EMISSAO), oFont10CN) // CJ_EMISSAO

EndIf



oPrn:Say( Tpix(nLin+02.6), Tpix(01.0), "Vendedor: " + LTRIM(GetAdvFval('SA3',"A3_NOME",xFilial('SA3') + C5_VEND1 ,1,"" )) 			, oFont10CN)
oPrn:Say( Tpix(nLin+02.6), Tpix(12.0), "Deposito de Entrega: " + C6_LOCAL + " - " + alltrim(NNR_DESCRI), oFont10CN)

//oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Telefono: "+A1_TEL, oFont10CN)
oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Lugar de Entrega: " +  ALLTRIM(C5_ULUGENT), oFont09CN)
oPrn:Say( Tpix(nLin+03.0), Tpix(12.0), "Impresión: "+ dtoc(ddatabase) +' '+ TIME(), oFont10CN)

oPrn:Say( Tpix(nLin+03.4), Tpix(01.0), "Observación: " + alltrim(C5_UOBSERV), oFont09CN)
If !empty(Bruto)
oPrn:Say(Tpix(nLin+03.4), Tpix(12.0), "Peso Bruto: " + alltrim(C5_PBRUTO), oFont09CN)						 			
EndIf						 			
//oPrn:Say( Tpix(nLin+03.4), Tpix(01.0), "Forma de Pago: " + alltrim(E4_DESCRI), oFont10CN)
//
//
//oPrn:Say( Tpix(nLin+03.8), Tpix(14.0), "PM: " +  IF(C5_DESC1<>0,TRANSFORM(C5_DESC1,"@A 99.99"),TRANSFORM(C5_PDESC,"@A 99.99")) + "%"	, oFont10CN)
//
//oPrn:Say( Tpix(nLin+04.2), Tpix(01.0), "Dir.Deposito: " +  ALLTRIM(NNR_UDIREC), oFont10CN)


Return(nLin+05.4)      


Static Function fImpTotales(nLin,total,desc,recargo,nMoneda,dfecha)

//oPrn:Say( Tpix(nLin+01.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)

//oPrn:Say( Tpix(nLin+01.5), Tpix(15.6), "TOTAL  Bs.:" +  Transform(round(xmoeda(total+recargo,nMoneda,1,stod(dfecha),4),2),"@A 999,999,999.99")												, oFont10C)
//oPrn:Say( Tpix(nLin+02.0), Tpix(15.6), "TOTAL $us.:" +  Transform(round(xmoeda(total+recargo,nMoneda,2,stod(dfecha),4),2),"@A 999,999,999.99")												, oFont10C)
oPrn:Say( Tpix(nLin+02.0), Tpix(03.0), "Resp. Almacen"															, oFont10C)
//oPrn:Say( Tpix(nLin+05.0), Tpix(07.0), "Vendedor Externo"															, oFont10C)
//oPrn:Say( Tpix(nLin+05.0), Tpix(8.5), "VoBo"															, oFont10C)
oPrn:Say( Tpix(nLin+02.0), Tpix(13.0), "Recibi Conforme"															, oFont10C)
oPrn:Say( Tpix(nLin+01.5), Tpix(03.0), "_____________"															, oFont10C)
//oPrn:Say( Tpix(nLin+04.5), Tpix(07.0), "________________"															, oFont10C)
//oPrn:Say( Tpix(nLin+04.5), Tpix(8.0), "_____________"															, oFont10C)
oPrn:Say( Tpix(nLin+01.5), Tpix(13.0), "_____________"															, oFont10C)
//  oPrn:Line( Tpix(06.5),Tpix(1.0) ,Tpix(nLin+0.9),Tpix(1.0))
//  oPrn:Line( Tpix(06.5),Tpix(01.5) ,Tpix(nLin+0.9),Tpix(01.5))
//  oPrn:Line( Tpix(06.5),Tpix(04.0) ,Tpix(nLin+0.9),Tpix(04.0))
//  oPrn:Line( Tpix(06.5),Tpix(07.0) ,Tpix(nLin+0.9),Tpix(07.0))
//  oPrn:Line( Tpix(06.5),Tpix(14.0) ,Tpix(nLin+0.9),Tpix(14.0))
//  oPrn:Line( Tpix(06.5),Tpix(16.0) ,Tpix(nLin+0.9),Tpix(16.0))
//  oPrn:Line( Tpix(06.5),Tpix(17.5) ,Tpix(nLin+0.9),Tpix(17.5))
   //oPrn:Line( Tpix(06.5),Tpix(19.0) ,Tpix(nLin+0.9),Tpix(19.0))
Return(nLin+06.0)







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ValidPerg ºAutor  ³ Walter Alvarez ³  04/11/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)


aAdd(aRegs,{"01","De Fecha de Emisión     :","mv_ch1","D",08,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"02","A Fecha de Emisión      :","mv_ch2","D",08,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"03","De Cliente              :","mv_ch3","C",6,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,"SA1",""})
aAdd(aRegs,{"04","A Cliente               :","mv_ch4","C",6,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,"SA1",""})
aAdd(aRegs,{"05","De Presupuesto          :","mv_ch5","C",6,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"SCJ",""})
aAdd(aRegs,{"06","A Presupuesto           :","mv_ch6","C",6,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"SCJ",""})

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

Return

Static Function ffechalarga(sfechacorta)
     
//20101105

Local sFechalarga:=""             
Local descmes := ""
Local sdia:=substr(sfechacorta,7,2)
Local smes:=substr(sfechacorta,5,2)
Local sano:=substr(sfechacorta,0,4)

if smes=="01"     
  descmes :="Enero"  
endif
if smes=="02"     
  descmes :="Febrero"  
endif
if smes=="03"     
  descmes :="Marzo"  
endif
if smes=="04"     
  descmes :="Abril"  
endif
if smes=="05"     
  descmes :="Mayo"  
endif
if smes=="06"     
  descmes :="Junio"  
endif
if smes=="07"     
  descmes :="Julio"  
endif
if smes=="08"     
  descmes :="Agosto"  
endif
if smes=="09"     
  descmes :="Septiembre"  
endif
if smes=="10"     
  descmes :="Octubre"  
endif
if smes=="11"     
  descmes :="Noviembre"  
endif
if smes=="12"     
  descmes :="Diciembre"  
endif      

sFechalarga := sdia + " de " + descmes + " de " + sano

Return(sFechalarga)      

Static Function diferencia(sfechafin,sfechaini)
     
//20101105

Local diasdia:=0 
Local diasmes:=0
Local diasano:=0            
Local sdiafin:=val(substr(sfechafin,7,2))
Local smesfin:=val(substr(sfechafin,5,2))
Local sanofin:=val(substr(sfechafin,0,4))  

Local sdiaini:=val(substr(sfechaini,7,2))
Local smesini:=val(substr(sfechaini,5,2))
Local sanoini:=val(substr(sfechaini,0,4))    

if sdiafin>=sdiaini
  diasdia:=sdiafin-sdiaini
else
  diasdia := (30+sdiafin)-sdiaini 
  smesfin:=smesfin-1
endif         

if smesfin<smesini
   diasmes:=((smesfin+12)-smesini)*30
else
   diasmes := (smesfin-smesini)*30
endif 

diferencia:=diasdia + diasmes   

Return(diferencia)      


Static Function cCodUser(cNomeUser)
	Local _IdUsuario:= ""
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  ±±³  ³ PswOrder(nOrder): seta a ordem de pesquisa   ³±±
  ±±³  ³ nOrder -> 1: ID;                             ³±±
  ±±³  ³           2: nome;                           ³±±
  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
  	PswOrder(2)
  	If pswseek(cNomeUser,.t.)
  		_aUser      := PswRet(1)
  		_IdUsuario  := _aUser[1][1]      // Código de usuario 
  	Endif  

Return(_IdUsuario)


Static Function GraContPert()

SX1->(DbSetOrder(1))
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_FILIAL       //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_FILIAL          //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End               

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SC5->C5_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SC5->C5_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
                                   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_NUM        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_NUM        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"07"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := str(SC5->C5_MOEDA)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End 
Return
Static Function TextoCompleto(cTexto,nTamLine)
	Local aTexto	:= {}
	Local cToken	:= " "
	Local nX
	Local cTextoNvo := ""
	
	aTexto := STRTOKARR ( cTexto , cToken )
	
	For nX := 1 To Len(aTexto)
		If Len(AllTrim(cTextoNvo+cToken+aTexto[nX])) <= nTamLine
			cTextoNvo := AllTrim(cTextoNvo) + cToken + aTexto[nX]
		Else
			nX := Len(aTexto)
		Endif
	Next nX
	
Return(cTextoNvo)
        