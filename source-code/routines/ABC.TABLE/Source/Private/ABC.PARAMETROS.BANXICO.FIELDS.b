* @ValidationCode : MjotNjU4MDQ3NjgyOkNwMTI1MjoxNzUwMjk3Mjk1MDczOkx1Y2FzRmVycmFyaTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Jun 2025 22:41:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
SUBROUTINE ABC.PARAMETROS.BANXICO.FIELDS
    
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdN('6.6')
    EB.SystemTables.setIdT('A')
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('BANXICO.NUM.BANCO', '3', 'A', '')
    
    EB.Template.TableAddfielddefinition('CTA.NOSTRO', '13..C', 'ACC', '')
    EB.Template.FieldSetcheckfile('ACCOUNT')
    
    EB.Template.TableAddfielddefinition('CTA.NOSTRO.USD', '13..C', 'ACC', '')
    EB.Template.FieldSetcheckfile('ACCOUNT')
    
    EB.Template.TableAddfielddefinition('BANXICO.PLAZA', '3.3', '', '')
    
    EB.Template.TableAddfielddefinition('BANXICO.ACCOUNT', '20', 'A', '')
    
    EB.Template.TableAddfielddefinition('BANXICO.NOMBRE.BANCO', '35', 'A', '')
    
    EB.Template.TableAddfielddefinition('PLAZA.SPEUA', '5', 'A', '')
    
    EB.Template.TableAddfielddefinition('TIPO.CTA.SPEUA', '3', 'A', '')
    
    EB.Template.TableAddfielddefinition('MIN.AMOUNT.SPEUA', '20', '', '')
    
    EB.Template.TableAddfielddefinition('MAX.AMOUNT.SPEUA.AUT', '20', '', '')
    
    EB.Template.TableAddfielddefinition('IMAGES.PATH', '60', 'A', '')
    
    EB.Template.TableAddfielddefinition('FILES.PATH', '60', 'A', '')
    
    EB.Template.TableAddfielddefinition('SPEUA.DEVOL.REC', '60', 'A', '')
    
    EB.Template.TableAddfielddefinition('SPEUA.ORD.REC', '60', 'A', '')
    
    EB.Template.TableAddfielddefinition('SPEUA.ORD.REC.DEVOL', '60', 'A', '')
    
    EB.Template.TableAddfielddefinition('CECOBAN.REC', '60', 'A', '')
    
    EB.Template.TableAddfielddefinition('CECOBAN.REC.DEV', '60', 'A', '')
    
    EB.Template.TableAddfielddefinition('XX<ACCT.REST', '2', '', '')
    EB.Template.FieldSetcheckfile('POSTING.RESTRICT')
    
    EB.Template.TableAddfielddefinition('XX>REJ.CODE', '2', 'A', '')
    EB.Template.FieldSetcheckfile('ABC.MO.DE.CE')
        
    EB.Template.TableAddfielddefinition('OFS.SRCE.PAGADOS', '20', 'A', '')
    EB.Template.FieldSetcheckfile('OFS.SOURCE')
    
    EB.Template.TableAddfielddefinition('COMM.TYPE.CHQ.DEV', '11', 'A', '')
    EB.Template.FieldSetcheckfile('FT.COMMISSION.TYPE')
    
    EB.Template.TableAddfielddefinition('CUST.DR.CHQ.DEV', '3', 'A', '')
    EB.Template.FieldSetcheckfile('TRANSACTION')
    
    EB.Template.TableAddfielddefinition('CUST.CR.CHQ.DEV', '3', 'A', '')
    EB.Template.FieldSetcheckfile('TRANSACTION')
    
    EB.Template.TableAddfielddefinition('IMAGE.TYPE', '2', '', '')
    
    EB.Template.TableAddfielddefinition('IMAGE.OFS.VERSION', '40', 'A', '')
    EB.Template.FieldSetcheckfile('VERSION')
    
    EB.Template.TableAddfielddefinition('IMAGE.OFS.SOURCE', '40', 'A', '')
    EB.Template.FieldSetcheckfile('OFS.SOURCE')
    
    EB.Template.TableAddfielddefinition('IMAGE.POST.MAINT', '3', '', '')
    
    EB.Template.TableAddfielddefinition('IMAGE.REC.PATH', '60', 'A', '')
    
    EB.Template.TableAddfielddefinition('AMT.IMG.MXN', '20', 'AMT', '')
    
    EB.Template.TableAddfielddefinition('AMT.IMG.USD', '20', 'AMT', '')
    
    EB.Template.TableAddfielddefinition('TT.TXN.DEP.MXN', '3', '', '')
    EB.Template.FieldSetcheckfile('TELLER.TRANSACTION')
    
    EB.Template.TableAddfielddefinition('TT.TXN.DEP.USD', '3', '', '')
    EB.Template.FieldSetcheckfile('TELLER.TRANSACTION')
    
    EB.Template.TableAddfielddefinition('CTA.BNK.DEP.USD', '13..C', 'ACC', '')
    EB.Template.FieldSetcheckfile('ACCOUNT')
    
    EB.Template.TableAddfielddefinition('COMM.TYPE.REMESA', '11', 'A', '')
    EB.Template.FieldSetcheckfile('FT.COMMISSION.TYPE')
    
    EB.Template.TableAddfielddefinition('COMM.TYPE.REM.DEV', '11', 'A', '')
    EB.Template.FieldSetcheckfile('FT.COMMISSION.TYPE')
    
    EB.Template.TableAddfielddefinition('CATEG.REMESA', '5', '', '')
    EB.Template.FieldSetcheckfile('CATEGORY')
    
    EB.Template.TableAddfielddefinition('CATEG.DOCTOS', '5', '', '')
    EB.Template.FieldSetcheckfile('CATEGORY')
    
    EB.Template.TableAddfielddefinition('REM.CHK.PAID', '2', 'A', '')
*    CHECKFILE(Z)="VPM.2BR.CTLG.OP.REMESAS":FM:VPM.OP.REM.DESCRIPCION:FM:'A.'
    
    EB.Template.TableAddfielddefinition('TXN.CDE.REMESAS', '3', 'A', '')
    EB.Template.FieldSetcheckfile('TRANSACTION')
    
    EB.Template.TableAddfielddefinition('TXN.CDE.REM.REJ', '3', 'A', '')
    EB.Template.FieldSetcheckfile('TRANSACTION')
    
    EB.Template.TableAddfielddefinition('CTA.NOSTRO.REM', '13..C', 'ACC', '')
    EB.Template.FieldSetcheckfile('ACCOUNT')
*-----------------------------------------------------------------------------
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------
END
