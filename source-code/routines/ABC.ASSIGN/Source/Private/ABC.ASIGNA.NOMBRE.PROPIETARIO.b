* @ValidationCode : MjoyMDY5NDk3MDpDcDEyNTI6MTc1MTUwODEyMTA0ODpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Jul 2025 23:02:01
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
$PACKAGE AbcAssign
SUBROUTINE ABC.ASIGNA.NOMBRE.PROPIETARIO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*$INSERT ../T24_BP I_COMMON*
*$INSERT ../T24_BP I_EQUATE
*$INSERT ../T24_BP I_F.ACCOUNT
*$INSERT ABC.BP I_F.ET.SAP.TARJETA


*Y.NOMBRE.TITULAR=''
*Y.NOMBRE.TITULAR=R.NEW(CRD.TITULAR.ID)
*R.NEW(CRD.NOMBRE.PROPIETARIO)=Y.NOMBRE.TITULAR

*RETURN
END
