using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;

public class ScheduleAsRunReport : Persistent
{
    public ScheduleAsRunReport()
    {
        OrderByColumnName = "english_title";
        OrderByCondition = "ASC";
        //tableName = "";
        //pkColName = "";
    }

    #region ---------------Attributes And Prperties---------------

    private int _title_code;
    public int title_code
    {
        get { return this._title_code; }
        set { this._title_code = value; }
    }

    private string _english_title;
    public string english_title
    {
        get { return this._english_title; }
        set { this._english_title = value; }
    }

    private string _deal_no;
    public string deal_no
    {
        get { return this._deal_no; }
        set { this._deal_no = value; }
    }

    private int _deal_movie_code;
    public int deal_movie_code
    {
        get { return this._deal_movie_code; }
        set { this._deal_movie_code = value; }
    }

    private string _platforms;
    public string platforms
    {
        get { return this._platforms; }
        set { this._platforms = value; }
    }

    private string _Rights_Period;
    public string Rights_Period
    {
        get { return this._Rights_Period; }
        set { this._Rights_Period = value; }
    }

    private string _NoOfRuns;
    public string NoOfRuns
    {
        get { return this._NoOfRuns; }
        set { this._NoOfRuns = value; }
    }

    private string _Provision_Run;
    public string Provision_Run
    {
        get { return this._Provision_Run; }
        set { this._Provision_Run = value; }
    }

    private string _Actual_Run;
    public string Actual_Run
    {
        get { return this._Actual_Run; }
        set { this._Actual_Run = value; }
    }

    private string _Balance_Run;
    public string Balance_Run
    {
        get { return this._Balance_Run; }
        set { this._Balance_Run = value; }
    }

    private string _Is_Yearwise_Definition;
    public string Is_Yearwise_Definition
    {
        get { return this._Is_Yearwise_Definition; }
        set { this._Is_Yearwise_Definition = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new ScheduleAsRunReportBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }


    #endregion
}
