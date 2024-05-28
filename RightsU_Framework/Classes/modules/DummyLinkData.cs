using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using UTOFrameWork.FrameworkClasses;
using System.Data.SqlClient;

public class DummyLinkData : Persistent
{
    public DummyLinkData()
    {

    }

    private string _ArtistName;
    private int _CustomerCode;
    private int _DealCode;
    private int _DealMovieCode;
    private float _DealCostPerEpisode;
    private int _DealTypeCode;
    private string _DealTypeName;
    private string _DealNo;

    public string ArtistName
    {
        get { return _ArtistName; }
        set { _ArtistName = value; }
    }
    public int CustomerCode
    {
        get { return _CustomerCode; }
        set { _CustomerCode = value; }
    }
    public int DealCode
    {
        get { return _DealCode; }
        set { this._DealCode = value; }
    }
    public int DealMovieCode
    {
        get { return _DealMovieCode; }
        set { _DealMovieCode = value; }
    }
    public float DealCostPerEpisode
    {
        get { return _DealCostPerEpisode; }
        set { _DealCostPerEpisode = value; }
    }
    public int DealTypeCode
    {
        get { return _DealTypeCode; }
        set { _DealTypeCode = value; }
    }
    public string DealTypeName
    {
        get { return _DealTypeName; }
        set { _DealTypeName = value; }
    }
    public string DealNo
    {
        get { return _DealNo; }
        set { _DealNo = value; }
    }

    private int _NoOfAppearance;
    public int NoOfAppearance
    {
        get { return _NoOfAppearance; }
        set { _NoOfAppearance = value; }
    }

    public override DatabaseBroker GetBroker()
    {
        return new DummyLinkDataBroker();
    }

    public override void UnloadObjects()
    {
        throw new NotImplementedException();
    }

    public DataSet getLinkDealEpisodes(int DealMovieCode)
    {
        return ((DummyLinkDataBroker)GetBroker()).getLinkDealEpisodes(DealMovieCode);
    }

    //DADA
    public DataSet getLinkDealEpisodes_New(int DealMovieCode, int DMContentCode, SqlTransaction sqlTrans)
    {
        return ((DummyLinkDataBroker)GetBroker()).getLinkDealEpisodes(DealMovieCode, DMContentCode, sqlTrans);
    }

    //DADA
    public void updateDMContentsCost_Continue(int DealMovieCode, int DMContentCode, SqlTransaction sqlTrans)
    {
        ((DummyLinkDataBroker)GetBroker()).updateDMContentsCost_Continue(DealMovieCode, DMContentCode, sqlTrans);
    }
}