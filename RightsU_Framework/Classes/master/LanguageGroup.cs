using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class LanguageGroup : Persistent
{
    public LanguageGroup()
    {
        OrderByColumnName = "Language_Group_Code";
        OrderByCondition = "ASC";
        tableName = "Language_Group";
        pkColName = "Language_Group_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private string _LanguageGroupName;
    public string LanguageGroupName
    {
        get { return this._LanguageGroupName; }
        set { this._LanguageGroupName = value; }
    }

    private string _IsActive;
    public string IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }

    private string _Language;

    public string Language
    {
        get { return _Language; }
        set { _Language = value; }
    }

    private ArrayList _arrLanguageGroupDetails_Del;
    public ArrayList arrLanguageGroupDetails_Del
    {
        get
        {
            if (this._arrLanguageGroupDetails_Del == null)
                this._arrLanguageGroupDetails_Del = new ArrayList();
            return this._arrLanguageGroupDetails_Del;
        }
        set { this._arrLanguageGroupDetails_Del = value; }
    }

    private ArrayList _arrLanguageGroupDetails;
    public ArrayList arrLanguageGroupDetails
    {
        get
        {
            if (this._arrLanguageGroupDetails == null)
                this._arrLanguageGroupDetails = new ArrayList();
            return this._arrLanguageGroupDetails;
        }
        set { this._arrLanguageGroupDetails = value; }
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
        return new LanguageGroupBroker();
    }

    public override void LoadObjects()
    {

        this.arrLanguageGroupDetails = DBUtil.FillArrayList(new LanguageGroupDetails(), " and Language_Group_Code = '" + this.IntCode + "'", false);

    }

    public override void UnloadObjects()
    {

        if (arrLanguageGroupDetails_Del != null)
        {
            foreach (LanguageGroupDetails objLanguageGroupDetails in this.arrLanguageGroupDetails_Del)
            {
                objLanguageGroupDetails.IsTransactionRequired = true;
                objLanguageGroupDetails.SqlTrans = this.SqlTrans;
                objLanguageGroupDetails.IsDeleted = true;
                objLanguageGroupDetails.Save();
            }
        }
        if (arrLanguageGroupDetails != null)
        {
            foreach (LanguageGroupDetails objLanguageGroupDetails in this.arrLanguageGroupDetails)
            {
                objLanguageGroupDetails.LanguageGroupCode = this.IntCode;
                objLanguageGroupDetails.IsTransactionRequired = true;
                objLanguageGroupDetails.SqlTrans = this.SqlTrans;
                //if (objLanguageGroupDetails.IntCode > 0)
                //    objLanguageGroupDetails.IsDirty = true;
                objLanguageGroupDetails.Save();
            }
        }
    }

    #endregion
}
