* @ValidationCode : MjotMTU2OTYzMTExOkNwMTI1MjoxNzQ0MTYwMzY2Mjc4OlVzaWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Apr 2025 19:59:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usiario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------
*========================================================================
SUBROUTINE ABC.VAL.POST.REST(Y.ID.ACCT)
*=======================================================================
*   Creado por  : Omar Basabe
*   Fecha       : Octubre 2015
*   Descripcion : No Permite Retirar de las cuentas si estan Embargadas.
*   Modificado por : SFE
*   Fecha: Julio 2020
*   Descripción: Se limpia código y se agrega la validación por todos los códigos que tengan
*   tipo de restricción ALL en la aplicación POSTING.REESTRICT
*========================================================================
*    $INCLUDE ../T24_BP I_COMMON
*    $INCLUDE ../T24_BP I_EQUATE
*    $INCLUDE ../T24_BP I_F.ACCOUNT
*    $INCLUDE ../T24_BP I_F.POSTING.RESTRICT

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING AC.Config
    $USING ABC.BP

*************************************************************************
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN

**********
INITIALIZE:
**********************


    Y.APPL = EB.SystemTables.getApplication();
*    Y.CLAVE.EMBARGO = "84"

    FN.ACCT="F.ACCOUNT"
    F.ACCT  = ""
    EB.DataAccess.Opf(FN.ACCT,F.ACCT)

    FN.POST="F.POSTING.RESTRICT"
    F.POST=""
    EB.DataAccess.Opf(FN.POST,F.POST)

RETURN

********
PROCESS:
********

    Y.POST.REST=''
    R.POST=''
    ERR.POST=''
    Y.REST.TYPE=''

    REC.ACCT = AC.AccountOpening.Account.Read(Y.ID.ACCT, ERR.ACCT)
*Y.POST.REST = REC.ACCT<AC.POSTING.RESTRICT>
    Y.AVAIL.BAL = REC.ACCT<AC.AccountOpening.Account.PostingRestrict>
    IF Y.POST.REST NE "" THEN

        EB.DataAccess.FRead(FN.POST, Y.POST.REST, R.POST, F.POST, ERR.POST)
*Y.REST.TYPE = R.POST<AC.POS.RESTRICTION.TYPE>
        Y.REST.TYPE = R.POST<AC.Config.PostingRestrict.PosRestrictionType>
        IF Y.REST.TYPE EQ 'ALL' THEN
*COMI = ""
            EB.SystemTables.setComi("");
*ETEXT = "La Cuenta: ":Y.ID.ACCT:" tiene restricciones"
            EB.SystemTables.setEtext("La Cuenta: ":Y.ID.ACCT:" tiene restricciones")
            EB.ErrorProcessing.StoreEndError()
        END

        RETURN
    END
