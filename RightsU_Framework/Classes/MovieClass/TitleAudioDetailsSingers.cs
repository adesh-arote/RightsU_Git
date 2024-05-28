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
public class TitleAudioDetailsSingers : Persistent
{
    public TitleAudioDetailsSingers()
    {
        OrderByColumnName = "title_audio_details_singers_code";
        OrderByCondition = "ASC";
        tableName = "title_audio_details_singers";
        pkColName = "title_audio_details_singers_code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _TitleCode;
    public int TitleCode
    {
        get { return this._TitleCode; }
        set { this._TitleCode = value; }
    }

    private int _TitleAudioDetailsCode;
    public int TitleAudioDetailsCode
    {
        get { return this._TitleAudioDetailsCode; }
        set { this._TitleAudioDetailsCode = value; }
    }

    private int _TalentCode;
    public int TalentCode
    {
        get { return this._TalentCode; }
        set { this._TalentCode = value; }
    }

    private Talent _objTalent;
    public Talent objTalent
    {
        get
        {
            if (_objTalent == null)
                _objTalent = new Talent();
            return _objTalent;
        }
        set { _objTalent = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new TitleAudioDetailsSingersBroker();
    }

    public override void LoadObjects()
    {
        if (this.TalentCode > 0)
        {
            this.objTalent.IntCode = this.TalentCode;
            this.objTalent.Fetch();
        }
    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
