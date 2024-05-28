using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;

public class ShowHouseId_Dummy : Persistent
{
    public ShowHouseId_Dummy()
    {
        OrderByColumnName = "english_title";
        OrderByCondition = "ASC";
        //tableName = "";
        //pkColName = "";
    }

    #region ---------------Attributes And Prperties---------------

    private string _english_title;
    public string english_title
    {
        get { return this._english_title; }
        set { this._english_title = value; }
    }

    private string _HouseID_Type_Name;
    public string HouseID_Type_Name
    {
        get { return this._HouseID_Type_Name; }
        set { this._HouseID_Type_Name = value; }
    }

    private string _House_ID;
    public string House_ID
    {
        get { return this._House_ID; }
        set { this._House_ID = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ShowHouseId_DummyBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }
    
    #endregion
}
