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
public class UploadRevenueDataHomeVideo : IExcelUploadable
{
    public UploadRevenueDataHomeVideo()
    {
        //
        // TODO: Add constructor logic here
        //

    }
    public UploadRevenueDataHomeVideo(int logonUserCode)
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
        return GlobalParams.arrRevenueForHomeVideo();
    }

    string IExcelUploadable.frmUploadFileType()
    {
        return "RH";
    }

    int IExcelUploadable.logonUser()
    {
        return logOnUserCode;
    }

    bool IExcelUploadable.writeToDBTableAfterSuccess(Table dtSuccess, Page senderWebForm, int uploadedBy, long uploadedFileId, DataSet ds, int bankCode)
    {
        RevenueDataHomeVideo objRevenueDataTheatre = new RevenueDataHomeVideo();
        string errRet = "";

        foreach (TableRow dr in dtSuccess.Rows)
        {
            objRevenueDataTheatre = new RevenueDataHomeVideo();
            objRevenueDataTheatre.DistributorVendorCode = Convert.ToInt32(dr.Cells[0].Text);
            objRevenueDataTheatre.DealMovieCode = Convert.ToInt32(dr.Cells[1].Text);
            objRevenueDataTheatre.TitleCodeId = Convert.ToString(dr.Cells[2].Text);
            objRevenueDataTheatre.FromDate = Convert.ToDateTime(dr.Cells[3].Text);
            objRevenueDataTheatre.ToDate = Convert.ToDateTime(dr.Cells[4].Text);
            objRevenueDataTheatre.GrossAmount = Convert.ToDecimal(dr.Cells[5].Text);
            objRevenueDataTheatre.Tax = Convert.ToDecimal(dr.Cells[6].Text);
            objRevenueDataTheatre.NetAmount= Convert.ToDecimal(dr.Cells[7].Text);
            objRevenueDataTheatre.Copy= Convert.ToDecimal(dr.Cells[8].Text);
            objRevenueDataTheatre.TotalRevenue = Convert.ToDecimal(dr.Cells[9].Text);
            
            errRet = objRevenueDataTheatre.Save();

        }

        return false;
    }

    #endregion
}
