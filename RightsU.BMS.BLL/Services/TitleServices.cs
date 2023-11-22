using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.BLL.Services
{
    public class TitleServices
    {
        private readonly TitleRepositories objTitleRepositories = new TitleRepositories();
        public TitleReturn List_Titles(string order,Int32? page,string search_value,Int32? size,string sort,string Date_GT,string Date_LT,Int32? id)
        {
            TitleReturn objTitleReturn = new TitleReturn();
            objTitleReturn = objTitleRepositories.GetTitle_List(order, page.Value, search_value, size.Value, sort,Date_GT,Date_LT,id.Value);
            return objTitleReturn;
        }

        public List<USP_Bind_Extend_Column_Grid_Result> USP_Bind_Extend_Column_Grid(Nullable<int> title_Code)
        {
            
            return objTitleRepositories.USP_Bind_Extend_Column_Grid(title_Code);
        }

        public title GetById(Int32? id)
        {
            title objTitleReturn = new title();
            objTitleReturn = objTitleRepositories.GetTitleById(id.Value);
            return objTitleReturn;
        }
    }
}
