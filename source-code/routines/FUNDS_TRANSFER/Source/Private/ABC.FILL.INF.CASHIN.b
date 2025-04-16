* @ValidationCode : MjoxMzgzMDY2NzA2OkNwMTI1MjoxNzQ0NzM0ODYxMDE1OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Apr 2025 11:34:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.FILL.INF.CASHIN
*===============================================================================
* Nombre de Programa : ABC.FILL.INF.CASHIN
* Compania           : ABC Capital
* Objetivo           : Rutina que guarda informacion en FT
* Desarrollador      : Fyg Solutions
* Fecha Creacion     : 2022-08-08
* Componente T24     : FUNDS.TRANSFER,ABC.COMISIONISTA.CASH.IN
* Modificaciones     :
*===============================================================================

*    $INSERT ../T24_BP I_COMMON
*    $INSERT ../T24_BP I_EQUATE
*    $INSERT ../T24_BP I_F.FUNDS.TRANSFER
*    $INSERT ../T24_BP I_F.ACCOUNT
*
*    $INCLUDE ABC.BP I_F.ABC.COMISIONISTAS
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.Updates
*-----------------------------------------------------------------------------
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

RETURN

*---------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------

*    FN.ABC.COMISIONISTAS = 'F.ABC.COMISIONISTAS'
*    F.ABC.COMISIONISTAS = ''
*    CALL OPF(FN.ABC.COMISIONISTAS,F.ABC.COMISIONISTAS)

*    CALL GET.LOCAL.REFM('FUNDS.TRANSFER','ID.COMI',Y.POS.ID)
    applications     = ""
    fields           = ""
    applications<1>  = "FUNDS.TRANSFER"
    fields<1,1>      = "D.COMI"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    Y.POS.ID     = field_Positions<1,1>
RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.COMISIONISTA = ''
    REC.COMISIONISTA = ''
    Y.ERR.COMISIONISTA = ''

    Y.COMISIONISTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.ID> ;*R.NEW(FT.LOCAL.REF)<1,Y.POS.ID>

*    CALL F.READ(FN.ABC.COMISIONISTAS,Y.COMISIONISTA,REC.COMISIONISTA,F.ABC.COMISIONISTAS,Y.ERR.COMISIONISTA)
    REC.COMISIONISTA = ABC.BP.AbcComisionistas.Read(Y.COMISIONISTA, Y.ERR.COMISIONISTA)

    IF Y.ERR.COMISIONISTA THEN
        RETURN
    END

    Y.AC.NOMBRE.COMI = ''
    Y.AC.NOMBRE.COMI = REC.COMISIONISTA<ABC.BP.AbcComisionistas.NombreComi>     ;*<AC.NOMBRE.COMI>
*    R.NEW(FT.EXTEND.INFO) = 'Deposito en ' : Y.AC.NOMBRE.COMI
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.ExtendInfo, 'Deposito en ' : Y.AC.NOMBRE.COMI)

RETURN

*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

RETURN

END
