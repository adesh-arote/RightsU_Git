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
public class  HouseIdMap : Persistent
{
	public  HouseIdMap()
	{
        OrderByColumnName = "title";
        OrderByCondition = "ASC";
        tableName = "tblHouseIdMap";
        pkColName = "map_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _mapHouseIdUnk;
	public string mapHouseIdUnk
	{
		get { return this._mapHouseIdUnk; }
		set { this._mapHouseIdUnk = value; }
	}

	private string _mapHouseId;
	public string mapHouseId
	{
		get { return this._mapHouseId; }
		set { this._mapHouseId = value; }
	}

	private string _title;
	public string title
	{
		get { return this._title; }
		set { this._title = value; }
	}

	private int _LastUpdatedBy;
	public int LastUpdatedBy
	{
		get { return this._LastUpdatedBy; }
		set { this._LastUpdatedBy = value; }
	}

	private DateTime _LastUpdatedOn;
	public DateTime LastUpdatedOn
	{
		get { return this._LastUpdatedOn; }
		set { this._LastUpdatedOn = value; }
	}

	private string _src;
	public string src
	{
		get { return this._src; }
		set { this._src = value; }
	}


    private string _fileID;
    public string fileID
    {
        get { return this._fileID; }
        set { this._fileID = value; }
    }

    private ArrayList _arrHouseIdMap;
    public ArrayList arrHouseIdMap
    {
        get
        {
            if (this._arrHouseIdMap == null)
                this._arrHouseIdMap = new ArrayList();
            return this._arrHouseIdMap;
        }
        set { this._arrHouseIdMap = value; }
    }




    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new HouseIdMapBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
