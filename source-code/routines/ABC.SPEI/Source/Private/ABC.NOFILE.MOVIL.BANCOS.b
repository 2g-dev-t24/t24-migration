$PACKAGE ABC.BP
SUBROUTINE ABC.NOFILE.MOVIL.BANCOS(R.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.Template
    
    GOSUB INICIALIZA
    GOSUB PROCESA
    GOSUB FINAL
    
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.LOOKUP    = 'F.EB.LOOKUP'
    F.LOOKUP    = ''
    EB.DataAccess.Opf(FN.LOOKUP,F.LOOKUP)

    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    R.DATA = ''
    Y.SEP = '*'

RETURN

*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------

    Y.SEL.CMD = "SELECT " : FN.LOOKUP : " @ID LIKE CLB.BANK.CODE*..."
    Y.REG.LIST = '' ; Y.NO.REG = ''
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
    
    Y.I = 1
    Y.COUNT = 0
    LOOP
    WHILE Y.I LE Y.NO.REG
        Y.REG.ACT = Y.REG.LIST<Y.I>
        Y.R.EB.LOOKUP	= EB.Template.Lookup.Read(Y.REG.ACT, Y.READ.ERROR)
        IF Y.R.EB.LOOKUP NE '' THEN
            Y.LOOKUP.ID = Y.R.EB.LOOKUP<EB.Template.Lookup.LuLookupId>
            
            GOSUB OBTEN.CAMPOS.ADICIONALES
            
            IF Y.LOOKUP.ID NE '' AND Y.BAN.ESTATUS EQ 'A' THEN
                Y.COUNT++
                R.DATA<Y.COUNT> = Y.LOOKUP.ID : Y.SEP : Y.TIPO : Y.SEP : Y.BAN.ESTATUS
            END
        END
        Y.I++
    REPEAT

RETURN

*---------------------------------------------------------------
OBTEN.CAMPOS.ADICIONALES:
*---------------------------------------------------------------

    Y.TIPO = ''
    Y.BAN.ESTATUS = ''
    
    Y.DATA.NAME = Y.R.EB.LOOKUP<EB.Template.Lookup.LuDataName>
    Y.DATA.VALUES = Y.R.EB.LOOKUP<EB.Template.Lookup.LuDataValue>
    
    LOCATE 'TIPO' IN Y.DATA.NAME<1,1> SETTING Y.POS.TIPO THEN
        Y.TIPO = Y.DATA.VALUES<1,Y.POS.TIPO>
    END
    
    LOCATE 'BAN.ESTATUS' IN Y.DATA.NAME<1,1> SETTING Y.POS.ESTATUS THEN
        Y.BAN.ESTATUS = Y.DATA.VALUES<1,Y.POS.ESTATUS>
    END

RETURN

*---------------------------------------------------------------
FINAL:
*---------------------------------------------------------------

END
