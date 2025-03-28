* @ValidationCode : MjoxODE1MzI3ODkwOkNwMTI1MjoxNzQzMTI2NTcyOTI2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Mar 2025 22:49:32
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
SUBROUTINE ABC.ASSIGN.DAO.CUST
*----------------------------------------------------
*  Subroutine:         BAM.ASSIGN.DAO.CUST
*  Objective:          This routine assigns the ACCOUNT.OFFICER
*                      got from the user to the CUSTOMER
*                      versions
*  First Released For: Banco Autofin Mexico, S.A.
*  First Released:     June/21/2006
*  Author:             Fabian Gamboa
*----------------------------------------------------


*  $INCLUDE ../T24_BP I_COMMON
*  $INCLUDE ../T24_BP I_EQUATE
*  $INCLUDE ../T24_BP I_F.CUSTOMER
*  $INCLUDE ../T24_BP I_F.USER
    
*------------------------------
* Main Program Loop
*------------------------------
* El campo para el DAO en CUSTOMER lo voy a llenar con el campo del DAO del registro del USER
* R.NEW(EB.CUS.ACCOUNT.OFFICER) = R.USER<EB.USE.DEPARTMENT.CODE>
* CALL REBUILD.SCREEN
* RETURN
    
END
