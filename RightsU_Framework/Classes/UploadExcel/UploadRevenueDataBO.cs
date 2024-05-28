using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for uploadRegionData
/// </summary>
public class UploadRevenueDataBO : IExcelUploadable
{
    public UploadRevenueDataBO()
    {
        //
        // TODO: Add constructor logic here
        //

    }
    public UploadRevenueDataBO(int logonUserCode)
    {
        //
        // TODO: Add constructor logic here
        //
        logOnUserCode = logonUserCode;
    }

    int logOnUserCode = 0;
    #region IExcelUploadable Members

    System.Collections.ArrayList IExcelUploadable.getFileHeaderList()
    {
        return GlobalParams.arrRevenueForBO();
    }

    string IExcelUploadable.frmUploadFileType()
    {
        return "RBO";
    }

    int IExcelUploadable.logonUser()
    {
        return logOnUserCode;
    }

    bool IExcelUploadable.writeToDBTableAfterSuccess(Table dtSuccess, Page senderWebForm, int uploadedBy, long uploadedFileId, DataSet ds, int bankCode)
    {
        RevenueDataBO objRevenueDataBO = new RevenueDataBO();
        string errRet = "";

        foreach (TableRow dr in dtSuccess.Rows)
        {
            objRevenueDataBO = new RevenueDataBO();
            //dr.Cells[0]; Movie Name
            objRevenueDataBO.TitleCodeId = Convert.ToString(dr.Cells[1].Text);
            objRevenueDataBO.FromDate = Convert.ToString(dr.Cells[2].Text);            
            objRevenueDataBO.Revenue = Convert.ToDecimal(dr.Cells[3].Text);
            errRet = objRevenueDataBO.Save();
        }

        return false;
    }

    #endregion
}
