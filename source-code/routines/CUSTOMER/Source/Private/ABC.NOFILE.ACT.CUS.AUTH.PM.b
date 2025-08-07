$PACKAGE ABC.BP
SUBROUTINE ABC.NOFILE.ACT.CUS.AUTH.PM(R.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Customer
	$USING ST.Config
    
    GOSUB INICIALIZA
    GOSUB PROCESA
    GOSUB FINAL
    
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

   FN.CUSTOMER = "F.CUSTOMER"
   F.CUSTOMER = ""
   EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
   

   FN.CUSTOMER$NAU = "F.CUSTOMER$NAU"
   F.CUSTOMER$NAU  = ""
   EB.DataAccess.Opf(FN.CUSTOMER$NAU,F.CUSTOMER$NAU)
   
   FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER"
   F.DEPT.ACCT.OFFICER = ""
   EB.DataAccess.Opf(FN.DEPT.ACCT.OFFICER, F.DEPT.ACCT.OFFICER)


    R.DATA = ''
    Y.SEP = '*'


RETURN

*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------
    Y.SEL.CMD = "SELECT " : FN.CUSTOMER : " WITH SECTOR GE 2001 AND SECTOR LE 2014 AND CUSTOMER.TYPE EQ PROSPECT"
    Y.REG.LIST = '' ; Y.NO.REG = ''
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
    Y.ESTADO = 'Por Activar'
    GOSUB IMPRIME.TODO
    Y.ESTADO = ''
    Y.NO.REG= ''
    Y.REG.LIST = ''
    Y.SEL.CMD = "SELECT " : FN.CUSTOMER$NAU : " WITH SECTOR GE 2001 AND SECTOR LE 2014 AND CUSTOMER.TYPE EQ ACTIVE"
    Y.REG.LIST = '' ; Y.NO.REG = ''
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
    Y.ESTADO = 'Por Autorizar'
    GOSUB IMPRIME.TODO


RETURN
*---------------------------------------------------------------
IMPRIME.TODO:
*---------------------------------------------------------------
    
    Y.I = 1
    LOOP
    WHILE Y.I LE Y.NO.REG
        Y.REG.ACT = Y.REG.LIST<Y.I>
        EB.DataAccess.FRead(FN.CUSTOMER, Y.REG.ACT, R.CUSTOMER, F.CUSTOMER, CUST.ERR)
        
        IF NOT(R.CUSTOMER) THEN
           EB.DataAccess.FRead(FN.CUSTOMER$NAU, Y.REG.ACT, R.CUSTOMER, F.CUSTOMER$NAU, CUST.ERR)
        END
    
        IF NOT(R.CUSTOMER) THEN
           RETURN
        END
        Y.ID.OFFICER = R.CUSTOMER<ST.Customer.Customer.EbCusAccountOfficer>

        EB.DataAccess.FRead(FN.DEPT.ACCT.OFFICER, Y.ID.OFFICER, R.DAO, F.DEPT.ACCT.OFFICER, Y.ERR.DAO)


        Y.SHORT.NAME = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
        Y.NAME.ONE = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
        Y.NAME.TWO = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>
        Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
        Y.DAO.NAME = R.DAO<ST.Config.DeptAcctOfficer.EbDaoName>
        Y.INPUTTER = R.CUSTOMER<ST.Customer.Customer.EbCusInputter>
        Y.INPUTTER = FIELD(Y.INPUTTER, "__", 1)
        Y.INPUTTER = FIELD(Y.INPUTTER, "_", 2)
        Y.COMPANY = R.CUSTOMER<ST.Customer.Customer.EbCusCompanyBook>
        R.DATA<-1> = Y.REG.ACT:Y.SEP:Y.SHORT.NAME:Y.SEP:Y.NAME.ONE:Y.SEP:Y.NAME.TWO:Y.SEP:Y.SECTOR:Y.SEP:'Persona Moral':Y.SEP:Y.ID.OFFICER:Y.SEP:Y.DAO.NAME:Y.SEP:Y.ESTADO:Y.SEP:Y.INPUTTER:Y.SEP:Y.COMPANY
        
        Y.I++
    REPEAT

RETURN

*---------------------------------------------------------------
FINAL:
*---------------------------------------------------------------

END



