* @ValidationCode : Mjo1MzQ2MjY4Nzg6Q3AxMjUyOjE3NTQ1MzE4OTY1MjE6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Aug 2025 22:58:16
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
$PACKAGE AbcAccount
SUBROUTINE ABC.VAL.PORC.BENEF.N4L
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
 
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.POS.BEN.PORCENTAJE = ''
    Y.TOTAL.PORCENTAJE = ''
    Y.PORCENTAJES = ''
    Y.NO.BENEF = ''
    Y.MAX.BENEF = 5

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------


    Y.PORCENTAJES = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.BenPorcentaje)
    
    CHANGE @SM TO @FM IN Y.PORCENTAJES

    IF Y.PORCENTAJES THEN

        Y.NO.BENEF = DCOUNT(Y.PORCENTAJES, @FM)

        IF Y.NO.BENEF GT Y.MAX.BENEF THEN
            ETEXT = 'SOLO ES POSIBLE CAPTURAR COMO MAXIMO CINCO BENEFICIARIOS'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

        FOR I=1 TO Y.NO.BENEF
            Y.TOTAL.PORCENTAJE += Y.PORCENTAJES<I>
        NEXT I

        IF Y.TOTAL.PORCENTAJE NE 100 THEN
            ETEXT = 'LA SUMATORIA DE PORCENTAJE ASIGNADO A LOS BENEFICIARIOS ES DIFERENTE AL 100%'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END


RETURN

END
