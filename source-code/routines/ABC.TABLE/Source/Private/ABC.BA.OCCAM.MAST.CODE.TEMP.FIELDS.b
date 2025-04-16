* @ValidationCode : MjoxMzY3MTU0OTY0OkNwMTI1MjoxNzQ0ODIzNzU1ODQ2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Apr 2025 14:15:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
SUBROUTINE ABC.BA.OCCAM.MAST.CODE.TEMP.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Template
    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = ""; ID.CONCATFILE = ""

*-----------------------------------------------------------------------------

    ID.F = "ID";       ID.N = "50.18.C";       ID.T = "A";

    Z = 0

    Z+ =1;      F(Z) = "FEC.CREACION";   N(Z) = "11";     T(Z)<1> = "D";  T(Z)<3> = 'NOINPUT'
    Z+ =1;      F(Z) = "FEC.ENVIO";      N(Z) = "11";     T(Z)<1> = "D";  T(Z)<3> = 'NOINPUT'
    Z+ =1;      F(Z) = "XX<TIPO.ARCH";   N(Z) = "20";     T(Z)<1> = "A";  T(Z)<3> = 'NOINPUT'
    Z+ =1;      F(Z) = "XX-CODIGO";      N(Z) = "20";     T(Z)<1> = "A";  T(Z)<3> = 'NOINPUT'
    Z+ =1;      F(Z) = "XX>DESC.ARCH";   N(Z) = "180";    T(Z)<1> = "A";  T(Z)<3> = 'NOINPUT'

    V = Z + 9;   PREFIX = "MCT"


END

