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
public class  TitlePromotion : Persistent
{
	public  TitlePromotion()
	{
        OrderByColumnName = "title_promotion_code";
		OrderByCondition= "ASC";
        tableName = "Title_Promotion";
        pkColName = "title_promotion_code";
	}	

    #region ---------------Attributes And Prperties---------------
    
	
	private int _ExternalTitleCode;
	public int ExternalTitleCode
	{
		get { return this._ExternalTitleCode; }
		set { this._ExternalTitleCode = value; }
	}

	private DateTime _EffectiveStartDate;
	public DateTime EffectiveStartDate
	{
		get { return this._EffectiveStartDate; }
		set { this._EffectiveStartDate = value; }
	}

	private DateTime _EffectiveEndDate;
	public DateTime EffectiveEndDate
	{
		get { return this._EffectiveEndDate; }
		set { this._EffectiveEndDate = value; }
	}

	private string _IsPromotion;
	public string IsPromotion
	{
		get { return this._IsPromotion; }
		set { this._IsPromotion = value; }
	}

	private ExternalTitle _objExternalTitle;
	public ExternalTitle objExternalTitle
	{
		get { 
			if (this._objExternalTitle == null)
				this._objExternalTitle = new ExternalTitle();
			return this._objExternalTitle;
		}
		set { this._objExternalTitle = value; }
	}

    /*
    
    
     private DealMovie _objDealMovie;
    public DealMovie objDealMovie
    {
        get
        {
            if (this._objDealMovie == null)
                this._objDealMovie = new DealMovie();
            return this._objDealMovie;
        }
        set { this._objDealMovie = value; }
    }
   */
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new TitlePromotionBroker();
    }

	public override void LoadObjects()
    {		
		if (this.ExternalTitleCode > 0)
		{
			this.objExternalTitle.IntCode = this.ExternalTitleCode;
			this.objExternalTitle.Fetch();
           // this.objTitleMapping.ExternalTitleCode = this.ExternalTitleCode;
           // this.objTitleMapping.Fetch();
		}
        //if (this.objExternalTitle.DealMovieCode > 0)
        //{
        //    this.objDealMovie.IntCode = this.objExternalTitle.DealMovieCode;
        //    this.objDealMovie.Fetch();
        //}

	}

    public override void UnloadObjects()
    {
        
    }
    
    #endregion    

    public string getEffectiveStartDt(int TitlePromCode)
    {
        return ((TitlePromotionBroker)GetBroker()).getEffectiveStartDt(TitlePromCode);
    }
    public DataSet getDealTitle(string searchStr)
    {
        return ((TitlePromotionBroker)GetBroker()).getDealTitle(searchStr);
    }
    //public string getMaxTitlePromotionCode(int ExtTitleCode)
    //{
    //    return ((TitlePromotionBroker)GetBroker()).getMaxTitlePromotionCode(ExtTitleCode);
    //}
}
