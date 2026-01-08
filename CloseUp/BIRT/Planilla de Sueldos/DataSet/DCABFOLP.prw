#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'
#INCLUDE "GPER680.CH"
#INCLUDE "FIVEWIN.CH"

User_Dataset DCABFOLP
title "Planilla de sueldos"
description "Cabecera de la planilla"
PERGUNTE "GPR680"

columns

define column EMPRESA    	type 	character size (len(STR0008) + 45)  				label	"EMPRESA"
define column EMPLEADOR    	type 	character size (len(STR0009) + 25)  				label	"EMPLEADOR"
define column DESCMES    	type 	character size (len(STR0012) + len(STR0013) + 25)  	label	"DESCMES"
define column NOMEMPL  		type 	character size 50  									label	"NOMEMPL"
define column CIEMPL   		type 	character size 20  									label	"CIEMPL"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local aDetalle		:= {}
Local cEmpresa	:= TRIM(OemToAnsi(STR0008)) + ": " + TRIM(SM0->M0_NOME)

Local cCompet	:= self:execParamValue("MV_PAR03")
Local nPerEvent	:= self:execParamValue("MV_PAR14")
Local cNomEmpr	:= self:execParamValue("MV_PAR15")
Local cNumDocId	:= self:execParamValue("MV_PAR16")
Private aTabS007:= {}

/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ mv_par01        //  Processo						           ³
³ mv_par02        //  Roteiro							       ³
³ mv_par03        //  Competencia                              ³
³ mv_par04        //  Filial  De                               ³
³ mv_par05        //  Filial  Ate                              ³
³ mv_par06        //  Centro de Custo De                       ³
³ mv_par07        //  Centro de Custo Ate                      ³
³ mv_par08        //  Matricula De                             ³
³ mv_par09        //  Matricula Ate                            ³
³ mv_par10        //  Nome De                                  ³
³ mv_par11        //  Nome Ate                                 ³
³ mv_par12        //  Situacao                                 ³
³ mv_par13        //  Categoria                                ³
³ mv_par14        //  Personal - Eventual/Permanente           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

dDataRef := cToD( "01/" + SubStr(cCompet,1,2) + "/" + SubStr(cCompet,3,4))
fCarrTab ( @aTabS007, "S007", dDataRef, .T.)
cEmplead	:= aTabS007[1][6]
cNit		:= aTabS007[1][8]
cEmpMTrab	:= OemToAnsi(STR0009) +": "+ alltrim(cNit) + allTrim(cEmplead)

cDescMes := OemToAnsi(STR0012) +" "+ UPPER(FDESC_MES(Val(SubStr(cCompet,1,2)))) +" "+ STR0013 +" "+ SubStr(cCompet,3,4)

cNomEmpr	:= Trim(mv_par15)	//If( (cNomEmpr := fTabela("S007",1,10 )) <> Nil, cNomEmpr, mv_par15 )
cNumDocId	:= Trim(mv_par16)	//If( (cNumDocId := fTabela("S007",1,11 )) <> Nil, cNumDocId, mv_par16 )

cFechImp	:= DtoC(dDataBase)

cursorarrow()


RecLock(cWTabAlias, .T.)

(cWTabAlias)-> EMPRESA		:= cEmpresa
(cWTabAlias)-> EMPLEADOR	:= cEmpMTrab
(cWTabAlias)-> DESCMES		:= cDescMes
(cWTabAlias)-> NOMEMPL		:= cNomEmpr
(cWTabAlias)-> CIEMPL		:= cNumDocId

(cWTabAlias)->(MsUnlock())

return .T.
