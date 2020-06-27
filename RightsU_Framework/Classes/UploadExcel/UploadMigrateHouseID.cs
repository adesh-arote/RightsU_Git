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


public class UploadMigrateHouseID:IExcelUploadable
{
    public UploadMigrateHouseID()
    {
        //
        // TODO: Add constructor logic here
        //

    }
    public UploadMigrateHouseID(int logonUserCode)
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
        return GlobalParams.arrMigratCostForUpload();
    }

    string IExcelUploadable.frmUploadFileType()
    {
        return "RT";
    }

    int IExcelUploadable.logonUser()
    {
        return logOnUserCode;
    }

    bool IExcelUploadable.writeToDBTableAfterSuccess(Table dtSuccess, Page senderWebForm, int uploadedBy, long uploadedFileId, DataSet ds, int bankCode)
    {
        RevenueDataTheatre objRevenueDataTheatre = new RevenueDataTheatre();
        string errRet = "";

        foreach (TableRow dr in dtSuccess.Rows)
        {
            objRevenueDataTheatre = new RevenueDataTheatre();
            objRevenueDataTheatre.DistributorVendorCode = Convert.ToInt32(dr.Cells[0].Text);
            objRevenueDataTheatre.TheatreName = Convert.ToString(dr.Cells[1].Text);
            objRevenueDataTheatre.CityName = Convert.ToString(dr.Cells[2].Text);
            objRevenueDataTheatre.DealMovieCode = Convert.ToInt32(dr.Cells[3].Text);
            objRevenueDataTheatre.TitleCodeId = Convert.ToString(dr.Cells[4].Text);

            objRevenueDataTheatre.FromDate = Convert.ToDateTime(dr.Cells[5].Text);
            objRevenueDataTheatre.ToDate = Convert.ToDateTime(dr.Cells[6].Text);
            objRevenueDataTheatre.Days = Convert.ToInt32(dr.Cells[7].Text);
            objRevenueDataTheatre.ShowPerDay = Convert.ToDecimal(dr.Cells[8].Text);
            objRevenueDataTheatre.NoOfSeat = Convert.ToDecimal(dr.Cells[9].Text);

            objRevenueDataTheatre.TicketRate = Convert.ToDecimal(dr.Cells[10].Text);
            objRevenueDataTheatre.St = Convert.ToDecimal(dr.Cells[11].Text);
            objRevenueDataTheatre.EntTax = Convert.ToDecimal(dr.Cells[12].Text);
            objRevenueDataTheatre.NetAmount = Convert.ToDecimal(dr.Cells[13].Text);
            objRevenueDataTheatre.Revenue = Convert.ToDecimal(dr.Cells[14].Text);

            errRet = objRevenueDataTheatre.Save();

        }

        return false;
    }

    #endregion
}

