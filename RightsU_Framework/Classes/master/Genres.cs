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
public class Genres : Persistent {
    public Genres()
    {

		tableName = "Genres";
		pkColName = "Genres_Code";
		OrderByColumnName = "Genres_Name";
        OrderByCondition = "ASC";
    }

    #region ---------------Attributes And Prperties---------------


    private string _GenresName;
    public string GenresName
    {
        get { return this._GenresName; }
        set { this._GenresName = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new GenresBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }

    #endregion
}
