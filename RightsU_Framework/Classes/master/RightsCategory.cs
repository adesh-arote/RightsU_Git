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
public class RightsCategory : Persistent
{
    public RightsCategory()
    {
        OrderByColumnName = "rights_category_code";
        OrderByCondition = "ASC";
        tableName = "rights_category";
        pkColName = "rights_category_code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _RightsCategoryName;
    public string RightsCategoryName
    {
        get { return this._RightsCategoryName; }
        set { this._RightsCategoryName = value; }
    }

    private int _ParentCategoryCode;
    public int ParentCategoryCode
    {
        get { return this._ParentCategoryCode; }
        set { this._ParentCategoryCode = value; }
    }

    private string _IsSystemGenerated;
    public string IsSystemGenerated
    {
        get { return this._IsSystemGenerated; }
        set { this._IsSystemGenerated = value; }
    }

    private string _RightsCategoryPlatforms;
    public string RightsCategoryPlatforms
    {
        get { return this._RightsCategoryPlatforms; }
        set { this._RightsCategoryPlatforms = value; }
    }

    private string _PlatformCodes;
    public string PlatformCodes
    {
        get { return this._PlatformCodes; }
        set { this._PlatformCodes = value; }
    }
    private Boolean _IsTabSelected;
    public Boolean IsTabSelected
    {
        get { return this._IsTabSelected; }
        set { this._IsTabSelected = value; }
    }

    private RightsCategory _objRightsCategory;
    public RightsCategory objRightsCategory
    {
        get
        {
            if (_objRightsCategory == null)
                this._objRightsCategory = new RightsCategory();
            return _objRightsCategory;
        }
        set { _objRightsCategory = value; }
    }

    private ArrayList _arrRightsCategoryPlatforms;
    public ArrayList arrRightsCategoryPlatforms
    {
        get
        {
            if (this._arrRightsCategoryPlatforms == null)
                this._arrRightsCategoryPlatforms = new ArrayList();
            return this._arrRightsCategoryPlatforms;
        }
        set
        { this._arrRightsCategoryPlatforms = value; }
    }

    private ArrayList _arrRightsCategoryPlatforms_del;
    public ArrayList arrRightsCategoryPlatforms_del
    {
        get
        {
            if (this._arrRightsCategoryPlatforms_del == null)
                this._arrRightsCategoryPlatforms_del = new ArrayList();
            return this._arrRightsCategoryPlatforms_del;
        }
        set
        { this._arrRightsCategoryPlatforms_del = value; }
    }

    private ArrayList _arrChilRightsCategoryPlatforms;
    public ArrayList arrChilRightsCategoryPlatforms
    {
        get
        {
            if (this._arrChilRightsCategoryPlatforms == null)
                this._arrChilRightsCategoryPlatforms = new ArrayList();
            return this._arrChilRightsCategoryPlatforms;
        }
        set
        { this._arrChilRightsCategoryPlatforms = value; }
    }


    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new RightsCategoryBroker();
    }

    public override void LoadObjects()
    {
        if (this.ParentCategoryCode > 0)
        {
            this.objRightsCategory.IntCode = this.ParentCategoryCode;
            this.objRightsCategory.Fetch();
        }

        this.arrRightsCategoryPlatforms = DBUtil.FillArrayList(new RightsCategoryPlatforms(), " and rights_category_code='" + this.IntCode + "'", true);
        this.arrRightsCategoryPlatforms_del = DBUtil.FillArrayList(new RightsCategoryPlatforms(), " and rights_category_code='" + this.IntCode + "'", false);
        this.arrChilRightsCategoryPlatforms = DBUtil.FillArrayList(new RightsCategory(), " and parent_category_code='" + this.IntCode + "'", false);
        if (this.arrRightsCategoryPlatforms.Count > 0)
        {
            foreach (RightsCategoryPlatforms obj in this.arrRightsCategoryPlatforms)
            {
                RightsCategoryPlatforms += obj.objPlatform.PlatformName + ",";
                PlatformCodes += obj.PlatformsCode + ",";
            }
            RightsCategoryPlatforms = RightsCategoryPlatforms.Trim(',');
            PlatformCodes = PlatformCodes.Trim(',');
        }
    }

    public override void UnloadObjects()
    {
        if (this.arrRightsCategoryPlatforms_del != null)
        {
            foreach (RightsCategoryPlatforms objRightsCategoryPlatforms in this.arrRightsCategoryPlatforms_del)
            {
                objRightsCategoryPlatforms.IsTransactionRequired = true;
                objRightsCategoryPlatforms.SqlTrans = this.SqlTrans;
                objRightsCategoryPlatforms.IsDeleted = true;
                objRightsCategoryPlatforms.Save();
            }
        }

        if (this.arrRightsCategoryPlatforms != null)
        {
            foreach (RightsCategoryPlatforms objRightsCategoryPlatforms in this.arrRightsCategoryPlatforms)
            {
                objRightsCategoryPlatforms.RightsCategoryCode = this.IntCode;
                objRightsCategoryPlatforms.IsTransactionRequired = true;
                objRightsCategoryPlatforms.SqlTrans = this.SqlTrans;
                if (objRightsCategoryPlatforms.IntCode > 0)
                    objRightsCategoryPlatforms.IsDirty = true;
                objRightsCategoryPlatforms.Save();
            }
        }
    }

  
    #endregion
}
