#Include "RwMake.ch"
#Include "TopConn.ch"
/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ  RPPRE01  บAutor  ณ	Nahim Terrazas			 บ 15/02/16   บฑฑ
ฑฑ									Denar Terrazas			 บ 20/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑDescripcion ณImpresion de Proforma de Venta con inclusi๓n de lote       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIMA SRL			      			                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ MV_PAR01 ณ Descricao da pergunta1 do SX1                              บฑฑ
ฑฑบ MV_PAR02 ณ Descricao da pergunta2 do SX1                              บฑฑ
ฑฑบ MV_PAR03 ณ Descricao do pergunta3 do SX1                              บฑฑ
ฑฑบ MV_PAR04 ณ Descricao do pergunta4 do SX1                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PEDVEN(aPRs)

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
		Processa({|| fImpPres(aPRs)},"Impressใo (1) de aPRs ","Imprimindo aPRs...")
	Else
		Return
	Endif
Else
	Processa({|| fImpPres(aPRs)},"Impressใo (2) de aPRs ","Imprimindo aPRs...")
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as fontes a serem utilizadas na impressao                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia o uso da classe ...                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrn:= TMSPrinter():New("NOTA")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define pagina no formato paisagem ...        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrn:SetPortrait()

oPrn:Setup()       
                                                         
cQuery := "SELECT DISTINCT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_FECENT,C5_CONDPAG,C5_DESC1,C5_UNOMCLI,C5_UNITCLI,C5_ULUGENT,C5_UOBSERV,"
cQuery += "C5_PBRUTO,C5_TRANSP,C5_COTACAO,C5_USRREG,A3_NOME,"
cQuery += "C6_ENTREG,C6_ITEM,C6_PRODUTO,C6_LOCAL,NNR_DESCRI,C6_UM, C6_QTDVEN,C6_PRCVEN,C6_VALOR, C6_LOTECTL,"
cQuery += "A1_NOME,A1_CGC,A1_END, CASE WHEN LEN(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),''))=0 THEN B1_DESC " 
cQuery += "   ELSE ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),'') END C6_UESPECI, "
cQuery += "C5_TXMOEDA,C5_MOEDA,E4_DESCRI,A1_COD,A1_LOJA,C5_VEND1,B1_DESC "  
cQuery += " ,(SELECT (DSCTO/TOTAL) * 100.00 PDESC FROM (SELECT SUM(C6_VALOR) + SUM(C6_VALDESC) TOTAL, SUM(C6_VALDESC) DSCTO FROM "+RetSqlName("SC6")+" SC61 "
cQuery += " WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) C5_PDESC, ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),'') C6_UDESCLA "
cQuery += "FROM " + RetSqlName("SC5") + " SC5 "     
cQuery += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL  "   
cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD=C5_CLIENTE AND A1_LOJA = C5_LOJACLI and SA1.D_E_L_E_T_<>'*' "  
cQuery += "LEFT JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD=C5_VEND1 " 
cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD=C6_PRODUTO "   
cQuery += "INNER JOIN " + RetSqlName("SE4") + " SE4 ON E4_CODIGO=C5_CONDPAG "
cQuery += "INNER JOIN " + RetSqlName("NNR") + " NNR ON NNR_CODIGO=C6_LOCAL AND NNR_FILIAL = C6_FILIAL " 
cQuery += " WHERE C5_FILIAL BETWEEN '"+trim(XFILIAL("SC5"))+"' AND '"+trim(XFILIAL("SC5"))+"'"
cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " AND C5_NUM BETWEEN '"+trim(mv_par05)+"' AND '"+trim(mv_par06)+"'"
cQuery += " AND SC5.D_E_L_E_T_=' ' AND SC6.D_E_L_E_T_=' ' AND E4_FILIAL='"+ xfilial('SE4') +"' "
cQuery += " AND SB1.D_E_L_E_T_=' ' " 


//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//aviso("",cQuery,{'ok'},,,,,.t.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ฟ
//ณ Caso area de trabalho estiver aberta, fecha... ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ู
If !Empty(Select("TRB"))
	dbSelectArea("TRB")
	dbCloseArea()
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ฟ
//ณ Executa query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ู
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
		oPrn:Say( Tpix(26.0), Tpix(18.0), "Pแgina : "+Transform(nPag,"999"), oFont10C)
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
    oPrn:Say( Tpix(26.0), Tpix(01.0), PADC("Av. Isabel la Cat๓lica #81A , Esq. C/ Romulo Gomez - Tel้fono: 3 3599930",100), oFont10C)
    
				
    oPrn:Say( Tpix(26.0), Tpix(18.0), "Pแgina : "+Transform(nPag,"999"), oFont10C)
	If nLindet > 22   
		nPag+=1
		oPrn:EndPage()
		oPrn:StartPage()   
		nLin := 01.0
	    nLin := fImpCabec(nLin)
		oPrn:Say( Tpix(26.0), Tpix(18.0), "Pแgina : "+Transform(nPag,"999"), oFont10C)
		nLindet := 06.1 							
	Endif
	dbSkip()

    //oPrn:EndPage()
End 
	//oPrn:Say( Tpix(nLindet+2.8), Tpix(01.0), "NOTA.- AL MOMENTO DE HACER SU COMPRA POR FAVOR EXIGIR SU FACTURA", oFont10C)
    oPrn:Say( Tpix(nLindet+3.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
    nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha)                                    
    //oPrn:Say( Tpix(26.0), Tpix(02.0),"query : " + consulta, oFont12C)



oPrn:EndPage()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se visualiza ou imprime ...         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lPrint
	
	While lPrint
		nDef := Aviso("Impressใo de Pedido de Venta", "Confirma Impressใo da Pedido?", {"Preview","Setup","Cancela","Ok"},,)
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
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.5), "CODIGO", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(04.3), "DESCRIPCION", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(11.9), "UNID.", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(13.5), "CANTIDAD", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(16.1), "PRECIO", oFont10C)  
	oPrn:Say( Tpix(nLin+00.5), Tpix(18.6), "IMPORTE", oFont10C) 
	oPrn:Say( Tpix(nLin+00.7), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
			
Return(nLin+03.0)

Static Function fImpItem(nLin)

	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), C6_ITEM, oFont10C)                                                  
	oPrn:Say( Tpix(nLin+01.5), Tpix(01.5), C6_PRODUTO, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), Left(C6_UESPECI,50), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.0), C6_UM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.7),Transform(C6_QTDVEN,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(15.1),Transform(C6_PRCVEN,"@A 99,999,999.99"), oFont10C)  
	oPrn:Say( Tpix(nLin+01.5), Tpix(17.5), Transform(C6_VALOR,"@A 999,999,999.99"), oFont10C)
	If Len(AllTrim(C6_UESPECI)) > 50
		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),Right(C6_UESPECI,30), oFont10C)
		nLin:= nLin+00.3
	EndIf
   	/*cDesc2 := POSICIONE("SB1",1,XFILIAL("SB1")+C6_PRODUTO,"B1_UESPEC2")
	If !Empty(cDesc2)
    	If Len(AllTrim(cDesc2)) > 50
    		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),Left(cDesc2,50), oFont10C)																	
	   		nLin:= nLin+00.3
    		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8), Right(cDesc2,30), oFont10C)																	
	   		nLin:= nLin+00.3
    	Else
    		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8), Left(cDesc2,50), oFont10C)																	
	   		nLin:= nLin+00.3	
    	EndIf
	EndIf*/
// Adicion Lote
	If !Empty(C6_LOTECTL)
		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),C6_LOTECTL, oFont10C)
	   	nLin:= nLin+00.3
	endif

	nLin:= nLin+00.3	

Return(nLin)     

Static Function TPix(nTam,cBorder,cTipo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Desconta area nao imprimivel (Lexmark Optra T) ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If cBorder == "lb"			// Left Border
	nTam := nTam - 0.40
ElseIf cBorder == "tb" 		// Top Border
	nTam := nTam - 0.60
EndIf

nPix := nTam * 120

Return(nPix)     


Static Function fImpCabec(nLin)

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cabecera ณ
//ภฤฤฤฤฤฤฤฤฤฤฤู      
local diasfin :=0
local diasini :=0  
local direccion:=""
local tel:=""

//diasfin:=DateDiffDay(CTOD(CJ_VALIDA),CTOD(CJ_EMISSAO))  //substr(CJ_VALIDA,8,2)

If SM0->(Eof())                                
	SM0->( MsSeek( cEmpAnt + SC5->C5_FILIAL , .T. ))
Endif
 
cFLogo := GetSrvProfString("Startpath","") + "Logo01.bmp"
oPrn:SayBitmap(90,120, cFLogo,200,200)
 
tel:= SM0->M0_TEL 
direccion:=SM0->M0_ENDENT
            
//oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), SM0->M0_FILIAL, oFont14CN)
oPrn:Say( Tpix(nLin+00.5), Tpix(08.0), "NOTA DE VENTA", oFont18CN)      
oPrn:Say( Tpix(nLin+01.4), Tpix(01.0), "Sucursal: "+ SM0->M0_FILIAL, oFont10CN) // CJ_EMISSAO  
oPrn:Say( Tpix(nLin+01.4), Tpix(14.0), "Numero: "+C5_NUM, oFont10CN)
oPrn:Say( Tpix(nLin+01.8), Tpix(01.0), "Cliente: "+ A1_COD +'/'+ A1_LOJA +' - '+ ALLTRIM(A1_NOME), oFont10CN)
oPrn:Say( Tpix(nLin+01.8), Tpix(14.0), "Fecha: "+ ffechalarga(C5_EMISSAO), oFont10CN) // CJ_EMISSAO
oPrn:Say( Tpix(nLin+02.2), Tpix(01.0), "Direccion: "+A1_END, oFont10CN)
oPrn:Say( Tpix(nLin+02.2), Tpix(14.0), "NIT: "+iif(!empty(C5_UNITCLI),AllTrim(str(SC5->C5_UNITCLI)),AllTrim(SA1->A1_CGC)), oFont10CN)
//oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Telefono: "+A1_TEL, oFont10CN)

oPrn:Say( Tpix(nLin+02.6), Tpix(01.0), "Vendedor: " + LTRIM(GetAdvFval('SA3',"A3_NOME",xFilial('SA3') + C5_VEND1 ,1,"" )) 			, oFont10CN)
oPrn:Say( Tpix(nLin+02.6), Tpix(14.0), "Moneda: "+GetMV("MV_MOEDA"+Alltrim(STR(C5_MOEDA)))							 			, oFont10CN)
oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Forma de Pago: " + alltrim(E4_DESCRI), oFont10CN)
oPrn:Say( Tpix(nLin+03.0), Tpix(14.0), "Impresi๓n: "+ dtoc(ddatabase) +' '+ TIME()								 			, oFont10CN)

oPrn:Say( Tpix(nLin+03.4), Tpix(01.0), "Deposito de Entrega: " + C6_LOCAL + " - " + alltrim(NNR_DESCRI) 			, oFont10CN)
//oPrn:Say( Tpix(nLin+03.4), Tpix(14.0), "PM: " +  IF(C5_DESC1<>0,TRANSFORM(C5_DESC1,"@A 99.99"),TRANSFORM(C5_PDESC,"@A 99.99")) + "%"	, oFont10CN)
//oPrn:Say( Tpix(nLin+03.8), Tpix(01.0), "Dir.Deposito: " +  ALLTRIM(NNR_UDIREC), oFont10CN)
oPrn:Say( Tpix(nLin+03.8), Tpix(01.0), "Lugar de Entrega: " +  ALLTRIM(C5_ULUGENT), oFont09CN)
oPrn:Say( Tpix(nLin+04.6), Tpix(01.0), "Observaci๓n: " + alltrim(C5_UOBSERV), oFont09CN)

Return(nLin+05.4)      


Static Function fImpTotales(nLin,total,desc,recargo,nMoneda,dfecha)

oPrn:Say( Tpix(nLin+01.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)

oPrn:Say( Tpix(nLin+01.5), Tpix(15.6), "TOTAL  Bs.:" +  Transform(round(xmoeda(total+recargo,nMoneda,1,stod(dfecha),4),2),"@A 999,999,999.99")												, oFont10C)
oPrn:Say( Tpix(nLin+02.0), Tpix(15.6), "TOTAL $us.:" +  Transform(round(xmoeda(total+recargo,nMoneda,2,stod(dfecha),4),2),"@A 999,999,999.99")												, oFont10C)
oPrn:Say( Tpix(nLin+05.0), Tpix(03.0), "Elaborado por"															, oFont10C)
//oPrn:Say( Tpix(nLin+05.0), Tpix(07.0), "Vendedor Externo"															, oFont10C)
oPrn:Say( Tpix(nLin+05.0), Tpix(8.5), "VoBo"															, oFont10C)
oPrn:Say( Tpix(nLin+05.0), Tpix(13.0), "Recibido Por"															, oFont10C)
oPrn:Say( Tpix(nLin+04.3), Tpix(03.0), cUserName																, oFont10C)
oPrn:Say( Tpix(nLin+04.5), Tpix(03.0), "_____________"															, oFont10C)
//oPrn:Say( Tpix(nLin+04.5), Tpix(07.0), "________________"															, oFont10C)
oPrn:Say( Tpix(nLin+04.5), Tpix(8.0), "_____________"															, oFont10C)
oPrn:Say( Tpix(nLin+04.5), Tpix(13.0), "_____________"															, oFont10C)
  
			
Return(nLin+06.0)







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณ Walter Alvarez ณ  04/11/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)


aAdd(aRegs,{"01","De Fecha de Emisi๓n     :","mv_ch1","D",08,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"02","A Fecha de Emisi๓n      :","mv_ch2","D",08,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""})
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
/*ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
  ฑฑณ  ณ PswOrder(nOrder): seta a ordem de pesquisa   ณฑฑ
  ฑฑณ  ณ nOrder -> 1: ID;                             ณฑฑ
  ฑฑณ  ณ           2: nome;                           ณฑฑ
  ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ*/
  	PswOrder(2)
  	If pswseek(cNomeUser,.t.)
  		_aUser      := PswRet(1)
  		_IdUsuario  := _aUser[1][1]      // C๓digo de usuario 
  	Endif  

Return(_IdUsuario)


Static Function GraContPert()

SX1->(DbSetOrder(1))
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SC5->C5_EMISSAO)
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SC5->C5_EMISSAO)
   SX1->(MsUnlock())
End               

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_CLIENTE        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_CLIENTE        //Variable publica con sucursal en uso
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

Return




