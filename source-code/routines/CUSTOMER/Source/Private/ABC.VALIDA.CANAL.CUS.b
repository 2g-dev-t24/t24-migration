* @ValidationCode : MjotNjk2Mzg5ODU6Q3AxMjUyOjE3NDUyODAxMDAxMTk6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2025 21:01:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.CANAL.CUS
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.VALIDA.CANAL.CUS
* Objetivo:             Rutina que valida que el usuario corresponda al canal
*      del registro
* Desarrollador:        C�sar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC CAPITAL
* Fecha Creacion:       19 - May - 2020
* Modificaciones:
*-----------------------------------------------------------------------------

    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer

    GOSUB INICIALIZA
    GOSUB VALIDA.USUARIO

RETURN

***********
INICIALIZA:
***********

    Y.APP.LOC = 'CUSTOMER'
    Y.FIELD.LOC = 'CANAL'
    Y.POS.LOC = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.FIELD.LOC, Y.POS.LOC)

    YPOS.CANAL = Y.POS.LOC<1,1>
RETURN

***************
VALIDA.USUARIO:
***************
 
    Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.CANAL = Y.LOCAL.REF<1,YPOS.CANAL>

    ABC.BP.AbcValidaCanal(Y.CANAL, Y.ERROR)
    IF Y.ERROR NE '' THEN
        EB.SystemTables.setEtext(Y.ERROR)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

END
