#Include "RwMake.ch"
#Include "TopConn.ch"
/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ  RPPRE01  บAutor  ณTdeP       บ                  		  บฑฑ
ฑฑ           ณ  UORCFAT  บModificado  ณDenar Terrazas  บ Date 03/04/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑDescripcion Impresion de Proforma de Venta                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP12BIB	                                          		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ MV_PAR01 ณ Descricao da pergunta1 do SX1                              บฑฑ
ฑฑบ MV_PAR02 ณ Descricao da pergunta2 do SX1                              บฑฑ
ฑฑบ MV_PAR03 ณ Descricao do pergunta3 do SX1                              บฑฑ
ฑฑบ MV_PAR04 ณ Descricao do pergunta4 do SX1                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function UORCFAT(aPRs)

Private cPerg	:= "IMPRE"  

 ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO		 
 
 GraContPert()
   
 If funname() == 'MATA415'
	Pergunte(cPerg,.F.)   
 Else
	Pergunte(cPerg,.T.)         
 Endif


If aPRs == Nil
	If Pergunte(cPerg,.t.)
		Processa({|| fImpPres(aPRs)},"Impresion (1) de aPRs ","Imprimindo aPRs...")
	Else
		Return
	Endif
Else
	Processa({|| fImpPres(aPRs)},"Impresion (2) de aPRs ","Imprimindo aPRs...")
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

Private tCJ_NUM := ""
Private tA1_COD := ""
Private tA1_LOJA := ""
Private tA1_NOME := ""
Private tA1_END := ""
Private tA1_TEL := ""
Private tCJ_EMISSAO := ""
Private tCJ_UVEND := ""
Private tA1_CGC := ""
Private tCJ_MOEDA := ""
Private tE4_DESCRI := ""
Private tCJ_DESC1 := ""
//Private tCJ_UTPOENT := ""
//Private tCJ_ULUGENT := ""
//Private tCJ_UOBSERV := ""
//Private tCJ_USRREG := ""
Private nImpIteCli := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as fontes a serem utilizadas na impressao                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oFont09T  := TFont():New("Times New Roman",09,09,,.f.)
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
oFont24CN  := TFont():New("Courier New",24,24,,.t.)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia o uso da classe ...                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrn:= TMSPrinter():New("Proforma")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define pagina no formato paisagem ...        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrn:SetPortrait()

oPrn:Setup()       
                                                         
cQuery := "SELECT CJ_FILIAL,CJ_EMISSAO,CJ_NUM,A1_COD,A1_NOME,A1_END,A1_TEL,A1_CGC,A1_CGC A1_UNITCLI,CASE WHEN CJ_STATUS='A' THEN 'APROBADO' ELSE 'PENDIENTE' END CJ_STATUS,"
cQuery += " CASE WHEN CJ_MOEDA=1 then 'BOLIVIANOS' ELSE 'DOLARES' END CJ_MOEDA,CK_PEDCLI,CK_PRODUTO,CK_DESCRI,B1_DESC,CK_UM,CK_QTDVEN,CJ_FRETE,CJ_DESPESA,CJ_SEGURO,"
cQuery += " CK_PRCVEN,CK_VALOR,CK_OBS,CJ_VALIDA,CK_ENTREG,CK_VALDESC,CJ_DESC1,CK_ITEM,CK_ITECLI,CJ_UVEND,A1_LOJA,A1_UNOMFAC,E4_DESCRI,CJ_MOEDA CJMOEDA  "
cQuery += " ,(SELECT ROUND((DSCTO/TOTAL) * 100.00,2) PDESC FROM (SELECT SUM(CK_VALOR) + SUM(CK_VALDESC) TOTAL, SUM(CK_VALDESC) DSCTO FROM "+RetSqlName("SCK")+" SCK1 "
cQuery += " WHERE CK_NUM=SCJ.CJ_NUM AND CK_CLIENTE=SCJ.CJ_CLIENTE AND SCK1.D_E_L_E_T_!='*') A ) CJ_PDESC "
cQuery += " FROM "+RetSqlName("SCJ")+" SCJ "    
cQuery += " INNER JOIN "+RetSqlName("SCK")+" SCK On CJ_FILIAL=CK_FILIAL and CJ_NUM=CK_NUM AND CJ_LOJA=CK_LOJA  AND CJ_CLIENTE =CK_CLIENTE "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 On CK_PRODUTO=B1_COD "
cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 On CJ_CLIENTE=A1_COD  AND A1_LOJA=CJ_LOJA and SA1.D_E_L_E_T_<>'*' "
cQuery += " INNER JOIN " + RetSqlName("SE4") + " SE4 on E4_CODIGO=CJ_CONDPAG "  
cQuery += " WHERE CJ_FILIAL = '"+xFilial("SCJ")+"'" + " AND "
cQuery += " A1_FILIAL = '"+xFilial("SA1")+"'" + " AND " 
cQuery += " CK_FILIAL = '"+xFilial("SCK")+"'" + " AND "
cQuery += " CJ_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " AND A1_COD BETWEEN '"+mv_par03+"' AND '"+trim(mv_par04)+"'"
cQuery += " AND CJ_NUM BETWEEN '"+mv_par05+"' AND '"+trim(mv_par06)+"'"  
cQuery += " AND SCK.D_E_L_E_T_<>'*' AND SB1.D_E_L_E_T_<>'*' "
cQuery += " ORDER BY CJ_NUM,CK_ITEM"

//Aviso("",cQuery,{'ok'},,,,,.t.)
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//MemoWrite("ImpPresee.txt",cQuery)
				
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

//Alert("Item: " + CK_ITEM + " Item Cliente: " + CK_ITECLI)
	nImpIteCli := Len(AllTrim(CK_ITECLI))
    nLindet := 06.2             				
	nPag := 1
	cNroProforma:=""
	nMoneda:=0
	dfecha:=""
	While !EOF()    
		nMoneda:=CJMOEDA
		dfecha:= CJ_EMISSAO
		If nPag == 1 .and. CJ_NUM <> cNroProforma .and.cNroProforma==""
			cNroProforma :=CJ_NUM      

			tCJ_NUM	:= CJ_NUM
			tA1_COD := A1_COD
			tA1_LOJA := A1_LOJA
			tA1_NOME := A1_NOME
			tA1_END	:= A1_END
			tA1_TEL	:= A1_TEL
			tCJ_EMISSAO :=CJ_EMISSAO
			tCJ_UVEND := CJ_UVEND
			tA1_CGC	:= A1_CGC
			tCJ_MOEDA := CJ_MOEDA
			tE4_DESCRI := E4_DESCRI
			tCJ_DESC1 := IF(CJ_DESC1<>0,CJ_DESC1,CJ_PDESC)
//			tCJ_UTPOENT := CJ_UTPOENT
//			tCJ_ULUGENT := CJ_ULUGENT
//			tCJ_UOBSERV := CJ_UOBSERV
//			tCJ_USRREG := CJ_USRREG

			oPrn:StartPage() 
		ElseIf CJ_NUM <> cNroProforma  
			cNroProforma :=CJ_NUM
	
			nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha)         
			fImpNota(nLindet)
			nPag++	
			oPrn:EndPage()

			tCJ_NUM	:= CJ_NUM
			tA1_COD := A1_COD
			tA1_LOJA := A1_LOJA
			tA1_NOME := A1_NOME
			tA1_END	:= A1_END
			tA1_TEL	:= A1_TEL
			tCJ_EMISSAO :=CJ_EMISSAO
			tCJ_UVEND := CJ_UVEND
			tA1_CGC	:= A1_CGC
			tCJ_MOEDA := CJ_MOEDA
			tE4_DESCRI := E4_DESCRI
			tCJ_DESC1 := IF(CJ_DESC1<>0,CJ_DESC1,CJ_PDESC)
//			tCJ_UTPOENT := CJ_UTPOENT
//			tCJ_ULUGENT := CJ_ULUGENT
//			tCJ_UOBSERV := CJ_UOBSERV
//			tCJ_USRREG := cUserName

			oPrn:StartPage()   
			nLin := 01.0
		    nLin := fImpCabec(nLin)
			nLindet := 06.2   
			nTotal    := 00.0      
			nDesc    := 00.0
			nRecargo := 00.0							
		EndIf	
	
	   	IF nLindet == 06.2 .AND. nPag == 1
	   		nLin := 01.0
	   		nLin := fImpCabec(nLin)
		EndIf       
	
	    nLinha := MlCount(B1_DESC,40)   
	    
	    nLinha2 := " "//MlCount(_cProcedencia,20) 
		nLindet := fImpItem(nLindet)
		 
	    nTotal:=nTotal+CK_VALOR 
	    nDesc:=nDesc+CK_VALDESC   
	    nRecargo:=(CJ_FRETE+CJ_DESPESA+CJ_SEGURO)
	     
		If nLindet > 23  
			fImpPiePag()
			nPag+=1
			oPrn:EndPage()
			oPrn:StartPage()   
			nLin := 01.0
		    nLin := fImpCabec(nLin)
			nLindet := 06.2 							
		Endif
		dbSkip()
	
	    //oPrn:EndPage()
	End 

	nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha)                                    

	fImpNota(nLindet)

oPrn:EndPage()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se visualiza ou imprime ...         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lPrint
	
	While lPrint
		nDef := Aviso("Impressใo de Presupuesto", "Confirma Impressใo da Presupuesto?", {"Preview","Setup","Cancela","Ok"},,)
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

Static Function fImpItem(nLin)
	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), CK_ITEM, oFont10C)
	If nImpIteCli > 0                                                  
		oPrn:Say( Tpix(nLin+01.5), Tpix(01.5), CK_ITECLI, oFont10C)
		oPrn:Say( Tpix(nLin+01.5), Tpix(02.1), CK_PRODUTO, oFont10C)
	Else
		oPrn:Say( Tpix(nLin+01.5), Tpix(01.8), CK_PRODUTO, oFont10C)
	EndIf
   	oPrn:Say( Tpix(nLin+01.5), Tpix(04.5), CK_DESCRI, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.5), CK_UM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.7),Transform(CK_QTDVEN,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(15.1),Transform(CK_PRCVEN,"@A 99,999,999.99"), oFont10C)  
	oPrn:Say( Tpix(nLin+01.5), Tpix(17.5), Transform(CK_VALOR,"@A 999,999,999.99"), oFont10C)
//    If Len(AllTrim(CK_UESPECI)) > 45
//       nLin := nLin+00.3
//	   oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), Right(CK_UESPECI,35), oFont10C)																	
//    EndIf

//   	cDesc2 := POSICIONE("SB1",1,XFILIAL("SB1")+CK_PRODUTO,"B1_UESPEC2")
//	If !Empty(cDesc2)
//    	If Len(AllTrim(cDesc2)) > 45
//	   		nLin:= nLin+00.3
//    		oPrn:Say( Tpix(nLin+01.5), Tpix(04.3),Left(cDesc2,45), oFont10C)																	
//	   		nLin:= nLin+00.3
//    		oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), Right(cDesc2,35), oFont10C)																	
//    	Else
//	   		nLin:= nLin+00.3	
//    		oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), Left(cDesc2,45), oFont10C)																	
//    	EndIf
//	EndIf

    If Len(AllTrim(CK_OBS)) > 0
       nLin := nLin+00.3
	   oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), Left(CK_OBS,45), oFont10C)																	
    EndIf
   	If Len(AllTrim(CK_OBS)) > 45
       nLin := nLin+00.3
	   oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), Right(CK_OBS,35), oFont10C)																	
   	EndIf

//   	If !Empty(CK_ULOTE)
//       nLin := nLin+00.3
//	   oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), CK_ULOTE, oFont10C)																	
//   	EndIf

Return(nLin+00.3)     

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
		SM0->( MsSeek( cEmpAnt + CJ_FILIAL , .T. ))
	Endif

	tel:= SM0->M0_TEL 
	direccion:=SM0->M0_ENDENT  
//	oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "CIMA SRL", oFont14CN)
	oPrn:Say( Tpix(nLin+00.5), Tpix(08.0), "PRESUPUESTO DE VENTA", oFont18CN)      

	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), "Sucursal: " + upper(SM0->M0_FILIAL), oFont10CN) // CJ_EMISSAO  
	oPrn:Say( Tpix(nLin+01.5), Tpix(14.0), "Numero: " + tCJ_NUM								 			, oFont10CN)
	oPrn:Say( Tpix(nLin+02.0), Tpix(01.0), "Cliente: "+ tA1_COD +'/'+ tA1_LOJA +' - '+ upper(ALLTRIM(tA1_NOME)), oFont10CN)
	oPrn:Say( Tpix(nLin+02.0), Tpix(14.0), "Fecha: " + upper(ffechalarga(tCJ_EMISSAO)), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+02.5), Tpix(01.0), "Direccion: " + upper(tA1_END), oFont10CN)
	oPrn:Say( Tpix(nLin+02.5), Tpix(14.0), "NIT: " + tA1_CGC, oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Telefono: " + tA1_TEL, oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(14.0), "Moneda: " + tCJ_MOEDA, oFont10CN)
	
	//oPrn:Say( Tpix(nLin+03.5), Tpix(01.0), "Proforma Valida hasta el : " + ffechalarga(dtos(DaySum( stod(tCJ_EMISSAO) , 3 ))) 			, oFont10CN)  //NT

	oPrn:Say( Tpix(nLin+03.5), Tpix(01.0), "Proforma Valida hasta el : " + upper(ffechalarga(dtos( stod(CJ_VALIDA) ))) 			, oFont10CN)  //NT
	oPrn:Say( Tpix(nLin+03.5), Tpix(14.0), "Impresi๓n: "+ dtoc(ddatabase) +' '+ TIME(), oFont10CN)
//	oPrn:Say( Tpix(nLin+04.0), Tpix(01.0), "Tiempo de Entrega: " + alltrim(tCJ_UTPOENT), oFont10CN)
	oPrn:Say( Tpix(nLin+04.0), Tpix(14.0), "Vendedor: " + upper(LTRIM(GetAdvFval('SA3',"A3_NOME",xFilial('SA3') + tCJ_UVEND ,1,"" ))) 			, oFont10CN)
	oPrn:Say( Tpix(nLin+04.5), Tpix(01.0), "Forma de Pago: " + alltrim(tE4_DESCRI), oFont10CN)
	oPrn:Say( Tpix(nLin+04.5), Tpix(14.0),  "PM: " +  CValToChar(tCJ_DESC1) + "%", oFont10CN)

//	oPrn:Say( Tpix(nLin+05.0), Tpix(01.0), "Lugar de Entrega: " + alltrim(tCJ_ULUGENT), oFont09CN)
//	oPrn:Say( Tpix(nLin+05.5), Tpix(01.0), "Observaci๓n: " + alltrim(tCJ_UOBSERV), oFont09CN)

	oPrn:Say( Tpix(nLin+05.7), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(01.0), "IT.", oFont10C) 
	If nImpIteCli > 0                                                  
		oPrn:Say( Tpix(nLin+06.1), Tpix(01.5), "ITC", oFont10C)                                                             
		oPrn:Say( Tpix(nLin+06.1), Tpix(02.1), "CODIGO", oFont10C)
	Else
		oPrn:Say( Tpix(nLin+06.1), Tpix(01.8), "CODIGO", oFont10C)
	EndIf                                                            
	oPrn:Say( Tpix(nLin+06.1), Tpix(04.3), "DESCRIPCION", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(12.4), "UNID.", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(13.5), "CANTIDAD", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(16.1), "PRECIO", oFont10C)  
	oPrn:Say( Tpix(nLin+06.1), Tpix(18.6), "IMPORTE", oFont10C) 
	oPrn:Say( Tpix(nLin+06.13), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)

Return(nLin+10.8)      

Static Function fImpTotales(nLin,total,desc,recargo,nMoneda,dfecha)
	oPrn:Say( Tpix(nLin+01.0), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(15.6), "TOTAL  Bs.:" +  Transform(round(xmoeda(total+recargo,nMoneda,1,stod(dfecha),4),2),"@A 999,999,999.99")												, oFont10C)
	oPrn:Say( Tpix(nLin+01.9), Tpix(15.6), "TOTAL $us.:" +  Transform(round(xmoeda(total+recargo,nMoneda,2,stod(dfecha),4),2),"@A 999,999,999.99")												, oFont10C)
Return(nLin+02.0)

Static Function fImpNota(nLin)
	If nLin > 20  
		fImpPiePag()
		nPag+=1
		oPrn:EndPage()
		oPrn:StartPage()   
		nLin := 01.0
	    nLin := fImpCabec(nLin)
		nLin := 06.2 
	Else
		nLin := nLin - 2.8
	Endif

	oPrn:Say( Tpix(nLin+2.8), Tpix(01.0), "NOTA.- AL MOMENTO DE HACER SU COMPRA POR FAVOR EXIGIR SU FACTURA", oFont10C)
    oPrn:Say( Tpix(nLin+3.0), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)
    //oPrn:Say( Tpix(nLin+3.5), Tpix(01.0), PADC("IMPORTANTE",130), oFont10C)
    oPrn:Say( Tpix(nLin+3.5), Tpix(4.0), "ESTIMADO CLIENTE:", oFont10C)          
    oPrn:Say( Tpix(nLin+4.0), Tpix(4.0), "UNA VEZ PASADA LA VALIDEZ DE OFERTA, POR FAVOR CONFIRMAR EXISTENCIA DE STOCK."  , oFont10C)
//    oPrn:Say( Tpix(nLin+5.0), Tpix(4.0), "DEPOSITO EN CUENTA BANCARIA Y EL DEPOSITANTE DEBE SER EL MISMO DE LA FACTURA." , oFont10C)          
//    oPrn:Say( Tpix(nLin+5.5), Tpix(4.0), AllTrim(GetNewPar("MV_UBCODES","")), oFont10C)          
//    oPrn:Say( Tpix(nLin+6.0), Tpix(4.0), AllTrim(GetNewPar("MV_UBCOBOL","")), oFont10C)          
//    oPrn:Say( Tpix(nLin+6.0), Tpix(10.0), AllTrim(GetNewPar("MV_UBCODOL","")), oFont10C)
//    oPrn:Say( Tpix(nLin+6.5), Tpix(4.0), AllTrim(GetNewPar("MV_UBCODE2","")), oFont10C)          
//    oPrn:Say( Tpix(nLin+7.0), Tpix(4.0), AllTrim(GetNewPar("MV_UBCOBO2","")), oFont10C)          
//    oPrn:Say( Tpix(nLin+7.0), Tpix(10.0), AllTrim(GetNewPar("MV_UBCODO2","")), oFont10C)
//    oPrn:Say( Tpix(nLin+7.2), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)
//    oPrn:Say( Tpix(nLin+7.7), Tpix(01.0), "LA EMPRESA NO SE HACE RESPONSABLE POR LOS DAัOS CAUSADOS EN EL TRANSPORTE" , oFont10C)
//    oPrn:Say( Tpix(nLin+8.2), Tpix(01.0), "" , oFont10C)

    fImpPiePag()
Return

Static Function fImpPiePag()
	oPrn:Say( Tpix(25.3), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C) 
//	oPrn:Say( Tpix(25.7), Tpix(01.0),PADC("Contacto: " + AllTrim(tCJ_USRREG) + "   |   E-Mail: " + UsrRetMail(cCodUser(tCJ_USRREG)),140), oFont10C)
//	oPrn:Say( Tpix(26.0), Tpix(01.0), PADC("Av.Viedma No 51 Z/Cementerio General - Telfs: 3 3326174 / 3 3331447 / 3 3364244 - Fax: 3 3368672",100), oFont10C)
	oPrn:Say( Tpix(26.0), Tpix(18.0), "Pแgina : "+Transform(nPag,"999"), oFont10C)
Return
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
/*If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_FILIAL       //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_FILIAL          //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End        */       

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SCJ->CJ_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SCJ->CJ_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
                                   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_CLIENTE       //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_CLIENTE       //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_NUM        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_NUM        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End  
Return
