user function MT105FIM()

local cTemp 		:= getNextAlias()
Local cQuery	    := ""
Local cToken    
Local cResponse := ''
local cNum
local cSolicitud
Local aItems  := {}

cNum := SCP->CP_NUM
cSolicitud := SCP->CP_SOLICIT

BeginSql alias cTemp

	SELECT  SCP.*,AK_UTOKEN FROM %Table:SGM% SGM
	JOIN %Table:SAK% SAK ON AK_USER = GM_SUPER and SAK.%notdel%
	JOIN %Table:SCP% SCP ON SCP.CP_NUM  LIKE %exp:cNum% and SCP.%notdel%
	WHERE SGM.%notdel%

EndSql

cQuery:=GetLastQuery()
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

if (cTemp)->(!EOF())

	objCab := JsonObject():new()
	objCab ['USUARIO'] := UsrRetName( (cTemp)->CP_USER )
	cToken := (cTemp)->AK_UTOKEN
	objCab ['CP_DATPRF'] := CP_DATPRF
	objCab ['CP_NUM'] := CP_NUM
	objCab ['USERCODE'] := CP_USER
	objCab ['CP_FILIAL'] := CP_FILIAL
	objCab ['CP_OBS']    := (cTemp)->CP_OBS	

	While (cTemp)->(!EOF())
		objDet := JsonObject():new()
		objDet ['CP_DESCRI'] := (cTemp)->CP_DESCRI
		objDet ['CP_QUANT']  := (cTemp)->CP_QUANT
		objDet ['CP_LOCAL']  := (cTemp)->CP_LOCAL
		objDet ['CP_PRODUTO']    := (cTemp)->CP_PRODUTO	
		objDet ['CP_ITEM']    := (cTemp)->CP_ITEM	
//		alert((cTemp)->CP_DESCRI)
		AADD(aItems,objDet)											
		(cTemp)->(dbSkip())			
	enddo
	
	/*   
	"detalle": [
                {
                    "CP_DESCRI": "LIMPIADOR DE CONTACTO CRC     ",
                    "CP_LOCAL": "RC",
                    "CP_QUANT": 1,
                    "CP_PRODUTO": "CL LIMPI C                    ",
                    "CP_ITEM": "01"
                }
            ],
            "USUARIO": "comprador",
            "CP_DATPRF": "20190521",
            "CP_FILIAL": "0101",
            "CP_NUM": "001507",
            "USERCODE": "000003",
            "CP_OBS": "LIMPIADOR DE CONTACTO PARA USO EN EL TALLER ELECTRICO DE LA PLANTA BELEN-4                                                                                                                                                                                    "
*/
	
	
	objCab['detalle'] 	:= aItems
	aItems := {}	
	cJson := FWJsonSerialize(objCab,.T.,.T.)
	cResponse:= cJson
	
//	alert(cResponse)	
	
endif

if(!EMPTY(cToken))
//	alert("entro")
	U_SoliNotif(cToken , cResponse )
endif

return    