* @ValidationCode : MjoyMDU1MjczMDYyOkNwMTI1MjoxNzUzNzEzNzM1NjI0OmZyYW5jOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Jul 2025 11:42:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : franc
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE ABC.BP
***********************************************************
SUBROUTINE ABC.NOF.GET.SECTOR.ECONOMICO(R.DATA)
***********************************************************
* Ticket #128 fix codigos con id comenzado en 0

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AbcTable
    $USING EB.Reports
    $USING MXBASE.CustomerRegulatory
    
    GOSUB INIT.VARS
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

**********
INIT.VARS:
**********
    DEBUG

***se usa este separador porque se pidio caracter * en la salida
    Y.SEP        = "~"

    FN.ABC.ACTIVIDAD.ECONOMICA = 'F.ABC.ACTIVIDAD.ECONOMICA'
    F.ABC.ACTIVIDAD.ECONOMICA = ''

** Ticket #128- I
    FN.MXBASE.REGULATORY.CODES = 'F.MXBASE.REGULATORY.CODES'
    F.MXBASE.REGULATORY.CODES = ''
** Ticket #128- F

RETURN

***********
OPEN.FILES:
***********

    EB.DataAccess.Opf(FN.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA)
** Ticket #128- I
    EB.DataAccess.Opf(FN.MXBASE.REGULATORY.CODES, F.MXBASE.REGULATORY.CODES)
** Ticket #128- I

    SEL.FIELDS  = EB.Reports.getDFields()
    SEL.VALUES  = EB.Reports.getDRangeAndValue()

RETURN

********
PROCESS:
********

    LOCATE "ID.CUSTOMER" IN SEL.FIELDS SETTING IND.POS THEN
        Y.ID.CUS = SEL.VALUES<IND.POS>
    END

    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUS,CUST.ERR)
    DEBUG
    IF R.CUSTOMER EQ '' THEN
*        Y.ID.CUS = EB.SystemTables.getIdNew()
        DEFFUN System.getVariable()
        Y.ID.CUS = System.getVariable('CURRENT.ID.CUS')
        R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUS,CUST.ERR)
    END
    Y.INDUSTRY = R.CUSTOMER<ST.Customer.Customer.EbCusIndustry>
    IF LEN(Y.INDUSTRY) < 4 THEN
        Y.FILTRO = FMT(Y.INDUSTRY, "R%4")
    END

*    Y.FILTRO = Y.INDUSTRY[1,3]
    Y.FILTRO = Y.INDUSTRY[1,2]

    R.DATA = ""
    Y.CADENA.SALIDA = ""
** Ticket #128- I
*    SEL.CMD = "SELECT " : FN.ABC.ACTIVIDAD.ECONOMICA : " WITH @ID LIKE ":Y.FILTRO:"..."

    Y.FILTRO.ID = "BANXICO.ECO.ACTIVITY*":Y.FILTRO:"..."
    SEL.CMD = "SELECT " : FN.MXBASE.REGULATORY.CODES : " WITH @ID LIKE ":Y.FILTRO.ID
** Ticket #128- F

    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)

    FOR Y.I = 1 TO Y.NO.REGISTROS
        Y.ID.ACT.ECONOMICA = Y.LIST.REG<Y.I>
** Ticket #128- I
*        EB.DataAccess.FRead(FN.INDUSTRY, Y.ID.ACT.ECONOMICA, R.ABC.ACTIVIDAD.ECONOMICA, F.ABC.ACTIVIDAD.ECONOMICA, ERR.IND)
        EB.DataAccess.FRead(FN.MXBASE.REGULATORY.CODES, Y.ID.ACT.ECONOMICA, R.MXBASE.REGULATORY.CODES, F.MXBASE.REGULATORY.CODES, ERR.IND)
        
        R.DATA<-1> = Y.ID.ACT.ECONOMICA
        
*        Y.ACT.ECON.DESC = R.ABC.ACTIVIDAD.ECONOMICA<AbcTable.AbcActividadEconomica.Descripcion>
*        IF Y.ID.ACT.ECONOMICA[1,1] EQ 0 THEN
*            Y.LEN.ACT.E = LEN(Y.ID.ACT.ECONOMICA)
*            Y.ID.ACT.ECONOMICA = Y.ID.ACT.ECONOMICA[2,6]
*        END
*        Y.CADENA.SALIDA = "BANXICO.ECO.ACTIVITY*": Y.ID.ACT.ECONOMICA : Y.SEP : Y.ACT.ECON.DESC : Y.SEP
*        R.DATA<-1> = Y.CADENA.SALIDA
** Ticket #128- F
    NEXT Y.I

RETURN

END
