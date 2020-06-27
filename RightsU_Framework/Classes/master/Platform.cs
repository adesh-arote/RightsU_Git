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
using System.Data.SqlClient;

/// <summary>
/// Summary description for Title
/// </summary>
public class Platform : Persistent
{
    public Platform()
    {
        //OrderByColumnName = "Platform_Name";
        //OrderByCondition = "ASC";
        OrderByColumnName = "module_position";
        OrderByCondition = "ASC";

        tableName = "Platform";
        pkColName = "Platform_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _PlatformName;
    public string PlatformName
    {
        get { return this._PlatformName; }
        set { this._PlatformName = value; }
    }

    private char _IsActive;
    public char IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }

    private char _IsNoOfRun;
    public char IsNoOfRun
    {
        get { return this._IsNoOfRun; }
        set { this._IsNoOfRun = value; }
    }

    private char _IsApplicableForHoldBack;
    public char IsApplicableForHoldBack
    {
        get { return this._IsApplicableForHoldBack; }
        set { this._IsApplicableForHoldBack = value; }
    }
    private ArrayList _arrRightCategory;
    public ArrayList arrRightCategory
    {
        get
        {
            if (this._arrRightCategory == null)
                this._arrRightCategory = new ArrayList();
            return this._arrRightCategory;
        }
        set { this._arrRightCategory = value; }
    }

    private int _ParentPlatformCode;
    public int ParentPlatformCode
    {
        get { return this._ParentPlatformCode; }
        set { this._ParentPlatformCode = value; }
    }

    private string _IsLastLevel;
    public string IsLastLevel
    {
        get { return this._IsLastLevel; }
        set { this._IsLastLevel = value; }
    }

    private string _modulePosition;
    public string modulePosition
    {
        get { return this._modulePosition; }
        set { this._modulePosition = value; }
    }

    private int _base_platform_code;
    public int base_platform_code
    {
        get { return this._base_platform_code; }
        set { this._base_platform_code = value; }
    }


    private string _PlatformNameHierarchy;
    public string PlatformNameHierarchy
    {
        get { return this._PlatformNameHierarchy; }
        set { this._PlatformNameHierarchy = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new PlatformBroker();
    }

    public override void LoadObjects()
    {
        this.arrRightCategory = DBUtil.FillArrayList(new RightsCategory(), "and rights_category_code in(select rights_category_code from rights_category_platforms where platforms_code='" + this.IntCode + "') and parent_category_code = 0", true);
    }

    public override void UnloadObjects()
    {
        SqlTransaction sqlTranTemp = (SqlTransaction)this.SqlTrans;
        this.insertPlatformRightsCategory(this.IntCode, sqlTranTemp);
    }
    public int insertPlatformRightsCategory(int platformCode, SqlTransaction sqlTran)
    {
        return ((PlatformBroker)this.GetBroker()).insertPlatformRightsCategory(platformCode, sqlTran);
    }

    public static string GetPlatformCodeHierarchy(string platformCode)
    {
        return PlatformBroker.GetPlatformCodeHierarchy(platformCode);
    }
    #endregion
}
