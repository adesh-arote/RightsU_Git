using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

class DummyLinkMusicBroker : DatabaseBroker
{
    public DummyLinkMusicBroker()
    {
    }
    string sql = "select distinct deal_type_name as deal_type_name, english_title as artist_name, dm.deal_movie_code, " +
                 "deal_movie_cost_per_episode, deal_for_code, deal_no, " +
                 "dm.no_of_episodes " +
                 "from deal_movie_cost dmc inner join deal_movie dm on dmc.deal_movie_code = dm.deal_movie_code " +
                 "inner join deal d on d.deal_code = dm.deal_code " +
                 "inner join deal_type dt on dt.deal_type_code = d.deal_for_code  " +
                 "inner join title t on dm.title_code = t.title_code " +
                 "inner join vendor v on d.customer_code = v.vendor_code " +
                 "where 1=1 and deal_type ='M' and is_default='N' and ISNULL(d.is_active,'N') = 'Y'";

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        return sql + strSearchString;
    }

    public override Persistent PopulateObject(System.Data.DataRow dRow, Persistent obj)
    {
        DummyLinkMusic objDummyLinkData;
        if (obj == null)
        {
            objDummyLinkData = new DummyLinkMusic();
        }
        else
        {
            objDummyLinkData = (DummyLinkMusic)obj;
        }

        objDummyLinkData.ArtistName = Convert.ToString(dRow["artist_name"]);
        //objDummyLinkData.CustomerCode = Convert.ToInt32(dRow["customer_code"]);
        objDummyLinkData.DealCode = Convert.ToInt32(dRow["deal_movie_code"]);
        //objDummyLinkData.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);
        objDummyLinkData.DealCostPerEpisode = Convert.ToSingle(dRow["deal_movie_cost_per_episode"]);
        objDummyLinkData.DealTypeCode = Convert.ToInt32(dRow["deal_for_code"]);
        objDummyLinkData.DealTypeName = Convert.ToString(dRow["deal_type_name"]);
        objDummyLinkData.DealNo = Convert.ToString(dRow["deal_no"]);
        if (dRow["no_of_episodes"] != DBNull.Value)
            objDummyLinkData.NoOfAppearance = Convert.ToInt32(dRow["no_of_episodes"]);
        if (dRow["deal_movie_code"] != DBNull.Value)
            objDummyLinkData.DealMovieCode = Convert.ToInt32(dRow["deal_movie_code"]);

        return objDummyLinkData;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetInsertSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetUpdateSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        throw new NotImplementedException();
    }

    public override string GetDeleteSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetCountSql(string strSearchString)
    {
        return sql + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public DataSet getLinkDealMusicEpisodes(int DealMovieCode, Array arrEpisodes)
    {
        string strEpisodes = string.Empty;

        for (int i = 0; i < arrEpisodes.Length; i++)
        {
            strEpisodes = strEpisodes + arrEpisodes.GetValue(i).ToString() + ",";
        }
        strEpisodes = strEpisodes.Trim(',');

        string sql = "select deal_movie_content_code, episode_no, cost from deal_movie_contents " +
                    " where deal_movie_code = " + DealMovieCode + " and deal_movie_content_code in (" + strEpisodes + ")  order by deal_movie_content_code";
        DataSet ds = ProcessSelect(sql);

        return ds;
    }

    //----DADA
    public DataSet getLinkDealEpisodes(int DealMovieCode, int DMContentCode)
    {
        string sql = "select deal_movie_content_code, episode_no, cost from deal_movie_contents " +
                    " where deal_movie_code = " + DealMovieCode + " and deal_movie_content_code >= '" + DMContentCode + "' order by deal_movie_content_code";
        DataSet ds = ProcessSelect(sql);

        return ds;
    }

}
