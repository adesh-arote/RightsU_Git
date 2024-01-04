using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class TitleRepositories : MainRepository<Title>
    {
        public Title GetById(Int32? Id)
        {
            var obj = new { Title_Code = Id.Value };
            return base.GetById<Title, Title_Country, Title_Talent, Title_Geners>(obj);
        }

        public IEnumerable<Title> GetAll()
        {
            return base.GetAll<Title, Title_Country, Title_Talent, Title_Geners>();
        }

        public void Add(Title entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Title entity)
        {
            Title oldObj = GetById(entity.Title_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Title entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Title> SearchFor(object param)
        {
            return base.SearchForEntity<Title, Title_Country, Title_Talent, Title_Geners>(param);
        }

        public IEnumerable<Title> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Title>(strSQL);
        }

        public TitleReturn GetTitle_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            TitleReturn ObjTitleReturn = new TitleReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@date_gt", Date_GT);
            param.Add("@date_lt", Date_LT);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjTitleReturn.content = base.ExecuteSQLProcedure<title_List>("USPAPI_Title_List", param).ToList();
            ObjTitleReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjTitleReturn;
        }

        public List<USPAPI_Title_Bind_Extend_Data> USPAPI_Title_Bind_Extend_Data(Nullable<int> title_Code)
        {
            List<USPAPI_Title_Bind_Extend_Data> ObjExtended = new List<USPAPI_Title_Bind_Extend_Data>();

            var param = new DynamicParameters();
            param.Add("@Title_Code", title_Code);
            ObjExtended = base.ExecuteSQLProcedure<USPAPI_Title_Bind_Extend_Data>("USPAPI_Title_Bind_Extend_Data", param).ToList();
            return ObjExtended;
        }

        public title GetTitleById(Int32 id)
        {
            title ObjTitleReturn = new title();

            var param = new DynamicParameters();
            //param.Add("@id", id);

            param.Add("@order", "ASC");
            param.Add("@page", 1);
            param.Add("@search_value", "");
            param.Add("@size", 1);
            param.Add("@sort", "Last_UpDated_Time");
            param.Add("@date_gt", "");
            param.Add("@date_lt", "");
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjTitleReturn = base.ExecuteSQLProcedure<title>("USPAPI_Title_List", param).FirstOrDefault();
            return ObjTitleReturn;
        }

        public Title_Validations Title_Validation(string InputValue, string InputType)
        {
            var param = new DynamicParameters();

            param.Add("@InputValue", InputValue);
            param.Add("@InputType", InputType);
            return base.ExecuteSQLProcedure<Title_Validations>("USPAPI_Title_Validations", param).FirstOrDefault();
        }
    }

    #region -------- Title_Country -----------
    public class Title_CountryRepositories : MainRepository<Title_Country>
    {
        public Title_Country Get(int Id)
        {
            var obj = new { Title_Country_Code = Id };

            return base.GetById<Title_Country>(obj);
        }
        public IEnumerable<Title_Country> GetAll()
        {
            return base.GetAll<Title_Country>();
        }
        public void Add(Title_Country entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Title_Country entity)
        {
            Title_Country oldObj = Get(entity.Title_Country_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Title_Country entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Title_Country> SearchFor(object param)
        {
            return base.SearchForEntity<Title_Country>(param);
        }

        public IEnumerable<Title_Country> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Title_Country>(strSQL);
        }
    }
    #endregion

    #region -------- Title_Talent -----------
    public class Title_TalentRepositories : MainRepository<Title_Talent>
    {
        public Title_Talent Get(int Id)
        {
            var obj = new { Title_Talent_Code = Id };

            return base.GetById<Title_Talent>(obj);
        }
        public IEnumerable<Title_Talent> GetAll()
        {
            return base.GetAll<Title_Talent>();
        }
        public void Add(Title_Talent entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Title_Talent entity)
        {
            Title_Talent oldObj = Get(entity.Title_Talent_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Title_Talent entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Title_Talent> SearchFor(object param)
        {
            return base.SearchForEntity<Title_Talent>(param);
        }

        public IEnumerable<Title_Talent> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Title_Talent>(strSQL);
        }
    }
    #endregion

    #region -------- Title_Talent -----------
    public class Title_GenersRepositories : MainRepository<Title_Geners>
    {
        public Title_Geners Get(int Id)
        {
            var obj = new { Title_Geners_Code = Id };

            return base.GetById<Title_Geners>(obj);
        }
        public IEnumerable<Title_Geners> GetAll()
        {
            return base.GetAll<Title_Geners>();
        }
        public void Add(Title_Geners entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Title_Geners entity)
        {
            Title_Geners oldObj = Get(entity.Title_Geners_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Title_Geners entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Title_Geners> SearchFor(object param)
        {
            return base.SearchForEntity<Title_Geners>(param);
        }

        public IEnumerable<Title_Geners> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Title_Geners>(strSQL);
        }
    }
    #endregion
}
