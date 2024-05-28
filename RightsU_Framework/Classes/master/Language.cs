using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class Language : Persistent {
    public Language()
    {
        OrderByColumnName = "Language_Name";
        OrderByCondition = "ASC";
        pkColName = "language_code";
        tableName = "Language";
    }

    #region ---------------Attributes And Prperties---------------


    private string _LanguageName;
    public string LanguageName
    {
        get { return this._LanguageName; }
        set { this._LanguageName = value; }
    }

    private string _IsActive;
    public string IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }
    private string _IsRef;
    public string IsRef
    {
        get { return this._IsRef; }
        set { this._IsRef = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new LanguageBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
