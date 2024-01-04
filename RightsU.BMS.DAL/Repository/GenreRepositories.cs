using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class GenreRepositories : MainRepository<Genre>
    {
        public void Add(Genre entity)
        {
            base.AddEntity(entity);
        }
        public IEnumerable<Genre> GetAll()
        {
            return base.GetAll<Genre>();
        }
        public Genre GetById(Int32? Id)
        {
            var obj = new { Genres_Code = Id.Value };
            return base.GetById<Genre>(obj);
        }
        public IEnumerable<Genre> SearchFor(object param)
        {
            return base.SearchForEntity<Genre>(param);
        }
        public void Update(Genre entity)
        {
            Genre oldObj = GetById(entity.Genres_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Genre entity)
        {
            base.DeleteEntity(entity);
        }
        public GenreReturn GetGenre_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            GenreReturn ObjGenreReturn = new GenreReturn();

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
            ObjGenreReturn.content = base.ExecuteSQLProcedure<Genre_List>("USPAPI_Genres_List", param).ToList();
            ObjGenreReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjGenreReturn;
        }
    }
}
