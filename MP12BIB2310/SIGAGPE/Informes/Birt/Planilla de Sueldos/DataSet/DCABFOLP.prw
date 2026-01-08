#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'
#INCLUDE "GPER680.CH"
#INCLUDE "FIVEWIN.CH"

User_Dataset DCABFOLP
title "Planilla de sueldos"
description "Cabecera de la planilla"
PERGUNTE "FOLPAGAM"

columns

define column EMPRESA    	type 	character size (len(STR0008) + 45)  				label	"EMPRESA"
define column EMPLEADOR    	type 	character size (len(STR0009) + 25)  				label	"EMPLEADOR"
define column DESCMES    	type 	character size (len(STR0012) + len(STR0013) + 25)  	label	"DESCMES"
define column NOMEMPL  		type 	character size 50  									label	"NOMEMPL"
define column CIEMPL   		type 	character size 20  									label	"CIEMPL"
define column NROCPS    	type 	character size 40  									label	"NROCPS"
define column NRONIT    	type 	character size 40  									label	"NRONIT"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local aDetalle		:= {}
Local cEmpresa	:= TRIM(OemToAnsi(STR0008)) + ": " + TRIM(FWCompanyName())//TRIM(SM0->M0_NOME)

Local cCompet	:= self:execParamValue("MV_PAR03")
Local cFilDe   	:= self:execParamValue("MV_PAR05")
Local cFilAte  	:= self:execParamValue("MV_PAR06")
Local nPerEvent	:= self:execParamValue("MV_PAR13")
Local cNomEmpr	:= self:execParamValue("MV_PAR14")
Local cNumDocId	:= self:execParamValue("MV_PAR15")
Local cFilLegal	:= FWCodFil()
Local cTabU001	:= "U001"
Local aInfoLegal:= {}
Private aTabU001:= {}

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
³ mv_par10        //  Situacao                                 ³
³ mv_par11        //  Categoria                                ³
³ MV_PAR13        //  Personal - Eventual/Permanente           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

dDataRef := cToD( "01/" + SubStr(cCompet,1,2) + "/" + SubStr(cCompet,3,4))
fCarrTab ( @aTabU001, cTabU001, dDataRef, .T.)
if(!Empty(cFilDe) .AND. ( TRIM(cFilDe) == TRIM(cFilAte) ) )
	cFilLegal:= cFilDe
endIf

//Se recorre el array para filtrar la sucursal del empleado
for i:= 1 to Len(aTabU001)
	if(TRIM(aTabU001[i][2]) == TRIM(cFilLegal))
		aInfoLegal:= aTabU001[i]
		exit
	endIf
next i

cEmplead	:= aInfoLegal[8]
cEmpMTrab	:= OemToAnsi(STR0009) + ": " + allTrim(cEmplead)
cNroEmpCps	:= "N°EMPLEADOR CNS: " + aInfoLegal[5]
cNit		:= "NÚMERO DE NIT: " + aInfoLegal[6]

cDescMes := OemToAnsi(STR0012) +" "+ UPPER(FDESC_MES(Val(SubStr(cCompet,1,2)))) +" "+ STR0013 +" "+ SubStr(cCompet,3,4)

//cNomEmpr	:= Trim(mv_par15)	//If( (cNomEmpr := fTabela("S007",1,10 )) <> Nil, cNomEmpr, mv_par15 )
//cNumDocId	:= Trim(mv_par16)	//If( (cNumDocId := fTabela("S007",1,11 )) <> Nil, cNumDocId, mv_par16 )

cFechImp	:= DtoC(dDataBase)

cursorarrow()

RecLock(cWTabAlias, .T.)

(cWTabAlias)-> EMPRESA		:= cEmpresa
(cWTabAlias)-> EMPLEADOR	:= cEmpMTrab
(cWTabAlias)-> DESCMES		:= cDescMes
(cWTabAlias)-> NOMEMPL		:= cNomEmpr
(cWTabAlias)-> CIEMPL		:= cNumDocId
(cWTabAlias)-> NROCPS		:= cNroEmpCps
(cWTabAlias)-> NRONIT		:= cNit

(cWTabAlias)->(MsUnlock())

return .T.
