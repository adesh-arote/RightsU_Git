using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using UTOFrameWork.FrameworkClasses;

public class DummyLinkMusic:Persistent 
{
    public DummyLinkMusic()
    {
        OrderByColumnName = "deal_movie_music_link_data_code";
        OrderByCondition = "ASC";
        tableName = "Deal_Movie_Music_Link_Data";
        pkColName = "deal_movie_music_link_data_code";
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



    private ArrayList _arrDealMLinkDataDet;
    public ArrayList arrDealMLinkDataDet
    {
        get
        {
            if (this._arrDealMLinkDataDet == null)
                this._arrDealMLinkDataDet = new ArrayList();
            return this._arrDealMLinkDataDet;
        }
        set { this._arrDealMLinkDataDet = value; }
    }

    public string EpisodeList
    {
        get
        {
            string retStr = "";
            if (this._arrDealMLinkDataDet != null)
            {
                //foreach (DealMovieLinkDataDetail objdet in arrDealMLinkDataDet)
                //{
                //    objdet.objDealMovieContents.IntCode = objdet.DealMovieContentCode;
                //    objdet.objDealMovieContents.Fetch();
                //    retStr = retStr + objdet.objDealMovieContents.EpisodeNo + ",";
                //}
            }
            retStr = retStr.Trim(",".ToCharArray());
            return retStr;
        }

    }


    public override DatabaseBroker GetBroker()
    {
        return new DummyLinkMusicBroker();
    }

    public override void UnloadObjects()
    {
        throw new NotImplementedException();
    }

    public override void LoadObjects()
    {
        //base.LoadObjects();
    }

    public DataSet getLinkDealMusicEpisodes(int DealMovieCode, Array arrEpisodes)
    {
        return ((DummyLinkMusicBroker)GetBroker()).getLinkDealMusicEpisodes(DealMovieCode, arrEpisodes);
    }
    
    public DataSet getLinkDealEpisodes_New(int DealMovieCode, int DMContentCode)
    {
        return ((DummyLinkMusicBroker)GetBroker()).getLinkDealEpisodes(DealMovieCode, DMContentCode);
    }
}
