#Include "Protheus.ch"

/*/{Protheus.doc} MT12ATE
Pedido de Compra cabeçalho
ExecBlock("MT120TEL",.F.,.F.,{@oDlg, aPosGet, aObj, nOpcx, nReg, @aDlgFields} )
@type function
@version 1.0
@author Luiz Fael
@since 28/11/2022
@return variant, nil
/*/ 
User Function MT12ATE()
	Local aArea     := GetArea()
	Local oDlg      := PARAMIXB[1]
	Local aPosGet   := PARAMIXB[2]
	Local nOpcx     := PARAMIXB[4]
	Local nRecPC    := PARAMIXB[5]
	Local aDlgFiel	:= PARAMIXB[6]
	Local oCampan
	Local oCampro
	Public cCampana := ""
	Public cCampro 	:= ""
	Public cCampdes := ""
	Public cCamprod	:= ""

	//Define o conteúdo para os campos
	SC7->(DbGoTo(nRecPc))
	If nOpcx == 3
		cCampana := CriaVar("C7_CAMPANA",.F.)
		cCampro  := CriaVar("C7_CAMPRO",.F.)
	Else
		If Empty(SC7->C7_NUMSC)
			cCampana := SC7->C7_CAMPANA
			cCampro  := SC7->C7_CAMPRO
		Else
			cCampana := SC1->C1_CAMPANA
			cCampro  := SC1->C1_CAMPRO
		EndIf
	EndIf
	@ 050, 	aPosGet[1,1]+793 SAY Alltrim(RetTitle("C7_CAMPANA"));
		OF oDlg;
		PIXEL;
		SIZE 050,006
	@ 049, aPosGet[1,1]+843 MSGET oCampan VAR cCampana;
		VALID U_CampDes(oDlG,cCampana,'','','');
		WHEN INCLUI .OR. ALTERA;
		F3 'ZZK';
		SIZE 05, 006;
		OF oDlg;
		COLORS 0, 16777215;
		PIXEL
	oCampan:bHelp := {|| ShowHelpCpo( "C7_CAMPANA", {GetHlpSoluc("C7_CAMPANA")[1]}, 5  )}
	aadd(aDlgFiel,{"C7_CAMPANA","cCampana"})
	@ 064, 	aPosGet[1,1]+793 SAY Alltrim(RetTitle("C7_CAMPRO"));
		OF oDlg;
		PIXEL;
		SIZE 050,006
	@ 063, 	aPosGet[1,1]+843 MSGET oCampro;
		VAR cCampro;
		VALID VALID U_CampDes(oDlG,cCampana,cCampro,'','');
		WHEN !Empty(cCampana);
		F3 'ZZL';
		SIZE 05, 006;
		OF oDlg COLORS 1, 16777215;
		PIXEL
	oCampro:bHelp := {|| ShowHelpCpo( "C7_CAMPRO", {GetHlpSoluc("C7_CAMPRO")[1]}, 5  )}
	//Se não houver edição, desabilita os gets
	RestArea(aArea)
Return
