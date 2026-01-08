#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ kardexcli ³ Autor ³	Nahim Terrazas Parada					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex de cliente (Cuentas por cobrar y pagar TREPORT )		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BOlivia														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim Terrazas ³02/10/2020³												³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function kardexcli()
	Local oReport
	// PRIVATE cPerg   := "IRESDUO"   // elija el Nombre de la pregunta
	// CriaSX1(cPerg)	// Si no esta creada la crea

	// Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "kardex cliente"

	// oReport	 := TReport():New("Kardex Clientes",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Kardex Clientes")
	oReport	 := TReport():New("kardexcli",NombreProg,/*cPerg*/,{|oReport| PrintReport(oReport)},"Kardex Clientes")
	//	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Kardex Clientes",{"SE1"})
	oReport:SetTotalInLine(.F.)

	TRCell():New(oSection,"EMITIDO"	,"SE1","EMITIDO") //carnet dpto
	TRCell():New(oSection,"DESCRIPCION"	,"SE1","DESCRIPCION",) //nombre completo
	TRCell():New(oSection,"DEBITO"	,"SE1","DEBITO",) //cuenta deposito salario
	TRCell():New(oSection,"CREDITO"	,"SE1","CREDITO ")
	If mv_par08 == 1
		TRCell():New(oSection,"CORRECCION"	,"SE1","CORRECCION")
	ENDIF
	TRCell():New(oSection,"DEUDA","SE1","DEUDA ACUMULADA",)
	TRCell():New(oSection,"SALDO","SE1","SALDO FINANCIERO",)
	TRCell():New(oSection,"VENCTO","SE1","VENCTO") //FECHA a

Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local cFiltro  := ""


	oSection:Init()
	oReport:PrintText(cCliente +" - "+ cLoja,oReport:row()- 40)
	oReport:SkipLine()
	oReport:PrintText(cNomeCli,oReport:row()- 40)
	oReport:SkipLine()

	// cCliente := SA1->A1_CGC
	// cTel     := SA1->A1_FAX
	// cLoja    := SA1->A1_loja
	// cNomeCli := SA1->A1_NOME


	WHILE TRB->(!EoF())
		oSection:Cell("EMITIDO"):SetBlock({|| 		Dtoc(TRB->EMISSAO) })
		oSection:Cell("DESCRIPCION"):SetBlock({||   If(TRB->CREDDEB=='2',"   "+TRB->TIPO,TRB->TIPO)+"  "+TRB->PREFIJO+IIf(TRB->TIPO="RC",TRB->SERIE,"")+TRB->NUMERO+" "+TRB->CUOTA })
		oSection:Cell("DEBITO"):SetBlock({||        PADR(Transform(TRB->DEBITO ,cPict),17) })
		oSection:Cell("CREDITO"):SetBlock({||       PADR(Transform(TRB->CREDITO,cPict),17) })
		If mv_par08 == 1
			oSection:Cell("CORRECCION"):SetBlock({||    PADR(TRANSFORM(TRB->CORRECAO  ,cPict),17) })
		ENDIF
		oSection:Cell("DEUDA"):SetBlock({||     PADR(Transform(TRB->SALDO  ,cPict),17) })
		oSection:Cell("SALDO"):SetBlock({||         PADR(Transform(TRB->SALTIT ,cPict),17) })
		oSection:Cell("VENCTO"):SetBlock({|| 		IIf(TRB->VENCTO=="  /  /  ","",TRB->VENCTO) })
		oSection:PrintLine()
		TRB->(DbSkip())
	ENDDO

	// @ 167,014 SAY OemToAnsi(STR0016) SIZE 72,10 // "PERIODO --->"
	// @ 167,055 SAY OemToAnsi(STR0017) + Trans(nDebPeri,cPict) SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE    // "Debitos : "  // COLOR "b/w"
	// @ 167,140 SAY OemToAnsi(STR0018) + Trans(nCredPeri,cPict) SIZE 80,10 COLOR CLR_HRED,CLR_WHITE   // "Creditos : "  // COLOR "r+/w"
	// @ 167,230 SAY OemToAnsi(STR0019) + Trans(nSaldoPeri,cPict1) SIZE 80,10 COLOR nPictSLPer,CLR_WHITE // "Saldo Periodo:"  // COLOR cPictSLPer

	// @ 177,014 SAY OemToAnsi(STR0020) SIZE 72,10 // "TOTALES --->"
	// @ 177,055 SAY OemToAnsi(STR0017) + Trans(nTotDeb,cPict) SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE  // "Debitos : "  // COLOR "b/w"
	// @ 177,140 SAY OemToAnsi(STR0018) + Trans(nTotCred,cPict) SIZE 80,10 COLOR CLR_HRED,CLR_WHITE  // "Creditos : "  // COLOR "r+/w"
	// @ 177,230 SAY OemToAnsi(STR0021) + Trans(nTotSaldo,cPict1) SIZE 80,10 COLOR nPictTotS,CLR_WHITE // "Saldo Total : "  // COLOR cPictTotS
	oReport:SkipLine()
	oReport:PrintText(OemToAnsi("TOTALES"),oReport:row()- 40)
	oReport:SkipLine()
	oReport:PrintText("DEBITOS: "  ,oReport:row()- 40)
	oReport:PrintText( PADR(Transform(nTotDeb ,cPict),17) ,oReport:row()- 40,110)
	oReport:SkipLine()
	oReport:PrintText("CREDITOS: "   ,oReport:row()- 40)
	oReport:PrintText( PADR(Transform(nTotCred ,cPict),17),oReport:row()- 40,110)
	oReport:SkipLine()
	oReport:PrintText("SALDO: "  ,oReport:row()- 40)
	oReport:PrintText(PADR(Transform(nTotSaldo ,cPict),17),oReport:row()- 40,110)

	oSection:finish()
	oReport:IncMeter()

Return