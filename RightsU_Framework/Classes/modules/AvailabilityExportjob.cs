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
public class  AvailabilityExportjob : Persistent
{
	public  AvailabilityExportjob()
	{
        OrderByColumnName = "Created_On";
		OrderByCondition= "DESC";
        tableName = "Availability_ExportJob";
        pkColName = "Availability_ExportJob_Code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private string _SPName;
	public string SPName
	{
		get { return this._SPName; }
		set { this._SPName = value; }
	}

	private string _PStrsearch;
	public string PStrsearch
	{
		get { return this._PStrsearch; }
		set { this._PStrsearch = value; }
	}

	private string _PStrsearchdate;
	public string PStrsearchdate
	{
		get { return this._PStrsearchdate; }
		set { this._PStrsearchdate = value; }
	}

	private int _PColcount;
	public int PColcount
	{
		get { return this._PColcount; }
		set { this._PColcount = value; }
	}

	private string _PStrcolumnlist;
	public string PStrcolumnlist
	{
		get { return this._PStrcolumnlist; }
		set { this._PStrcolumnlist = value; }
	}

	private DateTime _CreatedOn;
	public DateTime CreatedOn
	{
		get { return this._CreatedOn; }
		set { this._CreatedOn = value; }
	}

	private DateTime _CompletedOn;
	public DateTime CompletedOn
	{
		get { return this._CompletedOn; }
		set { this._CompletedOn = value; }
	}

	private string _ISProcessed;
	public string ISProcessed
	{
		get { return this._ISProcessed; }
		set { this._ISProcessed = value; }
	}

    private string _FileName;
    public string FileName
    {
        get { return _FileName; }
        set { _FileName = value; }
    }

    private string _Remarks;
    public string Remarks
    {
        get { return _Remarks; }
        set { _Remarks = value; }
    }

    private string _GeneratedBy_UserName;
    public string GeneratedBy_UserName
    {
        get { return _GeneratedBy_UserName; }
        set { _GeneratedBy_UserName = value; }
    }
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new AvailabilityExportjobBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    
}
