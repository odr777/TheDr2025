#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'RESTFUL.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#Include "Totvs.ch"

user function SoliNotif(cUsrTkn, cJsonPed)
	Local lRet := .F.
	Local cTknFB := ""
	Local aHeader := {}
	local cHeadRet:=""
	local oObjJson := nil
	Local cSup := alltrim(GETMV("MV_UTKNAPP"))
	obj := JsonObject():new()
    obj = cJsonPed
	cSup:="key=" + cSup	
	cTknFB := AllTrim( GetNewPar("MV_UTKNAPP"  ,"") )
	url:= "https://fcm.googleapis.com/fcm/send"		
	
	cBody := '{                                                       '
	cBody += '	"to" : "' + Alltrim(cUsrTkn) + '",                             '
	cBody += '	"data" : {                                            '
	cBody += '		"body" : "Toca para ver",                         '
	cBody += '		"title" : "Nueva solicitud Almacen ",             '
	cBody += '		"content_available" : true,                       '
	cBody += '		"priority" : "high",                              '
	cBody += '		"data": {                                         '
	cBody += '			"Solicitud": 									  '
	cBody += obj
	cBody += '		}                                                 '
	cBody += '	}                                                     '
	cBody += '}                                                       '
	
//	aviso("",cBody,{'ok'},,,,,.t.)

	Aadd(aHeader, 'Content-Type: application/json')
	Aadd(aHeader, 'Authorization: '+ cSup)

	sPostRet := HttpPost(url,"",cBody,120,aHeader,@cHeadRet)
	//FWJsonDeserialize(sPostRet,@oObj)
	//if(sPostRet)

return