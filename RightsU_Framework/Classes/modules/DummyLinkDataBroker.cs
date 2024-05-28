using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using UTOFrameWork.FrameworkClasses;
using System.Data.SqlClient;

class DummyLinkDataBroker : DatabaseBroker
{
    //string sql = "select distinct artist_name, d.deal_code, deal_movie_cost_per_episode, deal_for_code, " +
    //             "deal_type_name, deal_no " +
    //             "from deal_movie_cost dmc " +
    //             "inner join deal_movie dm on dmc.deal_movie_code = dm.deal_movie_code " +
    //             "inner join deal d on d.deal_code = dm.deal_code " +
    //             "inner join deal_type dt on dt.deal_type_code = d.deal_for_code where 1=1 and deal_type = 'S' "+
    //             "and is_default='N' "; //"and is_grid_required = 'N' ";

    //+ '( ' + vendor_name + ' )' 

    string sql = "select distinct deal_type_name as deal_type_name, english_title as artist_name, dm.deal_movie_code,  " +
                 "deal_movie_cost_per_episode, deal_for_code, deal_no,  " +
                 " dm.no_of_episodes " +
                 "from deal_movie_cost dmc inner join deal_movie dm on dmc.deal_movie_code = dm.deal_movie_code  " +
                 "inner join deal d on d.deal_code = dm.deal_code  " +
                 "inner join deal_type dt on dt.deal_type_code = d.deal_for_code  " +
                 "inner join title t on dm.title_code = t.title_code " +
                 "inner join vendor v on d.customer_code = v.vendor_code " +
                 "where 1=1 and deal_type = 'S' and is_default='N' and ISNULL(d.is_active,'N') = 'Y'  ";

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        return sql + strSearchString;
    }

    public override Persistent PopulateObject(System.Data.DataRow dRow, Persistent obj)
    {
        DummyLinkData objDummyLinkData;
        if (obj == null)
        {
            objDummyLinkData = new DummyLinkData();
        }
        else
        {
            objDummyLinkData = (DummyLinkData)obj;
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

    public DataSet getLinkDealEpisodes(int DealMovieCode)
    {
        string sql = "select deal_movie_content_code, episode_no, cost from deal_movie_contents " +
                    " where deal_movie_code = " + DealMovieCode + " order by deal_movie_content_code";
        DataSet ds = ProcessSelect(sql);

        return ds;
    }

    //----DADA
    public DataSet getLinkDealEpisodes(int DealMovieCode, int DMContentCode, SqlTransaction sqlTrans)
    {
        string sql = "select deal_movie_content_code, episode_no, cost from deal_movie_contents " +
                    " where deal_movie_code = " + DealMovieCode + " and deal_movie_content_code >= '" + DMContentCode + "' order by deal_movie_content_code";
        DataSet ds = ProcessSelectUsingTrans(sql, ref sqlTrans);

        return ds;
    }

    internal void updateDMContentsCost_Continue(int DealMovieCode, int DMContentCode, SqlTransaction sqlTrans)
    {
        /*
        //--------- Insert Into Deal_Movie_Contents_CostType
        string strSql_Insert = " INSERT INTO Deal_Movie_Contents_CostType ( "
        + " Deal_Movie_Content_Code, Deal_Movie_Cost_CostType_Code, CostTypeCode, Amount ) "
        + " select DMC.deal_movie_content_code, ct.deal_movie_cost_costtype_code, ct.cost_type_code, "
        + " ISNULL(e.Amount/(e.EpisodeTo-e.EpisodeFrom +1),0) Amount "
        + " from deal_movie_cost_costtype ct "
        + " inner join Deal_Movie_Contents DMC on DMC.deal_movie_code = ct.deal_movie_code "
        + " left outer join Deal_Movie_Cost_Costtype_Episode e "
        + " on DMC.episode_id between e.EpisodeFrom and e.EpisodeTo "
        + " and ct.deal_movie_cost_costtype_code=e.deal_movie_cost_costtype_code "
        + " inner join Deal_Movie DM on DM.deal_movie_code = DMC.deal_movie_code "
        + " where 1=1 "
        + " AND DMC.deal_movie_code = " + DealMovieCode + " "
        + " AND DMC.deal_movie_content_code >= " + DMContentCode + " "
        + " and DMC.deal_movie_content_code not in (select deal_movie_content_code from Deal_Movie_Contents_CostType) "
        + " order by 1 ";
        //--------- End Insert Into Deal_Movie_Contents_CostType

        ProcessScalarUsingTrans(strSql_Insert, ref sqlTrans);

        string strSql = " update  c set c.cost = a.Amount, c.balance_amount = a.Amount "
        + " from Deal_Movie_Contents c inner join "
        + " ( "
        + "	select DMC.deal_movie_content_code, SUM(ISNULL(e.Amount/(e.EpisodeTo-e.EpisodeFrom +1),0)) Amount "
        + " from deal_movie_cost_costtype ct "
        + " inner join Deal_Movie_Contents DMC on DMC.deal_movie_code = ct.deal_movie_code "
        + " left outer join Deal_Movie_Cost_Costtype_Episode e "
        + " on DMC.episode_id between e.EpisodeFrom and e.EpisodeTo 	and ct.deal_movie_cost_costtype_code=e.deal_movie_cost_costtype_code "
        + " where 1=1 "
        + " AND DMC.deal_movie_code = " + DealMovieCode + " "
        + " AND DMC.deal_movie_content_code >= " + DMContentCode + " "
        + " group by DMC.deal_movie_content_code "
        + " ) a on c.deal_movie_content_code = a.deal_movie_content_code ";

        ProcessScalarUsingTrans(strSql, ref sqlTrans);
        
        */

        string strSql = " Exec [USP_updateDMContentsCost_Continue] " + DealMovieCode + "," + DMContentCode + " ";
        ProcessScalarUsingTrans(strSql, ref sqlTrans);
    }
}
