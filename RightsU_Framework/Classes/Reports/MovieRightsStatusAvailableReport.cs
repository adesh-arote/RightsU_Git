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
public class  MovieRightsStatusAvailableReport : Persistent
{
	public MovieRightsStatusAvailableReport()
	{
		 OrderByColumnName = "1";
		//OrderByCondition= "ASC"; 
		//tableName = "";
		//pkColName = "";
	}	

    #region ---------------Attributes And Prperties---------------

    private string _SqlQ;
    public string SqlQ
    {
        get { return this._SqlQ; }
        set { this._SqlQ = value; }
    }

	
	private string _OriginalTitle;
	public string OriginalTitle
	{
		get { return this._OriginalTitle; }
		set { this._OriginalTitle = value; }
	}

	private string _RightPeriodFor;
	public string RightPeriodFor
	{
		get { return this._RightPeriodFor; }
		set { this._RightPeriodFor = value; }
	}

	private string _DealRights;
	public string DealRights
	{
		get { return this._DealRights; }
		set { this._DealRights = value; }
	}

	private DateTime _DealRightStartDate;
	public DateTime DealRightStartDate
	{
		get { return this._DealRightStartDate; }
		set { this._DealRightStartDate = value; }
	}

	private DateTime _DealRightEndDate;
	public DateTime DealRightEndDate
	{
		get { return this._DealRightEndDate; }
		set { this._DealRightEndDate = value; }
	}

	private string _PlatformName;
	public string PlatformName
	{
		get { return this._PlatformName; }
		set { this._PlatformName = value; }
	}

	private string _LanguageName;
	public string LanguageName
	{
		get { return this._LanguageName; }
		set { this._LanguageName = value; }
	}

	private int _TitleCode;
	public int TitleCode
	{
		get { return this._TitleCode; }
		set { this._TitleCode = value; }
	}

	private int _PlatformCode;
	public int PlatformCode
	{
		get { return this._PlatformCode; }
		set { this._PlatformCode = value; }
	}

	private int _InternationalTerritoryCode;
	public int InternationalTerritoryCode
	{
		get { return this._InternationalTerritoryCode; }
		set { this._InternationalTerritoryCode = value; }
	}

	private int _LanguageCode;
	public int LanguageCode
	{
		get { return this._LanguageCode; }
		set { this._LanguageCode = value; }
	}

	private int _DealMovieRightsCode;
	public int DealMovieRightsCode
	{
		get { return this._DealMovieRightsCode; }
		set { this._DealMovieRightsCode = value; }
	}

	private string _IsSubLicense;
	public string IsSubLicense
	{
		get { return this._IsSubLicense; }
		set { this._IsSubLicense = value; }
	}

	private string _DomesticTeritoryName;
	public string DomesticTeritoryName
	{
		get { return this._DomesticTeritoryName; }
		set { this._DomesticTeritoryName = value; }
	}

	private string _InternationalTerritoryName;
	public string InternationalTerritoryName
	{
		get { return this._InternationalTerritoryName; }
		set { this._InternationalTerritoryName = value; }
	}

	private DateTime _DealSignedDate;
	public DateTime DealSignedDate
	{
		get { return this._DealSignedDate; }
		set { this._DealSignedDate = value; }
	}

	private int _TerritoryCode;
	public int TerritoryCode
	{
		get { return this._TerritoryCode; }
		set { this._TerritoryCode = value; }
	}

	private string _IsExclusive;
	public string IsExclusive
	{
		get { return this._IsExclusive; }
		set { this._IsExclusive = value; }
	}

	private int _DealtypeCode;
	public int DealtypeCode
	{
		get { return this._DealtypeCode; }
		set { this._DealtypeCode = value; }
	}

	private int _EntityCode;
	public int EntityCode
	{
		get { return this._EntityCode; }
		set { this._EntityCode = value; }
	}

	private int _MinsaleRightStartDate;
	public int MinsaleRightStartDate
	{
		get { return this._MinsaleRightStartDate; }
		set { this._MinsaleRightStartDate = value; }
	}

	private int _MaxsaleRightEndDate;
	public int MaxsaleRightEndDate
	{
		get { return this._MaxsaleRightEndDate; }
		set { this._MaxsaleRightEndDate = value; }
	}

	private int _MovieMaterialMediumName;
	public int MovieMaterialMediumName
	{
		get { return this._MovieMaterialMediumName; }
		set { this._MovieMaterialMediumName = value; }
	}

	
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
		return new MovieRightsStatusAvailableReportBroker();
    }

	public override void LoadObjects()
    {
		
	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    

    public DataSet GetDataSetToBindGrid(Criteria objCri)
    {
        MovieRightsStatusAvailableReportBroker ObjMovieRightsStatusAvailableReportBroker = new MovieRightsStatusAvailableReportBroker();
      return  ObjMovieRightsStatusAvailableReportBroker.GetDataSetToBindGrid(objCri,this.SqlQ);

    }
}
