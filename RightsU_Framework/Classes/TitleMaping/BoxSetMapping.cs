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
public class BoxSetMapping : Persistent
{
    public BoxSetMapping()
    {
        OrderByColumnName = "box_mapping_code";
        OrderByCondition = "ASC";
        tableName = "Box_Set_Mapping";
        pkColName = "box_mapping_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _BoxsetExternalTitleCode;
    public int BoxsetExternalTitleCode
    {
        get { return this._BoxsetExternalTitleCode; }
        set { this._BoxsetExternalTitleCode = value; }
    }

    private string _MappingType;
    public string MappingType
    {
        get { return this._MappingType; }
        set { this._MappingType = value; }
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

    private ArrayList _arrBoxSetMappingTitles_Del;
    public ArrayList arrBoxSetMappingTitles_Del
    {
        get
        {
            if (this._arrBoxSetMappingTitles_Del == null)
                this._arrBoxSetMappingTitles_Del = new ArrayList();
            return this._arrBoxSetMappingTitles_Del;
        }
        set { this._arrBoxSetMappingTitles_Del = value; }
    }

    private ArrayList _arrBoxSetMappingTitles;
    public ArrayList arrBoxSetMappingTitles
    {
        get
        {
            if (this._arrBoxSetMappingTitles == null)
                this._arrBoxSetMappingTitles = new ArrayList();
            return this._arrBoxSetMappingTitles;
        }
        set { this._arrBoxSetMappingTitles = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new BoxSetMappingBroker();
    }

    public override void LoadObjects()
    {

        if (this.BoxsetExternalTitleCode > 0)
        {
            this.objExternalTitle.IntCode = this.BoxsetExternalTitleCode;
            this.objExternalTitle.Fetch();
        }

        this.arrBoxSetMappingTitles = DBUtil.FillArrayList(new BoxSetMappingTitles(), " and box_mapping_code = '" + this.IntCode + "'", true);

    }

    public override void UnloadObjects()
    {

        if (arrBoxSetMappingTitles_Del != null)
        {
            foreach (BoxSetMappingTitles objBoxSetMappingTitles in this.arrBoxSetMappingTitles_Del)
            {
                objBoxSetMappingTitles.IsTransactionRequired = true;
                objBoxSetMappingTitles.SqlTrans = this.SqlTrans;
                objBoxSetMappingTitles.IsDeleted = true;
                objBoxSetMappingTitles.Save();
            }
        }
        if (arrBoxSetMappingTitles != null)
        {
            foreach (BoxSetMappingTitles objBoxSetMappingTitles in this.arrBoxSetMappingTitles)
            {
                objBoxSetMappingTitles.BoxMappingCode = this.IntCode;
                objBoxSetMappingTitles.IsTransactionRequired = true;
                objBoxSetMappingTitles.SqlTrans = this.SqlTrans;
                if (objBoxSetMappingTitles.IntCode > 0)
                    objBoxSetMappingTitles.IsDirty = true;
                objBoxSetMappingTitles.Save();
            }
        }
    }

    #endregion
}
