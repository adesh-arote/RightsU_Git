using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class DealTag : Persistent
{
    public DealTag ()
    {
        OrderByColumnName = "Deal_Tag_Code";
        OrderByCondition = "ASC";
        tableName = "Deal_Tag";
        pkColName = "Deal_Tag_Code";
    }
   
    #region ---------------Attributes And Prperties---------------


    private string _DealTagDescription;
    public string DealTagDescription
    {
        get { return this._DealTagDescription; }
        set { this._DealTagDescription = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new DealTagBroker();
    }

    public override void LoadObjects()
    {
        
    }

    public override void UnloadObjects()
    {
         
    }

    #endregion
}
