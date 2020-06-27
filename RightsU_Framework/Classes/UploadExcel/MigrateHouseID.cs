using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;


public class MigrateHouseID :Persistent
{
    public MigrateHouseID()
    {

    }

    #region === Attributes and Properties ===

    private int _DealMovieCostCode;
    public int DealMovieCostCode
    {
        get { return this._DealMovieCostCode; }
        set { this._DealMovieCostCode = value; }
    }

    private string _Title;
    public string Title
    {
        get { return this._Title; }
        set { this._Title = value; }
    }

    //private  string  _DealMovieCost;
    //public decimal DealMovieCost
    //{
    //    get { return this._DealMovieCost; }
    //    set { this._DealMovieCost = value; }
    //}

    #endregion


    public override DatabaseBroker GetBroker()
    {
        return new MigrateHouseIDBroker();
    }

    public override void UnloadObjects()
    {
        throw new NotImplementedException();
    }

}

