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
public class TitleAudioDetails : Persistent
{
    public TitleAudioDetails()
    {
        OrderByColumnName = "title_audio_details_code";
        OrderByCondition = "ASC";
        tableName = "title_audio_details";
        pkColName = "title_audio_details_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _TitleCode;
    public int TitleCode
    {
        get { return this._TitleCode; }
        set { this._TitleCode = value; }
    }

    private string _SongName;
    public string SongName
    {
        get { return this._SongName; }
        set { this._SongName = value; }
    }

    private string _MovieName;
    public string MovieName
    {
        get { return this._MovieName; }
        set { this._MovieName = value; }
    }

    private int _Duration;
    public int Duration
    {
        get { return this._Duration; }
        set { this._Duration = value; }
    }

    private int _LanguageCode;
    public int LanguageCode
    {
        get { return this._LanguageCode; }
        set { this._LanguageCode = value; }
    }

    private int _GenersCode;
    public int GenersCode
    {
        get { return this._GenersCode; }
        set { this._GenersCode = value; }
    }

    private ArrayList _arrTitleAudioDetailsSingers_Del;
    public ArrayList arrTitleAudioDetailsSingers_Del
    {
        get
        {
            if (this._arrTitleAudioDetailsSingers_Del == null)
                this._arrTitleAudioDetailsSingers_Del = new ArrayList();
            return this._arrTitleAudioDetailsSingers_Del;
        }
        set { this._arrTitleAudioDetailsSingers_Del = value; }
    }

    private ArrayList _arrTitleAudioDetailsSingers;
    public ArrayList arrTitleAudioDetailsSingers
    {
        get
        {
            if (this._arrTitleAudioDetailsSingers == null)
                this._arrTitleAudioDetailsSingers = new ArrayList();
            return this._arrTitleAudioDetailsSingers;
        }
        set { this._arrTitleAudioDetailsSingers = value; }
    }

    private Genres _objGenres;
    public Genres objGenres
    {
        get
        {
            if (this._objGenres == null)
                this._objGenres = new Genres();
            return this._objGenres;
        }
        set { _objGenres = value; }
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
        set { _objLanguage = value; }
    }

    private string _strTitleAudioSingers;
    public string strTitleAudioSingers
    {
        get { return this._strTitleAudioSingers; }
        set { this._strTitleAudioSingers = value; }
    }

    private string _strTitleAudioTalentCodes;
    public string strTitleAudioTalentCodes
    {
        get { return this._strTitleAudioTalentCodes; }
        set { this._strTitleAudioTalentCodes = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new TitleAudioDetailsBroker();
    }

    public override void LoadObjects()
    {
        if (this.GenersCode > 0)
        {
            this.objGenres.IntCode = this.GenersCode;
            this.objGenres.Fetch();
        }
        if (this.LanguageCode > 0)
        {
            this.objLanguage.IntCode = this.LanguageCode;
            this.objLanguage.Fetch();
        }

        if (this.IntCode > 0)
        {
            //this.arrTitleAudioDetailsSingers_Del = DBUtil.FillArrayList(new TitleAudioDetailsSingers(), " and title_audio_details_code = '" + this.IntCode + "'", false);
            this.arrTitleAudioDetailsSingers = DBUtil.FillArrayList(new TitleAudioDetailsSingers(), " and title_audio_details_code = '" + this.IntCode + "'", false);
        }
        LoadAudioDetailsSingersArr();
    }

    public void LoadAudioDetailsSingersArr()
    {
        if (this.arrTitleAudioDetailsSingers.Count > 0)
        {
            strTitleAudioSingers = "";
            strTitleAudioTalentCodes = "";
            foreach (TitleAudioDetailsSingers obj in this.arrTitleAudioDetailsSingers)
            {
                if (obj.TalentCode > 0)
                {
                    obj.objTalent.IntCode = obj.TalentCode;
                    obj.objTalent.Fetch();
                }
                strTitleAudioSingers += obj.objTalent.talentName + ",";
                strTitleAudioTalentCodes += obj.TalentCode + ",";
            }
            strTitleAudioSingers = strTitleAudioSingers.Trim(',');
            strTitleAudioTalentCodes = strTitleAudioTalentCodes.Trim(',');
        }
    }

    public override void UnloadObjects()
    {

        if (arrTitleAudioDetailsSingers_Del != null)
        {
            foreach (TitleAudioDetailsSingers objTitleAudioDetailsSingers in this.arrTitleAudioDetailsSingers_Del)
            {
                objTitleAudioDetailsSingers.IsTransactionRequired = true;
                objTitleAudioDetailsSingers.SqlTrans = this.SqlTrans;
                objTitleAudioDetailsSingers.IsDeleted = true;
                objTitleAudioDetailsSingers.Save();
            }
        }
        if (arrTitleAudioDetailsSingers != null)
        {
            foreach (TitleAudioDetailsSingers objTitleAudioDetailsSingers in this.arrTitleAudioDetailsSingers)
            {
                objTitleAudioDetailsSingers.TitleAudioDetailsCode = this.IntCode;
                objTitleAudioDetailsSingers.TitleCode = this.TitleCode;
                objTitleAudioDetailsSingers.IsTransactionRequired = true;
                objTitleAudioDetailsSingers.SqlTrans = this.SqlTrans;
                if (objTitleAudioDetailsSingers.IntCode > 0)
                    objTitleAudioDetailsSingers.IsDirty = true;
                objTitleAudioDetailsSingers.Save();
            }
        }
    }

    #endregion
}
