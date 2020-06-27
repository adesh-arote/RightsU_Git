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
public class BoxSetMappingTitles : Persistent
{
    public BoxSetMappingTitles()
    {
        OrderByColumnName = "box_mapping_titles_code";
        OrderByCondition = "ASC";
        tableName = "Box_Set_Mapping_Titles";
        pkColName = "box_mapping_titles_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _BoxMappingCode;
    public int BoxMappingCode
    {
        get { return this._BoxMappingCode; }
        set { this._BoxMappingCode = value; }
    }

    private int _ExternalTitleCode;
    public int ExternalTitleCode
    {
        get { return this._ExternalTitleCode; }
        set { this._ExternalTitleCode = value; }
    }

    private decimal _percentage;
    public decimal percentage
    {
        get { return this._percentage; }
        set { this._percentage = value; }
    }

    private ExternalTitle _objExternalTitle;
    public ExternalTitle objExternalTitle
    {
        get
        {
            if (this._objExternalTitle == null)
                this._objExternalTitle = new ExternalTitle();
            return this._objExternalTitle;
        }
        set { this._objExternalTitle = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new BoxSetMappingTitlesBroker();
    }

    public override void LoadObjects()
    {

        if (this.ExternalTitleCode > 0)
        {
            this.objExternalTitle.IntCode = this.ExternalTitleCode;
            this.objExternalTitle.Fetch();
        }

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
