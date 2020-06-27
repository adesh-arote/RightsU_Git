using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class Format : Persistent
{
    public Format()
    {

        tableName = "Format";
        pkColName = "Format_Code";
        OrderByColumnName = "Format_Name";
        OrderByCondition = "ASC";
    }

    #region ---------------Attributes And Prperties---------------


    private string _FormatName;
    public string FormatName
    {
        get { return this._FormatName; }
        set { this._FormatName = value; }
    }

    private string _FormatPlatforms;
    public string FormatPlatforms
    {
        get { return this._FormatPlatforms; }
        set { this._FormatPlatforms = value; }
    }

    private ArrayList _arrFormatPlatforms;
    public ArrayList arrFormatPlatforms
    {
        get
        {
            if (this._arrFormatPlatforms == null)
                this._arrFormatPlatforms = new ArrayList();
            return this._arrFormatPlatforms;
        }
        set { this._arrFormatPlatforms = value; }
    }

    private ArrayList _arrFormatPlatforms_Del;
    public ArrayList arrFormatPlatforms_Del
    {
        get
        {
            if (this._arrFormatPlatforms_Del == null)
                this._arrFormatPlatforms_Del = new ArrayList();
            return this._arrFormatPlatforms_Del;
        }
        set { this._arrFormatPlatforms_Del = value; }
    }

    private string _IsRefExists;
    public string IsRefExists
    {
        get { return this._IsRefExists; }
        set { this._IsRefExists = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new FormatBroker();
    }

    public override void LoadObjects()
    {
        if (this.IntCode > 0)
        {
            this.arrFormatPlatforms = DBUtil.FillArrayList(new FormatPlatforms(), " and Format_Code = '" + this.IntCode + "'", true);
            this.arrFormatPlatforms_Del = DBUtil.FillArrayList(new FormatPlatforms(), " and Format_Code = '" + this.IntCode + "'", false);

            foreach (FormatPlatforms objFormatPlatforms in this.arrFormatPlatforms)
            {
                this.FormatPlatforms += objFormatPlatforms.objPlatform.PlatformName + ",";

            }
            if (this.FormatPlatforms != null)
                this.FormatPlatforms = this.FormatPlatforms.Trim(',');

        }

    }

    public override void UnloadObjects()
    {
        if (this._arrFormatPlatforms_Del != null)
        {
            foreach (FormatPlatforms objFormatPlatforms in this._arrFormatPlatforms_Del)
            {
                objFormatPlatforms.IsTransactionRequired = true;
                objFormatPlatforms.SqlTrans = this.SqlTrans;
                objFormatPlatforms.IsDeleted = true;
                objFormatPlatforms.Save();
            }
        }

        if (this._arrFormatPlatforms != null)
        {
            foreach (FormatPlatforms objFormatPlatforms in this._arrFormatPlatforms)
            {
                objFormatPlatforms.FormatCode = this.IntCode;
                objFormatPlatforms.IsTransactionRequired = true;
                objFormatPlatforms.SqlTrans = this.SqlTrans;
                if (objFormatPlatforms.IntCode > 0)
                    objFormatPlatforms.IsDirty = true;
                objFormatPlatforms.Save();
            }
        }
    }

    //Get Platform_codes which ref exists in deal.
    public string GetPlatform_RefExists(int FormatCode)
    {
        return ((FormatBroker)this.GetBroker()).GetPlatform_RefExists(FormatCode);
    }

    #endregion
}
