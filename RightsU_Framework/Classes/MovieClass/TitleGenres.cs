using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for MovieGenre
/// </summary>
public class TitleGenres:Persistent 
{
    #region-----------Constructor-------------
    public TitleGenres()
	{
        OrderByColumnName = "title_geners_code";
        OrderByCondition = "ASC";
    }
    #endregion
    #region-----------Attributes--------------
    private int _titleCode;
    private Genres _objMovGenre;
    private string _status;
    #endregion

    #region-----------Properties--------------
    public int titleCode
    {
        get { return _titleCode; }
        set { _titleCode = value; }
    }
    public Genres objMovGenre
    {
        get
        {
            if (_objMovGenre == null)
            {
                _objMovGenre = new Genres();
            }
            return _objMovGenre;
        }
        set { _objMovGenre = value; }
    }
    public string status
    {
        get { return _status; }
        set { _status = value; }
    }
    #endregion

    #region-----------Methods-----------------
    public override DatabaseBroker GetBroker()
    {
        return new TitleGenresBroker();
    }
    public override void LoadObjects()
    {
        if (_objMovGenre.IntCode > 0)
        {
            _objMovGenre.Fetch();
        }
    }
    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
    #endregion

}
