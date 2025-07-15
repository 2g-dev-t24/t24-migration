$PACKAGE AbcSpei

SUBROUTINE ABC.SPEI.EXPRESS.PREPARA.REQUEST(Y.STRING.ESCRIBIR, Y.RESPONSE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables

    GOSUB INITIALIZE
    GOSUB PROCESS
    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    GOSUB GET.DATA.PARAMS

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.POS = ''
    Y.SEPJ   = ";"

    Y.NO.TIPP = ''
    Y.TIPP.PARAMS = ''
    Y.FLAG = 0

    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    Y.STRING.ESCRIBIR := Y.SEPJ: Y.CVEENTIDAD :Y.SEPJ: Y.ID.EMPRESA :Y.SEPJ
    Y.CADENA.DATOS = ''

    AbcSpei.AbcSpeiExpressGetdataRequest(Y.STRING.ESCRIBIR, Y.CADENA.DATOS)
    Y.CADENA.SALIDA = ""

    AbcSpei.AbcSpeiArmaRequest(Y.TAG.S, Y.TAG.I, Y.CADENA.DATOS, Y.CADENA.SALIDA)

    Y.DATOS.ENVIO = ''
    Y.DATOS.ENVIO  = Y.URL.IP     : Y.SEPJ
    Y.DATOS.ENVIO := Y.URL         : Y.SEPJ
    Y.DATOS.ENVIO := Y.SERVERURI    : Y.SEPJ
    Y.DATOS.ENVIO := Y.NOMBEURI      : Y.SEPJ
    Y.DATOS.ENVIO := Y.CADENA.SALIDA  : Y.SEPL
    Y.DATOS.ENVIO := Y.RUTA.LOG        : Y.SEPL
    Y.DATOS.ENVIO := Y.PREF.ARCHIVO.LOG : Y.SEPL
    Y.DATOS.ENVIO := Y.ID.FT
    Y.RETURNVAL = ""

    AbcSpei.AbcSpeiSendRequest(Y.CD.SHELL, Y.DATOS.ENVIO, Y.RETURNVAL)
    Y.RESPONSE = Y.RETURNVAL
    RETURN

*-------------------------------------------------------------------------------
GET.DATA.PARAMS:
*-------------------------------------------------------------------------------
    Y.DATOS  = ""
    Y.TAG.I  = ""
    Y.MODULO = "SPEI.OUTGOING"
    Y.SEP    = "#"
    Y.SEPL   = "|"
    Y.DAT.PARAM  = ""
    Y.DAT.PARAM := "CVEENTIDAD"       : Y.SEP
    Y.DAT.PARAM := "IDEMPRESA"        : Y.SEP
    Y.DAT.PARAM := "URL"              : Y.SEP
    Y.DAT.PARAM := "URL.IP"           : Y.SEP
    Y.DAT.PARAM := "SERVERURI"        : Y.SEP
    Y.DAT.PARAM := "NOMBEURI"         : Y.SEP
    Y.DAT.PARAM := "R.TAG.S"          : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.1"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.2"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.3"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.4"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.5"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.6"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.7"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.8"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.9"        : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.10"       : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.11"       : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.12"       : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.13"       : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.14"       : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.15"       : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.16"       : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.17"       : Y.SEP
    Y.DAT.PARAM := "R.TAG.I.18"       : Y.SEP
    Y.DAT.PARAM := "CD.SHELL"         : Y.SEP
    Y.DAT.PARAM := "RUTA.LOG"         : Y.SEP
    Y.DAT.PARAM := "PREF.ARCHIVO.LOG" : Y.SEP

    AbcSpei.AbcTraeGeneralParam(Y.MODULO, Y.DAT.PARAM, Y.DATOS)

    Y.CVEENTIDAD            = FIELD(Y.DATOS,Y.SEP,1)
    Y.ID.EMPRESA  = FIELD(Y.DATOS,Y.SEP,2)
    Y.URL                         = FIELD(Y.DATOS,Y.SEP,3)
    Y.URL.IP                     = FIELD(Y.DATOS,Y.SEP,4)
    Y.SERVERURI              = FIELD(Y.DATOS,Y.SEP,5)
    Y.NOMBEURI              = FIELD(Y.DATOS,Y.SEP,6)
    Y.TAG.S                     = FIELD(Y.DATOS,Y.SEP,7)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,8)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,9)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,10)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,11)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,12)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,13)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,14)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,15)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,16)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,17)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,18)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,19)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,20)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,21)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,22)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,23)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,24)
    Y.TAG.I                     := FIELD(Y.DATOS,Y.SEP,25)
    Y.CD.SHELL                  = FIELD(Y.DATOS,Y.SEP,26)
    Y.RUTA.LOG                  = FIELD(Y.DATOS,Y.SEP,27)
    Y.PREF.ARCHIVO.LOG  = FIELD(Y.DATOS,Y.SEP,28)
    Y.ID.FT = EB.SystemTables.getIdNew()
    RETURN

END 