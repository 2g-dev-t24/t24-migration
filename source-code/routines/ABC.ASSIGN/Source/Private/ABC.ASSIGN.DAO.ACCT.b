* @ValidationCode : MjoyMjUzOTUzODg6Q3AxMjUyOjE3NDMxMjY1NjA1MzY6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Mar 2025 22:49:20
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
SUBROUTINE ABC.ASSIGN.DAO.ACCT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* $INCLUDE ../T24_BP I_COMMON
* $INCLUDE ../T24_BP I_EQUATE
* $INCLUDE ../T24_BP I_F.ACCOUNT
* $INCLUDE ../T24_BP I_F.USER

*R.NEW(AC.ACCOUNT.OFFICER) = R.USER<EB.USE.DEPARTMENT.CODE>
*CALL REBUILD.SCREEN

*RETURN
END
