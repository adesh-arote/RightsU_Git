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
public class LanguageGroupDetails : Persistent
{
    public LanguageGroupDetails()
    {
        OrderByColumnName = "Language_Group_Code";
        OrderByCondition = "ASC";
        tableName = "Language_Group_Details";
        pkColName = "Language_Group_Details_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _LanguageGroupCode;
    public int LanguageGroupCode
    {
        get { return this._LanguageGroupCode; }
        set { this._LanguageGroupCode = value; }
    }

    private int _LanguageCode;
    public int LanguageCode
    {
        get { return this._LanguageCode; }
        set { this._LanguageCode = value; }
    }

    private Language _objLanguage;
    public Language objLanguage
    {
        get
        {
            if (this._objLanguage == null)
                this._objLanguage = new Language();
            return this._objLanguage;
        }
        set { this._objLanguage = value; }
    }

    private string _IsActive;
    public string IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new LanguageGroupDetailsBroker();
    }

    public override void LoadObjects()
    {

        if (this.LanguageCode > 0)
        {
            this.objLanguage.IntCode = this.LanguageCode;
            this.objLanguage.Fetch();
        }

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
