* @ValidationCode : MjotNzE1OTI1MzcwOkNwMTI1MjoxNzUzMDY4NTY3NTUxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2025 00:29:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.VALIDA.ID.ADMIN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Display
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.FECHA = EB.SystemTables.getToday()
    Y.ID.ADMINISTRADOR = EB.SystemTables.getComi()
    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.TIPO.MOVIMIENTO = EB.SystemTables.getRNew(AbcTable.AbcComisionistasAdmin.TipoMovimiento)
    
    FN.ABC.COMISIONISTAS.ADMIN = "F.ABC.COMISIONISTAS.ADMIN"
    F.ABC.COMISIONISTAS.ADMIN  = ""
    EB.DataAccess.Opf(FN.ABC.COMISIONISTAS.ADMIN,F.ABC.COMISIONISTAS.ADMIN)
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    SEL.CMD = "SELECT ":FN.ABC.COMISIONISTAS.ADMIN:" WITH ID.ADMINISTRADOR EQ ":DQUOTE(Y.ID.ADMINISTRADOR)  ; * ITSS - SUNDRAM - Added DQUOTE
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)

    IF ID.LIST NE '' AND Y.ID.NEW NE ID.LIST THEN
        ETEXT = "EL ID DE ADMINISTRADOR YA EXISTE EN EL REGISTRO: ":ID.LIST
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        IF ID.LIST EQ '' AND Y.TIPO.MOVIMIENTO NE 'ALTA' THEN
            ETEXT = "CUANDO ES UN REGISTRO NUEVO SOLO SE PERMITE ALTA EN EL CAMPO TIPO MOVIMIENTO"
            EB.SystemTables.setEtext(ETEXT)
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END ELSE
            IF ID.LIST NE '' AND Y.TIPO.MOVIMIENTO EQ 'ALTA' THEN
                ETEXT = "SOLO SE PERMITE ALTA EN EL CAMPO TIPO MOVIMIENTO CUANDO ES UN REGISTRO NUEVO"
                EB.SystemTables.setEtext(ETEXT)
                EB.SystemTables.setE(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END
