* @ValidationCode : MjozNjcwOTAyMzg6Q3AxMjUyOjE3NDQ4Mzk0MTA1ODg6bWFyY286LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Apr 2025 16:36:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : marco
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
*-----------------------------------------------------------------------------
* <Rating>99</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE VPM.CC.CHECK.CUSTNO.DR
*-----------------------------------------------------------------------
* Marco Dávila
* 16-abr-2025
* Se realiza componetización de código
*-----------------------------------------------------------------------
* $INSERT I_COMMON  ;* Not Used anymore
* $INSERT I_EQUATE  ;* Not Used anymore
* $INSERT I_F.USER  ;* Not Used anymore
* $INSERT I_F.ACCOUNT  ;* Not Used anymore
* $INSERT I_F.VPM.2BR.CC.MORAL - Not Used anymore;
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING EB.Security
    $USING ABC.BP

*    EB.LocalReferences.GetLocRef("USER","CC.CUST.ID",YUSER.CUST.LR)
    applications     = ""
    fields           = ""
    applications<1>  = "USER"
    fields<1,1>      = "CC.CUST.ID"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications, fields, field_Positions)
    YUSER.CUST.LR = field_Positions<1,1>
*ITSS-SANGAVI-START
*    CALL DBR("USER":FM:EB.USE.LOCAL.REF,OPERATOR,YLOCAL.FLD)
    YLOCAL.FLD = EB.SystemTables.getRUser()<EB.Security.User.UseLocalRef>
*ITSS-SANGAVI-END
    YUSER.CC.CUST = YLOCAL.FLD<1,YUSER.CUST.LR>
    YUSER.CUST = FIELD(YUSER.CC.CUST,'.',1)


    IF NOT(TRIM(YUSER.CUST)) THEN
        EB.SystemTables.setE('NO EXISTE UNA LLAMADA ACTIVA')
        EB.ErrorProcessing.Err()
        EB.SystemTables.setComi('')
        RETURN
    END

*   *PIF - VERIFICACION PARA PERSONAS MORALES
    IF YUSER.CC.CUST[11,1] = "." THEN
        F.VPM.2BR.CC.MORAL = ''
        FN.VPM.2BR.CC.MORAL = 'F.VPM.2BR.CC.MORAL'
        EB.DataAccess.Opf(FN.VPM.2BR.CC.MORAL,F.VPM.2BR.CC.MORAL)
        YREC.CC.MORAL = ""
*        READ YREC.CC.MORAL FROM F.VPM.2BR.CC.MORAL,YUSER.CC.CUST ELSE NULL
        YERR = ''
        EB.DataAccess.FRead(FN.VPM.2BR.CC.MORAL,YUSER.CC.CUST,YREC.CC.MORAL,F.VPM.2BR.CC.MORAL,YERR)
    END

    IF YUSER.CC.CUST[11,1] = "." THEN
        LOCATE EB.SystemTables.getComi() IN YREC.CC.MORAL<ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralAccount,1> SETTING YPOS.ACCT THEN
            IF YREC.CC.MORAL<ABC.BP.Vpm2brCcMoral.Vpm2brCcMoralTransaction,YPOS.ACCT> EQ 'N' THEN
                EB.SystemTables.setE("CLIENTE NO ESTA AUTORIZADO A OPERAR CON CUENTA")
                EB.ErrorProcessing.Err()
                EB.SystemTables.setComi('')
            END
        END ELSE

            EB.SystemTables.setE("CUENTA NO CORRESPONDE A CLIENTE")
            EB.ErrorProcessing.Err()
            EB.SystemTables.setComi('')
        END



    END ELSE

        YACCT = EB.SystemTables.getComi()
        EB.DataAccess.Dbr("ACCOUNT":@FM:AC.AccountOpening.Account.Customer,YACCT,YCUSTOMER)
        EB.SystemTables.setE('')
        IF YCUSTOMER NE YUSER.CUST THEN
            EB.SystemTables.setE("CUENTA NO CORRESPONDE A CLIENTE")
            EB.ErrorProcessing.Err()
            EB.SystemTables.setComi('')
        END
    END
RETURN
END

